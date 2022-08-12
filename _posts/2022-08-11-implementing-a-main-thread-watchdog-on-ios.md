---
layout: post
categories: [software-dev]
tags: [ios, xcode, debugging, performance]
date: 2022-08-11T12:13:41-07:00
title: Implementing a main thread watchdog on iOS
---

On iOS the operating system employs a watchdog that monitors for and terminates unresponsive apps. If your app is blocking the main thread for too long, the system will kill it. In crash reports, you can identify [watchdog terminations](https://developer.apple.com/documentation/xcode/addressing-watchdog-terminations) via the termination reason code `0x8badf00d` ("ate bad food").

<!--excerpt-->

This is great for determining _why_ a termination happened --- your app was blocking the main thread for a significant time. However, it does not always answer _what_ (in your code) actually caused the termination. From Apple's [Addressing Watchdog Terminations guide](https://developer.apple.com/documentation/xcode/addressing-watchdog-terminations):

> However, the main thread’s backtrace doesn’t always contain the source of the issue. For example, imagine that your app needs exactly 4 seconds to complete a task out of a total allowed wall clock time of 5 seconds. When the watchdog terminates the app after 5 seconds, the code that took 4 seconds won’t show up in the backtrace because it completed, yet it consumed almost the entire time budget. The crash report instead records the backtrace frames of what the app was doing at the time the watchdog terminated it, even though the recorded backtrace frames aren’t the source of the problem.

To work around the limitations inherent to this kind of scenario, we can write our own main thread watchdog and add custom logging to our apps to help diagnose the root causes of `0x8badf00d` terminations. The APIs in Core Foundation actually make this relatively easy. We can use [`CFRunLoopObserver`](https://developer.apple.com/documentation/corefoundation/cfrunloopobserver-ri3). The code below implements a simple run loop observer. It is largely based on [this gist](https://gist.github.com/jspahrsummers/419266f5231832602bec) written by [Justin Spahr-Summers](https://github.com/jspahrsummers).

```objc
// WatchdogRunLoopObserver.h

@protocol WatchdogRunLoopObserverDelegate <NSObject>

- (void)runLoopDidStallWithDuration:(NSTimeInterval)duration;

@end

@interface WatchdogRunLoopObserver : NSObject

@property (nonatomic, weak, nullable) id<WatchdogRunLoopObserverDelegate> delegate;

- (instancetype)init;

- (instancetype)initWithRunLoop:(CFRunLoopRef)runLoop stallingThreshold:(NSTimeInterval)threshold;

- (void)start;

- (void)stop;
@end
```

```objc
// WatchdogRunLoopObserver.m

#import "WatchdogRunLoopObserver.h"
#include <mach/mach_time.h>

static const NSTimeInterval DefaultStallingThreshold = 4;

@interface WatchdogRunLoopObserver ()

@property (nonatomic, assign, readonly) CFRunLoopRef runLoop;
@property (nonatomic, assign, readonly) CFRunLoopObserverRef observer;
@property (nonatomic, assign, readonly) NSTimeInterval threshold;
@property (nonatomic, assign) uint64_t startTime;

@end

@implementation WatchdogRunLoopObserver

- (instancetype)init {
    return [self initWithRunLoop:CFRunLoopGetMain()
               stallingThreshold:DefaultStallingThreshold];
}

- (instancetype)initWithRunLoop:(CFRunLoopRef)runLoop
              stallingThreshold:(NSTimeInterval)threshold {
    NSParameterAssert(runLoop != NULL);
    NSParameterAssert(threshold > 0);

    self = [super init];
    if (self == nil) {
        return nil;
    }

    _runLoop = (CFRunLoopRef)CFRetain(runLoop);
    _threshold = threshold;

    // Pre-calculate timebase information.
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);

    NSTimeInterval secondsPerMachTime = timebase.numer / timebase.denom / 1e9;

    __weak typeof(self) weakSelf = self;

    // Observe at an extremely low order so that we can catch stalling even in
    // high-priority operations (like UI redrawing or animation).
    _observer = CFRunLoopObserverCreateWithHandler(NULL, kCFRunLoopAllActivities, YES, INT_MIN,
                                                   ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        switch (activity) {
                // What we consider one "iteration" might start with any one of these events.
            case kCFRunLoopEntry:
            case kCFRunLoopBeforeTimers:
            case kCFRunLoopAfterWaiting:
            case kCFRunLoopBeforeSources:
                if (strongSelf.startTime == 0) {
                    strongSelf.startTime = mach_absolute_time();
                }
                break;

            case kCFRunLoopBeforeWaiting:
            case kCFRunLoopExit: {
                uint64_t endTime = mach_absolute_time();
                if (strongSelf.startTime <= 0) {
                    break;
                }

                uint64_t elapsed = endTime - strongSelf.startTime;

                NSTimeInterval duration = elapsed * secondsPerMachTime;
                if (duration > strongSelf.threshold) {
                    [strongSelf iterationStalledWithDuration:duration];
                }

                strongSelf.startTime = 0;
                break;
            }

            default:
                NSAssert(NO, @"WatchdogRunLoopObserver should not have been triggered for activity %i", (int)activity);
        }
    });

    if (_observer == NULL) {
        return nil;
    }

    return self;
}

- (void)dealloc {
    if (_observer != NULL) {
        CFRunLoopObserverInvalidate(_observer);

        CFRelease(_observer);
        _observer = NULL;
    }

    if (_runLoop != NULL) {
        CFRelease(_runLoop);
        _runLoop = NULL;
    }
}

- (void)start {
    CFRunLoopAddObserver(self.runLoop, self.observer, kCFRunLoopCommonModes);
}

- (void)stop {
    CFRunLoopRemoveObserver(self.runLoop, self.observer, kCFRunLoopCommonModes);
}

- (void)iterationStalledWithDuration:(NSTimeInterval)duration {
    [self.delegate runLoopDidStallWithDuration:duration];
}

@end
```

This class, `WatchdogRunLoopObserver`, essentially wraps `CFRunLoopObserver` with a nicer, easier-to-use API. It calculates the time spent on each run loop iteration and reports to its `delegate` when your specified threshold is exceeded. It uses a default threshold of 4 seconds.

We can wrap this in a nicer API for Swift.

```swift
final public class Watchdog: NSObject, WatchdogRunLoopObserverDelegate {
    @objc
    public static let shared = Watchdog()

    private let observer = WatchdogRunLoopObserver()

    private var isStarted = false

    override private init() {
        super.init()
        self.observer.delegate = self
    }

    deinit {
        stop()
    }

    public func start() {
        if isStarted {
            return
        }

        print("[Watchdog] started")
        observer.start()
        isStarted = true
    }

    public func stop() {
        print("[Watchdog] stopped")
        observer.stop()
    }

    // MARK: WatchdogRunLoopObserverDelegate

    public func runLoopDidStall(withDuration duration: TimeInterval) {
        // TODO: implement your custom logging here
        //    - what task is currently running?
        //    - which view controller is currently on screen?
        print("🚫 ⚠️ [Watchdog] main thread blocked for \(duration) seconds")
    }
}
```

Then, during app startup or wherever you need to start tracking potential main thread blocking, you can start and stop the shared watchdog.

```swift
Watchdog.shared.start()

Watchdog.shared.stop()
```

Inside the `runLoopDidStall(withDuration:)` delegate callback is where you'll want to implement your custom logging --- what is currently happening in your app, which view controller is currently on screen, etc. You should include any relevant context to help you diagnose what might be blocking the main thread. I've put all this code, along with a brief example app, [on GitHub](https://github.com/jessesquires/ios-watchdog).

This is a relatively lightweight approach to tracking these issues. For a more involved implementation that includes reporting full stacktraces, see [this FB engineering blog post](https://engineering.fb.com/2015/06/25/ios/delivering-high-scroll-performance/) and its accompanying [gist](https://gist.github.com/clementgenzmer/4ff6c51224089cc65e9b).

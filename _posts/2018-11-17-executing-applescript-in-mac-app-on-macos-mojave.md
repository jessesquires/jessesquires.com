---
layout: post
title: Executing AppleScript in a Mac app on macOS Mojave and dealing with AppleEvent sandboxing
subtitle: Or, how I learned about a labyrinth of app entitlements
---

Over a weekend recently I built a tiny Mac app (more on that later). What I was trying to achieve required executing [AppleScript](https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/introduction/ASLR_intro.html), like so many things on macOS. It seemed simple enough, but of course new [app sandboxing](https://developer.apple.com/app-sandboxing/) restrictions in macOS Mojave got in the way.

<!--excerpt-->

### Executing AppleScript

It is surprisingly easy to run AppleScript within a Mac app. All you need to do is create an instance of [`NSAppleScript`](https://developer.apple.com/documentation/foundation/nsapplescript). Swift's multi-line string literals make it especially nice. You can write your script in the Script Editor, then copy it to your Swift source verbatim. AppleScript can be incredibly powerful and useful. I wrote [this one](https://github.com/jessesquires/safari-tabs-to-omnifocus) to send my currently open Safari tabs to OmniFocus.

{% highlight swift %}
// Example:
//
// AppleScript that tells Safari to search for "macOS"

let source = """
tell application "Safari" to search the web for "macOS"
"""

let script = NSAppleScript(source: source)!
let error: NSDictionary?
script.executeAndReturnError(&error)
{% endhighlight %}

My script was interacting with "System Events", which provides a lot of miscellaneous system-level functionality. I verified that my script was working as expected with the Script Editor app, but it was not working when executed from within my mac app.

### Scripting Additions error

The first error in the Xcode console seemed completely unrelated to my app.

{% highlight bash %}
skipped scripting addition "/Library/ScriptingAdditions/Adobe Unit Types.osax" because it is not SIP-protected.
{% endhighlight %}

I'm not familiar with "Scripting Additions" but I discovered there were [some big changes in Mojave](https://latenightsw.com/mojave-brings-in-big-security-changes/) that essentially killed this feature. (Shocking.) As expected, this error was in fact completely unrelated to my app &mdash; this file, `Adobe Unit Types.osax`, belongs to Adobe. (I have an older version of Photoshop installed.) I don't know why Xcode displays this error in the console for *my app*. It seems like it would be simple filter out these irrelevant logs. It makes for a confusing developer experience. Anyway, it was a great way to foreshadow the pain ahead.

### System Events isn't running

The other error in the console was produced by my code. This is contents of printing the `error` parameter after calling `script.executeAndReturnError(&error)`.

{% highlight bash %}
{
    NSAppleScriptErrorAppName = "System Events";
    NSAppleScriptErrorBriefMessage = "Application isn't running.";
    NSAppleScriptErrorMessage = "System Events got an error: Application isn't running.";
    NSAppleScriptErrorNumber = "-600";
    NSAppleScriptErrorRange = "NSRange: {151, 9}";
}
{% endhighlight %}

Interesting. System Events definitely *is* running. As far as I know, it is *always* running. My guess was that this was a permissions issue. It did not take long to find these posts by [Daniel Jalkut](https://twitter.com/danielpunkass) and [Felix Schwarz](https://twitter.com/felix_schwarz):

- [Apple Events Usage Description](https://indiestack.com/2018/08/apple-events-usage-description/)
- [Reauthorizing Automation in Mojave](https://bitsplitting.org/2018/07/11/reauthorizing-automation-in-mojave/)
- [Apple Event sandboxing in macOS Mojave lacks essential APIs](https://www.felix-schwarz.org/blog/2018/06/apple-event-sandboxing-in-macos-mojave)
- [macOS Mojave gets new APIs around AppleEvent sandboxing &mdash; but AEpocalypse still looms](https://www.felix-schwarz.org/blog/2018/08/new-apple-event-apis-in-macos-mojave)

I do not follow the Mac developer scene closely, but it looks like there had been issues with these APIs since the early betas of Mojave. I suggest reading those posts to get the full picture. In short, there are new sandboxing restrictions in Mojave for AppleEvents &mdash; the macOS mechanism for automation (like AppleScript) and other communication between applications. Those posts clearly explain the problems and how the new limitations negatively affect developers and users.

### Updating plist keys and entitlements

Based on the readings above, the solution was to add the `NSAppleEventsUsageDescription` key to my `Info.plist`. This is exactly how iOS permissions operate, so it was a familiar solution to me. Unfortunately, the app still did not work. I continued to see the "System Events isn't running" error.

After some digging around, I learned about the `com.apple.security.temporary-exception.apple-events` entitlement, buried in [this StackOverflow post](https://stackoverflow.com/questions/21303292/my-applescript-doesnt-work-any-more-when-i-upgrade-my-os-x-to-10-9). Now I had something to search for in the Mac developer docs, and I found [this guide on Temporary Exception Entitlements](https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/EntitlementKeyReference/Chapters/AppSandboxTemporaryExceptionEntitlements.html).

> A temporary exception entitlement permits your macOS app to perform certain operations otherwise disallowed by App Sandbox.
>
> If you need to request a temporary exception entitlement, use Apple’s bug reporting system to let Apple know what’s not working for you. Apple considers feature requests as it develops the macOS platform.

There's an entire section on temporary exceptions for AppleEvents.

> However, with App Sandbox you cannot send Apple events to other apps unless you configure a `scripting-targets` entitlement or an `apple-events` temporary exception entitlement.
>
> The `scripting-targets` entitlement is the preferred way to request the ability to send Apple events to apps that provide scripting access groups, as described in App Sandbox Entitlement Keys.

I needed to add the following entitlement to my `App.entitlements` file. The "temporary exception" in the key name was worrisome. I wondered if this would this be allowed in the Mac App Store? But, now my app worked as expected. Progress!

{% highlight xml %}
<key>com.apple.security.temporary-exception.apple-events</key>
<array>
    <string>com.apple.systemevents</string>
</array>
{% endhighlight %}

### Discovering scripting targets

Despite my uncertainty around this entitlement, I decided to submit my app to the Mac App Store anyway to see what would happen. (Again, I'll write more on this specifically in another post.) It was rejected, of course, because that entitlement exception is "not granted by the Apple Core Security team." Still, I was determined to find a way to make this work. Based on the docs above, it seems like the "App Store approved" entitlement is the `scripting-targets` one.

> The scripting target entitlement contains a dictionary where each entry has the target app’s code signing identifier as the key, and an array of scripting access groups as the value. Scripting access groups are identified by strings and are specific to an app.

The [guide](https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/EntitlementKeyReference/Chapters/AppSandboxTemporaryExceptionEntitlements.html) provides this example for the Mail app.

{% highlight xml %}
<key>com.apple.security.temporary-exception.apple-events:before:10.8</key>
    <string>com.apple.mail</string>

<key>com.apple.security.scripting-targets</key>
<dict>
    <key>com.apple.mail</key>
    <array>
        <string>com.apple.mail.compose</string>
    </array>
</dict>
{% endhighlight %}

Scripting access groups are provided by applications that support scripting via AppleScript. Access groups define groups of scriptable operations, which you can learn more about in [this WWDC talk](https://developer.apple.com/videos/play/wwdc2012/206/). There are a couple of ways to discover what is scriptable in an app. You can open the Script Editor, select `File > Open Dictionary...`, then select the application you want to automate and explore what is possible. This is great for simply writing AppleScript scripts, but I could not find anything that specified which actions were part of an access group. For that, you need to use the `sdef` tool, the scripting definition extractor.

{% highlight bash %}
sdef /Applications/Mail.app
{% endhighlight %}

This will dump the specified application's scripting definition to stdout. I'd recommend tossing the output into a file, so you can open it in an editor.

{% highlight bash %}
sdef /Applications/Mail.app > ~/Desktop/mail_sdef.xml
{% endhighlight %}

Once you have this, you can search for `access-group` in the definition file. For the Mail app, you will eventually find:

{% highlight xml %}
<access-group identifier="com.apple.mail.compose" access="rw"/>
{% endhighlight %}

Cool. Now I have a much better understanding of scripting targets and access groups. What's left is finding out the access groups I need to specify for System Events, so that I can use the approved `com.apple.security.scripting-targets` entitlement.

{% highlight bash %}
sdef /System/Library/CoreServices/System\ Events.app > ~/Desktop/system_events_sdef.xml
{% endhighlight %}

And disappointment ensues. The access groups I need are not there. In fact, the only one available is `com.apple.systemevents.window.position`, which [looks like it was added](https://mjtsai.com/blog/2014/03/04/add-security-access-groups-for-accessibility-apis/) because of [this radar](http://www.openradar.me/16224269) from Craig Hockenberry. About four years later, and no additional access groups have been added.

### App sandboxing is too limited

Generally, [app sandboxing](https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/EntitlementKeyReference/Chapters/EnablingAppSandbox.html) seems like a good feature to protect users. In practice however, it is extremely frustrating for developers who have to navigate a labyrinth of obscure entitlement options, some of which do not yet exist for functionality we want to provide. And the end results for users are extremely confusing permissions dialogs.

Even the big news about [Transmit 5 coming back to the Mac App Store](https://panic.com/blog/transmit-5-on-the-mac-app-store/) was not that promising considering it is still missing some functionality and [required **six** different kinds of temporary entitlement exceptions](https://mjtsai.com/blog/2018/11/16/transmit-5-on-the-mac-app-store/), some of which you must [request special access](https://developer.apple.com/contact/request/privileged-file-operations/) to use. Not much of a "win" for developers if you ask me. This was my first real experience trying to write a Mac app after years of doing iOS development and the majority of my time was spent trying to understand how sandboxing works and which entitlements I needed to specify.

I'll be following up soon with a post about the app.

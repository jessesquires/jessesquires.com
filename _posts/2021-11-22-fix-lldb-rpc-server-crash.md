---
layout: post
categories: [software-dev]
tags: [xcode, bugs, lldb, debugging]
date: 2021-11-22T10:14:07-08:00
title: Xcode LLDB RPC server crash
---

A few weeks ago, I wrote about [this bizarre Xcode 13 crash when running tests]({% post_url 2021-11-03-xcode-13-framework-test-fail %}). I just discovered the root cause for one of the issues I mentioned in that post &mdash; _I think_. At the very least, I have a "fix". The issue happens when running unit tests. Sometimes the full test suite will complete, sometimes not, and then LLDB will crash. This occurs with all of my projects. It doesn't seem to matter what I do, the crash always happens. It has been driving me crazy.

<!--excerpt-->

To be clear: Xcode itself is not crashing, only LLDB. Xcode displays an error alert with the following message:

> The LLDB RPC server has crashed. You may need to manually terminate your process. The crash log is located in ~/Library/Logs/DiagnosticReports and has a prefix 'lldb-rpc-server'. Please file a bug and attach the most recent crash log.

If I click "Details" to view more, Xcode displays the following:

```
Could not launch “<TEST TARGET NAME>”
Domain: IDEDebugSessionErrorDomain
Code: 3
Failure Reason: The LLDB RPC server has crashed. You may need to manually terminate your process. The crash log is located in ~/Library/Logs/DiagnosticReports and has a prefix 'lldb-rpc-server'. Please file a bug and attach the most recent crash log.
User Info: {
    DVTRadarComponentKey = 855031;
    IDERunOperationFailingWorker = DBGLLDBLauncher;
    RawUnderlyingErrorMessage = "The LLDB RPC server has crashed. You may need to manually terminate your process. The crash log is located in ~/Library/Logs/DiagnosticReports and has a prefix 'lldb-rpc-server'. Please file a bug and attach the most recent crash log.";
}
--

Analytics Event: com.apple.dt.IDERunOperationWorkerFinished : {
    "device_model" = "MacBookPro16,2";
    "device_osBuild" = "12.0.1 (21A559)";
    "device_platform" = "com.apple.platform.macosx";
    "launchSession_schemeCommand" = Test;
    "launchSession_state" = 1;
    "launchSession_targetArch" = "x86_64";
    "operation_duration_ms" = 92;
    "operation_errorCode" = 3;
    "operation_errorDomain" = IDEDebugSessionErrorDomain;
    "operation_errorWorker" = DBGLLDBLauncher;
    "operation_name" = IDERunOperationWorkerGroup;
    "param_consoleMode" = 0;
    "param_debugger_attachToExtensions" = 0;
    "param_debugger_attachToXPC" = 1;
    "param_debugger_type" = 3;
    "param_destination_isProxy" = 0;
    "param_destination_platform" = "com.apple.platform.macosx";
    "param_diag_MainThreadChecker_stopOnIssue" = 0;
    "param_diag_MallocStackLogging_enableDuringAttach" = 0;
    "param_diag_MallocStackLogging_enableForXPC" = 0;
    "param_diag_allowLocationSimulation" = 1;
    "param_diag_gpu_frameCapture_enable" = 3;
    "param_diag_gpu_shaderValidation_enable" = 0;
    "param_diag_gpu_validation_enable" = 1;
    "param_diag_memoryGraphOnResourceException" = 0;
    "param_diag_queueDebugging_enable" = 1;
    "param_diag_runtimeProfile_generate" = 1;
    "param_diag_sanitizer_asan_enable" = 0;
    "param_diag_sanitizer_tsan_enable" = 0;
    "param_diag_sanitizer_tsan_stopOnIssue" = 0;
    "param_diag_sanitizer_ubsan_stopOnIssue" = 0;
    "param_diag_showNonLocalizedStrings" = 0;
    "param_diag_viewDebugging_enabled" = 1;
    "param_diag_viewDebugging_insertDylibOnLaunch" = 0;
    "param_install_style" = 0;
    "param_launcher_UID" = 2;
    "param_launcher_allowDeviceSensorReplayData" = 0;
    "param_launcher_kind" = 0;
    "param_launcher_style" = 0;
    "param_launcher_substyle" = 0;
    "param_runnable_appExtensionHostRunMode" = 0;
    "param_runnable_productType" = "com.apple.product-type.tool";
    "param_runnable_type" = 1;
    "param_testing_launchedForTesting" = 1;
    "param_testing_suppressSimulatorApp" = 0;
    "param_testing_usingCLI" = 0;
    "sdk_canonicalName" = "macosx12.0";
    "sdk_osVersion" = "12.0";
    "sdk_variant" = macos;
}
```

As [previously mentioned]({% post_url 2021-11-03-xcode-13-framework-test-fail %}), I filed FB9738278 with Apple. This was their very helpful response:

> Looks like this is crashing in the reproducers, which are disabled. Most likely you created an `/AppleInternal` directory like you are on an internal system. This is not supported.

Who the fuck knows what that means. I replied that I've never created an `/AppleInternal` directory and I have no idea what they are talking about. You would think that a (seemingly serious) crash would receive more attention.

Anyway, last night I finally had a new idea about what might be happening. I haven't changed anything on my machine from a dev tools perspective other than upgrading to Xcode 13 from Xcode 12, after which this issue started happening. I wondered if it might be something with my `~/.lldbinit`, which is the only "modification" I've made to LLDB.

I have [Chisel](https://github.com/facebook/chisel) and [Kaleidoscope's](https://kaleidoscope.app) `lldb_ksdiff` installed. My `~/.lldbinit` imports these, and then contains just a couple of custom commands. I decided to try removing Chisel &mdash; and _the crash stopped happening_. I do not currently understand how or why this is the case &mdash; I don't know enough about the implementation details of Chisel &mdash; but I'm glad I have a "fix". I opened at report for Chisel at [#298 on GitHub](https://github.com/facebook/chisel/issues/298).

Debugging tools have improved sufficiently over the years such that I don't use Chisel often anymore, so it isn't a huge loss. I can always uncomment the import if needed for live debugging. I hope Chisel is the actual underlying problem, and not just a distraction. I'm curious if this issue is affecting anyone else &mdash; though I suspect not, because there would probably be a lot more outcry on Twitter if this were widespread.

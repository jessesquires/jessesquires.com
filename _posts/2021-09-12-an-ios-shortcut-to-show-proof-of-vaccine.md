---
layout: post
categories: [essays]
tags: [ios, ios-shortcuts]
date: 2021-09-12T15:46:48-07:00
title: An iOS shortcut to show proof of vaccine
image:
    file: "shortcut-vaccine-proof-1.jpg"
    alt: "iOS proof of vaccine shortcut code"
    caption: "iOS proof of vaccine shortcut code"
    source_link: null
    half_width: true
---

Here in Oakland and the rest of the Bay Area, more and more restaurants, bars, venues, and various events are requiring that people show proof of vaccine before entering. (As it should be.) Thankfully, all businesses and events allow showing proof digitally rather than carrying around your physical COVID-19 Vaccination Record Card from the CDC. This means you can take a photo with your phone and present that instead of your singular paper copy. This is great, but the tediousness of tapping around my phone to find and display it has been annoying. So, I made an iOS shortcut to present it instantly.

<!--excerpt-->

**A brief side note for California residents:** you can visit [myvaccinerecord.cdph.ca.gov](https://myvaccinerecord.cdph.ca.gov) to get a QR code and digital copy of your COVID-19 vaccination record. This is a more concise format that you can screenshot and save instead of taking a photo of the CDC card. (Of course, not every state has this because the US is a failed state and the only developed country in the world without a proper healthcare system.)

{% include break.html %}

Without a shortcut, navigating to your vaccine card photo is such a pain. You can save it in the Photos app or Files app. If you make it a favorite in Photos, you still have to navigate around your *actual* favorite photos to find it. Also, I don't want this in my photo favorites. Even worse, in the Files app, you can only favorite folders *not* individual files. In both cases, you have to find and open the app, then navigate through multiple taps to open the photo. I like to keep my photos library tidy, so I have saved my Digital California COVID-19 Vaccination Record screenshot in iCloud in the Files app.

Unfortunately, the Files app on iOS does not provide any app-specific shortcuts, for example, to open a specific file. This means we have to get a bit creative. What the Shortcuts app does provide, however, is the ability to open URLs &mdash; and that includes file URLs. The path to your root iCloud documents directory in the Files app is `shareddocuments://private/var/mobile/Library/Mobile Documents/com~apple~CloudDocs/`. I have my proof of vaccine photo stored in iCloud at `covid19/vax.png`. Thus, the full file path is `shareddocuments://private/var/mobile/Library/Mobile Documents/com~apple~CloudDocs/covid19/vax.png`. You can adjust this based on what you have named your file and where you have stored it.

Once we have the URL, we can create a simple shortcut that opens that URL.

{% include post_image.html %}

Then, you can add this shortcut to your homescreen or display it in a Shortcuts widget.

{% include blog_image.html
    file="shortcut-vaccine-proof-2.jpg"
    alt="iOS proof of vaccine shortcut on homescreen"
    caption="iOS proof of vaccine shortcut on homescreen"
    source_link=null
    half_width=true
%}

That's it! Now tapping this shortcut will open and present this file in Files app. It's fast and easy.

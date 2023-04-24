---
layout: post
categories: [software-dev]
tags: [ios, macos, swiftui, apps, indie-dev, contracting, freelance, consulting, taxatio-journal]
date: 2023-04-24T09:46:19-07:00
title: Introducing Taxatio
image:
    file: taxatio.jpg
    alt: Taxatio for iOS and macOS
    caption: null
    source_link: null
    half_width: false
---

I'm excited to share that I recently released a new app, a tax calculator for freelancers called [Taxatio](https://www.hexedbits.com/taxatio/). It is specifically for self-employed sole proprietors based in the United States --- freelancers, consultants, independent contractors, and indie developers (like me!). One of the more confusing and difficult aspects of [going independent]({% post_url 2023-04-10-going-indie %}) is taxes. And that's why I made this. It is a multiplatform SwiftUI app for iOS and macOS available as a universal purchase [on the App Store](https://apps.apple.com/app/taxatio/id6443885452).

<!--excerpt-->

I did a soft launch [back in December](https://www.hexedbits.com/news/2022/12/05/taxatio-launch/) and released the first update [last month](https://www.hexedbits.com/news/2023/03/31/taxatio-update/). It has been a long process and a fun project, and I'm glad I can finally share it. Ultimately, I made this app for myself. As [an indie dev and contractor]({% post_url 2023-04-10-going-indie %}), taxes are confusing and hard --- at least at first. There is much more to consider as opposed to being a full-time W-2 employee. Notably, you have to pay quarterly estimated taxes since deductions are not automatically taken from your payments from clients as a 1099 contractor.

This app started out as a note in the Notes app with my rough calculations and estimations. When that got too ridiculous, I made a Swift Playground. When that grew unwieldy, I moved all the calculation code into a proper Swift Package with unit tests. After that, I realized that all I needed to do was build a UI and then anyone could use this tool and benefit from it. Now here I am, with a fully-fledged app for iOS and macOS, built with SwiftUI.

{% include post_image.html %}

### The name and icon

The word [taxatio](https://en.wiktionary.org/wiki/taxatio) is a Latin noun meaning "valuing" or "estimation" and it is the root of the English word _taxation_. Note that it is **not** pronounced "Tax a tio" (tax a TEE-OH) like one of my good friends guessed, which I think is how you say "tax an uncle" in Spanish. You can listen to the correct [pronunciation here](https://translate.google.com/?sl=la&tl=en&text=taxatio&op=translate). So, that's the name!

I am not a designer, but I attempted to make an icon anyway. It is a stylized dollar sign with abstract flames in the background. The intent is to subtly communicate that paying taxes is similar to lighting your money on fire (at least in the US where tax money is primarily used to subsidize the lives of the rich). The more I learn about taxes in general, the more I realize that income tax is specifically designed to punish poor people, whose only means to earn income is through wage labor. Meanwhile, other forms of "income" that ultra wealthy people have --- like simply owning property, inheritance, and stonks --- are taxed at significantly lower rates. But, I digress.

### Motivations, goals, and constraints

I want to emphasize that this app is nothing like TurboTax, QuickBooks, or similar apps. It is a simple estimator. If you have an independent business, you probably use QuickBooks for bookkeeping. I do too. However, you might notice that the quarterly estimated taxes that QuickBooks attempts to estimate are always wrong. This was a big motivation for me to do these calculations myself. QuickBooks simply tries to be too smart based on historical data (which you do not have when you first start out) and projections based on current data (which may not be accurate depending on your upcoming contracts). Additionally, QuickBooks does not know anything about retirement contributions which may also affect your taxes.

This app is obviously very niche and is mostly for myself, but it serves a few purposes. I wanted to learn SwiftUI and specifically experiment with making a multiplatform app for iOS (iPhone and iPad) and macOS (not using Catalyst). It is a tool I wanted to have and use to get a better understanding of my taxes and to do financial planning during the year. And finally, it is a good project to add to my portfolio. This was my first time ever using SwiftUI.

The icing on the cake is that I could make this a _real_ app and sell it on the App Store --- and hopefully help out other contractors and freelancers like myself, which is my other primary motivation. You could type "tax calculator" into your favorite search engine and you will find a bunch of poorly-written, sleazy-looking websites to estimate your taxes --- they all have a rather terrible experience and limited functionality. I knew I could do much better in general, but more specifically, I wanted Taxatio to also be a tool for folks _to learn and understand_ what is going on with their taxes. Taxatio has clear breakdowns to show you how things are computed, and each part of the app has helpful tooltips that explain the calculations and tax rules.

I had a few constraints for building it. I wanted to experiment with out-of-the-box, vanilla iOS and macOS development. That meant no third-party libraries or assets, only use SwiftUI (when possible), only use SFSymbols, customize behavior as little as possible, etc. In other words, what can you do with _just_ Xcode and everything else that Apple provides with minimal customization? This was important, because this is not an app that I want to spend _that_ much time on --- it is a small, fun project with a limited scope. There were only a few occasions where I needed to use AppKit and UIKit. Much to my surprise and delight, you can get quite far with only the SDK and no third-party help nowadays!

### Features and limitations

As I mentioned, Taxatio has an intentionally limited scope --- there is no way for me to reasonably account for all tax scenarios unless I want to spend my entire life writing tax software. The biggest constraints are that the app assumes you are a single-filer and have no dependents. This may change in the future, but those are not scenarios I need to accommodate for myself. Presently, deductions are limited to a single field but I plan to expand on this in future updates. I might also expand on different types of retirement accounts if there are enough requests. Even with these constraints, I suspect the app will be useful to quite a few people.

After you enter your income, expenses, deductions, etc. you are presented with a detailed breakdown of your adjusted gross income, federal income tax, state income tax, and self-employment tax. Each field also has tooltips that explain how the value was computed. You can also see your tax brackets, along with a breakdown of how much you pay in each bracket. You can select the specific tax year to do historical comparisons, too. It begins with 2020, which is the year [I went independent]({% post_url 2023-04-10-going-indie %}) and started doing my own calculations in the Notes app, so this is sort of a small "easter egg".

### Getting to an MVP

This project reminded me how damn hard it is to **actually release** software. The core functionality only took around a month or two to write, building the initial UI (for iOS _and_ macOS) took about another month or two, and then I spent maybe another month on polish, bug fixes, and refinements. Of course, these were not 4-5 consecutive months, but days and weeks spread out over the course of last year. I had a finished app for months before actually submitting to the App Store. I really dragged my feet on getting all of the metadata together (screenshots, description, etc.) as well as building [a product page](https://www.hexedbits.com/taxatio/). For me, all of this stuff at the end is the hardest part --- it's not as fun as programming.

 There is a blog post I read long ago about shipping software and deciding on what will suffice for a minimum viable product (MVP). The author wrote something like, _"You should never be embarrassed by what you ship as an MVP, but you **should** be embarrassed by what you **do not** ship."_ The idea was that MVPs are, by definition, not what you _want_ to ship but what you _have to_ ship. You have to stop somewhere for 1.0, otherwise you will be developing forever and never release anything. I cannot remember who wrote that post. If you know, please tell me and I will link to it!

 Anyway, this is so true. If you _are not_ embarrassed by all the features your app is missing then you waited too long. (Again, you _should_ be proud of what you _do_ ship.) I shipped 1.0 _without_ state tax calculations. It only computed federal income tax and self-employment tax. Was that embarrassing? Yes, but I'm glad I shipped sooner rather than later and I'm proud of all the features that 1.0 did have --- including a bunch of easter eggs. Did I prioritize easter eggs over actual features? Yes, absolutely. (I'll write more on this another time.)

 The main reason I waited to write this post was so I could [ship an update](https://www.hexedbits.com/news/2023/03/31/taxatio-update/) that included state taxes and be less embarrassed about this announcement. Implementing state tax calculations was difficult and took _soooo_ long because all the states are different. Not to mention, I only ever needed to compute California income tax for myself, so this was the first big feature that provided functionality beyond my own needs.

### Development retrospective

Like I mentioned above, the total time it took to make this app was only a few months, but it was spread out over many more. The most difficult part was understanding how to do all the various calculations correctly and finding all of the information about tax brackets, etc. which change every year. There is no centralized database for all of this information. I was learning SwiftUI as I went. I was developing for three devices --- iPhone, iPad, and Mac --- and two platforms. Given all of that, I feel like the timeline was reasonable.

Overall, this was a great experience and when SwiftUI _just works_ it feels magical. However, when SwiftUI _does not_ work as advertised, it is significantly more confusing than UIKit or AppKit. SwiftUI often has surprising, unexpected behavior. It is very limited compared to UIKit and AppKit, yet what it does provide is typically extremely good. One thing I know for certain is that I would not have been able to build for both iOS and macOS this quickly without SwiftUI.

I think SwiftUI was very well suited for this tiny, simple app. However, I will not _always_ reach for SwiftUI in the future. For more complex apps, I still prefer using UIKit/AppKit --- or, at least I'll start with a UIKit/AppKit shell. I have a few more app ideas I want to pursue and only some of them would be good candidates for being entirely SwiftUI.

### Open source coming soon

I mentioned above that an early phase of this app was just a Swift Package and a Playground. That package is called `TaxCalc` and I plan to make it open source eventually --- hopefully by the end of this year. This package encapsulates all the core functionality in the app. I do not plan to open source the entire app. But in theory, you take the package and build your own UI on top of it.

### Taxatio dev journal series

Finally, I plan to write a short series of posts about how and why I implemented various parts of the app. I learned a lot while making it. I hope you enjoyed this introductory post. Stay tuned for more! And if you appreciate my blog, consider [going to the App Store](https://apps.apple.com/app/taxatio/id6443885452) and giving me some money!

---
layout: post
categories: [essays]
tags: [tech, politics, capitalism, apple]
date: 2021-03-30T19:56:17-07:00
date-updated: 2025-10-24T12:29:50-07:00
title: Apple's cooperation with authoritarian governments
---

Over the past few years, Apple seems increasingly willing to cooperate with authoritarian governments, uninterested in protecting its own users, and unwilling to actually standup for human rights in broad terms, as often [portrayed by its marketing department](https://s2.q4cdn.com/470004039/files/doc_downloads/gov_docs/2020/Apple-Human-Rights-Policy.pdf) or [direct statements from CEO Tim Cook](https://www.npr.org/sections/alltechconsidered/2015/10/01/445026470/apple-ceo-tim-cook-privacy-is-a-fundamental-human-right).

<!--excerpt-->

The company is quick to position itself as a [prominent human rights advocate](https://www.macrumors.com/2020/09/04/apple-publishes-human-rights-policy/) in the corporate world, especially regarding issues like user privacy and security. Although, [as Ole Begemann has aptly pointed out](https://oleb.net/2020/icloud-end-to-end-encryption/), this is increasingly disingenuous to the point of deliberately deceiving its customers and the general public. There are even (unconfirmed) reports that the lack of end-to-end encryption [that Ole criticizes](https://oleb.net/2020/icloud-end-to-end-encryption/) is actually due to [willful coordination and cooperation with the FBI](https://www.reuters.com/article/us-apple-fbi-icloud-exclusive/exclusive-apple-dropped-plan-for-encrypting-backups-after-fbi-complained-sources-idUSKBN1ZK1CT). And like most companies in the industry, Apple employs a [highly problematic](https://www.washingtonpost.com/technology/2020/12/29/lens-technology-apple-uighur/) [supply chain](https://www.theinformation.com/articles/apple-took-three-years-to-cut-ties-with-supplier-that-used-underage-labor), which makes its human rights crusade seem even less authentic.

Most recently, there was a [dispute with ProtonVPN](https://www.macrumors.com/2021/03/23/protonvpn-app-store-dispute-myanmar/) (the company that also makes [ProtonMail](https://protonmail.com)) over an update for its app in the App Store. [Proton Technologies claimed](https://protonvpn.com/blog/apple-blocks-app-updates/) that Apple was intentionally blocking the update amid the ongoing [crackdown in Myanmar](https://www.bbc.com/news/world-asia-56546920). I agree [with Gruber](https://daringfireball.net/2021/03/apple_protonvpn) that there is little direct evidence to support this *exact claim*. While I am willing to give Apple the benefit of the doubt and consider this an inconvenient coincidence, I would **not** be surprised if this _were_ a deliberate move. After all, [Apple has pulled VPN apps from the App Store](https://www.nytimes.com/2017/07/29/technology/china-apple-censorhip.html) before. For now, we can assume (as Gruber highlights) that this is yet another issue with Apple's poorly executed app review process where its so-called [rules are applied arbitrarily](https://mjtsai.com/blog/2021/03/23/protonvpn-security-updates-rejected-due-to-previously-approved-app-description/).

However, there is still reason to be concerned, because Apple does not have a laudable record when it comes to cooperating with authoritarian governments. Below is a brief history of events that I have been tracking so far. If you know of others, get in touch.

{% include break.html %}

##### January 2017 --- Apple removed NYT from the China App Store

[Katie Benner and Sui-Lee Wee, reporting for the New York Times](https://www.nytimes.com/2017/01/04/business/media/new-york-times-apps-apple-china.html):

> Apple, complying with what it said was a request from Chinese authorities, removed news apps created by The New York Times from its app store in China late last month.

##### July 2017 --- Apple removes VPN apps from China App Store

[Paul Mozur, reporting for the New York Times](https://www.nytimes.com/2017/07/29/technology/china-apple-censorhip.html):

> China appears to have received help on Saturday from an unlikely source in its fight against tools that help users evade its Great Firewall of internet censorship: Apple.
>
> Software made by foreign companies to help users skirt the country’s system of internet filters has vanished from Apple’s app store on the mainland.

[ExpressVPN](https://www.expressvpn.com/blog/china-ios-app-store-removes-vpns/):

> We received notification from Apple today, July 29, 2017 --- at roughly 04:00 GMT, that the ExpressVPN iOS app was removed from the China App Store. Our preliminary research indicates that all major VPN apps for iOS have been removed.

##### November 2017 --- Apple removes Skype from China App Store

[Paul Mozur, reporting for the New York Times](https://www.nytimes.com/2017/11/21/business/skype-app-china.html):

> "We have been notified by the Ministry of Public Security that a number of voice over internet protocol apps do not comply with local law. Therefore these apps have been removed from the app store in China," an Apple spokeswoman said Tuesday in an emailed statement responding to questions about Skype’s disappearance from the app store.

##### September 2019 --- Apple adopts a "SIM canary"

If you insert a Chinese carrier SIM, apps like TikTok & Apple News no longer function.

[Wang Boyuan on Twitter](https://twitter.com/thisboyuan/status/1169413062736007168) (via [Daniel Sinclair](https://twitter.com/_DanielSinclair/status/1169420981179428864)):

> TikTok for iOS has an unique region (i.e. China) lock. Before that it was Apple News.
> News detects iPhone’s SIM region, you can’t use the app only when ALL sims are from China.
> TikTok also checks SIM region, the diff is you can’t use it if ONE of the sims is from China.
>
> Having two sims inserted, one local and one roaming from China, TikTok can’t load a single video. Also failed on airplane mode. It works only after I take the China sim out.

[Daniel Sinclair on Twitter](https://twitter.com/_DanielSinclair/status/1169420981179428864):

> I had no idea China-bound iPhones were shipping with physical dual SIM support. Clever tactic to region users.
>
> iPhone XS Max and iPhone XR. iPhone XS only supports dual SIMs with an eSIM.
>
> This is a pretty intense tactic, and I think it will be increasingly more common as the Chinese tech ecosystem diverges. It's pretty concerning that Apple itself adopts it. The Great Firewall is moving to the metal; the VPNs won't work in that future.

##### October 2019 --- Apple removes Taiwan flag emoji in iOS 13

[Kris Cheng, reporting for the Hong Kong Free Press](https://hongkongfp.com/2019/10/05/taiwan-flag-emoji-disappears-latest-apple-iphone-keyboard/):

> The Republic of China flag emoji has disappeared from Apple iPhone’s keyboard for Hong Kong and Macau users. The change happened for users who updated their phones to the latest operating system.
>
> Updating iPhones to iOS 13.1.1 or above caused the flag emoji to disappear from the emoji keyboard. The flag, commonly used by users to denote Taiwan, can still be displayed by typing “Taiwan” in English, and choosing the flag in prediction candidates.

This unfortunately wasn't a bug, as [the same behavior shipped in iOS 13.2](https://twitter.com/_danielsinclair/status/1180603673967153153?s=21).

See also: reporting by [The Verge](https://www.theverge.com/2019/10/7/20903613/apple-hiding-taiwan-flag-emoji-hong-kong-macau-china).

##### October 2019 --- Apple Removes HKmap.live from the App Store

[Jack Nicas, writing for The New York Times](https://www.nytimes.com/2019/10/09/technology/apple-hong-kong-app.html):

> Apple removed an app late Wednesday that enabled protesters in Hong Kong to track the police, a day after facing intense criticism from Chinese state media for it, plunging the technology giant deeper into the complicated politics of a country that is fundamental to its business.

See also: reporting by [The Verge](https://www.theverge.com/2019/10/10/20908498/apple-ceo-tim-cook-hong-kong-protest-app-removed-store-email-employees-hkmaplive) and [MacRumors](https://www.macrumors.com/2019/10/18/us-lawmakers-condemn-apple-decision-hkmap-app/).

These decisions have real consequences for movements. In January 2021 --- [the Hong Kong police arrested 53 elected pro-democracy officials and activists](https://www.nytimes.com/2021/01/05/world/asia/hong-kong-arrests-national-security-law.html), advancing Beijing's initiative to quash dissent.

##### November 2019 --- Apple changes Crimea map to meet Russian demands

[The BBC](https://www.bbc.com/news/technology-50573069):

> Apple has complied with Russian demands to show the annexed Crimean peninsula as part of Russian territory on its apps.
>
> Russian forces annexed Crimea from Ukraine in March 2014, drawing international condemnation.
>
> The region, which has a Russian-speaking majority, is now shown as Russian territory on Apple Maps and its Weather app, when viewed from Russia.

##### November 2019 --- Trump re-election campaign ad shot in Apple's Mac Pro plant in Austin

[Gruber, at Daring Fireball](https://daringfireball.net/2019/11/cook_trump_campaign_ad):

> This wasn’t a promotion for the Mac Pro or its assembly plant. It was a promotion for Trump. This video makes it look like Trump’s trade policies have been good for Apple and that Tim Cook supports Trump.
>
> [...]
>
> This is how Apple chose to unveil the packaging for the Mac Pro — in a poorly-shot overexposed propaganda video by the White House, scored with bombastic music that sounds like it came from an SNL parody of a Michael Bay film.

See also: [No, That Mac Factory in Texas Is Not New](https://www.nytimes.com/2019/11/20/us/politics/trump-texas-apple-factory.html) by Jack Nicas at The New York Times.

Admittedly, this event is a bit of an outlier in relation to the others I have listed so far. But it is important to mention. This ad revealed how much effort Tim Cook is willing to exert to debase not only himself, but his entire company, to avoid tariffs and please whoever wields political power.

I find it difficult to reconcile. How can you claim to stand up for human rights while voluntarily participating in a re-election campaign ad for The Human-Rights-Violator-in-Chief? And to top it off, [Tim Cook gifted Trump the 'first' 2019 Mac Pro](https://www.macrumors.com/2021/01/20/tim-cook-donald-trump-mac-pro-gift/). Gruber is adamant that Cook does not support Trump and that Cook personally engaging with Trump does not imply support. However, I fail to see how that is relevant, when Cook is clearly willingly to play the game, regardless of his personal views.

This campaign ad made obvious the tacit acknowledgment that Tim Cook is merely a capitalist --- not a human rights activist. Apple is ultimately beholden to shareholders and investors, which means the pursuit of profit takes priority over anything else --- including and especially human rights violations.

##### February 2020 --- Apple removed Plague Inc. from Chinese App Store

[Eliza Gkritsi, writing for TechNode](https://technode.com/2020/02/27/plague-inc-removed-from-chinese-app-stores-amid-outbreak/):

> Popular infection simulation game Plague Inc. has been removed from Chinese app stores, Apple and Xiaomi users noticed today, after enjoying renewed popularity during the Covid-19 outbreak.
>
> Why it matters: The removal shows just how serious the country’s authorities are in managing the public perception of the virus.
>
> Chinese authorities have been known to ban adult content and games with politically sensitive hidden messages. Plague Inc. has been praised for its educational value and scientific approach.

##### October 2020 --- Apple forced Telegram to close channels run by Belarus protestors

[Scott Chipolina, writing for Decrypt](https://decrypt.co/44339/telegram-forced-to-close-channels-run-by-belarus-protestors):

> Apple is requesting that Telegram shut down three channels used in Belarus to expose the identities of individuals belonging to the Belarusian authoritarian regime that may be oppressing civilians.

See also: [Michael Tsai's round up](https://mjtsai.com/blog/2020/10/09/apple-forces-telegram-to-close-channels-run-by-belarus-protestors/), and Daring Fireball's [Telegram, Apple, Belarus, and Conflating ‘Irrelevance’ With ‘Inconvenience’](https://daringfireball.net/2020/10/telegram_apple_belarus)

##### September 2020 --- Apple helps track down BLM protester

[Thomas Brewster, reporting for Forbes](https://www.forbes.com/sites/thomasbrewster/2020/09/16/apple-helps-fbi-track-down-george-floyd-protester-accused-of-firebombing-cop-cars/):

> Anyone who believes Apple and the FBI are at an impasse over investigations into the iPhone maker’s criminal customers should think again. In Seattle, Apple has given the feds vital evidence from one of its iCloud users who was arrested for firebombing cop cars during the George Floyd protests in late May.
>
> The case shows how Apple is willing to help even where the context of the crime is controversial, namely the Black Lives Matter protests.

(Note: you may be wondering why I have included the US in a list of authoritarian governments. Let me remind you of the [outrageous](https://www.theverge.com/2020/5/31/21276044/police-violence-protest-george-floyd) [police brutality](https://slate.com/news-and-politics/2020/05/george-floyd-protests-police-violence.html) [that we saw](https://www.huffpost.com/entry/police-medics-protests-george-floyd_n_5eda95b1c5b656c8b5c7c83a) [last summer](https://www.bbc.com/news/world-us-canada-52880970). And let's not forget the orange elephant in the room.)

Related, [Apple has reportedly dropped plans](https://www.reuters.com/article/us-apple-fbi-icloud-exclusive/exclusive-apple-dropped-plan-for-encrypting-backups-after-fbi-complained-sources-idUSKBN1ZK1CT) to implement full end-to-end encryption for all of iCloud. [Joseph Menn, reporting for Reuters](https://www.reuters.com/article/us-apple-fbi-icloud-exclusive/exclusive-apple-dropped-plan-for-encrypting-backups-after-fbi-complained-sources-idUSKBN1ZK1CT):

> Apple Inc dropped plans to let iPhone users fully encrypt backups of their devices in the company's iCloud service after the FBI complained that the move would harm investigations, six sources familiar with the matter told Reuters.

While this report is not confirmed, it does seem plausible. After years of incrementally advancing the security of iOS and touting its tough stance on privacy, why has Apple not delivered on end-to-end encryption for iCloud? I understand there are many technical challenges, but surely it should be a high priority.

##### December 2020 --- Pham v. Apple

via [Michael Tsai](https://mjtsai.com/blog/2020/12/31/fired-app-reviewer-sues-apple/):

> At this meeting, defendant Apple supervisors stated that the Guo Media App is critical of the Chinese government and, therefore, should be removed from the App Store. Plaintiff Pham responded stating the Guo Media App publishes valid claims of corruption against the Chinese government and Chinese Communist Party and, therefore, should not be taken down. Plaintiff Pham further told his supervisors that the Guo Media App does not contain violent content or incite violence; does not violate any of defendant Apple’s policies and procedures regarding Apps; and, therefore, it should remain on the App Store as a matter of free speech.
>
> Defendant Apple became aware of plaintiff Pham’s criticism and defendant Apple’s managers responded by retaliating against plaintiff Pham and ultimately terminating plaintiff Pham.

##### February 2021 --- Apple Removes Apps for Pakistani Government

[Megha Rajagopalan, reporting for BuzzFeed](https://www.buzzfeednews.com/article/meghara/pakistan-forced-down-ahmadiyya-apps):

> Over the last two years, the government of Pakistan has forced Google and Apple to take down apps in the country created by developers based in other nations who are part of a repressed religious minority.
>
> [...]
>
> At issue are seven religious apps created by the Ahmadi community in the United States, published under the name “Ahmadiyya Muslim Community.”

##### March 2021 --- Apple reportedly agrees to preinstall Russian software

[RadioFreeEurope](https://www.rferl.org/a/apple-russia-iphone-software/31153385.html):

> Russian media are reporting that Apple has agreed to sell its gadgets in Russia with preinstalled Russian-made software to comply with a law that comes into force on April 1.
>
> [...]
>
> The list of Russian government-approved programs for mandatory preinstallation on smartphones and tablets includes the search engine Yandex, Mail.ru mail and news, ICQ messenger, social network VKontakte, payment system MirPay, and antivirus Kaspersky Lab, among others.

See also: reporting by [Ars Technica](https://arstechnica.com/gadgets/2021/03/apple-bent-its-rules-for-russia-and-other-countries-will-take-note/).

{% include break.html %}

{% include updated_notice.html
message="
The entries below were added after this piece was first published. I will continue to keep this post up-to-date as new events occur. The date of this notice reflects the last time an update was published. Updates are in chronological order. Scroll to the bottom for the most recent update.
"
%}

##### May 2021 --- Seven Apple Suppliers Accused of Using Forced Labor From Xinjiang

[Wayne Ma, reporting for The Information](https://www.theinformation.com/articles/seven-apple-suppliers-accused-of-using-forced-labor-from-xinjiang):

> The industrial park is surrounded by walls and fences with only one way in or out.
>
> And next to the park was a large compound identified by a satellite imagery researcher as a detention center where the factory workers lived. The researcher, Nathan Ruser, from an Australian think tank, said “almost no other factories in Xinjiang have these characteristics except for industrial parks where there is detainee labor.
>
> The Information and human rights groups have found seven companies supplying device components, coatings and assembly services to Apple that are linked to alleged forced labor involving Uyghurs and other oppressed minorities in China. At least five of those companies received thousands of Uyghur and other minority workers at specific factory sites or subsidiaries that did work for Apple, the investigation found.
>
> The revelation stands in contrast to Apple’s assertions over the past year that it hasn’t found evidence of forced labor in its supply chain.

##### May 2021 --- Censorship, Surveillance and Profits: A Hard Bargain for Apple in China

[Jack Nicas, Raymond Zhong, and Daisuke Wakabayashi writing for The New York Times](https://www.nytimes.com/2021/05/17/technology/apple-china-censorship-data.html):

> Tim Cook, Apple’s chief executive, has said the data is safe. But at the data center in Guiyang, which Apple hoped would be completed by next month, and another in the Inner Mongolia region, Apple has largely ceded control to the Chinese government.
>
> Chinese state employees physically manage the computers. Apple abandoned the encryption technology it used elsewhere after China would not allow it. And the digital keys that unlock information on those computers are stored in the data centers they’re meant to secure.
>
> Internal Apple documents reviewed by The New York Times, interviews with 17 current and former Apple employees and four security experts, and new filings made in a court case in the United States last week provide rare insight into the compromises Mr. Cook has made to do business in China. They offer an extensive inside look — many aspects of which have never been reported before — at how Apple has given in to escalating demands from the Chinese authorities.
>
> [...]
>
> Mr. Cook often talks about Apple’s commitment to civil liberties and privacy. But to stay on the right side of Chinese regulators, his company has put the data of its Chinese customers at risk and has aided government censorship in the Chinese version of its App Store. After Chinese employees complained, it even dropped the “Designed by Apple in California” slogan from the backs of iPhones.

See also: [MacRumors](https://www.macrumors.com/2021/05/17/apple-security-compromises-china-icloud/), [Daring Fireball](https://daringfireball.net/2021/05/nyt_apple_china_icloud), and [Michael Tsai](https://mjtsai.com/blog/2021/05/19/a-hard-bargain-for-apple-in-china/).

##### June 2021 --- Apple's new 'private relay' feature will not be available in multiple countries

[Stephen Nellis and Paresh Dave writing for Reuters](https://www.reuters.com/world/china/apples-new-private-relay-feature-will-not-be-available-china-2021-06-07/):

> Apple Inc on Monday said a new "private relay" feature designed to obscure a user's web browsing behavior from internet service providers and advertisers will not be available in China for regulatory reasons.
>
> Apple said it also will not offer "private relay" in Belarus, Colombia, Egypt, Kazakhstan, Saudi Arabia, South Africa, Turkmenistan, Uganda and the Philippines.

##### August 2021 --- Engrave Danger: An Analysis of Apple Engraving Censorship across Six Regions

[Jeffrey Knockel and Lotus Ruan at The Citizen Lab](https://citizenlab.ca/2021/08/engrave-danger-an-analysis-of-apple-engraving-censorship-across-six-regions/):

> We analyzed Apple’s filtering of product engravings in six regions, discovering 1,105 keyword filtering rules used to moderate their content.
>
> Across all six regions we analyzed, we found that Apple’s content moderation practices pertaining to derogatory, racist, or sexual content are inconsistently applied and that Apple’s public-facing documents failed to explain how it derives their keyword lists.
>
> Within mainland China, we found that Apple censors political content including broad references to Chinese leadership and China’s political system, names of dissidents and independent news organizations, and general terms relating to religions, democracy, and human rights.
>
> We found that part of Apple’s mainland China political censorship bleeds into both Hong Kong and Taiwan. Much of this censorship exceeds Apple’s legal obligations in Hong Kong, and we are aware of no legal justification for the political censorship of content in Taiwan.
>
> We present evidence that Apple does not fully understand what content they censor and that, rather than each censored keyword being born of careful consideration, many seem to have been thoughtlessly reappropriated from other sources.

##### September 2021 --- Apple removes Navalny app from stores before Russian elections

[Justin Sherman writing for Wired](https://www.wired.com/story/opinion-in-russia-apple-and-google-staff-get-muscled-up-by-the-state/):

> Earlier this month, when the Kremlin told multiple Big Tech companies to suppress political opposition amid nationwide elections in Russia, their answer was unequivocal: no. Yet just two weeks later, Apple and Google deleted from their app stores the Smart Voting app, opposition leader Alexey Navalny and his party’s primary tool for consolidating votes against Vladimir Putin’s regime. Then Telegram and Google-owned YouTube also restricted access to the recommendations for opposition candidates that Navalny was sharing on these platforms.

See also: [Reuters](https://www.reuters.com/world/europe/google-apple-remove-navalny-app-stores-russian-elections-begin-2021-09-17/).

##### August 2022 --- Apple warns suppliers to follow China rules on 'Taiwan' labeling

[Cheng Ting-Fang and Lauly Li, reporting for Nikkei](https://asia.nikkei.com/Spotlight/Supply-Chain/Apple-warns-suppliers-to-follow-China-rules-on-Taiwan-labeling):

> Apple has asked suppliers to ensure that shipments from Taiwan to China strictly comply with Chinese customs regulations after a recent visit by senior U.S. lawmaker Nancy Pelosi to Taipei stoked fears of rising trade barriers.
>
> Apple told suppliers on Friday that China has started strictly enforcing a long-standing rule that Taiwanese-made parts and components must be labeled as being made either in "Taiwan, China" or "Chinese Taipei," sources familiar with the matter told Nikkei Asia, language that indicates the island is part of China.

It is certainly not a good look when you force your suppliers to print CCP state propaganda on Taiwanese-made parts.

##### January 2023 --- Apple Brings Mainland Chinese Web Censorship To Hong Kong

[Sam Biddle, reporting for The Intercept](https://theintercept.com/2023/01/26/apple-china-censorship-hong-kong-gitlab/):

> Apple quietly expanded the use of Chinese company Tencent's website blacklist to users in Hong Kong --- and no one will answer questions about it.
>
> When Safari users in Hong Kong recently tried to load the popular code-sharing website GitLab, they received a strange warning instead: Apple's browser was blocking the site for their own safety. The access was temporarily cut off thanks to Apple's use of a Chinese corporate website blacklist, which resulted in the innocuous site being flagged as a purveyor of misinformation. Neither Tencent, the massive Chinese firm behind the web filter, nor Apple will say how or why the site was censored.

##### December 2023 --- Governments spying on Apple, Google users through push notifications

[Raphael Satter, reporting for Reuters](https://www.reuters.com/technology/cybersecurity/governments-spying-apple-google-users-through-push-notifications-us-senator-2023-12-06/):

> Unidentified governments are surveilling smartphone users via their apps' push notifications, a U.S. senator warned on Wednesday.
>
> [In a letter to the Department of Justice](https://www.documentcloud.org/documents/24191267-wyden_smartphone_push_notification_surveillance_letter_to_doj_-_signed), Senator Ron Wyden said foreign officials were demanding the data from Alphabet's Google and Apple. Although details were sparse, the letter lays out yet another path by which governments can track smartphones.

See also: [MacRumors](https://www.macrumors.com/2023/12/06/apple-governments-surveil-push-notifications/), [Michael Tsai](https://mjtsai.com/blog/2023/12/06/governments-using-push-notifications-to-surveil-users/), [9to5Mac](https://9to5mac.com/2023/12/06/push-notification-spying/), [Washington Post](https://www.washingtonpost.com/technology/2023/12/06/push-notifications-surveillance-apple-google/), and [404 Media: _Here's a Warrant Showing the U.S. Government is Monitoring Push Notifications_](https://www.404media.co/us-government-warrant-monitoring-push-notifications-apple-google-yahoo/).

##### April 2024 --- Apple removes popular messaging apps from App Store in China

[MacRumors](https://www.macrumors.com/2024/04/19/apple-pulls-whatsapp-telegram-signal-threads-china/):

> Apple on late Thursday into Friday removed the popular messaging and social media apps WhatsApp, Telegram, Signal, and Threads from its App Store in China at the request of the Chinese government [...]
>
> Apple has complied with similar App Store removal orders from the Chinese government in the past for apps related to VPNs, news, and more.

##### July 2024 --- Apple removes VPN apps from the App Store in Russia

[William Gallagher, reporting for Apple Insider](https://appleinsider.com/articles/24/07/05/russia-forces-apple-to-remove-vpn-apps-from-the-app-store):

> Apple has caved to pressure from Russian authorities and removed a number of the best iPhone VPN apps from the App Store in the country.
>
> Apple's App Store team has been notifying VPN developers that their apps are being removed "per demand from Roskomnadzor." This the state media watchdog that previously forced both Apple and Google to remove a political app backed by the leader of the country's opposition.
>
> [...]
>
> Reportedly, VPN usage increased dramatically in Russia following the start of the war with Ukraine. At that point, Russian authorities blocked access to a number of Western social media sites.

See also: [Michael Tsai](https://mjtsai.com/blog/2024/07/05/apple-removes-vpn-apps-from-russian-app-store/)

##### October 2025 --- Apple removes multiple ICE reporting apps from the App Store

[Pablo Manriquez, reporting for Migrant Insider](https://migrantinsider.com/p/scoop-apple-quietly-made-ice-agents):

> Apple has quietly removed DeICER, a civic-reporting app used to log immigration enforcement activity, from its App Store after a law enforcement complaint — invoking a rule normally reserved for protecting marginalized groups from hate speech.

See also: [Michael Tsai](https://mjtsai.com/blog/2025/10/10/deicer-removed-from-the-app-store/), [Daring Fireball](https://daringfireball.net/linked/2025/10/09/apple-app-store-deicer)

[JOSEPH COX, report for 404 Media](https://www.404media.co/apple-banned-an-app-that-simply-archived-videos-of-ice-abuses/):

> Apple removed an app for preserving TikToks, Instagram reels, news reports, and videos documenting abuses by ICE, 404 Media has learned. The app, called Eyes Up, differs from other banned apps such as ICEBlock which were designed to report sightings of ICE officials in real-time to warn local communities. Eyes Up, meanwhile, was more of an aggregation service pooling together information to preserve evidence in case the material is needed in the future in court.

See also: [Michael Tsai](https://mjtsai.com/blog/2025/10/09/eyes-up-removed-from-the-app-store/), [Daring Fireball](https://daringfireball.net/linked/2025/10/09/apple-banned-eyes-up)

[Business Insider](https://www.businessinsider.com/apple-iceblock-app-store-removed-2025-10):

> Apple has removed ICEBlock, an app that allowed users to monitor and report the location of immigration enforcement officers, from the App Store.

See also: [Michael Tsai](https://mjtsai.com/blog/2025/10/03/iceblock-removed-from-the-app-store/)

{% include break.html %}

### Conclusion

So what does any of this have to do with app developers? Why should we care? When it comes to the iOS App Store, Apple controls where we are allowed to distribute our apps. More importantly, Apple has the unilateral power remove our apps from *any* App Store region *at any time* to nurture its relationship with whatever unsavory government it is interested in pleasing in order to pursue its political motives or financial objectives.

Apple's centralized power over app distribution combined with its willingness to surrender to political pressures is incredibly concerning as ostensibly "democratic" governments across the globe (including the United Sates!) increasingly exhibit far-right, fascist behavior and implement fascist policies. What will happen when you need to build your own [HKmap.live](https://www.nytimes.com/2019/10/09/technology/apple-hong-kong-app.html)?

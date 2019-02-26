---
layout: post
title: ! 'Agile by degrees: How to estimate engineering project timelines'
subtitle: You were always wrong, until now
image:
    file: engineering_estimates.jpg
    caption: 'Software engineers during their daily stand-up meeting'
    half_width: false
---

I [tweeted a joke](https://twitter.com/jesse_squires/status/1099113115080257537) about estimating software engineering projects while I was at work during a team meeting for a retrospective on a project we recently shipped. The project was not completed within our original estimations. (Did I even need to say that?)

<!--excerpt-->

<span class="text-muted"><i>Estimated reading time: approx. 3 minutes (or 37.4 hours)</i></span>

> New idea for engineering estimations:
>
> 1. Choose number of weeks you think it will take
> 2. Use that as a temperature in Celsius
> 3. Convert to Fahrenheit
> 4. This is your actual number of weeks
>
> Example:
> 3 weeks > 3 C > 37.4 F > 37.4 weeks

{% include post_image.html %}

I expected to get a few laughs, but now [the tweet](https://twitter.com/jesse_squires/status/1099113115080257537) has gone viral (at least for me at over 3,000 retweets and over 9,000 likes). I think speaks to how visceral this topic is among engineers and project managers. Software engineering was on my mind, but unsurprisingly, it resonated with many folks from other engineering disciplines, too. It is even more comical to me given the context in which I wrote it.

#### Why are we so bad at this

Software (and other engineering) projects are complex and it is difficult to completely internalize and comprehend all aspects of complex systems, then estimate how long it will take to finish or successfully modify them. Does anyone know 100 percent of the behaviors of a non-trivial code base 100 percent of the time? Of course not. Once a piece of software grows to a substantial size and amasses significant functionality, it is nearly or definitely impossible to completely understand and reason about it all the time, for every possible input. I've worked on multiple large apps for multi-year periods of time and for each one there were parts of the code where I had no clue how it actually worked. Usually at least one person knew, so collectively the team understood the code base completely. Yet even that was not always true.

Aside from the inherent technical complexities of building software (or building bridges), humans are [naturally terrible at estimating](https://evolution.berkeley.edu/evolibrary/news/110201_throwing) for evolutionary reasons, as well as psychological ones &mdash; namely, the [planning fallacy](https://en.wikipedia.org/wiki/Planning_fallacy), [optimism bias](https://en.wikipedia.org/wiki/Optimism_bias), and [anchoring](https://en.wikipedia.org/wiki/Anchoring). Considering teams are composed of dozens or sometimes hundreds of humans each estimating their share of a project, it is amazing that we can even attempt to estimate projects at all.

#### Techniques for estimating

Perhaps most ironically (and hilariously), the thread on Twitter is full of other suggestions for "improving" our estimates. But rather than trying to account for an inherent flaw like optimism bias, people suggested varying techniques of applying arbitrary multipliers to their initial estimates. These took two main forms: (1) multiply the estimate by some value, or (2) increase the original estimate then increase the unit of measure. Some examples:

1. Double, triple, or quadruple the estimate. Or, multiply it by pi. 🍰 Example: if you estimate 2 days, then triple it to become 6 days.
2. Add one, then increase the unit of measure. Example: if you estimate 2 weeks, then add one and change weeks to months, to yield 3 months.
3. Double it (or use some other multiplier), then increase the unit of measure. Example: 1 week becomes 2 months.

It sounded absurd to use the Celsius to Fahrenheit conversion, but are any of these much less absurd when you stop to think about it? I can't say I'm optimistic about our abilities to dramatically improve engineering estimates in the future, but at least now we finally have a use for Fahrenheit.

##### Some great replies

The whole thread on Twitter was comical and fun to read. Here are some of my favorites.

*"code freezes at 32 degrees Fahrenheit"* &mdash; [@jakeout](https://twitter.com/jakeout/status/1099153073077915649)

*"That means it will take a minimum of 32 weeks to get anything done."* &mdash; [@wrighthydromet](https://twitter.com/wrighthydromet/status/1099832282439868421)

*"Finally a use for Fahrenheit."* &mdash; [@jimmysjolund](https://twitter.com/jimmysjolund/status/1099251950590324739)

*"And the price is in kelvin."* &mdash; [@AstroMikeMerri](https://twitter.com/AstroMikeMerri/status/1099305565510135809)

*"My favorite part about this is that it works on 'completed' work:<br>
'I finished this 2 weeks ago!'<br>
-2 weeks -> -2℃ -> 28℉ -> 28 weeks<br>
28 more weeks needed!"* &mdash; [@quoll](https://twitter.com/quoll/status/1099289094121840640)

*"If you called it 'agile by degrees' you could just live off the interest of your book sales"* &mdash; [@TJChecketts](https://twitter.com/TJChecketts/status/1099263521198551040)

*"And then back to Celsius again for how long you'll have time to fix everything after requirement changes are announced."* &mdash; [@s1guza](https://twitter.com/s1guza/status/1100074377696157696)

*"5. Explain to project managers that a bigger number means a higher temperature and so the burn down will happen faster."* &mdash; [@dylansmith](https://twitter.com/dylansmith/status/1099966711225372672)

---
layout: post
categories: [essays]
tags: [tech, interviews]
date: 2021-12-01T10:24:15-08:00
title: My worst tech interview experience
---

Everyone in tech seems to have a "terrible tech interview" story. The topic quietly orbits in the ether of our industry and periodically bursts through the atmosphere in the form of a tweet or blog post that [goes viral](https://twitter.com/mxcl/status/608682016205344768). Despite universal loathing of our industry's impetuous and heedless interview processes, few seem willing to improve the [current standard](https://mjtsai.com/blog/2020/07/23/programming-job-interviews/). A recent tweet in my timeline reminded me of a story that I've never told.

<!--excerpt-->

It was sometime around 2015. I was interviewing at various places, and I got an interview with the Apple Watch team. After a full morning, I was on (maybe?) my 4th interview. The interviewer asked me to write [merge sort](https://en.wikipedia.org/wiki/Merge_sort) in C on a whiteboard. Of course, I was familiar with the algorithm and could explain how it works conceptually. But accurately reproducing it on a whiteboard in a programming language that I didn't use daily was, as you might expect, intimidating. Not to mention, I was generally nervous and anxious, because interviews. After only a few lines, the interviewer called out from behind me while comfortably sitting in his chair to make a joke that "you must must be writing a lot of Swift" because I had accidentally omitted a few semicolons.

That comment threw me off for the rest of our time, not only because I was in the middle of a ridiculous whiteboard exercise that would demonstrate nothing, but because it also pissed me off and I had to just be cool about it. At the time, Swift was only a couple of years old and _I was not_ writing it at my current job. It was the early days when Swift was **rough**. My team was avoiding it. I only experimented with Swift for fun at home. I was writing Objective-C all day, every day &mdash; which _does_ have semicolons. But if your whiteboard code doesn't compile, you must be an idiot.

As you've likely concluded, the rest of the hour or so in that room did not turn out well.

{% include break.html %}

However, there's a special irony to this story. This interview took place only a year or two after my _Apples To Apples_ blog post series ([Part 1]({% post_url 2014-06-25-apples-to-apples %}), [Part 2]({% post_url 2014-08-06-apples-to-apples-part-two %}), [Part 3]({% post_url 2014-08-21-apples-to-apples-part-three %})) in which I implemented merge sort along with various other sorting algorithms in Swift, Objective-C, and C, and then compared the results. (Swift used to be **really** slow.) But I didn't write any of those sorting algorithms from memory. I referenced the infinite number of resources on the Internet to write them and ensure they were correct. I certainly didn't internalize any of them. That wasn't the point, nor is that a good use of time &mdash; even now. Those posts were a quick exercise for fun and experimentation, and literally no one has ever written merge sort in production.

Fast forward a few years and I ended up taking a job at Facebook (big mistake, but that's another post). Surprisingly, a few members of the early Swift team ended up leaving Apple and joining Facebook to work on HHVM or something similar, not sure. Anyway, one of those people was [Nadav Rotem](https://github.com/nadavrot), who had worked on the compiler optimizations team. We met for a coffee break after he sent me a message saying he recognized my name from the _Apples To Apples_ blog posts, which had [been fireballed](https://daringfireball.net/linked/2014/08/18/swift-performance) and [linked in iOS Dev Weekly](https://iosdevweekly.com/issues/160#news). I also remember getting a message from Chris Lattner thanking me for writing the posts at the time. I learned that those posts had been circulated internally &mdash; all the way up to Craig Federighi, in fact. Apple was eager to showcase Swift's success in those early days. Nadav's team ended up using the code I wrote to improve optimizations in the compiler.

{% include break.html %}

Given that, I suppose it's pretty funny that I failed an interview dealing with academic sorting algorithms that no one will ever use in their day-to-day work. But how was I supposed to know that the underpinnings of watchOS were built on top of merge sort? It was very early in my career and I was nervous, I somewhat panicked in the moment, and I had to deal with an asshole making jokes. Also, writing code on a whiteboard is fucking stupid &mdash; so there's that.

Even though I did not get an offer, my recruiter was eager to get me interviews with other teams. I've heard all teams are very different within Apple. However, I declined and proceeded with interviews at other companies instead. Another strange thing about this experience is that over the years, I’ve watched some of the people from my interview loop give talks at WWDC.

{% include break.html %}

Since that experience, I've been on both sides of the interview process dozens and dozens of times at various companies. I've learned that a great interviewer knows how to ask great questions that give her a lot of signal about the candidate’s skills while ensuring the candidate always feels comfortable and confident. That's how I interview folks.

Trick questions and esoteric puzzles give the interviewer no useful information about the interviewee &mdash; her skills, her strengths, her weaknesses, her potential for growth. *Those* are the things a great interviewer should be seeking out. That means you give hints when the candidate gets stuck and you don't interrupt them with asinine comments. Whatever problem you give a candidate to solve, your goal as an interviewer should be to get them through as much of that problem as possible, to get as much signal as possible. The added benefit is that the further you get, the better and more confident the candidate feels, which also helps prepare them to do their best for the next session. Less experienced interviewees often need more help, and that's ok.

The goal should **never** be to trick the interviewee &mdash; that’s a waste of everyone’s time. And my interview experience with that team was just that &mdash; a complete waste of my time and theirs.

---
layout: post
title: Apples to apples
subtitle: A comparison of sorts between Objective-C and Swift
excerpt: 
---

When Craig Federighi arrived at his presentation slide about Objective-C during this year's [WWDC keynote](http://www.apple.com/apple-events/june-2014/) everyone in the room seemed puzzled, curious, and maybe even a bit uneasy. *What was happening?* As he continued, he considered what Objective-C would be like **without the C**, and the room abruptly filled with rumblings and whispers <sup><a href="#note1" id="superscript1">[1]</a></sup> as developers in the audience confided in those around them. If you had been following the [discussions](http://kickingbear.com/blog/archives/412) in our community about the [state of Objective-C](http://nearthespeedoflight.com/article/2014_03_17_objective_next) (and why we [need to replace it](http://ashfurrow.com/blog/we-need-to-replace-objective-c)) during the previous months, you could only have imagined one thing: Objective-C was no more &mdash; at least not as we knew it. 

<blockquote>
	<p>And then Federighi said, let there be Swift; and there was Swift.</p>
	<footer>WWDC 2014, 1:44:48</footer>
</blockquote>

The third floor of Moscone West erupted with applause as if we had traveled back in time to Steve Jobs' [2007 announcement](https://www.youtube.com/watch?v=EHWRkuDlNOE) of _**the**_ iPhone: *"An iPod, a phone, and an Internet communicator"*.

As the keynote continued, we were assured safety, optimizations, clarity, modernity, and speed. But, as some have [already investigated](http://www.splasmata.com/?p=2798), Swift may not be as swift as promised. However, Swift is still in beta (along with Xcode 6, iOS 8, and OS X 10.10), so we will undoubtedly see many improvements and changes in the coming months.

As a fun and interesting [code kata](http://codekata.com), I decided to port my [objc-sorts](https://github.com/jessesquires/objc-sorts) project on GitHub to Swift. Behold, [swift-sorts](https://github.com/jessesquires/swift-sorts). These projects are collections of sorting algorithms implemented in Objective-C and Swift, respectively. I completed a rough version of the Swift project during the week of WWDC and have since refined both. I also shared the results below with Apple engineers in the Swift Labs during WWDC, but more on that later.

#### Setup

* *Code:* [Swift Sorts](https://github.com/jessesquires/swift-sorts) and [Objective-C Sorts](https://github.com/jessesquires/objc-sorts)
* *Software:* OS X Mavericks 10.9.3, Xcode6-Beta WWDC seed
* *Hardware:* 2008 unibody MacBook Pro, 2.4 Ghz Intel Core 2 Duo, 8 GB 1067 MHz DDR3 memory <sup><a href="#note2" id="superscript2">[2]</a></sup>

Each project is a command line app with a debug, release, and unit-test scheme. After downloading, simply build and run, then watch the console for output.

The benchmarks consist of *T* trials, which are averaged at the end to obtain the average execution time for each algorithm. Each trial begins by generating an array of *N* random integers in the range `[0, UINT32_MAX)`. Then, each sorting algorithm is passed a copy of this initial array to sort. The current time is logged before and after each sort and the difference between the two yields the execution time for the algorithm for the current trial.

These two programs were carefully crafted to be a true *apples-to-apples* comparison. All of the algorithms, as well as `main.swift` and `main.m`, are implemented as simiarly as possible, bounded only by the confines and paradigms of the languages themselves. In Objective-C, `NSArray` and `NSNumber` are used intentionally as the counterparts to Swift's `Array` and `Int`. The APIs are language-specific too, for example `exchangeObjectAtIndex: withObjectAtIndex:` versus `swap()`. 

The following were used for the standard library sorts:

<script src="https://gist.github.com/jessesquires/06b6bd68a7d18810651f.js"></script>

#### Results

Below are the results of running each program over 10 trials with 10,000 integers. The build configuration settings are noted for each language during each run and the execution times are displayed in seconds. The average case runtime complexity for each algorithm is also noted.

<div class="table-responsive">
	<table class="table table-bordered table-hover">
		<thead>
			<tr>
				<th class="text-muted"><em>T</em> = 10
					<br />
					<em>N</em> = 10,000
				</th>
				<th>Std lib sort</th>
				<th>Quick sort<br/><code>O(n log n)</code></th>
				<th>Heap sort<br/><code>O(n log n)</code></th>
				<th>Insertion sort<br/><code>O(n<sup>2</sup>)</code></th>
				<th>Selection sort<br/><code>O(n<sup>2</sup>)</code></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<th>Objective-C <code>-O0</code> (debug)</th>
				<td>~0.015813 s</td>
				<td>~0.011393 s</td>
				<td>~0.023052 s</td>
				<td>~1.945385 s</td>
				<td>~3.745795 s</td>
			</tr>
			<tr>
				<th>Objective-C <code>-O3</code> (release)</th>
				<td>~0.012037 s</td>
				<td>~0.010317 s</td>
				<td>~0.020318 s</td>
				<td>~1.777335 s</td>
				<td>~3.508259 s</td>
			</tr>
			<tr>
				<th>Swift <code>-Onone</code> (debug)</th>
				<td>~</td>
				<td>~</td>
				<td>~</td>
				<td>~</td>
				<td>~</td>
			</tr>
			<tr>
				<th>Swift <code>-O</code> (release)</th>
				<td>~0.079272 s</td>
				<td>~0.072787 s</td>
				<td>~0.212094 s</td>
				<td>~28.431325 s</td>
				<td>~8.662720 s</td>
			</tr>
			<tr>
				<th>Swift <code>-Ofast</code> (release)</th>
				<td>~0.022573 s</td>
				<td>~0.005410 s</td>
				<td>~0.005903 s</td>
				<td>~0.997563 s</td>
				<td>~0.113045 s</td>
			</tr>
		</tbody>
	</table>
</div>

<p class="text-muted">Note that <code>-O</code> is the standard optimization level for Swift and <code>-Ofast</code>, though faster, removes <strong>all</strong> safety features (<em>array bounds-checking, integer overflow checking, etc.</em>) from Swift. In other words, do not ship an entire app compiled with <code>-Ofast</code>. According to the Apple engineers that I spoke with, <code>-O3</code> in Objective-C is essentially the eqivalent to <code>-O</code> in Swift.</p>

There are a few notable discoveries here:

1. Objective-C *without* optimizations running in debug outperforms Swift *with* optimizations running in release. Only with <code>-Ofast</code> do we begin to experience the swiftness of Swift, and even then the standard library sort in Objective-C is faster. According to Craig Federighi's slides on benchmarks during the keynote (1:45:30), we should (probably?) be seeing different results here. He noted benchmarks for complex object sort that showed Objective-C performing at 2.8x and Swift at 3.9x, using Python as the baseline (1.0x). It is not clear at this time how these benchmarks were acheived. What were the build and optimization settings? What is a "complex object"? In any case, surely Swift should be able to sort integers just as well as "complex objects", right?

2. We all know that selection sort and insertion sort are not particularly optimal algorithms, and Swift does a good job to emphasize this. But why are these two so terrible in Swift? Especially insertion sort. *Especially insertion sort.*

3. My not-at-all-special quick sort implementation is faster than the standard library sort for both languages. Typically, these methods would utilize multiple sorting algorithms that are guided by a set of heuristics that help determine the best algorithm to use based on the dataset. I suspect that we would see the standard library sorts perform best with larger datasets and/or with complex objects. 

#### Swift Labs at WWDC

The Apple engineers hanging out in the Swift Labs at WWDC were very interested in these benchmarks and were somewhat surprised to see them. Unfortunately, they did not really have an explanation for why we were seeing these results. We filed Radar #17201160, noting the three points above.

Additionally, I asked what the best practices are with regard to using <code>-Ofast</code>. They recommended the following approach: (1) profile your app to find out where it is slow, (2) extract this slow code into a separate module/framework, (3) very thoroughly test this framework, (4) compile the framework using <code>-Ofast</code> and link it to your app.

#### Moving forward

The results above seem to indicate that Apple has not (yet) followed through on their promises of speed and safety, particularly in the sense that these features can be mutually inclusive. Again, it is still early. Hopefully these benchmarks will improve as Swift nears v1.0. As Brent Simmons [said](http://inessential.com/2014/02/12/on_replacing_objective-c), Objective-C used to be considered slow compared to plain C, but it is not slow compared to Java or Python. I am not sure if the correct reaction to these results should be *we have faster hardware, so a slower language is fine*, or *nothing will ever be as fast as C*. But after completing these two projects, I do know this: Swift is a pleasure to write and read. Many things came easier and more naturally in Swift, and Playgrounds are pure gold.

In the end, I think Apple was exactly right: Swift *is* Objective-C **without the C**.

**I plan on updating this post or writing follow-up posts as Apple releases updates to Xcode6-beta and Swift.**

#### Futher reading

* [*Swift?*](http://www.splasmata.com/?p=2798) from Splasm Software
* [*The Foundation Collection Classes*](http://www.objc.io/issue-7/collections.html) by Peter Steinberger, objc.io issue #7

<div class="footnotes text-muted">
	<ul>
		<li>
			<a href="#superscript1" id="note1">[1]</a> If you turn up the volume and listen closely, you can hear this in the keynote video. It was much louder in person.
		</li>
		<li>
			<a href="#superscript2" id="note2">[2]</a> If you are thinking, <em>this guy needs a new MacBook</em> &mdash; you are correct! :)
		</li>
	</ul>
</div>

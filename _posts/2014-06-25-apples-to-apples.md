---
layout: post
title: Apples to apples
date-updated: 1 Aug 2014
subtitle: A comparison of sorts between Objective-C and Swift
redirect_from: /apples-to-apples/
---

When Craig Federighi arrived at his presentation slide about Objective-C during this year's [WWDC keynote](http://www.apple.com/apple-events/june-2014/) everyone in the room seemed puzzled, curious, and maybe even a bit uneasy. *What was happening?* As he continued, he considered what Objective-C would be like **without the C**, and the room abruptly filled with rumblings and whispers <sup><a href="#note1" id="superscript1">[1]</a></sup> as developers in the audience confided in those around them. If you had been following the [discussions](http://informalprotocol.com/2014/02/replacing-cocoa/) in our community about the [state of Objective-C](http://nearthespeedoflight.com/article/2014_03_17_objective_next) (and why we [need to replace it](http://ashfurrow.com/blog/we-need-to-replace-objective-c)) during the previous months, you could only have imagined one thing: Objective-C was no more &mdash; at least not as we knew it.

<!--excerpt-->

<blockquote>
	<p>And then Federighi said, let there be Swift; and there was Swift.</p>
	<footer>WWDC 2014, 1:44:48</footer>
</blockquote>

The third floor of Moscone West erupted with applause as if we had traveled back in time to Steve Jobs' [2007 announcement](https://www.youtube.com/watch?v=EHWRkuDlNOE) of _**the**_ iPhone: *"An iPod, a phone, and an Internet communicator"*.

As the keynote continued, we were assured safety, optimizations, clarity, modernity, and speed. But, as some have [already investigated](http://www.splasmata.com/?p=2798), Swift may not be as swift as promised. However, Swift is still in beta (along with Xcode 6, iOS 8, and OS X 10.10), so we will undoubtedly see many improvements and changes in the coming months.

As a fun and interesting [code kata](http://codekata.com), I decided to port my [objc-sorts](https://github.com/jessesquires/objc-sorts) project on GitHub to Swift. Behold, [swift-sorts](https://github.com/jessesquires/swift-sorts). These projects are collections of sorting algorithms implemented in Objective-C and Swift, respectively. I completed a rough version of the Swift project during the week of WWDC and have since refined both. I also shared the results below with Apple engineers in the Swift Labs during WWDC, but more on that later.

### Setup

<div class="alert alert-danger">
	<strong>Update 1: Xcode6-beta2</strong> <span class="pull-right"><em>27 July 2014</em></span>
	<p>
		This post has been updated for Xcode6-beta2. All trials were re-run as described below using Xcode6-beta2.
		Results were largely similar, no significant changes.
	</p>
</div>

<div class="alert alert-danger">
	<strong>Update 2: Xcode6-beta4</strong> <span class="pull-right"><em>1 Aug 2014</em></span>
	<p>
		This post has been updated for Xcode6-beta4. All trials were re-run as described below using Xcode6-beta4.
	</p>
	<p>
		Major changes to the Swift language include the <a href="https://developer.apple.com/swift/blog/?id=3" class="alert-link">redesign of arrays</a> to have full value semantics and new syntactic sugar &mdash; introduced in Xcode6-beta3.
		As of the beta4 release, Swift has seen <strong>dramatic</strong> performance improvements. See the updated results below.
	</p>
	<p>
		<strong>Note:</strong> because of the new array semantics and syntax, code changes were required for Swift. You can find the previous code on the <code>xcode6-beta1and2</code> branch <a href="https://github.com/jessesquires/swift-sorts/branches" class="alert-link">on GitHub</a>.
	</p>
</div>

* *Code:* [Swift Sorts](https://github.com/jessesquires/swift-sorts) and [Objective-C Sorts](https://github.com/jessesquires/objc-sorts)
* *Software:* OS X Mavericks ~~10.9.3~~ 10.9.4, Xcode6-beta4 ~~beta2~~ ~~WWDC seed~~
* *Hardware:* 2008 unibody MacBook Pro, 2.4 Ghz Intel Core 2 Duo, 8 GB 1067 MHz DDR3 memory <sup><a href="#note2" id="superscript2">[2]</a></sup>

Each project is a command line app with a debug, release, and unit-test scheme. Build and run, then watch the console for output.

The benchmarks consist of *T* trials, which are averaged at the end to obtain the average execution time for each algorithm. Each trial begins by generating an array of *N* random integers in the range `[0, UINT32_MAX)`. Then, each sorting algorithm is passed a copy of this initial array to sort. The current time is logged before and after each sort and the difference between the two yields the execution time for the algorithm for the current trial.

These two programs were carefully crafted to be a true *apples-to-apples* comparison. All of the algorithms, as well as `main.swift` and `main.m`, are implemented as similarly as possible, bounded only by the confines and paradigms of the languages themselves. In Objective-C, `NSArray` and `NSNumber` are used intentionally as the counterparts to Swift's `Array` and `Int`. The APIs are language-specific too, for example `exchangeObjectAtIndex: withObjectAtIndex:` versus `swap()`.

The following were used for the standard library sorts:

{% highlight swift %}

// Swift
var arr: [Int] = // some array
let newArr = sorted(arr);

// Objective-C
NSMutableArray *arr = // some array
[arr sortUsingComparator:^NSComparisonResult(NSNumber *n1, NSNumber *n2) {
    return [n1 compare:n2];
}];

{% endhighlight %}

<span class="text-muted text-center center table-header-footer">
Previous Swift std lib sort <a href="https://gist.github.com/jessesquires/06b6bd68a7d18810651f/ee5aa0a7427f830fadd4d369c9d04a895fc2b49b">implementation here</a>.
</span>

<br/>

<h3>Results</h3>

Below are the results of running each program over 10 trials with 10,000 integers. The build configuration settings are noted for each run and the execution times are displayed in seconds. The average case runtime complexity for each algorithm is also noted. I realize that 10,000 is relatively small, but you'll see that Swift was taking quite a long time.

<p class="text-muted text-center table-header-footer"><strong>Table 1</strong></p>
<div class="table-responsive">
	<table class="table table-bordered table-hover">
		<thead>
			<tr>
				<th class="text-muted">
					<em>T</em> = 10
					<br />
					<em>N</em> = 10,000
					<br />
					Debug
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
				<th>Objective-C <code>-O0</code></th>
				<td><strike>0.015813 s</strike><br/>0.015732 s</td>
				<td><strike>0.011393 s</strike><br/>0.011395 s</td>
				<td><strike>0.023052 s</strike><br/>0.025252 s</td>
				<td><strike>1.945385 s</strike><br/>1.931189 s</td>
				<td><strike>3.745795 s</strike><br/>3.762144 s</td>
			</tr>
			<tr>
				<th>Swift <code>-Onone</code></th>
				<td><strike>1.460893 s</strike><br/>1.536891 s</td>
				<td><strike>1.585898 s</strike><br/>1.633227 s</td>
				<td><strike>4.498561 s</strike><br/>4.714571 s</td>
				<td><strike>599.164323 s</strike><br/>625.810322 s</td>
				<td><strike>507.968824 s</strike><br/>519.386646 s</td>
			</tr>
		</tbody>
	</table>
</div>

<br />

<p class="text-muted text-center table-header-footer"><strong>Table 2</strong></p>
<div class="table-responsive">
	<table class="table table-bordered table-hover">
		<thead>
			<tr>
				<th class="text-muted">
					<em>T</em> = 10
					<br />
					<em>N</em> = 10,000
					<br />
					Release
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
				<th>Objective-C <code>-O3</code></th>
				<td><strike>0.012037 s</strike><br/>0.012195 s</td>
				<td><strike>0.010317 s</strike><br/>0.010893 s</td>
				<td><strike>0.020318 s</strike><br/>0.019672 s</td>
				<td><strike>1.777335 s</strike><br/>1.778275 s</td>
				<td><strike>3.508259 s</strike><br/>3.521110 s</td>
			</tr>
			<tr>
				<th>Swift <code>-O</code></th>
				<td><strike>0.079272 s</strike><br/>0.019062 s</td>
				<td><strike>0.072787 s</strike><br/>0.007888 s</td>
				<td><strike>0.212094 s</strike><br/>0.057481 s</td>
				<td><strike>28.431325 s</strike><br/>4.407984 s</td>
				<td><strike>8.662720 s</strike><br/>7.028199 s</td>
			</tr>
		</tbody>
	</table>
</div>

<p class="text-muted text-center table-header-footer">According to the Apple engineers that I spoke with, <code>-O3</code> in Objective-C is essentially the equivalent to <code>-O</code> in Swift.</p>

<br />

<p class="text-muted text-center table-header-footer"><strong>Table 3</strong></p>
<div class="table-responsive">
	<table class="table table-bordered table-hover">
		<thead>
			<tr>
				<th class="text-muted">
					<em>T</em> = 10
					<br />
					<em>N</em> = 10,000
					<br />
					Release
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
				<th>Objective-C <code>-Ofast</code></th>
				<td><strike>0.012278 s</strike><br/>0.011828 s</td>
				<td><strike>0.010448 s</strike><br/>0.010285 s</td>
				<td><strike>0.020256 s</strike><br/>0.019763 s</td>
				<td><strike>1.787421 s</strike><br/>1.776664 s</td>
				<td><strike>3.582407 s</strike><br/>3.497402 s</td>
			</tr>
			<tr>
				<th>Swift <code>-Ofast</code></th>
				<td><strike>0.022573 s</strike><br/>0.001306 s</td>
				<td><strike>0.005410 s</strike><br/>0.001426 s</td>
				<td><strike>0.005903 s</strike><br/>0.002259 s</td>
				<td><strike>0.997563 s</strike><br/>0.297713 s</td>
				<td><strike>0.113045 s</strike><br/>0.068731 s</td>
			</tr>
		</tbody>
	</table>
</div>

<p class="text-muted text-center table-header-footer">Note that <code>-O</code> is the standard optimization level for Swift and <code>-Ofast</code>, though faster, removes <strong>all</strong> safety features (<em>array bounds-checking, integer overflow checking, etc.</em>) from Swift. In other words, do not ship an entire app compiled with <code>-Ofast</code>. More on that below.</p>

<br />

<div class="alert alert-danger">
	<strong>Update 2: Xcode6-beta4</strong> <span class="pull-right"><em>1 Aug 2014</em></span>
	<p>
		We see the following notable changes with Xcode-beta4:
	</p>
	<ol>
		<li>Swift is now slightly worse without optimizations. (see <em>Table 1</em>)</li>
		<li>With optimizations, Swift performance is incredibly better and much closer to Objective-C. However, Objective-C is still faster. (see <em>Table 2</em>)</li>
		<li>Swift's insertion sort has completely turned around, and now outperforms selection sort with significant margins!</li>
		<li>Swift with agressive optimizations is substantially faster than before, and outperforms Objective-C on every sort.</li>
	</ol>
</div>

There are a few notable discoveries here:

1. Rather shockingly, debug is incredibly slow in Swift but improves dramatically with compiler flags. The difference in performance between *no* optimizations and <code>-Ofast</code> in Swift is stark. On the other hand, Objective-C sees relatively minor benefits.

2. At the standard optimization level (see *Table 2*), the two languages begin to perform more similarly. Objective-C is still noticeably faster though. Std lib sort is 6.5x faster. Quick sort is 7.0x faster. Heap sort is 10.4x faster. Insertion sort is 16.0x faster. Selection sort is 2.47x faster.

3. Only with <code>-Ofast</code> do we begin to experience the swiftness of Swift, and even then the standard library sort in Objective-C is almost twice as fast (1.84x). However, when comparing Swift to Swift the discrepancies are enormous. Swift performs orders of magnitude better than it did without optimizations and puts Objective-C to shame with regard to quick sort, heap sort, insertion sort, and selection sort (see *Table 3*).

4. We all know that selection sort and insertion sort are not particularly optimal algorithms, and Swift does a good job to emphasize this (when not using <code>-Ofast</code>, see *Table 1* and *Table 2*). But why are these two so terrible in Swift? Especially insertion sort &mdash; in debug Objective-C is 308.0x faster. I'm still puzzled by this. These two sorting algorithms are not complex, but they stand apart from the other sorts in the following ways: selection sort has nested for-loops and insertion sort has a while-loop nested in a for-loop. Perhaps Swift is having trouble optimizing these? Is this a bug?

5. My mundane quick sort implementation is faster than the standard library sort for both languages. Typically, these library methods would utilize multiple sorting algorithms that are guided by a set of heuristics that help determine the best algorithm to use based on the dataset. I suspect that we would see the standard library sorts perform best with larger datasets and/or with complex objects.

According to the benchmarks presented during the keynote (1:45:30), we should (probably?) be seeing different results here. Federighi noted that for complex object sort, Objective-C performed at 2.8x and Swift performed at 3.9x, using Python as the baseline (1.0x). It is not clear at this time how these benchmarks were achieved. What were the build and optimization settings? What is a "complex object"? In any case, surely Swift should be able to sort integers just as well as "complex objects", right?

### Swift Labs at WWDC

The Apple engineers hanging out in the Swift Labs at WWDC were interested in these benchmarks and were somewhat surprised to see them. Unfortunately, the engineers that I spoke with did not have an explanation for why we were seeing these results. We filed Radar #17201160, noting most of the points above.

Additionally, I asked what the best practices are with regard to using <code>-Ofast</code>. They recommended the following approach: (1) profile your app to find out where it is slow, (2) extract this slow code into a separate module/framework, (3) very thoroughly test this module, and then (4) compile the module using <code>-Ofast</code> and link it to your app. Remember, this removes <strong>all</strong> safety features from Swift.

### Moving forward

The results above seem to indicate that Apple has not (yet) followed through on their promises of speed and safety &mdash; at least in the sense that these features can be mutually inclusive. Again, it is still early. Hopefully these benchmarks will improve as Swift nears a 1.0 release. **I plan on updating this post or writing follow-up posts as Apple releases updates for Swift and Xcode6-beta.** <span class="text-danger"><strong>[Updated 2X]</strong></span>

As Brent Simmons [said](http://inessential.com/2014/02/12/on_replacing_objective-c), Objective-C used to be considered slow compared to plain C, but it is not slow compared to Java or Python. I am not sure if the reaction to these results should be *we have faster hardware, so a slower language is fine*, or *nothing will ever be as fast as C*, or somewhere in-between. But after completing these two projects, I do know this: Swift is a pleasure to write and read. Many things came easier and more naturally in Swift, and Playgrounds are pure gold. Swift has a lot of potential. Let's hope this is the next step that we have all been waiting for, and not another [Copland](http://arstechnica.com/apple/2010/06/copland-2010-revisited/).

### Futher reading

* The *Official* [Apple Swift Blog](https://developer.apple.com/swift/blog/)
* [*Swift?*](http://www.splasmata.com/?p=2798) from Splasm Software
* [*The Foundation Collection Classes*](http://www.objc.io/issue-7/collections.html) by Peter Steinberger, objc.io issue #7

<div class="footnotes text-muted">
	<ul>
		<li>
			<a href="#superscript1" id="note1"><i class="fa fa-angle-up"></i> [1]</a> If you turn up the volume and listen closely, you can hear this in the keynote video. It was much louder in person.
		</li>
		<li>
			<a href="#superscript2" id="note2"><i class="fa fa-angle-up"></i> [2]</a> If you are thinking, <em>this guy needs a new MacBook</em> &mdash; you are correct! :)
		</li>
	</ul>
</div>

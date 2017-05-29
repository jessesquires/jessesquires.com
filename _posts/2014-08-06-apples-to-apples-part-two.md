---
layout: post
title: Apples to apples, Part II
subtitle: An analysis of sorts between Objective-C and Swift
redirect_from: /apples-to-apples-part-two/
---

If at first you don't succeed, try, try again. Practice makes perfect. These proverbs have encouraged us all in many different contexts. But in software development, they tug at our heartstrings uniquely. Programmers persevere through countless nights of fixing bugs. Companies march vigilantly toward an [MVP](http://en.wikipedia.org/wiki/Minimum_viable_product). But after 1.0 there is no finish line, there is no bottom of the 9th inning. There are more bugs to be fixed. There are new releases ahead. The march continues, because software is not a *product*, it is a *process*.

<!--excerpt-->

This week, Apple has reminded us of the value of this iterative process and its rewards with the fifth beta release of Xcode 6, iOS 8, OS X Yosemite, and most importantly &mdash; *Swift*. This update includes a [number of improvements](http://adcdownload.apple.com//Developer_Tools/xcode_6_beta_5_za4gu6/xcode_6_beta_5_release_notes.pdf), but perhaps the most interesting are those not listed. Swift was rough around the edges during its launch at [WWDC](https://developer.apple.com/wwdc/), but it is **definitely** beginning to live up to its name.

If you missed my first post, [*Apples to Apples*](/apples-to-apples/), you should head over there now to catch up.

### Setup

The setup is the same as before, but I'll reiterate for clarity.

<blockquote>
	<ul>
		<li><strong>Code:</strong> <a href="https://github.com/jessesquires/swift-sorts">swift-sorts</a>, <a href="https://github.com/jessesquires/objc-sorts">objc-sorts</a>, and <a href="https://gist.github.com/jessesquires/06b6bd68a7d18810651f#file-sorts-m">std lib sort</a> implementations</li>
		<li><strong>Software:</strong> OS X Mavericks 10.9.4, Xcode 6 beta 5</li>
		<li><strong>Hardware:</strong> 2008 unibody MacBook Pro, 2.4 Ghz Intel Core 2 Duo, 8 GB 1067 MHz DDR3 memory</li>
	</ul>

	<p>The benchmarks consist of <em><strong>T</strong></em> trials, which are averaged at the end to obtain the average execution time for each algorithm. Each trial begins by generating an array of <em><strong>N</strong></em> random integers in the range <code>[0, UINT32_MAX)</code>. Then, each sorting algorithm is passed a copy of this initial array to sort. The current time is logged before and after each sort and the difference between the two yields the execution time for the algorithm for the current trial.</p>

	<p>These two programs were carefully crafted to be a true <em>apples-to-apples</em> comparison. All of the algorithms, as well as <code>main.swift</code> and <code>main.m</code>, are implemented as similarly as possible, bounded only by the confines and paradigms of the languages themselves. In Objective-C, <code>NSArray</code> and <code>NSNumber</code> are used intentionally as the counterparts to Swift's <code>Array</code> and <code>Int</code>. The APIs are language-specific too, for example <code>exchangeObjectAtIndex: withObjectAtIndex:</code> versus <code>swap()</code>.</p>
</blockquote>

### Results

Below are the results of running each program over 10 trials with 10,000 integers. The build configuration settings are noted for each run and the average execution times are displayed in seconds. The average case runtime complexity for each algorithm is also noted.

The final row in each table is the difference in speed of Swift compared to Objective-C. A positive value indicates that Swift is faster, while a negative value indicates that Swift is slower. For example, if Objective-C runs in 3.6 seconds and Swift runs in 1.2 seconds, then Swift is 3 times (3x) faster.

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
				<td>0.015161 s</td>
				<td>0.011438 s</td>
				<td>0.023984 s</td>
				<td>1.917997 s</td>
				<td>3.685714 s</td>
			</tr>
			<tr>
				<th>Swift <code>-Onone</code></th>
				<td>1.300011 s</td>
				<td>1.364851 s</td>
				<td>3.974969 s</td>
				<td>524.086557 s</td>
				<td>400.251450 s</td>
			</tr>
			<tr class="info text-info">
				<th>Difference</th>
				<td>-85.7x</td>
				<td>-119.3x</td>
				<td>-165.7x</td>
				<td>-273.2x</td>
				<td>-108.6x</td>
			</tr>
		</tbody>
	</table>
</div>

When not optimized, Swift is nothing to write home about. You can see that Objective-C performs substantially better. But this is ok &mdash; since you will be shipping with optimized builds. With no optimizations, this is what we should expect to see. The swiftness of Swift is in the compiler &mdash; [LLVM](http://www.llvm.org) and [Clang](http://clang.llvm.org). Mike Ash's *Friday Q&amp;A* last month on the [*Secrets of Swift's Speed*](https://mikeash.com/pyblog/friday-qa-2014-07-04-secrets-of-swifts-speed.html) provides a good overview of how better performance can be achieved with Swift versus Objective-C with compiler optimizations. We can see these optimizations in action below.

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
				<td>0.011852 s</td>
				<td>0.010419 s</td>
				<td>0.019587 s</td>
				<td>1.741661 s</td>
				<td>3.439606 s</td>
			</tr>
			<tr>
				<th>Swift <code>-O</code></th>
				<td>0.001072 s</td>
				<td>0.001316 s</td>
				<td>0.002580 s</td>
				<td>0.279190 s</td>
				<td>0.193269 s</td>
			</tr>
			<tr class="info text-info">
				<th>Difference</th>
				<td>11.1x</td>
				<td>7.9x</td>
				<td>7.6x</td>
				<td>6.2x</td>
				<td>17.8x</td>
			</tr>
		</tbody>
	</table>
</div>

If you recall the results from the [previous post](/apples-to-apples/), then this should be quite shocking (in a good way). Take a deep breath. Yes, yes this is real life. The tables have completely turned (no pun intended). I've been running these trials since the first beta, and this is the *first time* that Swift has performed **better than Objective-C** for every single algorithm, with standard optimizations. And not only is Swift faster, but it is faster by significant margins.

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
				<td>0.012596 s</td>
				<td>0.010147 s</td>
				<td>0.019617 s</td>
				<td>1.763124 s</td>
				<td>3.504833 s</td>
			</tr>
			<tr>
				<th>Swift <code>-Ounchecked</code></th>
				<td>0.000773 s</td>
				<td>0.001011 s</td>
				<td>0.002073 s</td>
				<td>0.261637 s</td>
				<td>0.099996 s</td>
			</tr>
			<tr class="info text-info">
				<th>Difference</th>
				<td>16.3x</td>
				<td>10.0x</td>
				<td>9.5x</td>
				<td>6.7x</td>
				<td>35.0x</td>
			</tr>
		</tbody>
	</table>
</div>

<p class="text-muted text-center table-header-footer">As of beta 5, the Swift optimization level of <code>-Ofast</code> has been deprecated in favor <code>-Ounchecked</code>. This renaming is a delightful change. Previously it read as, <em>"Ooooh fast!"</em>, begging for misuse and misunderstanding. But now it's more like <em>"Oh... unchecked?"</em>, which better reflects its unsafe nature.</p>

This should come as no surprise. Swift performance at this optimization level was always better than Objective-C, with the exception of the std lib sort &mdash; which no longer the case.

The benchmarks above were gathered with `N = 10,000` to be consistent with the previous post. However, this is no longer a challenge for Swift. Let's see what happens when `N = 100,000`. Given that most, if not all, developers will be compliling their modules and apps at the standard optimization level, the trials below were only run with `-O` and release. As expected, Swift comes out on top.

<p class="text-muted text-center table-header-footer"><strong>Table 4</strong></p>
<div class="table-responsive">
	<table class="table table-bordered table-hover">
		<thead>
			<tr>
				<th class="text-muted">
					<em>T</em> = 10
					<br />
					<em>N</em> = 100,000
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
				<td>0.151701 s</td>
				<td>0.121619 s</td>
				<td>0.251310 s</td>
				<td>175.421688 s</td>
				<td>349.182743 s</td>
			</tr>
			<tr>
				<th>Swift <code>-O</code></th>
				<td>0.013933 s</td>
				<td>0.015712 s</td>
				<td>0.036932 s</td>
				<td>27.532488 s</td>
				<td>18.969978 s</td>
			</tr>
			<tr class="info text-info">
				<th>Difference</th>
				<td>10.9x</td>
				<td>7.7x</td>
				<td>6.8x</td>
				<td>6.4x</td>
				<td>18.4x</td>
			</tr>
		</tbody>
	</table>
</div>

### Full speed ahead

When Apple introduced Swift, we were assured safety, clarity, modernity, and speed. It is clear to me that they have delivered and are continuing to deliver on these promises. The refinements and enhancements made over the past few months have been absolutely great. Some highlights for me include array value semantics, array and dictionary syntactic sugar, the `..<` operator replacing the `..` operator, and the performance improvements seen here. I think Swift is coming along quite nicely and I am more excited than ever for the next beta.

Swift is a breath of fresh air that makes reading and writing Objective-C feel archaic. I cannot wait for 1.0 and the moment when I can say goodbye to Objective-C.

**The *Apples to apples* series will continue as betas are released. Stay tuned for updates and new posts!**

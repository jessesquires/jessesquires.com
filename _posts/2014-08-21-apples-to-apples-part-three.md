---
layout: post
title: Apples to apples, Part III
subtitle: A modest proposal&#58; can Swift outperform plain C?
redirect_from: /apples-to-apples-part-three/
---

*When I find my code is slow or troubled, friends and colleagues comfort me. Speaking words of wisdom, write in C.* It is understood that foregoing the features and abstractions of [high-level](http://en.wikipedia.org/wiki/High-level_programming_language) programming languages in favor of their [low-level](http://en.wikipedia.org/wiki/Low-level_programming_language) counterparts can yield faster, more efficient code. If you abandon your favorite runtime, forget about garbage collection, eschew dynamic typing, and leave message passing behind; then you will be left with scalar operations, manual memory management, and raw pointers. However, the closer we get to the hardware, the further we get from readability, safety, and maintainability.

<!--excerpt-->

In [*Apples to apples, Part II*](/apples-to-apples-part-two/), we discovered that Swift was finally performing better than Objective-C. As expected, some common [reactions](https://twitter.com/OldManKris/status/497102303833255936) and [responses](https://twitter.com/mpweiher/status/497066155224608768) on Twitter were, *then how does it compare to C?* This is precisely what we are investigating today to welcome this week's arrival of [Xcode 6 beta 6](https://developer.apple.com/xcode/downloads/).

### Setup

* *Code:* [swift-sorts](https://github.com/jessesquires/swift-sorts) and [c-sorts](https://github.com/jessesquires/c-sorts)
* *Software:* OS X Mavericks 10.9.4, Xcode 6 beta 6
* *Hardware:* 2008 unibody MacBook Pro, 2.4 Ghz Intel Core 2 Duo, 8 GB 1067 MHz DDR3 memory

<p>The benchmarks consist of <em><strong>T</strong></em> trials, which are averaged at the end to obtain the average execution time for each algorithm. Each trial begins by generating an array of <em><strong>N</strong></em> random integers in the range <code>[0, UINT32_MAX)</code>. Then, each sorting algorithm is passed a copy of this initial array to sort. The current time is logged before and after each sort and the difference between the two yields the execution time for the algorithm for the current trial. Each execution time is saved to find the average time and standard deviation after all trials are complete.</p>

The sorting algorithms are written as [textbook implementations](http://en.wikipedia.org/wiki/Introduction_to_Algorithms) for clarity, objectivity, and fairness to each language. The standard library sort for Swift uses the `sorted()` [function](https://gist.github.com/jessesquires/06b6bd68a7d18810651f#file-sorts-m) while C uses `qsort()` from [cstdlib](http://www.cplusplus.com/reference/cstdlib/qsort/).

### Results

Below are the results of running each program over 20 trials with 100,000 integers. The average execution times are displayed in seconds with the standard deviation listed underneath. All trials were run with the release build configuration, since we know Swift would be too slow in debug. The final row in each table is the difference in speed of Swift compared to C. A positive value indicates that Swift is faster, while a negative value indicates that Swift is slower. For example, if C runs in 1.2 seconds and Swift runs in 3.6 seconds, then Swift is 3 times (-3x) slower. Also note that the different compiler optimization levels have no affect on C, but are listed for consistency.

<p class="text-muted text-center table-header-footer"><strong>Table 1</strong></p>
<div class="table-responsive">
	<table class="table table-bordered table-hover">
		<thead>
			<tr>
				<th class="text-muted">
					<em>T</em> = 20
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
				<th>C <code>-O3</code></th>
				<td>0.020853 s<br /><span class="text-muted">(&plusmn; 0.000191)</span></td>
				<td>0.011243 s<br /><span class="text-muted">(&plusmn; 0.000042)</span></td>
				<td>0.014909 s<br /><span class="text-muted">(&plusmn; 0.000360)</span></td>
				<td>7.575798 s<br /><span class="text-muted">(&plusmn; 0.016685)</span></td>
				<td>6.981794 s<br /><span class="text-muted">(&plusmn; 0.004399)</span></td>
			</tr>
			<tr>
				<th>Swift <code>-O</code></th>
				<td>0.014114 s<br /><span class="text-muted">(&plusmn; 0.000413)</span></td>
				<td>0.016745 s<br /><span class="text-muted">(&plusmn; 0.000202)</span></td>
				<td>0.042325 s<br /><span class="text-muted">(&plusmn; 0.003881)</span></td>
				<td>33.819305 s<br /><span class="text-muted">(&plusmn; 0.120471)</span></td>
				<td>25.255743 s<br /><span class="text-muted">(&plusmn; 0.084152)</span></td>
			</tr>
			<tr class="info text-info">
				<th>Difference</th>
				<td>1.48x</td>
				<td>-1.48x</td>
				<td>-2.84x</td>
				<td>-4.46x</td>
				<td>-3.62x</td>
			</tr>
		</tbody>
	</table>
</div>

<span class="text-muted">
	**Note:** I should point out that Swift has **slightly regressed** in beta 6 &mdash; but it is still substantially faster than Objective-C on all algorithms. When comparing the results above with [*Table 4* from Part II](/apples-to-apples-part-two/), we see that Swift is slower for each sort by the following rates: 1.01x, 1.06x, 1.15x, 1.23x, 1.33x, respectively. Remember, Swift is still in beta. Things happen. If previous releases are any indication, we will surely see improvements.
</span>

Unexpectedly, **Swift outperforms C** for the standard library sort. This may reveal more about the standard library sorting algorithms than it does about the languages, but it is fascinating nonetheless. Examining the other sorts, C comes out ahead as most would have guessed &mdash; but its **margins are small**, relatively speaking. Recall how Swift nailed Objective-C in the previous post. At its slowest, Swift was still 6x faster than Objective-C, which means that Objective-C could not dream of performing this well. This is a big deal.

<p class="text-muted text-center table-header-footer"><strong>Table 2</strong></p>
<div class="table-responsive">
	<table class="table table-bordered table-hover">
		<thead>
			<tr>
				<th class="text-muted">
					<em>T</em> = 20
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
				<th>C <code>-Ofast</code></th>
				<td>0.020861 s<br /><span class="text-muted">(&plusmn; 0.000216)</span></td>
				<td>0.011245 s<br /><span class="text-muted">(&plusmn; 0.000044)</span></td>
				<td>0.014932 s<br /><span class="text-muted">(&plusmn; 0.000308)</span></td>
				<td>7.578673 s<br /><span class="text-muted">(&plusmn; 0.012784)</span></td>
				<td>6.985793 s<br /><span class="text-muted">(&plusmn; 0.004598)</span></td>
			</tr>
			<tr>
				<th>Swift <code>-Ounchecked</code></th>
				<td>0.009508 s<br /><span class="text-muted">(&plusmn; 0.000367)</span></td>
				<td>0.011953 s<br /><span class="text-muted">(&plusmn; 0.000603)</span></td>
				<td>0.033006 s<br /><span class="text-muted">(&plusmn; 0.002562)</span></td>
				<td>30.831836 s<br /><span class="text-muted">(&plusmn; 0.057725)</span></td>
				<td>9.660987 s<br /><span class="text-muted">(&plusmn; 0.078939)</span></td>
			</tr>
			<tr class="info text-info">
				<th>Difference</th>
				<td>2.19x</td>
				<td>-1.06x</td>
				<td>-2.21x</td>
				<td>-4.07x</td>
				<td>-1.38x</td>
			</tr>
		</tbody>
	</table>
</div>

Here we see what we should expect from `-Ounchecked`, given the results in *Table 1*. There is a similar pattern, only amplified. Swift gets even faster and even closer to C.

### Approaching the speed of C

It's serendipitous that `c` denotes [the speed of light](http://en.wikipedia.org/wiki/Speed_of_light) in physics, isn't it? A common view in the programming community is that *nothing beats C*, and rightly so. It paved the road ahead and has endured the decades since its inception. I doubt that C is going anywhere, but this new kid on the block is pretty swift.

As programmers, we have a choice with regard to our toolsets. Programming languages come in a variety of forms with a [variety of features](https://www.destroyallsoftware.com/talks/wat). The opportunity costs of choosing one language are the features that you are foregoing in another. Swift is no C when it comes to speed, but when considering the features of each language, Swift's superiority is undisputed.

And now we must patiently wait for the next beta.

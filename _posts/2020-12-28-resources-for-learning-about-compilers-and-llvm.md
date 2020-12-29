---
layout: post
categories: [software-dev]
tags: [swift, compilers, llvm]
date: 2020-12-28T14:23:27-08:00
title: Resources for learning about compilers and LLVM
---

Today I cleaned up my various projects and todo's in [OmniFocus](https://www.omnigroup.com/omnifocus). I am always collecting links and resources for potential project ideas, or for general learning. Sometimes, however, it is best to acknowledge that I will likely never have enough free time to even begin some of these endeavors.

<!--excerpt-->

One thing I love about OmniFocus is the concept of "dropping" a project or task, which neither deletes the item nor marks it as complete &mdash; a feature sorely lacking in most "Todo" apps. Dropping an item is similar to deletion, but it preserves the record in case you would ever like to return to it. It is removed from view, but you can find it again by searching.

Today I decided to "drop" my compilers project in OmniFocus. I may return to it one day. Maybe not. In any case, I figured others in the community who want to learn about compilers might find these resources valuable. I have only skimmed them, but they should provide a good starting point. I hope you succeed where I did not.

All of these notes (among many others) are also in my [TIL repo](https://github.com/jessesquires/TIL/blob/main/compilers/README.md) on GitHub.

- [Watch: Building a Tiny Compiler](https://academy.realm.io/posts/tryswift-samuel-giddins-building-tiny-compiler-swift-ios/), Samuel Giddins
> We all use compilers every day, but they still can seem like a mysterious black box at times. In this try! Swift talk, Samuel Giddins builds a tiny compiler for his made-up language 100% from scratch to get a feel for the basics of how compilers work.

- [Watch: How to Clang Your Dragon](https://www.skilled.io/u/playgroundscon/how-to-clang-your-dragon), Harlan Haskins
> We're going to start by going over the basic structure of a compiler. Then we're going to build a lexer and a parser for Kaleidoscope. Then we're going to take that parse data and we're going to compile it to LLVM Intermediate Representation.

- [So You Want to Be a (Compiler) Wizard](http://belkadan.com/blog/2016/05/So-You-Want-To-Be-A-Compiler-Wizard/), Jordan Rose
> These are things you can do on your own. I’ve arranged them roughly in order of difficulty and time commitment, although of course the language / environment you pick will affect things.

- [LLVM tutorial](http://www.llvm.org/docs/tutorial/)
> This is the “Kaleidoscope” Language tutorial, showing how to implement a simple language using LLVM components in C++.

- [Crafting interpreters](http://www.craftinginterpreters.com)
> This book contains everything you need to implement a full-featured, efficient scripting language. You’ll learn both high-level concepts around parsing and semantics and gritty details like bytecode representation and garbage collection. Your brain will light up with new ideas, and your hands will get dirty and calloused. It’s a blast.

- [Mu - Swift Playground](https://github.com/marciok/Mu)
> It's a playground explaining how to create a tiny programming language (Mu).

- [A Tourist’s Guide to the LLVM Source Code](https://blog.regehr.org/archives/1453)
> In my Advanced Compilers course last fall we spent some time poking around in the LLVM source tree. A million lines of C++ is pretty daunting but I found this to be an interesting exercise and at least some of the students agreed, so I thought I’d try to write up something similar. We’ll be using LLVM 3.9, but the layout isn’t that different for previous (and probably subsequent) releases.

- The [LLVM conference videos](https://www.youtube.com/c/LLVMPROJ/playlists) on YouTube.

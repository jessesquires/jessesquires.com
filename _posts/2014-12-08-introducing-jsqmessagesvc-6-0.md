---
layout: post
title: Introducing JSQMessagesVC 6.0
subtitle: A brief history and celebration of the popular messages UI library for iOS
redirect_from: /introducing-jsqmessagesvc-6-0/
---

A few weeks ago I published the [sixth major release](https://github.com/jessesquires/JSQMessagesViewController/releases/tag/6.0.0) of ~~my~~ *our* [messages UI library](http://www.jessesquires.com/JSQMessagesViewController/) for iOS. This release closes the door on a major milestone for this project, so I wanted to take the time to highlight its significance, discuss its new features, and examine its design. Of course, this would not have been possible without our amazing open-source [community](https://github.com) and the [contributors](https://github.com/jessesquires/JSQMessagesViewController/graphs/contributors) to this project.

<!--excerpt-->

<img class="img-thumbnail img-responsive center" src="{{ site.img_url }}/jsqmessages6.png" title="JSQMessagesViewController 6.0" alt="JSQMessagesViewController 6.0"/>
<small class="text-muted center">JSQMessagesViewController: An elegant messages UI library for iOS</small>

### A brief history

It all began with [Hemoglobe](http://bit.ly/hemoglobeapp), an app for the bleeding disorder community. I built this app with [Michael Schultz](http://michaelschultz.com) almost two years ago, and one of the main features was... *private user messages*. I searched on [GitHub](https://github.com) and [CocoaControls](https://www.cocoacontrols.com) for an existing open-source framework. What I found was a lot of [great attempts](https://www.cocoacontrols.com/search?utf8=✓&q=messages) and partially completed projects. However, one [abandoned project](https://github.com/samsoffes/ssmessagesviewcontroller) stuck out and gave me some great ideas to get started.

[CocoaPods](http://cocoapods.org) was just entering its third year back then and was not very mainstream. I knew very little about it until [an issue](https://github.com/jessesquires/JSQMessagesViewController/issues/3) was opened that requested CocoaPod support and I received my [first pull-request](https://github.com/jessesquires/JSQMessagesViewController/pull/4) to add a [podspec](http://guides.cocoapods.org/syntax/podspec.html).

After the app launched, I extracted the messages UI into a separate component and published [version 1.0](https://github.com/jessesquires/JSQMessagesViewController/releases/tag/1.0.0) on GitHub. I figured this was the least I could do, given how much the abandoned projects had helped me even though they were only partially completed. I figured there were probably other developers out there searching for a "finished" messages UI framework I like was before.

The component was originally implemented with a `UITableView`, until [version 5.0](https://github.com/jessesquires/JSQMessagesViewController/releases/tag/5.0.0) which saw a complete rewrite of the library that opted for the more flexible `UICollectionView` instead. And here we are today, [49 releases](https://github.com/jessesquires/JSQMessagesViewController/tags) later at version [6.1.0](https://github.com/jessesquires/JSQMessagesViewController/releases/tag/6.1.0), with over [20 apps](https://github.com/jessesquires/JSQMessagesViewController#apps-using-this-library) using this library and [3,000](https://github.com/jessesquires/JSQMessagesViewController/stargazers) stars on GitHub. I **never** thought that this library would get so much attention. It's been such a pleasure developing this component out in the open and collaborating with each of the [contributors](https://github.com/jessesquires/JSQMessagesViewController/graphs/contributors).

### The anatomy of a cell

The flagship feature of 6.0 is the *most requested* feature to date &mdash; media messages. In order to display anything other than text in the message bubbles, some major changes were required in the core library. With these new changes it is now possible to display **any arbitrary** `UIView` in a message bubble. The messages view (picture above) is backed by subclasses of `UICollectionViewCell`, `UICollectionView`, and `UICollectionViewFlowLayout`. Each message is represented as a cell in the collection view and has a number of customizable subviews and properties, which are outlined in the following diagram. The labels for the subviews in the diagram are the names of the actual subview properties for a cell. See the [JSQMessagesCollectionViewCell](http://cocoadocs.org/docsets/JSQMessagesViewController/6.1.0/Classes/JSQMessagesCollectionViewCell.html) documentation for further details.

<img class="img-thumbnail img-responsive center" src="{{ site.img_url }}/jsqmessages_cell_anatomy.jpg" title="Anatomy of a cell" alt="Anatomy of a cell"/>
<small class="text-muted center">Anatomy of a cell</small>

There are two basic types of cells, incoming and outgoing. Each cell has three labels for message metadata &mdash; the sender, the date, and delivery status. Each of these labels is optional, and you can hide or show any combination of them. Next, there are two top-level container views, one for the message content and one for the avatar. The `messageBubbleContainerView` holds the `messageBubbleImageView` and either a `textView` or `mediaView`. The `avatarContainerView` holds the `avatarImageView`. Avatars are also optional. Finally, there's a customizable margin (`messageBubbleLeftRightMargin`) on the side of the cell that is opposite the avatar. For outgoing messages, this is the left-side margin. For incoming messages, this is the right-side margin. You can modify this margin using [the property](http://cocoadocs.org/docsets/JSQMessagesViewController/6.1.0/Classes/JSQMessagesCollectionViewFlowLayout.html#//api/name/messageBubbleLeftRightMargin) on the flow layout object. Each of these subviews is customizable via the usual [UIKit](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIKit_Framework/) APIs. Now that we understand the basics about the views, it's time to examine the model behind them.

### The model: speaking to protocols

One of the most challenging aspects of developing a framework is making assumptions &mdash; you should always try to make as few as possible. This is much easier said than done, and I've made plenty of [embarassing mistakes](https://github.com/jessesquires/JSQMessagesViewController/issues/389). Frameworks and libraries are constantly [evolving](http://st-www.cs.illinois.edu/users/droberts/evolve.html) as new use cases and edge cases emerge. It is vitally important to be modular, flexible, and extensible.

<blockquote>
	<p>Designing frameworks is difficult. In fact, I believe that they are so difficult, that they can only be designed by building examples and generalizing the example code into the framework code.</p>
	<footer><a href="http://st-www.cs.illinois.edu/users/droberts/">Don Roberts</a></footer>
</blockquote>

So how do we implement *the model* in *Model-View-Controller* when we have no idea what the model will be? *Every* developer that wants to use this library will have a *unique* model. Class names will be different, variable names will be different, the persistence layer ([Core Data](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/cdProgrammingGuide.html) or otherwise) will be different. We unify these differences with [Protocols](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithProtocols/WorkingwithProtocols.html) (or [Interfaces](http://en.wikipedia.org/wiki/Interface_(Java))). This is the [L](http://en.wikipedia.org/wiki/Liskov_substitution_principle) in [SOLID](http://en.wikipedia.org/wiki/SOLID_(object-oriented_design)), and it is one of the most powerful design tools that you have.

There are 4 data protocols for the model layer:

1. `JSQMessageData`: defines methods for providing message data (text or media) and metadata (sender, date, etc.)
2. `JSQMessageMediaData`: defines methods for representing media as a `UIView`
3. `JSQMessageAvatarImageDataSource`: defines methods for providing avatar images
4. `JSQMessageBubbleImageDataSource`: defines methods for providing message bubble images

Together, these protocols specify the comprehensive interface through which the `JSQMessagesViewController` framework communicates with your data. This means it does not matter how your data is structured or defined &mdash; you simply need to conform to the protocols by implementing their methods. This is very flexible and gives you the freedom to implement *your* model however *you* like.

Finally, I want to mention that the library *does* provide concrete model classes for those who want to use them. This allows you to get started using this library more quickly, and also serves as an example for how to implement these protocols in your custom classes should you choose to do so.

### Media messages revealed

Earlier I mentioned that the new media message API allows you to display **any arbitrary** `UIView` in a message bubble. This means that your media message can be *anything* and you only need to implement the `JSQMessageMediaData` protocol that defines how to display your specific media. For example, media data could be a [CLLocation](https://developer.apple.com/library/mac/documentation/CoreLocation/Reference/CLLocation_Class/index.html), or a [UIImage](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIImage_Class/index.html), or an [ABRecordRef](https://developer.apple.com/library/ios/documentation/AddressBook/Reference/ABRecordRef_iPhoneOS/index.html#//apple_ref/c/tdef/ABRecordRef). The 6.0 release provides 3 concrete media types: `JSQLocationMediaItem`, `JSQPhotoMediaItem`, and `JSQVideoMediaItem`. I think these are the most common kind of media that users want to send and that developers want to support. They should cover about 80 percent of use cases.

<img class="img-thumbnail img-responsive center" src="{{ site.img_url }}/jsqmessages_media_type.jpg" title="JSQMessage Media Items" alt="JSQMessage Media Items"/>
<small class="text-muted center">Provided media message types</small>

The media message API was built with extensibility in mind. If the provided media items do not suit your needs, you can extend them to do so. And, with very little effort you can define *your own* **custom** media items.

An alternative approach to this API would have been to define the different message or media types as an [Enum](http://nshipster.com/ns_enum-ns_options/). And a few contributors have suggested or asked about this. Hopefully, you can see how limiting this would have been, especially regarding the library-provided media types. Using an enum would litter the code base with `switch` statements &mdash; a [code smell](http://en.wikipedia.org/wiki/Code_smell) &mdash; and require special handling for each kind of media. The only option for extensibilty would have been providing a "custom" enum case, such as `JSQMediaTypeCustom`, which would defer all the work to the consumer of the API. This special enum case further increases complexity. And more importantly, this solution **cannot** address the situation where a developer wants to add **more than one** custom media type. By using a protocol, we avoid these pitfalls and every single media type is handled in the exact same way by the library.

### Examples

Check out the [Getting Started](https://github.com/jessesquires/JSQMessagesViewController#getting-started) section of the `README`. You can find additional details in the [documentation](http://cocoadocs.org/docsets/JSQMessagesViewController) and [6.0 release notes](https://github.com/jessesquires/JSQMessagesViewController/releases/tag/6.0.0).

### Future work

I think this library is in a very good state. It's stable and extensbile, but there's still plenty of work to do moving forward. There are plenty of [feature requests](https://github.com/jessesquires/JSQMessagesViewController/labels/feature%20request) and some [bugs](https://github.com/jessesquires/JSQMessagesViewController/labels/bug) to address. And as mentioned above, frameworks are constantly evolving. I can't wait to see what this framework looks like in another year. I would love to rewrite it in [Swift](https://developer.apple.com/swift/) eventually. We'll see what happens.

### Thanks for contributing

Needless to say, this project **would not** be where it is today without the enthusiasm and support of our **awesome community**. The initial release of this library was so limited, and I never expected that I would still be developing it *years* later. It is only because of the interest, [kindness](https://github.com/jessesquires/JSQMessagesViewController/issues/172#issuecomment-41995394), and [encouragement](https://github.com/jessesquires/JSQMessagesViewController/issues/608) from the community that I've continued working on this. (Well, programming is also pretty fun for me too.)

Developing this library, and doing it openly, has **taught me so much** and given me **so many opportunities**. I've improved my programming skills, I've met dozens of great developers, I discovered CocoaPods, I've learned how to effectively manage a large project with dozens of individual contributors, and the list continues. And I continue to learn. Open-source has given me all of these amazing things. I could not be more grateful for that. And I'm very excited to continue supporting and maintaining this library.

**Thank you for this opportunity to learn, share, and collaborate.**

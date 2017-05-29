---
layout: post
title: Failable initializers, revisited
subtitle: Functional approaches to avoid Swift's failable initializers
redirect_from: /swift-failable-initializers-revisited/
---

In a [previous](/swift-failable-initializers/) post, I discussed how Swift's [failable initializers](https://developer.apple.com/swift/blog/?id=17) could be problematic. Specifically, I argued that their ease of use could persuade or encourage us to revert to old (bad) Objective-C habits of returning `nil` from `init`. Initialization is usually *not the right place* to fail. We should aim to avoid optionals as much as possible to reduce having to handle this absence of values. Recently, **@danielgomezrico** asked a great [question](https://github.com/jessesquires/jessesquires.github.io/issues/8) about a possible use case for a failable initializer &mdash; parsing JSON. [Given](http://owensd.io/2014/06/18/json-parsing.html) [this](http://chris.eidhof.nl/posts/json-parsing-in-swift.html) problem's [popularity](https://github.com/SwiftyJSON/SwiftyJSON) in the Swift community, I thought sharing my response here would be helpful.

<!--excerpt-->

### The problem

Suppose we have a JSON object that contains the data for a model object. Should we write a failable initializer for this model that receives the JSON, and fails if there is problem with parsing or validation? This scenario would look similar to the following:

{% highlight swift %}

// Some JSON for MyModel
struct JSON {
    init(data: NSData)
}

// Some model
struct MyModel {
    let name: String
    let number: Int
    let date: NSDate

    init?(json: JSON)
}

// Usage
if let model = MyModel(json: JSON(data: dataFromServer)) {
    // success
}
else {
    // failure
}

{% endhighlight %}

This rather straightforward, but is using `init?` the best solution? There are some issues here that we need to address. First, the model *knows* **everything**. It knows that JSON is a thing, that JSON exists. It shouldn't. A model should be a dumb container (preferably immutable) that holds data. Even worse, the model knows *how to parse* the JSON. This means the model knows how JSON is generally structured and how it works, but more specifically it knows how *itself is represented as JSON*.

What if the structure or keys in the JSON change? Then we would have to update our model. What if we are using [Core Data](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/cdProgrammingGuide.html), and our model is an `NSManagedObject` subclass? Then we would have to stand up an **entire** Core Data stack just to unit test the JSON parsing. What if the service from which we receive the JSON changes and instead we receive XML? Then we would need a new initializer, `init?(xml: XML)`, and the model would know all about XML.

This design has put our model in a fragile position.

### The solution

The issues above can be addressed by removing the model's dependency on JSON (or XML) and creating single-purpose objects for each step of the process: (1) validating the JSON, (2) parsing the JSON, and (3) constructing the model.

The first step is creating a generic validator object. We'll use a [phantom type](http://www.objc.io/snippets/13.html) to ensure that a validator can only validate the JSON for a specific type of model. We initialize the validator with a closure that receives JSON and returns a `Bool` indicating whether or not it is valid. This closure is saved as a property on the validator.

{% highlight swift %}

struct JSONValidator<T> {

    typealias ValidationClosure = (JSON) -> Bool

    let validator: ValidationClosure

    init(validator: ValidationClosure) {
        self.validator = validator
    }

    func isValid(json: JSON) -> Bool {
        return validator(json)
    }
}

// Usage
let validator = JSONValidator<MyModel> { (json) -> Bool in
    // validate the json
    return true
}

{% endhighlight %}

The combination of a phantom type and a closure property enable us to construct many unique validators, while maintaining a single generic interface through which validation occurs. In other words, we do not have to create many different concrete validators (or validator subclasses) for many different models. Additionally, in this example you can see how this brings type-safety and readability to the validator. We know that this validator is for `MyModel` instances.

Next, we'll define a JSON parser protocol, and implement a concrete parser. The protocol will allow us to reference parsers throughout our code in a generic way, while enabling each concrete parser to know about parsing a specific type of model. The parser will receive JSON, parse it, and return a model. We'll also add a new (more proper) designated initializer to `MyModel` that uses [dependency injection](http://en.wikipedia.org/wiki/Dependency_injection) and remove the old one, `init?(json: JSON)`. This parser assumes that the JSON has already been validated.

{% highlight swift %}

struct MyModel {
    let name: String
    let number: Int
    let date: NSDate

    init(name: String, number: Int, date: NSDate)
}

protocol JSONParserType {
    typealias T
    func parseJSON(json: JSON) -> T
}

struct MyModelParser: JSONParserType {

    func parseJSON(json: JSON) -> MyModel {
        // parse json and construct MyModel
        return MyModel(name: "name", number: 1, date: NSDate())
    }
}

{% endhighlight %}

Now we can put everything together. Once we receive JSON, we can validate it. If validation fails, then we are finished and there is no need to continue. With this solution, no failable initializers are required.

{% highlight swift %}

let json = JSON(data: dataFromServer)

let validator = JSONValidator<MyModel> { (json) -> Bool in
    // validate the json
    return true
}

if !validator.isValid(json) {
    // handle bad json
    return
}

let parser = MyModelParser()

let myModel = parser.parseJSON(json)

{% endhighlight %}

This is much better. We have divided the problem into smaller subproblems and addressed each one individually. Even better, we can now unit test each component in isolation. However, because we are using Swift we can make this better. We can combine all the steps above into a top-level generic function. This function receives each of the components above &mdash; JSON, a validator, and a parser &mdash; and returns a model.

{% highlight swift %}

func parse<T, P: JSONParserType where P.T == T>(json: JSON, validator: JSONValidator<T>, parser: P) -> T? {
    if !validator.isValid(json) {
        return nil
    }

    return parser.parseJSON(json)
}

// Usage
if let myModel = parse(json, validator, parser) {
    // success
}
else {
    // failure
}

{% endhighlight %}

Suffering from [angle-brack-T blindness](http://inessential.com/2015/02/04/random_swift_things)? Me too. Let's break this down. The type parameter `T` specifies the model type. The validator must be a validator for `T`, and the function returns an optional `T?`. The type parameter `P` specifies the parser type, and the `where` clause enforces that the parser `P` parses models of type `T`. If validation fails, then the function returns `nil`, otherwise it will parse the JSON and return a model.

<span class="text-muted"><strong>Note:</strong> Depending on your architecture, it may not be possible nor worthwhile to have separate validation and parsing steps for JSON. If so, these two steps could be combined into the parser object and everything will still work wonderfully.</span>

### When to fail

As you can see, we have a clear separation of concerns, easily testable code, and no failable initializers. Of course there will be situations where a solution like this is not possible, namely, resource loading. For example, a `UIImage` or `NSBundle` represents an actual resource on disk. If a resource does not exist, then the class that represents it cannot be instantiated and using a failable initializer is perfect. In this situation, `init?` has exactly the semantics we want. But for models and similar instances, using `init?` is probably not a good idea.

Next time you find yourself wanting to write `init?` instead of `init`, there is likely a way to avoid it with a more thoughtful design that will push optionals and failure states further toward the edges of your object graph. Remember, **_where_ we choose to fail _does_ matter.**

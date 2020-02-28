# WindowAlert

[![Version](https://img.shields.io/cocoapods/v/WindowAlert.svg?style=flat)](http://cocoapods.org/pods/WindowAlert)
[![License](https://img.shields.io/cocoapods/l/WindowAlert.svg?style=flat)](http://cocoapods.org/pods/WindowAlert)
[![Platform](https://img.shields.io/cocoapods/p/WindowAlert.svg?style=flat)](http://cocoapods.org/pods/WindowAlert)
[![Swift Version](https://img.shields.io/badge/Swift-4.0-F16D39.svg?style=flat)](https://developer.apple.com/swift)
[![Swift Version](https://img.shields.io/badge/Swift-4.2-F16D39.svg?style=flat)](https://developer.apple.com/swift)
[![Swift Version](https://img.shields.io/badge/Swift-5.0-F16D39.svg?style=flat)](https://developer.apple.com/swift)

* Hate having providing `UIViewController` every time you need to show a dialog? 
* Have a stack of modal controllers, and figuring out which one is currently visible makes you groan? 
* `-[UIAlertView show]` makes you feel nostalgic?

This library is a solution for all of these things! 

While introducing unified sheet and dialog controller was a great decision, making it a presentable view controller was a shoot and miss on Apple side (Android Fragment dialogs, hi!).

To achieve simplicity of `UIAlertView`, this library creates a separate window on top of everything with transparent root view controller, and presents your alert controller in said window. You just need to set up `WindowAlert`, and then showing your dialog is as simple as calling `show()` on your alert instance!

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
Swift 4.0, 4.2 or 5.0 must be used in the project.

## Installation

WindowAlert is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WindowAlert', '~> 3.0.0'
```

## Usage
The usage  is quite simple and for most parts it mimicks `UIAlertController` APIs.

The following piece of code will create alert dialog with one text field, title, message and one action:
```Swift
let alert = WindowAlert(title: "This is a title", message: "This is a message", preferredStyle: .alert)

alert.addTextField { textField in
  textField.text = "I'm a text field inside WindowAlert!"
}

alert.add(action: WindowAlertAction(
                title: "Got it!",
                style: .default))

alert.show()
```
This code can be called anywhere - no need to pass `UIViewController`s to present it on.

## Additional bonus features
* Set alignment of alert action:
```swift
WindowAlertAction(
                title: "Got it!",
                style: .default,
                titleAlignment: .left)
```

* Add image to alert action:
```swift
WindowAlertAction(
                title: "Got it!",
                style: .default,
                image: UIImage(named: "someImage"))
```

* Dismiss alert on tap outside:
```swift
let alert = WindowAlert(title: "This is a title", message: "This is a message", preferredStyle: .alert)
alert.hideOnTapOutside = true
```

Warning: images and title alignment are based on Apple internal implementation, and they may break without notice after iOS update. If you find it broke after an update, please let me know and I will issue an update ASAP.


## Author

Alexander Leontev,
alexwoodblock@icloud.com

## License

WindowAlert is available under the Apache 2.0 license. See the LICENSE file for more info.

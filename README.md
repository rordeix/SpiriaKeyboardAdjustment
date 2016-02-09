# SpiriaKeyboardAdjustment
At some point every mobile developer has to deal with the struggle of the keyboard and the screen layout.
Usually you have only a few screens so you probably just copy/paste the code to do it (register to keyboard notifications, and change the frame of the main view or just a constraint to the bottom of the main view). This extension does all those things for you :), automatically register to the notifications and when the keyboard appears it changes the frame of the main view or optionally modify the value of a constraint (bottom constraint to the main view). You only need to install the pod and import the library on your view controller, that's all.
If you don't want to resize the view on a given view controller but you already have this library included just override the property ```shouldAutoAdjustScreen``` and return NO:
```objective-c
-(BOOL)shouldAutoAdjustScreen {
    return NO;
}
```

If you want to use a constraint to the main view instead of resize the controller view, you can assign the constraint from the UIBuilder to the ```adjustBottomConstraint``` property, or just implement its getter method with the constraint you want.

![Demo](https://j.gifs.com/W6qXBx.gif)

[![Version](https://img.shields.io/cocoapods/v/SpiriaKeyboardAdjustment.svg?style=flat)](http://cocoapods.org/pods/SpiriaKeyboardAdjustment)
[![License](https://img.shields.io/cocoapods/l/SpiriaKeyboardAdjustment.svg?style=flat)](http://cocoapods.org/pods/SpiriaKeyboardAdjustment)
[![Platform](https://img.shields.io/cocoapods/p/SpiriaKeyboardAdjustment.svg?style=flat)](http://cocoapods.org/pods/SpiriaKeyboardAdjustment)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SpiriaKeyboardAdjustment is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SpiriaKeyboardAdjustment"
```

## Author

rordeix, rordeix@spiria.com.uy

## License

SpiriaKeyboardAdjustment is available under the MIT license. See the LICENSE file for more info.

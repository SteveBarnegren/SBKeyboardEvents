# SBKeyboardEvents

[![Version](https://img.shields.io/cocoapods/v/SBKeyboardEvents.svg?style=flat)](http://cocoapods.org/pods/SBKeyboardEvents)
[![License](https://img.shields.io/cocoapods/l/SBKeyboardEvents.svg?style=flat)](http://cocoapods.org/pods/SBKeyboardEvents)
[![Platform](https://img.shields.io/cocoapods/p/SBKeyboardEvents.svg?style=flat)](http://cocoapods.org/pods/SBKeyboardEvents)

SBKeyboardEvents makes it easy to repond to keyboard events without having to write the same boilerplate code in every view controller. No more subscribing to a bunch of Notifications in viewDidLoad!

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

SBKeyboardEvents is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SBKeyboardEvents"
```

## Usage

Your ViewController (or other class, if you like), should implement the 'KeyboardEventListener' protocol. It should then register itself for keyboard events should with the `SBKeyboardEvents` singleton:

######(There are methods for unsubscribing a listener, but this is handled automatically when the class is deallocated, so in practice, these methods should very rarely be required. It is safe subscribe and forget. SBKeyboardEvents keeps a weak reference to listeners, so it will not retain them)

```swift
override func viewDidLoad() {
	super.viewDidLoad()
        
	SBKeyboardEvents.addListener(self)
}

```

For the simplest implementation, you only need to implement a single method, `animateForKeyboardHeight(height:)`

This method is called from within the keyboard appearance/disappearance animation block, so adjust constraints/frames, and the rest will be handled automatically. Note that the height here, is the keyboard height from the bottom of the screen.

```swift
extension GameSetupViewController: KeyboardEventListener {
    
    func animateForKeyboardHeight(_ height: CGFloat) {
         
        keyboardPaddingConstraint.constant = height;
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}
```

This is the full Protocol declaration:

```swift
public protocol KeyboardEventListener : class {
    
    func keyboardWillAppear()
    func keyboardDidAppear()
    func keyboardWillHide()
    func keyboardDidHide()
    func keyboardWillChangeFrame(_ frame: CGRect)
    func keyboardDidChangeFrame(_ frame: CGRect)
    func animateForKeyboardFrame(_ frame: CGRect)
    func animateForKeyboardHeight(_ height: CGFloat)
}
```

Functions containing 'will' occur before the animation.

Functions containing 'did' occur after the animation.

Functions starting 'animate' are called from within the keyboard animation block

## Author

Steve Barnegren, steve.barnegren@gmail.com

[@SteveBarnegren](https://twitter.com/stevebarnegren)

## License

SBKeyboardEvents is available under the MIT license. See the LICENSE file for more info.

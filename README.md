# SwiftElegantDropdownMenu

[![CI Status](http://img.shields.io/travis/Armin Likic/SwiftElegantDropdownMenu.svg?style=flat)](https://travis-ci.org/Armin Likic/SwiftElegantDropdownMenu)
[![Version](https://img.shields.io/cocoapods/v/SwiftElegantDropdownMenu.svg?style=flat)](http://cocoapods.org/pods/SwiftElegantDropdownMenu)
[![License](https://img.shields.io/cocoapods/l/SwiftElegantDropdownMenu.svg?style=flat)](http://cocoapods.org/pods/SwiftElegantDropdownMenu)
[![Platform](https://img.shields.io/cocoapods/p/SwiftElegantDropdownMenu.svg?style=flat)](http://cocoapods.org/pods/SwiftElegantDropdownMenu)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SwiftElegantDropdownMenu is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftElegantDropdownMenu"
```

## Usage:
### Example 1
Start by creating an array of **dropdown elements**:
```swift
let items = ["Zeus", "Hades", "Poseidon", "Chronos", "Aphrodite", "Artemis", "Hefestus"]
```
Create a new instance of **SwiftElegantDropdownMenu**:
```swift
let dropdownMenu = SwiftElegantDropdownMenu(title: items.first!, items: items)
```
Add the menu to your view as any other UIVIew:
```swift
self.view.addSubview(dropdownMenu)
```
### Example 2
Create a new UIView storyboard element, assign the **SwiftElegantDropdownMenu** class to it, and create an outlet in your viewcontroller:
```swift
@IBOutlet weak var dropdownMenu: SwiftElegantDropdownMenu!
```
Assign the **items** and **title** properties to it:
```swift
self.dropdownMenu.items = items
self.dropdownMenu.title = items.first!
```

## Author

Armin Likic, armin-likic@live.com

## License

SwiftElegantDropdownMenu is available under the MIT license. See the LICENSE file for more info.

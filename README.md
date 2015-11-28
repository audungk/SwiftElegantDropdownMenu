# SwiftElegantDropdownMenu

[![Build Status](https://travis-ci.org/arminlikic/SwiftElegantDropdownMenu.svg)](https://travis-ci.org/arminlikic/SwiftElegantDropdownMenu)
[![Version](https://img.shields.io/cocoapods/v/SwiftElegantDropdownMenu.svg?style=flat)](http://cocoapods.org/pods/SwiftElegantDropdownMenu)
[![License](https://img.shields.io/cocoapods/l/SwiftElegantDropdownMenu.svg?style=flat)](http://cocoapods.org/pods/SwiftElegantDropdownMenu)
[![Platform](https://img.shields.io/cocoapods/p/SwiftElegantDropdownMenu.svg?style=flat)](http://cocoapods.org/pods/SwiftElegantDropdownMenu)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Description

This component provides an easy, configurable dropdown menu with the ability to place it anywhere. It comes with a simple item selected callback and a variety of configurable options. This component is inspired by the **BTNavigationDropdownMenu** from **PhamBaTho**.

![alt tag](https://raw.githubusercontent.com/arminlikic/SwiftElegantDropdownMenu/master/Assets/demo.gif)

## Installation

SwiftElegantDropdownMenu is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following lines to your Podfile:

```ruby
use_frameworks!
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

### Example 3
You can handle the selection using a completion handler:
```swift
self.dropdownMenu.onItemSelect = {

(index, item) -> () in

// do something

}
```
You can handle what happens when the menu button is tapped:
```swift
self.dropdownMenu.onMenuButtonTapped = {

willOpen -> () in

// do something

}

Also, you have the freedom to customize the layout of the dropdown to match your needs:
```swift
...
self.dropdownMenu.configuration.titleFont = UIFont(name: "Arial", size: 22)!
self.dropdownMenu.configuration.cellTextColor = UIColor.redColor()
self.dropdownMenu.configuration.cellFont = UIFont(name: "Courier New", size: 18)!
...
```

## Changelog

**0.1.5 (11-28-2015)**
- Fixed a crash issue.
- Added an **onMenuButtonTapped** handler.
- Fixed vertical position issue for list.

**0.1.4 (11-28-2015)**
- Improved the dropdown to handle the case when there are multiple dropdowns present.
- Added the ability to close the dropdown by tapping on the outter area.

**0.1.3 (11-27-2015)**
- The issue that was causing the app to crash when multiple dropdowns have been added on the view has been resolved.

## Author

Armin Likic, armin-likic@live.com

## License

SwiftElegantDropdownMenu is available under the MIT license. See the LICENSE file for more info.

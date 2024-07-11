# TLMonthYearPicker
A simple month and year picker for iOS app development. Now support Swift 5</br>
Android version can be found [here](https://github.com/minhnn2607/TLMonthYearPicker).

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/TLMonthYearPicker.svg?style=flat-square)](https://img.shields.io/cocoapods/v/TLMonthYearPicker.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)


<p align="center">
 <img src="https://github.com/lee5783/TLMonthYearPicker/raw/master/demo.gif" alt="TLMonthYearPicker"/>
</p>

## How it works

```swift
    self.monthYearPicker.calendar = calendar
    self.monthYearPicker.monthYearPickerMode = .monthAndYear // or '.year'
    self.monthYearPicker.minimumDate = self.minimumDate
    self.monthYearPicker.maximumDate = self.maximumDate
    self.monthYearPicker.delegate = self

    //Picker delegate
    func monthYearPickerView(picker: TLMonthYearPickerView, didSelectDate date: Date) {
        //do your work with selected date object
    }
```

## Add to your project

There are 2 ways you can add TLMonthYearPickerView to your project:


### Installation with CocoaPods
```ruby
    pod 'TLMonthYearPicker'
```
For Swift 4.2, please use version 2.0.0:
```ruby
    pod 'TLMonthYearPicker', '3.0.0'
```
For Swift 4.0, please use version 2.0.0:
```ruby
    pod 'TLMonthYearPicker', '2.0.0'
```
For Swift 3.x, please use version 1.0.3:
```ruby
    pod 'TLMonthYearPicker', '1.0.3'
```

### Installation with Carthage
```ruby
    github "lee5783/TLMonthYearPicker"
```

### Installation with Swift Package Manager
```ruby
    dependencies: [
        .package(url: "https://github.com/lee5783/TLMonthYearPicker.git", .upToNextMajor(from: "4.1.1"))
    ]
```

### Manual installation

Simply drag 'TLMonthYearPickerView.swift' into your project.

## License
Usage is provided under the [MIT License](http://opensource.org/licenses/mit-license.php). See LICENSE for the full details.

# TLMonthYearPicker

A simple month and year picker for iOS app development. Now support Swift 5</br>
Android version can be found [here](https://github.com/minhnn2607/TLMonthYearPicker).

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/TLMonthYearPicker.svg?style=flat-square)](https://img.shields.io/cocoapods/v/TLMonthYearPicker.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)


<p align="center">
 <img src="https://github.com/lee5783/TLMonthYearPicker/raw/master/demo.gif" alt="TLMonthYearPicker"/>
</p>

## Requirements
- iOS 12.0 and above
- Xcode 14.0 and above (below Xcode version was not tested yet)

## How it works

```swift
    self.monthYearPicker.calendar = calendar
    self.monthYearPicker.monthYearPickerMode = .monthAndYear // or '.year'
    self.monthYearPicker.minimumDate = self.minimumDate
    self.monthYearPicker.maximumDate = self.maximumDate
    self.monthYearPicker.delegate = self

    // Picker delegate
    func monthYearPickerView(picker: TLMonthYearPickerView, didSelectDate date: Date) {
        //do your work with selected date object
    }
```

## Integration

There are 4 ways you can add `TLMonthYearPickerView` to your project:

### CocoaPods
```ruby
    pod 'TLMonthYearPicker'
```

### Carthage
```ruby
    github "lee5783/TLMonthYearPicker"
```

### Swift Package Manager (SPM)
```ruby
    dependencies: [
        .package(url: "https://github.com/lee5783/TLMonthYearPicker.git", .upToNextMajor(from: "4.1.2"))
    ]
```

### Manual installation

Simply drag `TLMonthYearPickerView.swift` into your project.

### Contribution

Any pull request is welcome. If you found any bug, please open a new issue.

## License
Usage is provided under the [MIT License](http://opensource.org/licenses/mit-license.php). See `LICENSE` for the full details.

# NeatLayout

[![Version](https://img.shields.io/cocoapods/v/NeatLayout.svg?style=flat)](http://cocoapods.org/pods/NeatLayout)
[![License](https://img.shields.io/cocoapods/l/NeatLayout.svg?style=flat)](http://cocoapods.org/pods/NeatLayout)
[![Platform](https://img.shields.io/cocoapods/p/NeatLayout.svg?style=flat)](http://cocoapods.org/pods/NeatLayout)

## Overview

UIView extension for simple constraint-adding syntax.

Provides methods for adding constraints in code with easy syntax similar to one of PureLayout.

Available constraints are designed for:

- view centering
- pinning edges to other views' edges
- aligning axes
- setting view's width, height or size

## Requirements
* iOS9

## Installation with CocoaPods

NeatLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'NeatLayout'
```

## Usage

```Swift

headerView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
headerView.autoSetDimension(.height, toSize: 250)
        
titleLabel.autoPin(toTopLayoutGuideOf: self, withInset: 40)
titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 16)
        
imageView.autoAlignAxis(.baseline, toSameAxisOf: titleLabel)
imageView.autoPinEdge(.right, to: .left, of: titleLabel, withOffset: 12, relation: .greaterThanOrEqual)
imageView.autoSetDimensions(to: CGSize(width: 32, height: 32))
imageView.autoPinEdge(toSuperviewEdge: .left, withInset: 20) 

```

## Author

Alexander Antonov (nitrey)
antonovab@gmail.com

## License

NeatLayout is available under the MIT license. See the LICENSE file for more info.

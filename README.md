# CCFlexbox

Flexbox like layout container implemented by AutoLayout.

<p align="center"><img src ="https://raw.githubusercontent.com/perrywky/CCFlexbox/master/demo.gif" /></p>

## Demo

Run the demo project to see the potentials.

## Usage

```swift

//row stack
CCFlexbox.row(
    item1.cfb_flexGrow(1).cfb_right(5),
    item2.cfb_alignSelf(.Center),
    item3.cfb_flexBasis(80, 80).cfb_left(5)
).justifyContent(.SpaceBetween).alignItems(.FlexStart)

//column stack
CCFlexbox.column(
    item1,
    item2,
    item3
)

//nested stacks
CCFlexbox.row(
    item1,
    CCFlexbox.column(
        item2,
        item3
    )
)

```

## Install

### Cocoapods

```pod

    source 'https://github.com/CocoaPods/Specs.git'
    platform :ios, '8.0'
    use_frameworks!

    pod 'CCFlexbox'

```

### iOS 7.0

Copy Source/CCFlexbox.swift to your project. 

## License

CCFlexbox is available under the MIT license. See the LICENSE file for more info.

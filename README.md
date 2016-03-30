# CCFlexbox

Flexbox like layout container implemented by AutoLayout.

<p align="center"><img src ="https://raw.githubusercontent.com/perrywky/CCFlexbox/master/demo.gif" /></p>

## Usage

Copy CCFlexbox.swift to your project and you're ready. Have fun with the demo project.

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

## License

CCFlexbox is available under the MIT license. See the LICENSE file for more info.
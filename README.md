# CCFlexbox

Flexbox like layout container implemented by AutoLayout.

<p align="center"><img src ="http://recordit.co/4sxAhTi6bZ.gif" /></p>

## Usage

Copy CCFlexbox.swift to your project and you're ready. Have fun with the demo project.

```swift
CCFlexbox.row(
    item1.flexBasis(50, 50),
    item2,
    item3.flexBasis(80, 80)
)

CCFlexbox.column(
    item1.flexBasis(50, 50),
    item2,
    item3.flexBasis(80, 80)
)

CCFlexbox.row(
    item1.flexBasis(50, 50),
    CCFlexbox.column(
        item2,
        item3.flexBasis(80, 80)
    )
)
```

## License

CCFlexbox is available under the MIT license. See the LICENSE file for more info.
//
//  CCFlexbox.swift
//  swift_component
//
//  Created by Perry on 15/12/30.
//  Copyright © 2015年 Perry. All rights reserved.
//

import UIKit
import ObjectiveC

private struct FlexboxAssociatedKeys {
    static var flexGrow = "flexGrow"
    static var flexShrink = "flexShrink"
    static var flexBasis = "flexBasis"
    static var flex = "flex"
    static var alignSelf = "alignSelf"
    static var ccMargin = "ccMargin"
}

public let MarginAuto:CGFloat = CGFloat.max

public extension UIView {

    func flexBasis(size:CGSize) -> UIView {
        objc_setAssociatedObject(self, &FlexboxAssociatedKeys.flexBasis, NSValue.init(CGSize: size), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return self
    }

    func flexBasis(width:CGFloat, height:CGFloat) -> UIView {
        objc_setAssociatedObject(self, &FlexboxAssociatedKeys.flexBasis, NSValue.init(CGSize: CGSizeMake(width, height)), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return self
    }

    func flexBasis(width:CGFloat, _ height:CGFloat) -> UIView {
        objc_setAssociatedObject(self, &FlexboxAssociatedKeys.flexBasis, NSValue.init(CGSize: CGSizeMake(width, height)), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return self
    }

    func flexGrow(grow:Int) -> UIView {
        objc_setAssociatedObject(self, &FlexboxAssociatedKeys.flexGrow, NSNumber.init(long: grow), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return self
    }

    func flexShrink(shrink:Int) -> UIView {
        objc_setAssociatedObject(self, &FlexboxAssociatedKeys.flexShrink, NSNumber.init(long: shrink), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return self
    }

    func alignSelf(align:AlignItems) -> UIView {
        objc_setAssociatedObject(self, &FlexboxAssociatedKeys.alignSelf, NSNumber.init(long: align.rawValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return self
    }

    func ccMargin(margin:EdgeInsets) -> UIView {
        objc_setAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin, NSValue.init(UIEdgeInsets: margin), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return self
    }

    func ccTop(top:CGFloat) -> UIView {
        let marginValue = objc_getAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin)
        var margin = marginValue == nil ? EdgeInsetsZero : marginValue.UIEdgeInsetsValue()
        margin.top = top
        ccMargin(margin)
        return self
    }

    func ccTopAuto() -> UIView {
        let marginValue = objc_getAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin)
        var margin = marginValue == nil ? EdgeInsetsZero : marginValue.UIEdgeInsetsValue()
        margin.top = MarginAuto
        ccMargin(margin)
        return self
    }

    func ccLeft(left:CGFloat) -> UIView {
        let marginValue = objc_getAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin)
        var margin = marginValue == nil ? EdgeInsetsZero : marginValue.UIEdgeInsetsValue()
        margin.left = left
        ccMargin(margin)
        return self
    }

    func ccBottom(bottom:CGFloat) -> UIView {
        let marginValue = objc_getAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin)
        var margin = marginValue == nil ? EdgeInsetsZero : marginValue.UIEdgeInsetsValue()
        margin.bottom = bottom
        ccMargin(margin)
        return self
    }

    func ccRight(right:CGFloat) -> UIView {
        let marginValue = objc_getAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin)
        var margin = marginValue == nil ? EdgeInsetsZero : marginValue.UIEdgeInsetsValue()
        margin.right = right
        ccMargin(margin)
        return self
    }

    func ccLeftAuto() -> UIView {
        let marginValue = objc_getAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin)
        var margin = marginValue == nil ? EdgeInsetsZero : marginValue.UIEdgeInsetsValue()
        margin.left = MarginAuto
        ccMargin(margin)
        return self
    }
}

@objc public enum JustifyContent: Int{
    case FlexStart, FlexEnd, Center, SpaceBetween, SpaceAround, SpaceSeperate
}

@objc public enum AlignItems: Int {
    case Auto, FlexStart, FlexEnd, Center, Baseline, Stretch
}

private let basisPriority:Float = 751
private let marginTag:Int = 1
private let spaceTag:Int = 1

@objc public class CCFlexbox: UIView {

    private var items: [UIView]
    private var blanks: [UIView]
    private var margins: [UIView]
    private var vertical: Bool
    private var justifyContent: JustifyContent
    private var alignItems: AlignItems
    private var oldSize:CGSize
    private var ruler:UIView

    private init(items: [UIView]) {
        self.items = items
        self.blanks = []
        self.margins = []
        self.vertical = false
        self.justifyContent = .FlexStart
        self.alignItems = .Stretch
        self.oldSize = CGSizeZero
        self.ruler = UIView.init()
        super.init(frame: CGRectZero)
        for item in items {
            self.addSubview(item)
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        self.items = []
        self.blanks = []
        self.margins = []
        self.vertical = false
        self.justifyContent = .FlexStart
        self.alignItems = .Stretch
        self.oldSize = CGSizeZero
        self.ruler = UIView.init()
        super.init(coder: aDecoder)
    }

    public class func row(items: UIView...) -> CCFlexbox {
        let box = CCFlexbox.init(items: items)
        box.setupItems()
        return box
    }

    public class func row(items: [UIView]) -> CCFlexbox {
        let box = CCFlexbox.init(items: items)
        box.setupItems()
        return box
    }

    public class func column(items: UIView...) -> CCFlexbox {
        let box = CCFlexbox.init(items: items)
        box.vertical = true
        box.setupItems()
        return box
    }

    public class func column(items: [UIView]) -> CCFlexbox {
        let box = CCFlexbox.init(items: items)
        box.vertical = true
        box.setupItems()
        return box
    }

    public func justifyContent(value:JustifyContent) -> CCFlexbox {
        self.justifyContent = value
        self.setNeedsUpdateConstraints()
        return self
    }

    public func alignItems(value:AlignItems) -> CCFlexbox {
        self.alignItems = value
        self.setNeedsUpdateConstraints()
        return self
    }

    private func setupItems() -> Void {
        for var index = 0; index < items.count; index++ {
            let item = items[index]
            item.translatesAutoresizingMaskIntoConstraints = false
            let previousSpace = UIView.init()
            self.addSubview(previousSpace)
            self.blanks.append(previousSpace)
            previousSpace.snp_makeConstraints(closure: { (make) -> Void in
                if index > 0 {
                    let lastSpace = blanks[1 + (index-1)*2]
                    if vertical {
                        make.top.equalTo(lastSpace.snp_bottom)
                    } else {
                        make.left.equalTo(lastSpace.snp_right)
                    }
                }
                if vertical {
                    make.left.width.equalTo(0)
                } else {
                    make.top.height.equalTo(0)
                }
            })
            let previousMargin = UIView.init()
            self.addSubview(previousMargin)
            self.margins.append(previousMargin)
            previousMargin.snp_makeConstraints(closure: { (make) -> Void in
                if vertical {
                    make.top.equalTo(previousSpace.snp_bottom)
                    make.bottom.equalTo(item.snp_top)
                    make.left.width.equalTo(0)
                } else {
                    make.left.equalTo(previousSpace.snp_right)
                    make.right.equalTo(item.snp_left)
                    make.top.height.equalTo(0)
                }
            })
            self.addSubview(item)
            let nextMargin = UIView.init()
            self.addSubview(nextMargin)
            self.margins.append(nextMargin)
            nextMargin.snp_makeConstraints(closure: { (make) -> Void in
                if vertical {
                    make.top.equalTo(item.snp_bottom)
                    make.left.width.equalTo(0)
                } else {
                    make.left.equalTo(item.snp_right)
                    make.top.height.equalTo(0)
                }
            })
            let nextSpace = UIView.init()
            self.addSubview(nextSpace)
            self.blanks.append(nextSpace)
            nextSpace.snp_makeConstraints(closure: { (make) -> Void in
                if vertical {
                    make.top.equalTo(nextMargin.snp_bottom)
                    make.left.width.equalTo(0)
                } else {
                    make.left.equalTo(nextMargin.snp_right)
                    make.top.height.equalTo(0)
                }
            })
        }
        self.addSubview(self.ruler)
    }

    override public func updateConstraints() {
        if CGSizeEqualToSize(self.bounds.size, CGSizeZero) {
            super.updateConstraints()
            return
        }
        if vertical {
            let boundHeight = self.bounds.size.height
            var contentHeight:CGFloat = 0
            var grows = 0
            var shrinks = 0
            var shrinkTotal:CGFloat = 0
            var shrinkableHeight:CGFloat = 0
            for item in items {
                let grow = getFlexGrowForItem(item)
                grows += grow
                let shrink = getFlexShrinkForItem(item)
                shrinks += shrink
                let basis = getFlexBasisForItem(item)
                if basis.height != UIViewNoIntrinsicMetric {
                    contentHeight += basis.height
                    if shrink > 0 {
                        shrinkTotal += basis.height*CGFloat(shrink)
                        shrinkableHeight += basis.height
                    }
                } else {
                    let size = item.intrinsicContentSize()
                    if size.height != UIViewNoIntrinsicMetric {
                        contentHeight += size.height

                        if shrink > 0 {
                            shrinkTotal += size.height*CGFloat(shrink)
                            shrinkableHeight += size.height
                        }
                    }
                }
                let margins = getMarginForItem(item)
                if margins.top != MarginAuto {
                    contentHeight += margins.top
                }
                if margins.bottom != MarginAuto {
                    contentHeight += margins.bottom
                }
            }

            let sizePerGrow = grows > 0 ? (boundHeight - contentHeight) / CGFloat( grows) : 0
            let shrinkPercent = (contentHeight - boundHeight) / shrinkTotal

            var autoMargins:[UIView] = []
            for var index = 0; index < items.count; index++ {
                let item = items[index]
                self.setHeightConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                self.setHorizontalAlignConstraintForItem(item, defaultAlign: alignItems)

                let margins = self.getMarginForItem(item)
                let topMargin = self.margins[index * 2]
                topMargin.snp_updateConstraints(closure: { (make) -> Void in
                    if margins.top == MarginAuto {
                        autoMargins.append(topMargin)
                    } else {
                        make.height.equalTo(margins.top)
                    }
                })
                let bottomMargin = self.margins[1+index*2]
                bottomMargin.snp_updateConstraints(closure: { (make) -> Void in
                    if margins.bottom == MarginAuto {
                        autoMargins.append(bottomMargin)
                    } else {
                        make.height.equalTo(margins.bottom)
                    }
                })
            }
            if autoMargins.count > 0 {
                let firstMargin = autoMargins.first!
                firstMargin.snp_updateConstraints(closure: { (make) -> Void in
                    make.height.greaterThanOrEqualTo(0)
                    for margin in autoMargins[1..<autoMargins.count] {
                        make.height.equalTo(margin)
                    }
                })
            }

            switch justifyContent {
            case .FlexStart:
                let firstSpace = self.blanks.first!
                firstSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.top.equalTo(0)
                    make.height.equalTo(0)
                })
                let lastSpace = self.blanks.last!
                lastSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.bottom.equalTo(0)
                    //0 if any auto margin, otherwise > 0
                    make.height.greaterThanOrEqualTo(0).priorityHigh()
                    make.height.lessThanOrEqualTo(0).priorityLow()
                })
                for var index = 1; index < blanks.count - 1; index++ {
                    let space = blanks[index]
                    space.snp_updateConstraints(closure: { (make) -> Void in
                        make.height.equalTo(0)
                    })
                }
                break
            case .FlexEnd:
                let lastSpace = self.blanks.last!
                lastSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.bottom.equalTo(0)
                    make.height.equalTo(0)
                })
                let firstSpace = self.blanks.first!
                firstSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.top.equalTo(0)
                    //0 if any auto margin, otherwise > 0
                    make.height.greaterThanOrEqualTo(0).priorityHigh()
                    make.height.lessThanOrEqualTo(0).priorityLow()
                })
                for var index = 1; index < blanks.count - 1; index++ {
                    let space = blanks[index]
                    space.snp_updateConstraints(closure: { (make) -> Void in
                        make.height.equalTo(0)
                    })
                }
                break
            case .Center:
                let firstSpace = self.blanks.first!
                firstSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.top.equalTo(0)
                    //0 if any auto margin, otherwise > 0
                    make.height.greaterThanOrEqualTo(0).priorityHigh()
                    make.height.lessThanOrEqualTo(0).priorityLow()
                })
                let lastSpace = self.blanks.last!
                lastSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.bottom.equalTo(0)
                    make.height.equalTo(firstSpace)
                })
                for var index = 1; index < blanks.count - 1; index++ {
                    let space = blanks[index]
                    space.snp_updateConstraints(closure: { (make) -> Void in
                        make.height.equalTo(0)
                    })
                }
                break
            case .SpaceBetween:
                let firstSpace = self.blanks.first!
                firstSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.top.equalTo(0)
                    make.height.equalTo(0)
                })
                let lastSpace = self.blanks.last!
                lastSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.height.equalTo(0)
                    make.bottom.equalTo(0)
                })
                let secondSpace = blanks[1]
                secondSpace.snp_updateConstraints(closure: { (make) -> Void in
                    //0 if any auto margin, otherwise > 0
                    make.height.greaterThanOrEqualTo(0).priorityHigh()
                    make.height.lessThanOrEqualTo(0).priorityLow()
                    for nextSpace in blanks[2..<blanks.count-1] {
                        make.height.equalTo(nextSpace)
                    }
                })
                break
            case .SpaceAround:
                let firstSpace = self.blanks.first!
                let lastSpace = self.blanks.last!
                firstSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.top.equalTo(0)
                    //0 if any auto margin, otherwise > 0
                    make.height.greaterThanOrEqualTo(0).priorityHigh()
                    make.height.lessThanOrEqualTo(0).priorityLow()
                    for nextSpace in blanks[1..<blanks.count] {
                        make.height.equalTo(nextSpace)
                    }
                })
                lastSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.bottom.equalTo(0)
                })
                break
            case .SpaceSeperate:
                let firstSpace = self.blanks.first!
                let lastSpace = self.blanks.last!
                firstSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.top.equalTo(0)
                    //0 if any auto margin, otherwise > 0
                    make.height.greaterThanOrEqualTo(0).priorityHigh()
                    make.height.lessThanOrEqualTo(0).priorityLow()
                    for nextSpace in blanks[1..<blanks.count-1] {
                        make.height.equalTo(nextSpace).multipliedBy(2)
                    }
                })
                lastSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.bottom.equalTo(0)
                    make.height.equalTo(firstSpace)
                })
                break
            }

        } else {

            let boundWidth = self.bounds.size.width
            var contentWidth:CGFloat = 0
            var grows = 0
            var shrinks = 0
            var shrinkTotal:CGFloat = 0
            var shrinkableWidth:CGFloat = 0
            for item in items {
                let grow = getFlexGrowForItem(item)
                grows += grow
                let shrink = getFlexShrinkForItem(item)
                shrinks += shrink
                let basis = getFlexBasisForItem(item)
                if basis.width != UIViewNoIntrinsicMetric {
                    contentWidth += basis.width
                    if shrink > 0 {
                        shrinkTotal += basis.width*CGFloat(shrink)
                        shrinkableWidth += basis.width
                    }
                } else {
                    let size = item.intrinsicContentSize()
                    if size.width != UIViewNoIntrinsicMetric {
                        contentWidth += size.width

                        if shrink > 0 {
                            shrinkTotal += size.width*CGFloat(shrink)
                            shrinkableWidth += size.width
                        }
                    }
                }
                let margins = getMarginForItem(item)
                if margins.left != MarginAuto {
                    contentWidth += margins.left
                }
                if margins.right != MarginAuto {
                    contentWidth += margins.right
                }
            }

            let sizePerGrow = grows > 0 ? (boundWidth - contentWidth) / CGFloat( grows) : 0
            let shrinkPercent = (contentWidth - boundWidth) / shrinkTotal

            var autoMargins:[UIView] = []
            for var index = 0; index < items.count; index++ {
                let item = items[index]
                self.setWidthConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                self.setVerticalAlignConstraintForItem(item, defaultAlign: alignItems)

                let margins = self.getMarginForItem(item)
                let leftMargin = self.margins[index * 2]
                leftMargin.snp_updateConstraints(closure: { (make) -> Void in
                    if margins.left == MarginAuto {
                        autoMargins.append(leftMargin)
                    } else {
                        make.width.equalTo(margins.left)
                    }
                })
                let rightMargin = self.margins[1+index*2]
                rightMargin.snp_updateConstraints(closure: { (make) -> Void in
                    if margins.right == MarginAuto {
                        autoMargins.append(rightMargin)
                    } else {
                        make.width.equalTo(margins.right)
                    }
                })
            }
            if autoMargins.count > 0 {
                let firstMargin = autoMargins.first!
                firstMargin.snp_updateConstraints(closure: { (make) -> Void in
                    make.width.greaterThanOrEqualTo(0)
                    for margin in autoMargins[1..<autoMargins.count] {
                        make.width.equalTo(margin)
                    }
                })
            }

            switch justifyContent {
            case .FlexStart:
                let firstSpace = self.blanks.first!
                firstSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.left.equalTo(0)
                    make.width.equalTo(0)
                })
                let lastSpace = self.blanks.last!
                lastSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.right.equalTo(0)
                    //0 if any auto margin, otherwise > 0
                    make.width.greaterThanOrEqualTo(0).priorityHigh()
                    make.width.lessThanOrEqualTo(0).priorityLow()
                })
                for var index = 1; index < blanks.count - 1; index++ {
                    let space = blanks[index]
                    space.snp_updateConstraints(closure: { (make) -> Void in
                        make.width.equalTo(0)
                    })
                }
                break
            case .FlexEnd:
                let lastSpace = self.blanks.last!
                lastSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.right.equalTo(0)
                    make.width.equalTo(0)
                })
                let firstSpace = self.blanks.first!
                firstSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.left.equalTo(0)
                    //0 if any auto margin, otherwise > 0
                    make.width.greaterThanOrEqualTo(0).priorityHigh()
                    make.width.lessThanOrEqualTo(0).priorityLow()
                })
                for var index = 1; index < blanks.count - 1; index++ {
                    let space = blanks[index]
                    space.snp_updateConstraints(closure: { (make) -> Void in
                        make.width.equalTo(0)
                    })
                }
                break
            case .Center:
                let firstSpace = self.blanks.first!
                firstSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.left.equalTo(0)
                    //0 if any auto margin, otherwise > 0
                    make.width.greaterThanOrEqualTo(0).priorityHigh()
                    make.width.lessThanOrEqualTo(0).priorityLow()
                })
                let lastSpace = self.blanks.last!
                lastSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.right.equalTo(0)
                    make.width.equalTo(firstSpace)
                })
                for var index = 1; index < blanks.count - 1; index++ {
                    let space = blanks[index]
                    space.snp_updateConstraints(closure: { (make) -> Void in
                        make.width.equalTo(0)
                    })
                }
//                ruler.snp_remakeConstraints(closure: { (make) -> Void in
//                    make.left.equalTo(firstSpace)
//                    make.right.equalTo(lastSpace)
//                    make.centerX.equalTo(0)
//                    make.height.equalTo(0)
//                })
                break
            case .SpaceBetween:
                let firstSpace = self.blanks.first!
                firstSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.left.equalTo(0)
                    make.width.equalTo(0)
                })
                let lastSpace = self.blanks.last!
                lastSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.width.equalTo(0)
                    make.right.equalTo(0)
                })
                let secondSpace = blanks[1]
                secondSpace.snp_updateConstraints(closure: { (make) -> Void in
                    //0 if any auto margin, otherwise > 0
                    make.width.greaterThanOrEqualTo(0).priorityHigh()
                    make.width.lessThanOrEqualTo(0).priorityLow()
                    for nextSpace in blanks[2..<blanks.count-1] {
                        make.width.equalTo(nextSpace)
                    }
                })
                break
            case .SpaceAround:
                let firstSpace = self.blanks.first!
                let lastSpace = self.blanks.last!
                firstSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.left.equalTo(0)
                    //0 if any auto margin, otherwise > 0
                    make.width.greaterThanOrEqualTo(0).priorityHigh()
                    make.width.lessThanOrEqualTo(0).priorityLow()
                    for nextSpace in blanks[1..<blanks.count] {
                        make.width.equalTo(nextSpace)
                    }
                })
                lastSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.right.equalTo(0)
                })
//                ruler.snp_remakeConstraints(closure: { (make) -> Void in
//                    make.left.equalTo(firstSpace)
//                    make.right.equalTo(lastSpace)
//                    make.centerX.equalTo(0) //center x aligning
//                    make.height.equalTo(0)
//                })
                break
            case .SpaceSeperate:
                let firstSpace = self.blanks.first!
                let lastSpace = self.blanks.last!
                firstSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.left.equalTo(0)
                    //0 if any auto margin, otherwise > 0
                    make.width.greaterThanOrEqualTo(0).priorityHigh()
                    make.width.lessThanOrEqualTo(0).priorityLow()
                    for nextSpace in blanks[1..<blanks.count-1] {
                        make.width.equalTo(nextSpace).multipliedBy(2)
                    }
                })
                lastSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.right.equalTo(0)
                    make.width.equalTo(firstSpace)
                })
//                ruler.snp_remakeConstraints(closure: { (make) -> Void in
//                    make.left.equalTo(firstSpace)
//                    make.right.equalTo(lastSpace)
//                    make.centerX.equalTo(0) //center x aligning
//                    make.height.equalTo(0)
//                })
                break
            }
        }

        super.updateConstraints()
    }

    override public func layoutSubviews() {
        if !CGSizeEqualToSize(self.bounds.size, self.oldSize) {
            self.setNeedsUpdateConstraints()
            self.oldSize = self.bounds.size
        }
        super.layoutSubviews()
    }

    private func getFlexBasisForItem(item:UIView) -> CGSize {
        let basisValue = objc_getAssociatedObject(item, &FlexboxAssociatedKeys.flexBasis)
        return basisValue == nil ? CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric) : basisValue.CGSizeValue()
    }

    private func getFlexGrowForItem(item:UIView) -> Int {
        let growValue = objc_getAssociatedObject(item, &FlexboxAssociatedKeys.flexGrow)
        return growValue == nil ? 0 : growValue.integerValue
    }

    private func getFlexShrinkForItem(item:UIView) -> Int {
        let shrinkValue = objc_getAssociatedObject(item, &FlexboxAssociatedKeys.flexShrink)
        return shrinkValue == nil ? 1 : shrinkValue.integerValue
    }

    private func getAlignSelfForItem(item:UIView) -> AlignItems {
        let alignValue = objc_getAssociatedObject(item, &FlexboxAssociatedKeys.alignSelf)
        return alignValue == nil ? AlignItems.Auto : AlignItems(rawValue: alignValue.integerValue)!
    }

    private func getMarginForItem(item:UIView) -> EdgeInsets {
        let marginValue = objc_getAssociatedObject(item, &FlexboxAssociatedKeys.ccMargin)
        return marginValue == nil ? EdgeInsetsZero : marginValue.UIEdgeInsetsValue()
    }

    private func getItemSize(item:UIView) -> CGSize {
        var width:CGFloat = 0
        var height:CGFloat = 0
        let size = getFlexBasisForItem(item)
        let content = item.intrinsicContentSize()
        if size.width != UIViewNoIntrinsicMetric {
            width = size.width
        } else if content.width != UIViewNoIntrinsicMetric {
            width = content.width
        }
        if size.height != UIViewNoIntrinsicMetric {
            height = size.height
        } else if content.height != UIViewNoIntrinsicMetric {
            height = content.height
        }
        return CGSizeMake(width, height)
    }

    private func setWidthConstraintForItem(item:UIView, sizePerGrow:CGFloat, shrinkPercent:CGFloat) -> Void {
        let basis = getFlexBasisForItem(item)
        let grow = getFlexGrowForItem(item)
        let shrink = getFlexShrinkForItem(item)
        item.snp_updateConstraints(closure: { (make) -> Void in
            if basis.width != UIViewNoIntrinsicMetric {
                if sizePerGrow > 0 {
                    make.width.equalTo(basis.width + CGFloat(grow) * sizePerGrow).priority(basisPriority)
                } else {
                    if shrink > 0 && shrinkPercent > 0 {
                        make.width.equalTo(max(basis.width * (1 - shrinkPercent * CGFloat(shrink)), 0)).priority(basisPriority)
                    } else {
                        make.width.equalTo(basis.width).priority(basisPriority)
                    }
                }
            } else {
                let size = item.intrinsicContentSize()
                if size.width != UIViewNoIntrinsicMetric {
                    if sizePerGrow > 0 {
                        make.width.equalTo(size.width + CGFloat(grow) * sizePerGrow).priority(basisPriority)
                    } else {
                        if shrink > 0 && shrinkPercent > 0 {
                            item.setContentCompressionResistancePriority(Float(750-shrink), forAxis: .Horizontal) //no shrinking
                            item.setContentHuggingPriority(251, forAxis: .Horizontal)
//                            make.width.equalTo(max(size.width * (1 - shrinkPercent * CGFloat(shrink)), 0)).priority(basisPriority)
                        } else {
                            item.setContentHuggingPriority(251, forAxis: .Horizontal)
                            item.setContentCompressionResistancePriority(basisPriority, forAxis: .Horizontal) //no shrinking
                        }
                    }
                } else {
                    if sizePerGrow > 0 {
                        item.setContentHuggingPriority(249, forAxis: .Horizontal)
                        item.setContentCompressionResistancePriority(basisPriority, forAxis: .Horizontal) //no shrinking
                    } else if(shrink > 0 && shrinkPercent > 0) {
                        item.setContentHuggingPriority(251, forAxis: .Horizontal)
                        item.setContentCompressionResistancePriority(basisPriority - 2, forAxis: .Horizontal) //shrinking
                    } else {
                        item.setContentHuggingPriority(251, forAxis: .Horizontal)
                        item.setContentCompressionResistancePriority(basisPriority, forAxis: .Horizontal) //no shrinking
                    }
                }
            }
        })
    }

    private func setVerticalAlignConstraintForItem(item:UIView, defaultAlign:AlignItems) -> Void {
        var align = getAlignSelfForItem(item)
        if align == .Auto {
            align = defaultAlign
        }

        var margin = getMarginForItem(item)
        if margin.top == MarginAuto {
            margin.top = 0
        }
        if margin.bottom == MarginAuto {
            margin.bottom = 0
        }
        
        item.snp_updateConstraints(closure: { (make) -> Void in
            switch align {
            case .FlexStart:
                make.top.equalTo(self).offset(margin.top)
                break;
            case .FlexEnd:
                make.bottom.equalTo(self).offset(-margin.bottom)
                break;
            case .Center:
                make.centerY.equalTo(self)
                break;
            case .Baseline:
                make.baseline.equalTo(self)
                break;
            case .Stretch, .Auto:
                make.top.bottom.equalTo(self).inset(EdgeInsetsMake(margin.top, left: 0, bottom: margin.bottom, right: 0))
                break;
            }
            if align != .Stretch && align != .Auto {
                let basis = getFlexBasisForItem(item)
                if basis.height != UIViewNoIntrinsicMetric {
                    make.height.equalTo(basis.height).priority(basisPriority)
                } else {
                    let size = item.intrinsicContentSize()
                    if size.height != UIViewNoIntrinsicMetric {

                        item.setContentHuggingPriority(251, forAxis: .Vertical)
                        item.setContentCompressionResistancePriority(basisPriority, forAxis: .Vertical) //no shrinking
                    } else {
                        item.setContentHuggingPriority(251, forAxis: .Vertical)
                        item.setContentCompressionResistancePriority(basisPriority, forAxis: .Vertical) //no shrinking
                    }
                }
            }
        })
    }

    private func setHeightConstraintForItem(item:UIView, sizePerGrow:CGFloat, shrinkPercent:CGFloat) -> Void {
        let basis = getFlexBasisForItem(item)
        let grow = getFlexGrowForItem(item)
        let shrink = getFlexShrinkForItem(item)
        item.snp_updateConstraints(closure: { (make) -> Void in
            if basis.height != UIViewNoIntrinsicMetric {
                if sizePerGrow > 0 {
                    make.height.equalTo(basis.height + CGFloat(grow) * sizePerGrow).priority(basisPriority)
                } else {
                    if shrink > 0 && shrinkPercent > 0 {
                        make.height.equalTo(max(basis.height * (1 - shrinkPercent * CGFloat(shrink)), 0)).priority(basisPriority)
                    } else {
                        make.height.equalTo(basis.height).priority(basisPriority)
                    }
                }
            } else {
                let size = item.intrinsicContentSize()
                if size.height != UIViewNoIntrinsicMetric {
                    if sizePerGrow > 0 {
                        make.height.equalTo(size.height + CGFloat(grow) * sizePerGrow).priority(basisPriority)
                    } else {
                        if shrink > 0 && shrinkPercent > 0 {
                            item.setContentCompressionResistancePriority(Float(750-shrink), forAxis: .Vertical) //no shrinking
                            item.setContentHuggingPriority(251, forAxis: .Vertical)
//                            make.height.equalTo(max(size.height * (1 - shrinkPercent * CGFloat(shrink)), 0)).priority(basisPriority)
                        } else {
                            item.setContentHuggingPriority(251, forAxis: .Vertical)
                            item.setContentCompressionResistancePriority(basisPriority, forAxis: .Vertical) //no shrinking
//                            make.height.equalTo(size.height).priority(basisPriority)
                        }
                    }
                } else {
                    if sizePerGrow > 0 {
                        item.setContentHuggingPriority(249, forAxis: .Vertical)
                        item.setContentCompressionResistancePriority(basisPriority, forAxis: .Vertical) //no shrinking
                    } else if(shrink > 0 && shrinkPercent > 0) {
                        item.setContentHuggingPriority(251, forAxis: .Vertical)
                        item.setContentCompressionResistancePriority(basisPriority - 2, forAxis: .Vertical) //shrinking
                    } else {
                        item.setContentHuggingPriority(251, forAxis: .Vertical)
                        item.setContentCompressionResistancePriority(basisPriority, forAxis: .Vertical) //no shrinking
                    }
                }
            }
        })
    }

    private func setHorizontalAlignConstraintForItem(item:UIView, defaultAlign:AlignItems) -> Void {
        var align = getAlignSelfForItem(item)
        if align == .Auto {
            align = defaultAlign
        }

        var margin = getMarginForItem(item)
        if margin.left == MarginAuto {
            margin.left = 0
        }
        if margin.right == MarginAuto {
            margin.right = 0
        }

        item.snp_updateConstraints(closure: { (make) -> Void in
            switch align {
            case .FlexStart:
                make.left.equalTo(self).offset(margin.left)
                break;
            case .FlexEnd:
                make.right.equalTo(self).offset(-margin.right)
                break;
            case .Center:
                make.centerX.equalTo(self)
                break;
            case .Baseline, .Stretch, .Auto:
                make.left.right.equalTo(self).inset(EdgeInsetsMake(0, left: margin.left, bottom: 0, right: margin.right))
                break;
            }
            if align != .Stretch && align != .Auto {
                let basis = getFlexBasisForItem(item)
                if basis.width != UIViewNoIntrinsicMetric {
                    make.width.equalTo(basis.width).priority(basisPriority)
                } else {
                    let size = item.intrinsicContentSize()
                    if size.width != UIViewNoIntrinsicMetric {
                        item.setContentHuggingPriority(251, forAxis: .Horizontal)
                        item.setContentCompressionResistancePriority(basisPriority, forAxis: .Horizontal) //no shrinking
                    } else {
                        item.setContentHuggingPriority(251, forAxis: .Horizontal)
                        item.setContentCompressionResistancePriority(basisPriority, forAxis: .Horizontal) //no shrinking
                    }
                }
            }
        })
    }

    override public func intrinsicContentSize() -> CGSize {
        var width:CGFloat = 0
        var height:CGFloat = 0
        for item in items {
            let basis = getFlexBasisForItem(item)
            let margin = getMarginForItem(item)
            let size = item.intrinsicContentSize()
            if width != UIViewNoIntrinsicMetric {
                var marginWidth:CGFloat = 0
                if margin.left != MarginAuto {
                    marginWidth += margin.left
                }
                if margin.right != MarginAuto {
                    marginWidth += margin.right
                }
                if basis.width != UIViewNoIntrinsicMetric {
                    if vertical {
                        width = max(width, basis.width + marginWidth)
                    } else {
                        width += basis.width + marginWidth
                    }
                } else {
                    if size.width != UIViewNoIntrinsicMetric {
                        if vertical {
                            width = max(width, size.width + marginWidth)
                        } else {
                            width += size.width + marginWidth
                        }
                    } else {
                        width = UIViewNoIntrinsicMetric
                    }
                }
            }
            if height != UIViewNoIntrinsicMetric {
                var marginHeight:CGFloat = 0
                if margin.top != MarginAuto {
                    marginHeight += margin.top
                }
                if margin.bottom != MarginAuto {
                    marginHeight += margin.bottom
                }
                if basis.height != UIViewNoIntrinsicMetric {
                    if vertical {
                        height += basis.height + marginHeight
                    } else {
                        height = max(height, basis.height + marginHeight)
                    }
                } else {
                    if size.height != UIViewNoIntrinsicMetric {
                        if vertical {
                            height += size.height + marginHeight
                        } else {
                            height = max(height, size.height + marginHeight)
                        }
                    } else {
                        height = UIViewNoIntrinsicMetric
                    }
                }
            }
        }
        return CGSizeMake(width, height)
    }
}

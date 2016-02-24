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
        if let parent = superview {
            parent.setNeedsUpdateConstraints()
        }
        return self
    }

    func flexBasis(width:CGFloat, height:CGFloat) -> UIView {
        objc_setAssociatedObject(self, &FlexboxAssociatedKeys.flexBasis, NSValue.init(CGSize: CGSizeMake(width, height)), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        if let parent = superview {
            parent.setNeedsUpdateConstraints()
        }
        return self
    }

    func flexBasis(width:CGFloat, _ height:CGFloat) -> UIView {
        objc_setAssociatedObject(self, &FlexboxAssociatedKeys.flexBasis, NSValue.init(CGSize: CGSizeMake(width, height)), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        if let parent = superview {
            parent.setNeedsUpdateConstraints()
        }
        return self
    }

    func flexGrow(grow:Int) -> UIView {
        objc_setAssociatedObject(self, &FlexboxAssociatedKeys.flexGrow, NSNumber.init(long: grow), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        if let parent = superview {
            parent.setNeedsUpdateConstraints()
        }
        return self
    }

    func flexShrink(shrink:Int) -> UIView {
        objc_setAssociatedObject(self, &FlexboxAssociatedKeys.flexShrink, NSNumber.init(long: shrink), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        if let parent = superview {
            parent.setNeedsUpdateConstraints()
        }
        return self
    }

    func alignSelf(align:AlignItems) -> UIView {
        objc_setAssociatedObject(self, &FlexboxAssociatedKeys.alignSelf, NSNumber.init(long: align.rawValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        if let parent = superview {
            parent.setNeedsUpdateConstraints()
        }
        return self
    }

    func ccMargin(margin:EdgeInsets) -> UIView {
        objc_setAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin, NSValue.init(UIEdgeInsets: margin), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        if let parent = superview {
            parent.setNeedsUpdateConstraints()
        }
        return self
    }

    func ccTop(top:CGFloat) -> UIView {
        let marginValue = objc_getAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin)
        var margin = marginValue == nil ? EdgeInsetsZero : marginValue.UIEdgeInsetsValue()
        margin.top = top
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

    func ccTopAuto() -> UIView {
        let marginValue = objc_getAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin)
        var margin = marginValue == nil ? EdgeInsetsZero : marginValue.UIEdgeInsetsValue()
        margin.top = MarginAuto
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

    func ccRightAuto() -> UIView {
        let marginValue = objc_getAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin)
        var margin = marginValue == nil ? EdgeInsetsZero : marginValue.UIEdgeInsetsValue()
        margin.right = MarginAuto
        ccMargin(margin)
        return self
    }

    func ccBottomAuto() -> UIView {
        let marginValue = objc_getAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin)
        var margin = marginValue == nil ? EdgeInsetsZero : marginValue.UIEdgeInsetsValue()
        margin.bottom = MarginAuto
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

@objc public class CCFlexbox: UIView {

    private var items: [UIView] = []
    private var blanks: [UIView] = []
    private var margins: [UIView] = []
    private var vertical: Bool = false
    private var justifyContent: JustifyContent = .FlexStart
    private var alignItems: AlignItems = .Auto
    private let baseline:UILabel = UILabel.init()

    private let spaceCrossSize:CGFloat = 0 //used for debug
    private var constraintIdentifier:String = NSUUID().UUIDString

    private init(items: [UIView]) {
        super.init(frame: CGRectZero)
        self.items = items
        for item in items {
            self.addSubview(item)
        }
        self.addSubview(baseline)
        baseline.backgroundColor = UIColor.blackColor()
        baseline.translatesAutoresizingMaskIntoConstraints = false
        setFixedRelateConstraint(item: baseline, attribute: .Left)
        setFixedRelateConstraint(item: baseline, attribute: .Top)
        setFixedConstantConstraint(item: baseline, attribute: .Width, constant: spaceCrossSize)
        setFixedRelateConstraint(item: baseline, attribute: .Height)
    }

    required public init?(coder aDecoder: NSCoder) {
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

            //prevent overflow on cross axis
            if vertical {
                setFixedRelateConstraint(item: item, attribute: .Width, constant: 0, relatedBy: .LessThanOrEqual, toItem: self, attribute: .Width, multiplier: 1, priority: 999)
            } else {
                setFixedRelateConstraint(item: item, attribute: .Height, constant: 0, relatedBy: .LessThanOrEqual, toItem: self, attribute: .Height, multiplier: 1, priority: 999)
            }

            let previousSpace = UIView.init()
            previousSpace.translatesAutoresizingMaskIntoConstraints = false
            previousSpace.backgroundColor = UIColor.redColor()
            self.addSubview(previousSpace)
            self.blanks.append(previousSpace)
            if index > 0 {
                let lastSpace = blanks[1 + (index-1)*2]
                if vertical {
                    setFixedRelateConstraint(item: previousSpace, attribute: .Top, toItem: lastSpace, attribute: .Bottom)
                } else {
                    setFixedRelateConstraint(item: previousSpace, attribute: .Left, toItem: lastSpace, attribute: .Right)
                }
            } else {
                if vertical {
                    setFixedRelateConstraint(item: previousSpace, attribute: .Top)
                } else {
                    setFixedRelateConstraint(item: previousSpace, attribute: .Left)
                }
            }
            if vertical {
                setFixedRelateConstraint(item: previousSpace, attribute: .Left)
                setFixedConstantConstraint(item: previousSpace, attribute: .Width, constant: spaceCrossSize)
            } else {
                setFixedRelateConstraint(item: previousSpace, attribute: .Top)
                setFixedConstantConstraint(item: previousSpace, attribute: .Height, constant: spaceCrossSize)
            }

            let previousMargin = UIView.init()
            previousMargin.translatesAutoresizingMaskIntoConstraints = false
            previousMargin.backgroundColor = UIColor.blueColor()
            self.addSubview(previousMargin)
            self.margins.append(previousMargin)
            if vertical {
                setFixedRelateConstraint(item: previousMargin, attribute: .Top, toItem: previousSpace, attribute: .Bottom)
                setFixedRelateConstraint(item: previousMargin, attribute: .Bottom, toItem: item, attribute: .Top)
                setFixedRelateConstraint(item: previousMargin, attribute: .Left)
                setFixedConstantConstraint(item: previousMargin, attribute: .Width, constant: spaceCrossSize)
                setFixedRelateConstraint(item: previousMargin, attribute: .Height, constant: 0, relatedBy: .LessThanOrEqual)
            } else {
                setFixedRelateConstraint(item: previousMargin, attribute: .Left, toItem: previousSpace, attribute: .Right)
                setFixedRelateConstraint(item: previousMargin, attribute: .Right, toItem: item, attribute: .Left)
                setFixedRelateConstraint(item: previousMargin, attribute: .Top)
                setFixedConstantConstraint(item: previousMargin, attribute: .Height, constant: spaceCrossSize)
                setFixedRelateConstraint(item: previousMargin, attribute: .Width, constant: 0, relatedBy: .LessThanOrEqual)
            }

            item.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(item)

            let nextMargin = UIView.init()
            nextMargin.translatesAutoresizingMaskIntoConstraints = false
            nextMargin.backgroundColor = UIColor.yellowColor()
            self.addSubview(nextMargin)
            self.margins.append(nextMargin)
            if vertical {
                setFixedRelateConstraint(item: nextMargin, attribute: .Top, toItem: item, attribute: .Bottom)
                setFixedRelateConstraint(item: nextMargin, attribute: .Left)
                setFixedConstantConstraint(item: nextMargin, attribute: .Width, constant: spaceCrossSize)
                setFixedRelateConstraint(item: nextMargin, attribute: .Height, constant: 0, relatedBy: .LessThanOrEqual)
            } else {
                setFixedRelateConstraint(item: nextMargin, attribute: .Left, toItem: item, attribute: .Right)
                setFixedRelateConstraint(item: nextMargin, attribute: .Top)
                setFixedConstantConstraint(item: nextMargin, attribute: .Height, constant: spaceCrossSize)
                setFixedRelateConstraint(item: nextMargin, attribute: .Width, constant: 0, relatedBy: .LessThanOrEqual)
            }

            let nextSpace = UIView.init()
            nextSpace.translatesAutoresizingMaskIntoConstraints = false
            nextSpace.backgroundColor = UIColor.greenColor()
            self.addSubview(nextSpace)
            self.blanks.append(nextSpace)
            if vertical {
                setFixedRelateConstraint(item: nextSpace, attribute: .Top, toItem: nextMargin, attribute: .Bottom)
                setFixedRelateConstraint(item: nextSpace, attribute: .Left)
                setFixedConstantConstraint(item: nextSpace, attribute: .Width, constant: spaceCrossSize)
                if index == items.count - 1 {
                    //prevent overflow
                    setFixedRelateConstraint(item: nextSpace, attribute: .Bottom, constant: 0, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, priority: 999)
                }
            } else {
                setFixedRelateConstraint(item: nextSpace, attribute: .Left, toItem: nextMargin, attribute: .Right)
                setFixedRelateConstraint(item: nextSpace, attribute: .Top)
                setFixedConstantConstraint(item: nextSpace, attribute: .Height, constant: spaceCrossSize)
                if index == items.count - 1 {
                    //prevent overflow
                    setFixedRelateConstraint(item: nextSpace, attribute: .Right, constant: 0, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, priority: 999)
                }
            }
        }
    }

    override public func updateConstraints() {
        clearWidthConstraints(self)
        if vertical {
            updateVerticalConstraints()
        } else {
            updateHorizontalConstraints()
        }
        super.updateConstraints()
    }

    private func updateHorizontalConstraints() {
        var grows = 0
        for item in items {
            let grow = getFlexGrowForItem(item)
            grows += grow
        }

        var autoMargins:[UIView] = []
        for var index = 0; index < items.count; index++ {
            let item = items[index]
            clearWidthConstraints(item)

            let basis = getFlexBasisForItem(item)
            let grow = max(getFlexGrowForItem(item), 0)
            let shrink = max(getFlexShrinkForItem(item), 0)
            if basis.width != UIViewNoIntrinsicMetric {
                setConstantWidthConstraint(item, constant: basis.width, .GreaterThanOrEqual, Float(750-shrink))
                setConstantWidthConstraint(item, constant: basis.width, .LessThanOrEqual, Float(250-shrink))
                setConstantWidthConstraint(item, constant: basis.width, .Equal, Float(750-shrink))

                //prevent content size changing bound size
                item.setContentCompressionResistancePriority(1, forAxis: .Horizontal)
                item.setContentHuggingPriority(1, forAxis: .Horizontal)
            } else{
                item.setContentCompressionResistancePriority(Float(750 - shrink), forAxis: .Horizontal) //no shrinking
                item.setContentHuggingPriority(Float(251 - grow), forAxis: .Horizontal)//make sibing column's inner label width grow
            }

            var align = getAlignSelfForItem(item)
            if align == .Auto {
                align = alignItems
            }
            var margin = getMarginForItem(item)
            if margin.top == MarginAuto {
                margin.top = 0
            }
            if margin.bottom == MarginAuto {
                margin.bottom = 0
            }
            switch align {
            case .FlexStart:
                setAlignConstraint(item: item, attribute: .Top, constant: margin.top)
                break;
            case .FlexEnd:
                setAlignConstraint(item: item, attribute: .Bottom, constant: -margin.bottom)
                break;
            case .Center:
                setAlignConstraint(item: item, attribute: .CenterY)
                break;
            case .Baseline:
                setAlignConstraint(item: item, attribute: .Baseline, constant: 0, relatedBy: .Equal, toItem: baseline, attribute: .Baseline)
                break;
            case .Stretch, .Auto:
                setAlignConstraint(item: item, attribute: .Top, constant: margin.top)
                setAlignConstraint(item: item, attribute: .Bottom, constant: -margin.bottom)
                break;
            }
            if align != .Stretch && align != .Auto && basis.height != UIViewNoIntrinsicMetric {
                setConstantHeightConstraint(item, constant: basis.height, .GreaterThanOrEqual, 750)
                setConstantHeightConstraint(item, constant: basis.height, .LessThanOrEqual, 750)
                setConstantHeightConstraint(item, constant: basis.height, .Equal, 750)
            }

            let leftMargin = self.margins[index * 2]
            clearWidthConstraints(leftMargin)
            if margin.left == MarginAuto {
                autoMargins.append(leftMargin)
            } else {
                setConstantWidthConstraint(leftMargin, constant: margin.left)
            }

            let rightMargin = self.margins[1+index*2]
            clearWidthConstraints(rightMargin)
            if margin.right == MarginAuto {
                autoMargins.append(rightMargin)
            } else {
                setConstantWidthConstraint(rightMargin, constant: margin.right)
            }
        }
        if autoMargins.count > 0 {
            let firstMargin = autoMargins.first!
            if grows > 0 {
                setConstantWidthConstraint(firstMargin, constant: 0)
            } else {
                setConstantWidthConstraint(firstMargin, constant: 0, .GreaterThanOrEqual)
            }

            for margin in autoMargins[1..<autoMargins.count] {
                setRelateWidthConstraint(margin, target: firstMargin)
            }
        }

        if grows > 0 {
            for var index = 0; index < blanks.count; index++ {
                let space = blanks[index]
                clearWidthConstraints(space)
                setConstantWidthConstraint(space, constant: 0)
            }
        } else {
            switch justifyContent {
            case .FlexStart:
                let firstSpace = self.blanks.first!
                clearWidthConstraints(firstSpace)
                setConstantWidthConstraint(firstSpace, constant: 0)
                let lastSpace = self.blanks.last!
                clearWidthConstraints(lastSpace)
                setConstantWidthConstraint(lastSpace, constant: 0, .GreaterThanOrEqual)
                for var index = 1; index < blanks.count - 1; index++ {
                    let space = blanks[index]
                    clearWidthConstraints(space)
                    setConstantWidthConstraint(space, constant: 0)
                }
                break
            case .FlexEnd:
                let lastSpace = self.blanks.last!
                clearWidthConstraints(lastSpace)
                setConstantWidthConstraint(lastSpace, constant: 0)
                let firstSpace = self.blanks.first!
                clearWidthConstraints(firstSpace)
                setConstantWidthConstraint(firstSpace, constant: 0, .GreaterThanOrEqual)
                for var index = 1; index < blanks.count - 1; index++ {
                    let space = blanks[index]
                    clearWidthConstraints(space)
                    setConstantWidthConstraint(space, constant: 0)
                }
                break
            case .Center:
                let firstSpace = self.blanks.first!
                clearWidthConstraints(firstSpace)
                setConstantWidthConstraint(firstSpace, constant: 0, .GreaterThanOrEqual) //0 if any auto margin, otherwise > 0

                let lastSpace = self.blanks.last!
                clearWidthConstraints(lastSpace)
                setRelateWidthConstraint(lastSpace, target: firstSpace)

                for var index = 1; index < blanks.count - 1; index++ {
                    let space = blanks[index]
                    clearWidthConstraints(space)
                    setConstantWidthConstraint(space, constant: 0)
                }
                break
            case .SpaceBetween:
                let firstSpace = self.blanks.first!
                clearWidthConstraints(firstSpace)
                setConstantWidthConstraint(firstSpace, constant: 0)

                let lastSpace = self.blanks.last!
                clearWidthConstraints(lastSpace)
                setConstantWidthConstraint(lastSpace, constant: 0)

                let secondSpace = blanks[1]
                clearWidthConstraints(secondSpace)
                setConstantWidthConstraint(secondSpace, constant: 0, .GreaterThanOrEqual)
                for nextSpace in blanks[2..<blanks.count-1] {
                    clearWidthConstraints(nextSpace)
                    setRelateWidthConstraint(nextSpace, target: secondSpace)
                }
                break
            case .SpaceAround:
                let firstSpace = self.blanks.first!
                clearWidthConstraints(firstSpace)
                setConstantWidthConstraint(firstSpace, constant: 0, .GreaterThanOrEqual) //0 if any auto margin, otherwise > 0

                for nextSpace in blanks[1..<blanks.count] {
                    clearWidthConstraints(nextSpace)
                    setRelateWidthConstraint(nextSpace, target: firstSpace)
                }
                break
            case .SpaceSeperate:
                let firstSpace = self.blanks.first!
                clearWidthConstraints(firstSpace)
                setConstantWidthConstraint(firstSpace, constant: 0, .GreaterThanOrEqual) //0 if any auto margin, otherwise > 0

                for nextSpace in blanks[1..<blanks.count-1] {
                    clearWidthConstraints(nextSpace)
                    setRelateWidthConstraint(firstSpace, target: nextSpace, multiplier: 2)
                }

                let lastSpace = self.blanks.last!
                clearWidthConstraints(lastSpace)
                setRelateWidthConstraint(lastSpace, target: firstSpace)
                break
            }
        }
    }

    private func updateVerticalConstraints() {
        var grows = 0
        for item in items {
            let grow = getFlexGrowForItem(item)
            grows += grow
        }

        var autoMargins:[UIView] = []
        for var index = 0; index < items.count; index++ {
            let item = items[index]
            clearWidthConstraints(item)

            let basis = getFlexBasisForItem(item)
            let grow = getFlexGrowForItem(item)
            let shrink = getFlexShrinkForItem(item)
            if basis.height != UIViewNoIntrinsicMetric {
                setConstantHeightConstraint(item, constant: basis.height, .GreaterThanOrEqual, Float(750-shrink))
                setConstantHeightConstraint(item, constant: basis.height, .LessThanOrEqual, Float(250-shrink))
                setConstantHeightConstraint(item, constant: basis.height, .Equal, Float(750-shrink))

                //prevent content size changing bound size
                item.setContentCompressionResistancePriority(1, forAxis: .Vertical)
                item.setContentHuggingPriority(1, forAxis: .Vertical)
            } else {
                item.setContentCompressionResistancePriority(Float(750 - shrink), forAxis: .Vertical) //no shrinking
                item.setContentHuggingPriority(Float(251 - grow), forAxis: .Vertical) //make sibling row's inner label height grow
            }

            var align = getAlignSelfForItem(item)
            if align == .Auto {
                align = alignItems
            }
            var margin = getMarginForItem(item)
            if margin.left == MarginAuto {
                margin.left = 0
            }
            if margin.right == MarginAuto {
                margin.right = 0
            }
            switch align {
            case .FlexStart:
                setAlignConstraint(item: item, attribute: .Left, constant: margin.left)
                break;
            case .FlexEnd:
                setAlignConstraint(item: item, attribute: .Right, constant: -margin.right)
                break;
            case .Center:
                setAlignConstraint(item: item, attribute: .CenterX)
                break;
            case .Baseline, .Stretch, .Auto:
                setAlignConstraint(item: item, attribute: .Left, constant: margin.left)
                setAlignConstraint(item: item, attribute: .Right, constant: -margin.right)
                break;
            }
            if align != .Stretch && align != .Auto && align != .Baseline && basis.width != UIViewNoIntrinsicMetric {
                setConstantWidthConstraint(item, constant: basis.width, .GreaterThanOrEqual, 750)
                setConstantWidthConstraint(item, constant: basis.width, .LessThanOrEqual, 750)
                setConstantWidthConstraint(item, constant: basis.width, .Equal, 750)
            }

            let topMargin = self.margins[index * 2]
            clearWidthConstraints(topMargin)
            if margin.top == MarginAuto {
                autoMargins.append(topMargin)
            } else {
                setConstantHeightConstraint(topMargin, constant: margin.top)
            }
            let bottomMargin = self.margins[1+index*2]
            clearWidthConstraints(bottomMargin)
            if margin.bottom == MarginAuto {
                autoMargins.append(bottomMargin)
            } else {
                setConstantHeightConstraint(bottomMargin, constant: margin.bottom)
            }
        }
        if autoMargins.count > 0 {
            let firstMargin = autoMargins.first!
            if grows > 0 {
                setConstantHeightConstraint(firstMargin, constant: 0)
            } else {
                setConstantHeightConstraint(firstMargin, constant: 0, .GreaterThanOrEqual)
            }

            for margin in autoMargins[1..<autoMargins.count] {
                setRelateHeightConstraint(margin, target: firstMargin)
            }
        }

        if grows > 0 {
            for var index = 0; index < blanks.count; index++ {
                let space = blanks[index]
                clearWidthConstraints(space)
                setConstantHeightConstraint(space, constant: 0)
            }
        } else {
            switch justifyContent {
            case .FlexStart:
                let firstSpace = self.blanks.first!
                clearWidthConstraints(firstSpace)
                setConstantHeightConstraint(firstSpace, constant: 0)
                let lastSpace = self.blanks.last!
                clearWidthConstraints(lastSpace)
                setConstantHeightConstraint(lastSpace, constant: 0, .GreaterThanOrEqual)
                for var index = 1; index < blanks.count - 1; index++ {
                    let space = blanks[index]
                    clearWidthConstraints(space)
                    setConstantHeightConstraint(space, constant: 0)
                }
                break
            case .FlexEnd:
                let lastSpace = self.blanks.last!
                clearWidthConstraints(lastSpace)
                setConstantHeightConstraint(lastSpace, constant: 0)
                let firstSpace = self.blanks.first!
                clearWidthConstraints(firstSpace)
                setConstantHeightConstraint(firstSpace, constant: 0, .GreaterThanOrEqual)
                for var index = 1; index < blanks.count - 1; index++ {
                    let space = blanks[index]
                    clearWidthConstraints(space)
                    setConstantHeightConstraint(space, constant: 0)
                }
                break
            case .Center:
                let firstSpace = self.blanks.first!
                clearWidthConstraints(firstSpace)
                setConstantHeightConstraint(firstSpace, constant: 0, .GreaterThanOrEqual) //0 if any auto margin, otherwise > 0

                let lastSpace = self.blanks.last!
                clearWidthConstraints(lastSpace)
                setRelateHeightConstraint(lastSpace, target: firstSpace)

                for var index = 1; index < blanks.count - 1; index++ {
                    let space = blanks[index]
                    clearWidthConstraints(space)
                    setConstantHeightConstraint(space, constant: 0)
                }
                break
            case .SpaceBetween:
                let firstSpace = self.blanks.first!
                clearWidthConstraints(firstSpace)
                setConstantHeightConstraint(firstSpace, constant: 0)

                let lastSpace = self.blanks.last!
                clearWidthConstraints(lastSpace)
                setConstantHeightConstraint(lastSpace, constant: 0)

                let secondSpace = blanks[1]
                clearWidthConstraints(secondSpace)
                setConstantHeightConstraint(secondSpace, constant: 0, .GreaterThanOrEqual)
                for nextSpace in blanks[2..<blanks.count-1] {
                    clearWidthConstraints(nextSpace)
                    setRelateHeightConstraint(nextSpace, target: secondSpace)
                }
                break
            case .SpaceAround:
                let firstSpace = self.blanks.first!
                clearWidthConstraints(firstSpace)
                setConstantHeightConstraint(firstSpace, constant: 0, .GreaterThanOrEqual) //0 if any auto margin, otherwise > 0

                for nextSpace in blanks[1..<blanks.count] {
                    clearWidthConstraints(nextSpace)
                    setRelateHeightConstraint(nextSpace, target: firstSpace)
                }
                break
            case .SpaceSeperate:
                let firstSpace = self.blanks.first!
                clearWidthConstraints(firstSpace)
                setConstantHeightConstraint(firstSpace, constant: 0, .GreaterThanOrEqual) //0 if any auto margin, otherwise > 0

                for nextSpace in blanks[1..<blanks.count-1] {
                    clearWidthConstraints(nextSpace)
                    setRelateHeightConstraint(firstSpace, target: nextSpace, multiplier: 2)
                }

                let lastSpace = self.blanks.last!
                clearWidthConstraints(lastSpace)
                setRelateHeightConstraint(lastSpace, target: firstSpace)
                break
            }
        }
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
        return shrinkValue == nil ? 0 : shrinkValue.integerValue
    }

    private func getAlignSelfForItem(item:UIView) -> AlignItems {
        let alignValue = objc_getAssociatedObject(item, &FlexboxAssociatedKeys.alignSelf)
        return alignValue == nil ? AlignItems.Auto : AlignItems(rawValue: alignValue.integerValue)!
    }

    private func getMarginForItem(item:UIView) -> EdgeInsets {
        let marginValue = objc_getAssociatedObject(item, &FlexboxAssociatedKeys.ccMargin)
        return marginValue == nil ? EdgeInsetsZero : marginValue.UIEdgeInsetsValue()
    }

    private func clearWidthConstraints(item:UIView) {
        let refreshConstraints = item.constraints.filter { (constraint) -> Bool in
            return constraint.identifier == constraintIdentifier
        }
        if #available(iOS 8.0, *) {
            NSLayoutConstraint.deactivateConstraints(refreshConstraints)
        } else {
            item.removeConstraints(refreshConstraints)
        }
    }

    private func setConstantWidthConstraint(item:UIView, constant:CGFloat, _ relation:NSLayoutRelation = .Equal, _ priority:UILayoutPriority = UILayoutPriorityRequired) {
        let constraint = NSLayoutConstraint(item: item, attribute: .Width, relatedBy: relation, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: constant)
        constraint.priority = priority
        constraint.identifier = constraintIdentifier
        if #available(iOS 8.0, *) {
            constraint.active = true
        } else {
            item.addConstraint(constraint)
        }
    }

    private func setRelateWidthConstraint(item:UIView, target:UIView, multiplier:CGFloat = 1, relatedBy: NSLayoutRelation = .Equal) {
        let constraint = NSLayoutConstraint(item: item, attribute: .Width, relatedBy: relatedBy, toItem: target, attribute: .Width, multiplier: multiplier, constant: 0)
        constraint.identifier = constraintIdentifier
        if #available(iOS 8.0, *) {
            constraint.active = true
        } else {
            item.addConstraint(constraint)
        }
    }

    private func setConstantHeightConstraint(item:UIView, constant:CGFloat, _ relation:NSLayoutRelation = .Equal, _ priority:UILayoutPriority = UILayoutPriorityRequired) {
        let constraint = NSLayoutConstraint(item: item, attribute: .Height, relatedBy: relation, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: constant)
        constraint.priority = priority
        constraint.identifier = constraintIdentifier
        if #available(iOS 8.0, *) {
            constraint.active = true
        } else {
            item.addConstraint(constraint)
        }
    }

    private func setRelateHeightConstraint(item:UIView, target:UIView, multiplier:CGFloat = 1, relatedBy: NSLayoutRelation = .Equal, priority:UILayoutPriority = UILayoutPriorityRequired, constant:CGFloat = 0) {
        let constraint = NSLayoutConstraint(item: item, attribute: .Height, relatedBy: relatedBy, toItem: target, attribute: .Height, multiplier: multiplier, constant: constant)
        constraint.identifier = constraintIdentifier
        constraint.priority = priority
        if #available(iOS 8.0, *) {
            constraint.active = true
        } else {
            item.addConstraint(constraint)
        }
    }

    private func setAlignConstraint(item view1: AnyObject, attribute attr1: NSLayoutAttribute, constant c: CGFloat = 0, relatedBy relation: NSLayoutRelation = .Equal, var toItem view2: AnyObject? = nil, var attribute attr2: NSLayoutAttribute? = nil, priority:UILayoutPriority = UILayoutPriorityRequired){
        if view2 == nil {
            view2 = self
        }
        if attr2 == nil {
            attr2 = attr1
        }
        let constraint = NSLayoutConstraint(item: view1, attribute: attr1, relatedBy: relation, toItem: view2!, attribute: attr2!, multiplier: 1, constant:c)
        constraint.identifier = constraintIdentifier
        constraint.priority = priority
        if #available(iOS 8.0, *) {
            constraint.active = true
        } else {
            view1.addConstraint(constraint)
        }
    }

    private func setFixedRelateConstraint(item view1: AnyObject, attribute attr1: NSLayoutAttribute, constant c: CGFloat = 0, relatedBy relation: NSLayoutRelation = .Equal, var toItem view2: AnyObject? = nil, var attribute attr2: NSLayoutAttribute? = nil, multiplier:CGFloat = 1, priority:UILayoutPriority = UILayoutPriorityRequired) {
        if view2 == nil {
            view2 = self
        }
        if attr2 == nil {
            attr2 = attr1
        }
        let constraint = NSLayoutConstraint(item: view1, attribute: attr1, relatedBy: relation, toItem: view2!, attribute: attr2!, multiplier: multiplier, constant: c)
        constraint.priority = priority
        constraint.identifier = "fixed"
        if #available(iOS 8.0, *) {
            constraint.active = true
        } else {
            view1.addConstraint(constraint)
        }
    }

    private func setFixedRelateConstraint(item view1: AnyObject, attribute attr1: NSLayoutAttribute, toItem view2: AnyObject, attribute attr2: NSLayoutAttribute) {
        setFixedRelateConstraint(item: view1, attribute: attr1, constant: 0, relatedBy: .Equal, toItem: view2, attribute: attr2, multiplier: 1, priority: UILayoutPriorityRequired)
    }

    private func setFixedConstantConstraint(item view1: AnyObject, attribute attr1: NSLayoutAttribute, constant c: CGFloat, priority:UILayoutPriority = UILayoutPriorityRequired) {
        let constraint = NSLayoutConstraint(item: view1, attribute: attr1, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: c)
        constraint.priority = priority
        constraint.identifier = "fixed"
        if #available(iOS 8.0, *) {
            constraint.active = true
        } else {
            view1.addConstraint(constraint)
        }
    }

    private func clearHeightConstraints(item:UIView) {
        for constraint in item.constraints {
            if constraint.firstAttribute == .Height {
                item.removeConstraint(constraint)
            }
        }
    }
}

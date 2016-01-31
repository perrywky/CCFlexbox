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

    private var items: [UIView]
    private var blanks: [UIView]
    private var margins: [UIView]
    private var vertical: Bool
    private var justifyContent: JustifyContent
    private var alignItems: AlignItems
    private var oldSize:CGSize
    private var ruler:UIView
    private var baseline:UIView

    override public var viewForFirstBaselineLayout: UIView {
        get {
            return baseline
        }
    }

    override public var viewForLastBaselineLayout: UIView {
        get {
            return baseline
        }
    }

    private init(items: [UIView]) {
        self.items = items
        self.blanks = []
        self.margins = []
        self.vertical = false
        self.justifyContent = .FlexStart
        self.alignItems = .Stretch
        self.oldSize = CGSizeZero
        self.ruler = UIView.init()
        self.baseline = UIView.init()
        super.init(frame: CGRectZero)
        for item in items {
            self.addSubview(item)
        }
        self.addSubview(baseline)
        baseline.snp_makeConstraints { (make) -> Void in
            make.left.top.width.equalTo(0)
            make.height.equalTo(self).multipliedBy(0.8)
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
        self.baseline = UIView.init()
        super.init(coder: aDecoder)
        self.addSubview(baseline)
        baseline.snp_makeConstraints { (make) -> Void in
            make.left.top.width.equalTo(0)
            make.height.equalTo(self).multipliedBy(0.8)
        }
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
        if vertical {

            var grows = 0
            for item in items {
                let grow = getFlexGrowForItem(item)
                grows += grow
            }

            var autoMargins:[UIView] = []
            for var index = 0; index < items.count; index++ {
                let item = items[index]
                self.setHeightConstraintForItem(item)
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
                    if grows > 0 {
                        make.height.equalTo(0)
                    } else {
                        make.height.greaterThanOrEqualTo(0)
                    }
                    for margin in autoMargins[1..<autoMargins.count] {
                        make.height.equalTo(margin)
                    }
                })
            }

            if grows > 0 {
                let firstSpace = self.blanks.first!
                firstSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.top.equalTo(0)
                })
                let lastSpace = self.blanks.last!
                lastSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.bottom.equalTo(0)
                })
                for var index = 0; index < blanks.count; index++ {
                    let space = blanks[index]
                    space.snp_updateConstraints(closure: { (make) -> Void in
                        make.height.equalTo(0)
                    })
                }
            } else {
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
                        make.height.greaterThanOrEqualTo(0)
                        make.height.lessThanOrEqualTo(0).priority(249) // prevent sibling's contentHugging
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
                        make.height.greaterThanOrEqualTo(0)
                        make.height.lessThanOrEqualTo(0).priority(249) // prevent sibing's contentHugging
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
                        make.height.greaterThanOrEqualTo(0)
                        make.height.lessThanOrEqualTo(0).priority(249) // prevent sibing's contentHugging
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
                        make.height.greaterThanOrEqualTo(0)
                        make.height.lessThanOrEqualTo(0).priority(249) // prevent sibing's contentHugging
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
                        make.height.greaterThanOrEqualTo(0)
                        make.height.lessThanOrEqualTo(0).priority(249) // prevent sibling's contentHugging
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
                        make.height.greaterThanOrEqualTo(0)
                        make.height.lessThanOrEqualTo(0).priority(249) // prevent uilabel contentHugging
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
            }

        } else {

            var grows = 0
            for item in items {
                let grow = getFlexGrowForItem(item)
                grows += grow
            }

            var autoMargins:[UIView] = []
            for var index = 0; index < items.count; index++ {
                let item = items[index]
                self.setWidthConstraintForItem(item)
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
                    if grows > 0 {
                        make.width.equalTo(0)
                    } else {
                        make.width.greaterThanOrEqualTo(0)
                    }
                    for margin in autoMargins[1..<autoMargins.count] {
                        make.width.equalTo(margin)
                    }
                })
            }

            if grows > 0 {
                let firstSpace = self.blanks.first!
                firstSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.left.equalTo(0)
                })
                let lastSpace = self.blanks.last!
                lastSpace.snp_updateConstraints(closure: { (make) -> Void in
                    make.right.equalTo(0)
                })
                for var index = 0; index < blanks.count; index++ {
                    let space = blanks[index]
                    space.snp_updateConstraints(closure: { (make) -> Void in
                        make.width.equalTo(0)
                    })
                }
            } else {
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
                        make.width.greaterThanOrEqualTo(0)
                        make.width.lessThanOrEqualTo(0).priority(249) // prevent sibling's contentHugging
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
                        make.width.greaterThanOrEqualTo(0)
                        make.width.lessThanOrEqualTo(0).priority(249) // prevent uilabel contentHugging
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
                        make.width.greaterThanOrEqualTo(0)
                        make.width.lessThanOrEqualTo(0).priority(249) // prevent sibing's contentHugging
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
                        make.width.greaterThanOrEqualTo(0)
                        make.width.lessThanOrEqualTo(0).priority(249) // prevent sibing's contentHugging
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
                        make.width.greaterThanOrEqualTo(0)
                        make.width.lessThanOrEqualTo(0).priority(249) // prevent sibling's contentHugging
                        for nextSpace in blanks[1..<blanks.count] {
                            make.width.equalTo(nextSpace)
                        }
                    })
                    lastSpace.snp_updateConstraints(closure: { (make) -> Void in
                        make.right.equalTo(0)
                    })
                    break
                case .SpaceSeperate:
                    let firstSpace = self.blanks.first!
                    let lastSpace = self.blanks.last!
                    firstSpace.snp_updateConstraints(closure: { (make) -> Void in
                        make.left.equalTo(0)
                        //0 if any auto margin, otherwise > 0
                        make.width.greaterThanOrEqualTo(0)
                        make.width.lessThanOrEqualTo(0).priority(249) // prevent uilabel contentHugging
                        for nextSpace in blanks[1..<blanks.count-1] {
                            make.width.equalTo(nextSpace).multipliedBy(2)
                        }
                    })
                    lastSpace.snp_updateConstraints(closure: { (make) -> Void in
                        make.right.equalTo(0)
                        make.width.equalTo(firstSpace)
                    })
                    break
                }
            }
        }

        super.updateConstraints()
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

    private func setWidthConstraintForItem(item:UIView) -> Void {
        let basis = getFlexBasisForItem(item)
        let grow = max(getFlexGrowForItem(item), 0)
        let shrink = max(getFlexShrinkForItem(item), 0)
        item.snp_updateConstraints(closure: { (make) -> Void in
            if basis.width != UIViewNoIntrinsicMetric {
                make.width.greaterThanOrEqualTo(basis.width).priority(750 - shrink) //ContentCompressionResistance
                make.width.lessThanOrEqualTo(basis.width).priority(250 - grow) //ContentHugging

                item.setContentCompressionResistancePriority(1, forAxis: .Horizontal) //incase content size is bigger
            } else {
                item.setContentCompressionResistancePriority(Float(750 - shrink), forAxis: .Horizontal) //no shrinking
                item.setContentHuggingPriority(Float(250 - grow), forAxis: .Horizontal)
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
                make.top.bottom.equalTo(self).inset(margin)
                break;
            }
            if align != .Stretch && align != .Auto {
                let basis = getFlexBasisForItem(item)
                if basis.height != UIViewNoIntrinsicMetric {
                    make.height.greaterThanOrEqualTo(basis.height).priority(750)
                    make.height.lessThanOrEqualTo(basis.height).priority(250)
                } else {
                    make.height.lessThanOrEqualTo(self).offset(-margin.top-margin.bottom).priority(750)
                }
            }
            item.setContentCompressionResistancePriority(1, forAxis: .Vertical) //incase content size is bigger
        })
    }

    private func setHeightConstraintForItem(item:UIView) -> Void {
        let basis = getFlexBasisForItem(item)
        let grow = getFlexGrowForItem(item)
        let shrink = getFlexShrinkForItem(item)
        item.snp_updateConstraints(closure: { (make) -> Void in
            if basis.height != UIViewNoIntrinsicMetric {
                make.height.greaterThanOrEqualTo(basis.height).priority(750 - shrink) //ContentCompressionResistance
                make.height.lessThanOrEqualTo(basis.height).priority(250 - grow) //ContentHugging

                item.setContentCompressionResistancePriority(1, forAxis: .Vertical) //incase content size is bigger
            } else {
                item.setContentCompressionResistancePriority(Float(750 - shrink), forAxis: .Vertical) //no shrinking
                item.setContentHuggingPriority(Float(250 - grow), forAxis: .Vertical)
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
                make.left.right.equalTo(self).inset(margin)
                break;
            }
            if align != .Stretch && align != .Auto {
                let basis = getFlexBasisForItem(item)
                if basis.width != UIViewNoIntrinsicMetric {
                    make.width.greaterThanOrEqualTo(basis.width).priority(750)
                    make.width.lessThanOrEqualTo(basis.width).priority(250)
                } else {
                    make.width.lessThanOrEqualTo(self).offset(-margin.left-margin.right).priority(750)
                }
            }
            item.setContentCompressionResistancePriority(1, forAxis: .Horizontal) //incase content size is bigger
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

    override public func viewForBaselineLayout() -> UIView {
        return baseline
    }
}

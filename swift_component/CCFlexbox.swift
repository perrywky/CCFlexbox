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

private struct AxisLayoutAttributes {
    let mainAxis: UILayoutConstraintAxis
    let crossAxis: UILayoutConstraintAxis
    let mainPrevious: NSLayoutAttribute
    let mainNext: NSLayoutAttribute
    let crossPrevious: NSLayoutAttribute
    let crossNext: NSLayoutAttribute
    let mainSize: NSLayoutAttribute
    let crossSize: NSLayoutAttribute
    let mainCenter:NSLayoutAttribute
    let crossCenter:NSLayoutAttribute

    init(vertical:Bool) {
        if vertical {
            mainAxis = .Vertical
            crossAxis = .Horizontal
            mainPrevious = .Top
            mainNext = .Bottom
            crossPrevious = .Left
            crossNext = .Right
            mainSize = .Height
            crossSize = .Width
            mainCenter = .CenterY
            crossCenter = .CenterX
        } else {
            mainAxis = .Horizontal
            crossAxis = .Vertical
            mainPrevious = .Left
            mainNext = .Right
            crossPrevious = .Top
            crossNext = .Bottom
            mainSize = .Width
            crossSize = .Height
            mainCenter = .CenterX
            crossCenter = .CenterY
        }
    }
}

private struct AxisMargins {
    var mainPrevious: CGFloat
    var mainNext: CGFloat
    var crossPrevious: CGFloat
    var crossNext: CGFloat
}

private struct AxisBasis {
    let mainBasis: CGFloat
    let crossBasis: CGFloat
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

    func ccMargin(margin:UIEdgeInsets) -> UIView {
        objc_setAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin, NSValue.init(UIEdgeInsets: margin), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        if let parent = superview {
            parent.setNeedsUpdateConstraints()
        }
        return self
    }

    func ccTop(top:CGFloat) -> UIView {
        let marginValue = objc_getAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin)
        var margin = marginValue == nil ? UIEdgeInsetsZero : marginValue.UIEdgeInsetsValue()
        margin.top = top
        ccMargin(margin)
        return self
    }

    func ccLeft(left:CGFloat) -> UIView {
        let marginValue = objc_getAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin)
        var margin = marginValue == nil ? UIEdgeInsetsZero : marginValue.UIEdgeInsetsValue()
        margin.left = left
        ccMargin(margin)
        return self
    }

    func ccBottom(bottom:CGFloat) -> UIView {
        let marginValue = objc_getAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin)
        var margin = marginValue == nil ? UIEdgeInsetsZero : marginValue.UIEdgeInsetsValue()
        margin.bottom = bottom
        ccMargin(margin)
        return self
    }

    func ccRight(right:CGFloat) -> UIView {
        let marginValue = objc_getAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin)
        var margin = marginValue == nil ? UIEdgeInsetsZero : marginValue.UIEdgeInsetsValue()
        margin.right = right
        ccMargin(margin)
        return self
    }

    func ccTopAuto() -> UIView {
        let marginValue = objc_getAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin)
        var margin = marginValue == nil ? UIEdgeInsetsZero : marginValue.UIEdgeInsetsValue()
        margin.top = MarginAuto
        ccMargin(margin)
        return self
    }

    func ccLeftAuto() -> UIView {
        let marginValue = objc_getAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin)
        var margin = marginValue == nil ? UIEdgeInsetsZero : marginValue.UIEdgeInsetsValue()
        margin.left = MarginAuto
        ccMargin(margin)
        return self
    }

    func ccRightAuto() -> UIView {
        let marginValue = objc_getAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin)
        var margin = marginValue == nil ? UIEdgeInsetsZero : marginValue.UIEdgeInsetsValue()
        margin.right = MarginAuto
        ccMargin(margin)
        return self
    }

    func ccBottomAuto() -> UIView {
        let marginValue = objc_getAssociatedObject(self, &FlexboxAssociatedKeys.ccMargin)
        var margin = marginValue == nil ? UIEdgeInsetsZero : marginValue.UIEdgeInsetsValue()
        margin.bottom = MarginAuto
        ccMargin(margin)
        return self
    }
}

private class CCLayoutGuide: UIView {

}

private class CCLabelLayoutGuide: UILabel {

}

@objc public enum JustifyContent: Int{
    case FlexStart, FlexEnd, Center, SpaceBetween, SpaceAround, SpaceSeperate
}

@objc public enum AlignItems: Int {
    case Auto, FlexStart, FlexEnd, Center, Baseline, Stretch
}

@objc public class CCFlexbox: UIView {

    private var items: [UIView] = []
    private var vertical: Bool = false
    private var justifyContent: JustifyContent = .FlexStart
    private var alignItems: AlignItems = .Auto
    private let baseline:CCLabelLayoutGuide = CCLabelLayoutGuide.init() //for baseline alignment

    private let layoutGuideSize:CGFloat = 0 //used for debugging
    private var constraintIdentifier:String = NSUUID().UUIDString //used for clearing existing constraints

    public var updateConstraintsCount = 0;

    private var axisAttributes:AxisLayoutAttributes = AxisLayoutAttributes.init(vertical: false)

    private init(items: [UIView]) {
        super.init(frame: CGRectZero)
        self.items = items
        for item in items {
            self.addSubview(item)
        }
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
        box.axisAttributes = AxisLayoutAttributes.init(vertical: true)
        box.setupItems()
        return box
    }

    public class func column(items: [UIView]) -> CCFlexbox {
        let box = CCFlexbox.init(items: items)
        box.vertical = true
        box.axisAttributes = AxisLayoutAttributes.init(vertical: true)
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
        for index in 0 ..< items.count {
            let item = items[index]
            self.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    override public func updateConstraints() {
        clearFlexConstraints(self)
        applyFlexLayout()
        super.updateConstraints()
        self.updateConstraintsCount += 1
    }

    private func applyFlexLayout() {
        var grows = 0
        var autoMarginCount = 0
        for item in items {
            let grow = getFlexGrowForItem(item)
            grows += grow
            let margin = getAxisMarginsForItem(item)
            if margin.mainPrevious == MarginAuto {
                autoMarginCount += 1
            }
            if margin.mainNext == MarginAuto {
                autoMarginCount += 1
            }
        }

        for subview in self.subviews {
            if subview is CCLayoutGuide {
                subview.removeFromSuperview()
                clearFlexConstraints(subview)
            }
        }
        baseline.removeFromSuperview()
        clearFlexConstraints(baseline)

        var subviews:[UIView] = []
        var autoSpaces:[UIView] = []

        var lastNextMargin:CGFloat = 0
        for index in 0 ..< items.count {
            let item = items[index]
            clearFlexConstraints(item)

            let basis = getAxisBasisForItem(item)
            let grow = max(getFlexGrowForItem(item), 0)
            let shrink = max(getFlexShrinkForItem(item), 0)
            if basis.mainBasis != UIViewNoIntrinsicMetric {
                setConstantConstraint(item, attribute: axisAttributes.mainSize, constant: basis.mainBasis, .GreaterThanOrEqual, Float(750-shrink)) //ContentCompressionResistancePriority
                setConstantConstraint(item, attribute: axisAttributes.mainSize, constant: basis.mainBasis, .LessThanOrEqual, Float(251-grow)) //ContentHuggingPriority

                //prevent content size changing bound size
                item.setContentCompressionResistancePriority(1, forAxis: axisAttributes.mainAxis)
                item.setContentHuggingPriority(1, forAxis: axisAttributes.mainAxis)
            } else{
                item.setContentCompressionResistancePriority(Float(750 - shrink), forAxis: axisAttributes.mainAxis) //no shrinking
                item.setContentHuggingPriority(Float(251 - grow), forAxis: axisAttributes.mainAxis)//make sibing column's inner label width grow
            }

            var margin = getAxisMarginsForItem(item)

            let previousMargin = margin.mainPrevious == MarginAuto ? 0 : margin.mainPrevious
            //no items can grow enabling auto margin
            let insertLeftAutoSpace = autoMarginCount == 0 && grows == 0 && (
                (justifyContent == .Center && index == 0) ||
                    justifyContent == .SpaceAround ||
                    justifyContent == .SpaceSeperate)

            if (margin.mainPrevious == MarginAuto && grows == 0) || insertLeftAutoSpace {
                let previousAutoSpace = CCLayoutGuide.init()
                previousAutoSpace.backgroundColor = UIColor.blackColor()
                previousAutoSpace.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(previousAutoSpace)
                setAlignConstraint(item: previousAutoSpace, attribute: axisAttributes.crossPrevious)
                setConstantConstraint(previousAutoSpace, attribute: axisAttributes.crossSize, constant: layoutGuideSize)

                if subviews.count > 0 {
                    setAlignConstraint(item: previousAutoSpace, attribute: axisAttributes.mainPrevious, constant: 0, relatedBy: .Equal, toItem: subviews.last!, attribute: axisAttributes.mainNext, priority: UILayoutPriorityRequired)
                } else {
                    setAlignConstraint(item: previousAutoSpace, attribute: axisAttributes.mainPrevious, constant: 0, relatedBy: .Equal, toItem: self, attribute: axisAttributes.mainPrevious, priority: UILayoutPriorityRequired)
                }
                subviews.append(previousAutoSpace)

                autoSpaces.append(previousAutoSpace)
            }
            if subviews.count > 0 {
                setAlignConstraint(item: item, attribute: axisAttributes.mainPrevious, constant: previousMargin + lastNextMargin, relatedBy: .Equal, toItem: subviews.last!, attribute: axisAttributes.mainNext, priority: UILayoutPriorityRequired)
            } else {
                if justifyContent == .FlexEnd {
                    setAlignConstraint(item: item, attribute: axisAttributes.mainPrevious, constant: previousMargin, relatedBy: .GreaterThanOrEqual, toItem: self, attribute: axisAttributes.mainPrevious, priority: 999)
                    if grows > 0 {
                        setAlignConstraint(item: item, attribute: axisAttributes.mainPrevious, constant: previousMargin, relatedBy: .Equal, toItem: self, attribute: axisAttributes.mainPrevious, priority: 999)
                    } else {
                        setAlignConstraint(item: item, attribute: axisAttributes.mainPrevious, constant: previousMargin, relatedBy: .Equal, toItem: self, attribute: axisAttributes.mainPrevious, priority: UILayoutPriorityDefaultLow)
                    }
                } else {
                    setAlignConstraint(item: item, attribute: axisAttributes.mainPrevious, constant: previousMargin, relatedBy: .Equal, toItem: self, attribute: axisAttributes.mainPrevious, priority: UILayoutPriorityRequired)
                }

            }
            subviews.append(item)

            lastNextMargin = margin.mainNext == MarginAuto ? 0 : margin.mainNext

            let insertRightAutoSpace = autoMarginCount == 0 && grows == 0 && (
                (justifyContent == .Center && index == items.count - 1) ||
                    (justifyContent == .SpaceBetween && index < items.count - 1) ||
                    justifyContent == .SpaceAround ||
                    (justifyContent == .SpaceSeperate && index == items.count - 1))

            if (margin.mainNext == MarginAuto && grows == 0) || insertRightAutoSpace {
                let nextAutoSpace = CCLayoutGuide.init()
                nextAutoSpace.backgroundColor = UIColor.blackColor()
                nextAutoSpace.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(nextAutoSpace)
                setAlignConstraint(item: nextAutoSpace, attribute: axisAttributes.crossPrevious)
                setConstantConstraint(nextAutoSpace, attribute: axisAttributes.crossSize, constant: layoutGuideSize)
                setAlignConstraint(item: nextAutoSpace, attribute: axisAttributes.mainPrevious, constant: 0, relatedBy: .Equal, toItem: item, attribute: axisAttributes.mainNext, priority: UILayoutPriorityRequired)

                if index == items.count - 1 {
                    setAlignConstraint(item: nextAutoSpace, attribute: axisAttributes.mainNext, constant: 0, relatedBy: .Equal, toItem: self, attribute: axisAttributes.mainNext, priority: UILayoutPriorityRequired)
                }
                subviews.append(nextAutoSpace)
                autoSpaces.append(nextAutoSpace)
            } else {
                if index == items.count - 1 {
                    if justifyContent == .FlexEnd {
                        setAlignConstraint(item: self, attribute: axisAttributes.mainNext, constant: lastNextMargin, relatedBy: .Equal, toItem: item, attribute: axisAttributes.mainNext, priority: UILayoutPriorityRequired)
                    } else {
                        setAlignConstraint(item: self, attribute: axisAttributes.mainNext, constant: lastNextMargin, relatedBy: .GreaterThanOrEqual, toItem: item, attribute: axisAttributes.mainNext, priority: 999)
                        if grows > 0 {
                            setAlignConstraint(item: self, attribute: axisAttributes.mainNext, constant: lastNextMargin, relatedBy: .Equal, toItem: item, attribute: axisAttributes.mainNext, priority: 999)
                        } else {
                            setAlignConstraint(item: self, attribute: axisAttributes.mainNext, constant: lastNextMargin, relatedBy: .Equal, toItem: item, attribute: axisAttributes.mainNext, priority: UILayoutPriorityDefaultLow)
                        }
                    }

                }
            }

            var align = getAlignSelfForItem(item)
            if align == .Auto {
                align = alignItems
            }
            if margin.crossPrevious == MarginAuto {
                margin.crossPrevious = 0
            }
            if margin.crossNext == MarginAuto {
                margin.crossNext = 0
            }
            switch align {
            case .FlexStart:
                setAlignConstraint(item: item, attribute: axisAttributes.crossPrevious, constant: margin.crossPrevious)
                break;
            case .FlexEnd:
                setAlignConstraint(item: item, attribute: axisAttributes.crossNext, constant: -margin.crossNext)
                break;
            case .Center:
                setAlignConstraint(item: item, attribute: axisAttributes.crossCenter)
                break;
            case .Baseline:
                if !vertical {
                    addSubview(baseline)
                    baseline.translatesAutoresizingMaskIntoConstraints = false
                    setAlignConstraint(item: baseline, attribute: axisAttributes.mainPrevious)
                    setAlignConstraint(item: baseline, attribute: axisAttributes.crossPrevious)
                    setAlignConstraint(item: baseline, attribute: axisAttributes.mainSize, constant: layoutGuideSize)
                    setAlignConstraint(item: baseline, attribute: axisAttributes.crossSize)

                    setAlignConstraint(item: item, attribute: .Baseline, constant: 0, relatedBy: .Equal, toItem: baseline, attribute: .Baseline)
                }
                break;
            case .Stretch, .Auto:
                setAlignConstraint(item: item, attribute: axisAttributes.crossPrevious, constant: margin.crossPrevious)
                setAlignConstraint(item: item, attribute: axisAttributes.crossNext, constant: -margin.crossNext)
                break;
            }
            if align != .Stretch && align != .Auto && basis.crossBasis != UIViewNoIntrinsicMetric {
                setConstantConstraint(item, attribute: axisAttributes.crossSize, constant: basis.crossBasis, .GreaterThanOrEqual, 750)
                setConstantConstraint(item, attribute: axisAttributes.crossSize, constant: basis.crossBasis, .LessThanOrEqual, 750)
                setConstantConstraint(item, attribute: axisAttributes.crossSize, constant: basis.crossBasis, .Equal, 750)
            }
            setAlignConstraint(item: item, attribute: axisAttributes.crossSize, constant: 0, relatedBy: .LessThanOrEqual, toItem: self, attribute: axisAttributes.crossSize, priority: 999);
        }

        if autoSpaces.count > 0 {
            //auto spaces consume all extra space
            let firstSpace = autoSpaces.first!
            setConstantConstraint(firstSpace, attribute: axisAttributes.mainSize, constant: 0, .GreaterThanOrEqual)

            for space in autoSpaces[1..<autoSpaces.count] {
                setAlignConstraint(item: space, attribute: axisAttributes.mainSize, constant: 0, relatedBy: .Equal, toItem: firstSpace, attribute: axisAttributes.mainSize)
            }
        }

    }

    private func getAxisBasisForItem(item:UIView) -> AxisBasis {
        let basisValue = objc_getAssociatedObject(item, &FlexboxAssociatedKeys.flexBasis)
        let size = basisValue == nil ? CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric) : basisValue.CGSizeValue()
        if vertical {
            return AxisBasis.init(mainBasis: size.height, crossBasis: size.width)
        } else {
            return AxisBasis.init(mainBasis: size.width, crossBasis: size.height)
        }
    }

    private func getAxisMarginsForItem(item:UIView) -> AxisMargins {
        let marginValue = objc_getAssociatedObject(item, &FlexboxAssociatedKeys.ccMargin)
        let edges = marginValue == nil ? UIEdgeInsetsZero : marginValue.UIEdgeInsetsValue()
        if vertical {
            return AxisMargins.init(mainPrevious: edges.top, mainNext: edges.bottom, crossPrevious: edges.left, crossNext: edges.right)
        } else {
            return AxisMargins.init(mainPrevious: edges.left, mainNext: edges.right, crossPrevious: edges.top, crossNext: edges.bottom)
        }
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

    private func clearFlexConstraints(item:UIView) {
        let flexConstraints = item.constraints.filter { (constraint) -> Bool in
            return constraint.identifier == constraintIdentifier
        }
        if #available(iOS 8.0, *) {
            NSLayoutConstraint.deactivateConstraints(flexConstraints)
        } else {
            item.removeConstraints(flexConstraints)
        }
    }

    private func setConstantConstraint(item:UIView, attribute: NSLayoutAttribute, constant:CGFloat, _ relation:NSLayoutRelation = .Equal, _ priority:UILayoutPriority = UILayoutPriorityRequired) {
        let constraint = NSLayoutConstraint(item: item, attribute: attribute, relatedBy: relation, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: constant)
        constraint.priority = priority
        constraint.identifier = constraintIdentifier
        if #available(iOS 8.0, *) {
            constraint.active = true
        } else {
            item.addConstraint(constraint)
        }
    }

    private func setAlignConstraint(item view1: AnyObject, attribute attr1: NSLayoutAttribute, constant c: CGFloat = 0, relatedBy relation: NSLayoutRelation = .Equal, toItem view2: AnyObject, attribute attr2: NSLayoutAttribute, priority:UILayoutPriority = UILayoutPriorityRequired){
        let constraint = NSLayoutConstraint(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: 1, constant:c)
        constraint.identifier = constraintIdentifier
        constraint.priority = priority
        if #available(iOS 8.0, *) {
            constraint.active = true
        } else {
            view1.addConstraint(constraint)
        }
    }

    private func setAlignConstraint(item view1: AnyObject, attribute attr1: NSLayoutAttribute, constant c: CGFloat = 0, relatedBy relation: NSLayoutRelation = .Equal){
        setAlignConstraint(item: view1, attribute: attr1, constant: c, relatedBy: relation, toItem: self, attribute: attr1)
    }
}

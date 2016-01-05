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
}

extension UIView {

    func flexBasis(size:CGSize) -> UIView {
        objc_setAssociatedObject(self, &FlexboxAssociatedKeys.flexBasis, NSValue.init(CGSize: size), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
}

enum JustifyContent {
    case FlexStart, FlexEnd, Center, SpaceBetween, SpaceAround, SpaceSeperate
}

enum AlignItems: Int {
    case Auto, FlexStart, FlexEnd, Center, Baseline, Stretch
}

private let basisPriority:Float = 751

class CCFlexbox: UIView {

    private var items: [UIView]
    private var blanks: [UIView]
    var vertical: Bool
    private var justifyContent: JustifyContent
    private var alignItems: AlignItems
    private var oldSize:CGSize

    private init(items: [UIView]) {
        self.items = items
        self.blanks = []
        self.vertical = false
        self.justifyContent = .FlexStart
        self.alignItems = .Stretch
        self.oldSize = CGSizeZero
        super.init(frame: CGRectZero)
        for item in items {
            self.addSubview(item)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        self.items = []
        self.blanks = []
        self.vertical = false
        self.justifyContent = .FlexStart
        self.alignItems = .Stretch
        self.oldSize = CGSizeZero
        super.init(coder: aDecoder)
    }

    class func row(items: UIView...) -> CCFlexbox {
        let box = CCFlexbox.init(items: items)
        box.setNeedsUpdateConstraints()
        return box
    }

    class func column(items: UIView...) -> CCFlexbox {
        let box = CCFlexbox.init(items: items)
        box.vertical = true
        box.setNeedsUpdateConstraints()
        return box
    }

    func justifyContent(value:JustifyContent) -> CCFlexbox {
        self.justifyContent = value
        self.setNeedsUpdateConstraints()
        return self
    }

    func alignItems(value:AlignItems) -> CCFlexbox {
        self.alignItems = value
        self.setNeedsUpdateConstraints()
        return self
    }

    override func updateConstraints() {
        if CGSizeEqualToSize(self.bounds.size, CGSizeZero) {
            super.updateConstraints()
            return
        }
        if vertical {
            for view in self.blanks {
                view.removeFromSuperview()
            }
            self.blanks.removeAll()

            let boundHeight = self.bounds.size.height
            var contentHeight:CGFloat = 0
            var grows = 0
            var shrinks = 0
            var hasNoShrink = false
            var shrinkTotal:CGFloat = 0
            var shrinkableHeight:CGFloat = 0
            for item in items {
                let grow = getFlexGrowForItem(item)
                grows += grow
                let shrink = getFlexShrinkForItem(item)
                if shrink == 0 {
                    hasNoShrink = true
                }
                shrinks += shrink
                let basis = getFlexBasisForItem(item)
                if basis.height > 0 {
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
            }
            let sizePerGrow = grows > 0 ? (boundHeight - contentHeight) / CGFloat( grows) : 0
            let shrinkPercent = (contentHeight - boundHeight) / shrinkTotal

            switch justifyContent {
            case .FlexStart:
                for var index = 0; index < items.count; index++ {
                    let item = items[index]
                    let previousItem = index == 0 ? self : items[index-1]
                    item.snp_remakeConstraints(closure: { (make) -> Void in
                        make.top.equalTo(index == 0 ? previousItem.snp_top : previousItem.snp_bottom)
                    })
                    self.setHeightConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                }
                break
            case .FlexEnd:
                for var index = items.count - 1; index >= 0; index-- {
                    let item = items[index]
                    let previousItem = index == (items.count - 1) ? self : items[index+1]
                    item.snp_remakeConstraints(closure: { (make) -> Void in
                        make.bottom.equalTo(index == (items.count - 1) ? previousItem.snp_bottom : previousItem.snp_top)
                    })
                    self.setHeightConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                }
                break
            case .Center:
                let topSpace = UIView.init()
                self.addSubview(topSpace)
                topSpace.snp_makeConstraints(closure: { (make) -> Void in
                    if hasNoShrink && (contentHeight - shrinkableHeight) > boundHeight {
                        make.top.equalTo(self).offset((boundHeight - contentHeight + shrinkableHeight) / 2.0)
                    } else {
                        make.top.equalTo(self)
                    }
                    make.left.width.equalTo(0)
                })
                for var index = 0; index < items.count; index++ {
                    let item = items[index]
                    let previousItem = index == 0 ? topSpace : items[index-1]
                    item.snp_remakeConstraints(closure: { (make) -> Void in
                        make.top.equalTo(previousItem.snp_bottom)
                    })
                    self.setHeightConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                }
                let bottomSpace = UIView.init()
                self.addSubview(bottomSpace)
                bottomSpace.snp_makeConstraints(closure: { (make) -> Void in
                    make.top.equalTo(items[items.count-1].snp_bottom)
                    if hasNoShrink && (contentHeight - shrinkableHeight) > boundHeight {
                        make.bottom.equalTo(self).offset(-(boundHeight - contentHeight + shrinkableHeight) / 2.0)
                    } else {
                        make.bottom.equalTo(self)
                    }
                    make.left.width.equalTo(0)
                    make.height.equalTo(topSpace)
                    if contentHeight >= boundHeight {
                        make.height.equalTo(0)
                    }
                })
                self.blanks = [topSpace, bottomSpace]
                break
            case .SpaceBetween:
                var previousItem:UIView = self
                for var index = 0; index < items.count; index++ {
                    let item = items[index]
                    if index == 0 {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.top.equalTo(self.snp_top)
                        })
                        self.setHeightConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                        if grows == 0 {
                            let space = self.appendColumnBlankToItem(item)
                            blanks.append(space)
                            previousItem = space
                        } else {
                            previousItem = item
                        }
                    } else if index == items.count - 1 {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.top.equalTo(previousItem.snp_bottom)
                            if hasNoShrink {
                                make.bottom.greaterThanOrEqualTo(self)
                            } else {
                                make.bottom.equalTo(self)
                            }
                        })
                        self.setHeightConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                        for var i = 0; i < blanks.count - 1; i++ {
                            let firstBlank = blanks[i]
                            let secondBlank = blanks[i+1]
                            firstBlank.snp_makeConstraints(closure: { (make) -> Void in
                                make.height.equalTo(secondBlank)
                            })
                        }
                    } else {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.top.equalTo(previousItem.snp_bottom)
                        })
                        self.setHeightConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                        if grows == 0 {
                            let space = self.appendColumnBlankToItem(item)
                            blanks.append(space)
                            previousItem = space
                        } else {
                            previousItem = item
                        }
                    }
                }
                break
            case .SpaceAround:
                let firstSpace = UIView.init()
                self.addSubview(firstSpace)
                firstSpace.snp_makeConstraints(closure: { (make) -> Void in
                    if hasNoShrink && (contentHeight - shrinkableHeight) > boundHeight {
                        make.top.equalTo(self).offset((boundHeight - contentHeight + shrinkableHeight) / 2.0)
                    } else {
                        make.top.equalTo(self)
                    }
                    make.left.width.equalTo(0)
                })
                blanks.append(firstSpace)
                var previousItem = firstSpace
                for var index = 0; index < items.count; index++ {
                    let item = items[index]
                    if index < items.count - 1 {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.top.equalTo(previousItem.snp_bottom)
                        })
                        self.setHeightConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                        let space = self.appendColumnBlankToItem(item)
                        blanks.append(space)
                        previousItem = space
                    } else  {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.top.equalTo(previousItem.snp_bottom)
                        })
                        self.setHeightConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                        let space = self.appendColumnBlankToItem(item)
                        blanks.append(space)
                        for var i = 0; i < blanks.count - 1; i++ {
                            let firstBlank = blanks[i]
                            let secondBlank = blanks[i+1]
                            firstBlank.snp_makeConstraints(closure: { (make) -> Void in
                                if i == 0 {
                                    make.height.equalTo(secondBlank).dividedBy(2)
                                } else if i == blanks.count - 2 {
                                    make.height.equalTo(secondBlank).multipliedBy(2)
                                } else {
                                    make.height.equalTo(secondBlank)
                                }
                            })
                        }
                        space.snp_makeConstraints(closure: { (make) -> Void in
                            if hasNoShrink && (contentHeight - shrinkableHeight) > boundHeight {
                                make.bottom.equalTo(self).offset(-(boundHeight - contentHeight + shrinkableHeight) / 2.0)
                            } else {
                                make.bottom.equalTo(self)
                            }
                            if contentHeight >= boundHeight {
                                make.height.equalTo(0)
                            }
                        })
                    }
                }
                break
            case .SpaceSeperate:
                let firstSpace = UIView.init()
                self.addSubview(firstSpace)
                firstSpace.snp_makeConstraints(closure: { (make) -> Void in
                    if hasNoShrink && (contentHeight - shrinkableHeight) > boundHeight {
                        make.top.equalTo(self).offset((boundHeight - contentHeight + shrinkableHeight) / 2.0)
                    } else {
                        make.top.equalTo(self)
                    }
                    make.left.width.equalTo(0)
                })
                blanks.append(firstSpace)
                var previousItem = firstSpace
                for var index = 0; index < items.count; index++ {
                    let item = items[index]
                    if index < items.count - 1 {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.top.equalTo(previousItem.snp_bottom)
                        })
                        self.setHeightConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                        let space = self.appendColumnBlankToItem(item)
                        blanks.append(space)
                        previousItem = space
                    } else  {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.top.equalTo(previousItem.snp_bottom)
                        })
                        self.setHeightConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                        let space = self.appendColumnBlankToItem(item)
                        blanks.append(space)
                        for var i = 0; i < blanks.count - 1; i++ {
                            let firstBlank = blanks[i]
                            let secondBlank = blanks[i+1]
                            firstBlank.snp_makeConstraints(closure: { (make) -> Void in
                                make.height.equalTo(secondBlank)
                            })
                        }
                        space.snp_makeConstraints(closure: { (make) -> Void in
                            if hasNoShrink && (contentHeight - shrinkableHeight) > boundHeight {
                                make.bottom.equalTo(self).offset(-(boundHeight - contentHeight + shrinkableHeight) / 2.0)
                            } else {
                                make.bottom.equalTo(self)
                            }
                            if contentHeight >= boundHeight {
                                make.height.equalTo(0)
                            }
                        })
                    }
                }
                break
            }

            for item:UIView in items {
                self.setHorizontalAlignConstraintForItem(item, defaultAlign: alignItems)
            }
        } else {
            for view in self.blanks {
                view.removeFromSuperview()
            }
            self.blanks.removeAll()

            let boundWidth = self.bounds.size.width
            var contentWidth:CGFloat = 0
            var grows = 0
            var shrinks = 0
            var hasNoShrink = false
            var shrinkTotal:CGFloat = 0
            var shrinkableWidth:CGFloat = 0
            for item in items {
                let grow = getFlexGrowForItem(item)
                grows += grow
                let shrink = getFlexShrinkForItem(item)
                if shrink == 0 {
                    hasNoShrink = true
                }
                shrinks += shrink
                let basis = getFlexBasisForItem(item)
                if basis.width > 0 {
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
            }
            let sizePerGrow = grows > 0 ? (boundWidth - contentWidth) / CGFloat( grows) : 0
            let shrinkPercent = (contentWidth - boundWidth) / shrinkTotal

            switch justifyContent {
            case .FlexStart:
                for var index = 0; index < items.count; index++ {
                    let item = items[index]
                    let previousItem = index == 0 ? self : items[index-1]
                    item.snp_remakeConstraints(closure: { (make) -> Void in
                        make.left.equalTo(index == 0 ? previousItem.snp_left : previousItem.snp_right)
                    })
                    self.setWidthConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                }
                break
            case .FlexEnd:
                for var index = items.count - 1; index >= 0; index-- {
                    let item = items[index]
                    let previousItem = index == (items.count - 1) ? self : items[index+1]
                    item.snp_remakeConstraints(closure: { (make) -> Void in
                        make.right.equalTo(index == (items.count - 1) ? previousItem.snp_right : previousItem.snp_left)
                    })
                    self.setWidthConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                }
                break
            case .Center:
                let leftSpace = UIView.init()
                self.addSubview(leftSpace)
                leftSpace.snp_makeConstraints(closure: { (make) -> Void in
                    if hasNoShrink && (contentWidth - shrinkableWidth) > boundWidth {
                        make.left.equalTo(self).offset((boundWidth - contentWidth + shrinkableWidth) / 2.0)
                    } else {
                        make.left.equalTo(self)
                    }
                    make.top.height.equalTo(0)
                })
                for var index = 0; index < items.count; index++ {
                    let item = items[index]
                    let previousItem = index == 0 ? leftSpace : items[index-1]
                    item.snp_remakeConstraints(closure: { (make) -> Void in
                        make.left.equalTo(previousItem.snp_right)
                    })
                    self.setWidthConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                }
                let rightSpace = UIView.init()
                self.addSubview(rightSpace)
                rightSpace.snp_makeConstraints(closure: { (make) -> Void in
                    make.left.equalTo(items[items.count-1].snp_right)
                    if hasNoShrink && (contentWidth - shrinkableWidth) > boundWidth {
                        make.right.equalTo(self).offset(-(boundWidth - contentWidth + shrinkableWidth) / 2.0)
                    } else {
                        make.right.equalTo(self)
                    }
                    make.top.height.equalTo(0)
                    make.width.equalTo(leftSpace)
                    if contentWidth >= boundWidth {
                        make.width.equalTo(0)
                    }
                })
                self.blanks = [leftSpace, rightSpace]
                break
            case .SpaceBetween:
                var previousItem:UIView = self
                for var index = 0; index < items.count; index++ {
                    let item = items[index]
                    if index == 0 {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.left.equalTo(self.snp_left)
                        })
                        self.setWidthConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                        if grows == 0 {
                            let space = self.appendRowBlankToItem(item)
                            blanks.append(space)
                            previousItem = space
                        } else {
                            previousItem = item
                        }
                    } else if index == items.count - 1 {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.left.equalTo(previousItem.snp_right)
                            if hasNoShrink {
                                make.right.greaterThanOrEqualTo(self)
                            } else {
                                make.right.equalTo(self)
                            }
                        })
                        self.setWidthConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                        for var i = 0; i < blanks.count - 1; i++ {
                            let firstBlank = blanks[i]
                            let secondBlank = blanks[i+1]
                            firstBlank.snp_makeConstraints(closure: { (make) -> Void in
                                make.width.equalTo(secondBlank)
                            })
                        }
                    } else {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.left.equalTo(previousItem.snp_right)
                        })
                        self.setWidthConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                        if grows == 0 {
                            let space = self.appendRowBlankToItem(item)
                            blanks.append(space)
                            previousItem = space
                        } else {
                            previousItem = item
                        }
                    }
                }
                break
            case .SpaceAround:
                let firstSpace = UIView.init()
                self.addSubview(firstSpace)
                firstSpace.snp_makeConstraints(closure: { (make) -> Void in
                    if hasNoShrink && (contentWidth - shrinkableWidth) > boundWidth {
                        make.left.equalTo(self).offset((boundWidth - contentWidth + shrinkableWidth) / 2.0)
                    } else {
                        make.left.equalTo(self)
                    }
                    make.top.height.equalTo(0)
                })
                blanks.append(firstSpace)
                var previousItem = firstSpace
                for var index = 0; index < items.count; index++ {
                    let item = items[index]
                    if index < items.count - 1 {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.left.equalTo(previousItem.snp_right)
                        })
                        self.setWidthConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                        let space = self.appendRowBlankToItem(item)
                        blanks.append(space)
                        previousItem = space
                    } else  {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.left.equalTo(previousItem.snp_right)
                        })
                        self.setWidthConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                        let space = self.appendRowBlankToItem(item)
                        blanks.append(space)
                        for var i = 0; i < blanks.count - 1; i++ {
                            let firstBlank = blanks[i]
                            let secondBlank = blanks[i+1]
                            firstBlank.snp_makeConstraints(closure: { (make) -> Void in
                                if i == 0 {
                                    make.width.equalTo(secondBlank).dividedBy(2)
                                } else if i == blanks.count - 2 {
                                    make.width.equalTo(secondBlank).multipliedBy(2)
                                } else {
                                    make.width.equalTo(secondBlank)
                                }
                            })
                        }
                        space.snp_makeConstraints(closure: { (make) -> Void in
                            if hasNoShrink && (contentWidth - shrinkableWidth) > boundWidth {
                                make.right.equalTo(self).offset(-(boundWidth - contentWidth + shrinkableWidth) / 2.0)
                            } else {
                                make.right.equalTo(self)
                            }
                            if contentWidth >= boundWidth {
                                make.width.equalTo(0)
                            }
                        })
                    }
                }
                break
            case .SpaceSeperate:
                let firstSpace = UIView.init()
                self.addSubview(firstSpace)
                firstSpace.snp_makeConstraints(closure: { (make) -> Void in
                    if hasNoShrink && (contentWidth - shrinkableWidth) > boundWidth {
                        make.left.equalTo(self).offset((boundWidth - contentWidth + shrinkableWidth) / 2.0)
                    } else {
                        make.left.equalTo(self)
                    }
                    make.top.height.equalTo(0)
                })
                blanks.append(firstSpace)
                var previousItem = firstSpace
                for var index = 0; index < items.count; index++ {
                    let item = items[index]
                    if index < items.count - 1 {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.left.equalTo(previousItem.snp_right)
                        })
                        self.setWidthConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                        let space = self.appendRowBlankToItem(item)
                        blanks.append(space)
                        previousItem = space
                    } else  {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.left.equalTo(previousItem.snp_right)
                        })
                        self.setWidthConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                        let space = self.appendRowBlankToItem(item)
                        blanks.append(space)
                        for var i = 0; i < blanks.count - 1; i++ {
                            let firstBlank = blanks[i]
                            let secondBlank = blanks[i+1]
                            firstBlank.snp_makeConstraints(closure: { (make) -> Void in
                                make.width.equalTo(secondBlank)
                            })
                        }
                        space.snp_makeConstraints(closure: { (make) -> Void in
                            if hasNoShrink && (contentWidth - shrinkableWidth) > boundWidth {
                                make.right.equalTo(self).offset(-(boundWidth - contentWidth + shrinkableWidth) / 2.0)
                            } else {
                                make.right.equalTo(self)
                            }
                            if contentWidth >= boundWidth {
                                make.width.equalTo(0)
                            }
                        })
                    }
                }
                break
            }

            for item:UIView in items {
                self.setVerticalAlignConstraintForItem(item, defaultAlign: alignItems)
            }
        }

        super.updateConstraints()
    }

    override func layoutSubviews() {
        if !CGSizeEqualToSize(self.bounds.size, self.oldSize) {
            self.setNeedsUpdateConstraints()
            self.oldSize = self.bounds.size
        }
        super.layoutSubviews()
    }

    private func getFlexBasisForItem(item:UIView) -> CGSize {
        let basisValue = objc_getAssociatedObject(item, &FlexboxAssociatedKeys.flexBasis)
        return basisValue == nil ? CGSizeMake(-1, -1) : basisValue.CGSizeValue()
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

    private func setWidthConstraintForItem(item:UIView, sizePerGrow:CGFloat, shrinkPercent:CGFloat) -> Void {
        let basis = getFlexBasisForItem(item)
        let grow = getFlexGrowForItem(item)
        let shrink = getFlexShrinkForItem(item)
        item.snp_makeConstraints(closure: { (make) -> Void in
            if basis.width > 0 {
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
                            make.width.equalTo(max(size.width * (1 - shrinkPercent * CGFloat(shrink)), 0)).priority(basisPriority)
                        } else {
                            make.width.equalTo(size.width).priority(basisPriority)
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

        item.snp_makeConstraints(closure: { (make) -> Void in
            switch align {
            case .FlexStart:
                make.top.equalTo(self)
                break;
            case .FlexEnd:
                make.bottom.equalTo(self)
                break;
            case .Center:
                make.centerY.equalTo(self)
                break;
            case .Baseline:
                make.baseline.equalTo(self)
                break;
            case .Stretch, .Auto:
                make.top.bottom.equalTo(self)
                break;
            }
            if align != .Stretch && align != .Auto {
                let basis = getFlexBasisForItem(item)
                if basis.height > 0 {
                    make.height.equalTo(basis.height).priority(basisPriority)
                } else {
                    let size = item.intrinsicContentSize()
                    if size.height != UIViewNoIntrinsicMetric {
                        make.height.equalTo(size.height).priority(basisPriority)
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
        item.snp_makeConstraints(closure: { (make) -> Void in
            if basis.height > 0 {
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
                            make.height.equalTo(max(size.height * (1 - shrinkPercent * CGFloat(shrink)), 0)).priority(basisPriority)
                        } else {
                            make.height.equalTo(size.height).priority(basisPriority)
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

        item.snp_makeConstraints(closure: { (make) -> Void in
            switch align {
            case .FlexStart:
                make.left.equalTo(self)
                break;
            case .FlexEnd:
                make.right.equalTo(self)
                break;
            case .Center:
                make.centerX.equalTo(self)
                break;
            case .Baseline, .Stretch, .Auto:
                make.left.right.equalTo(self)
                break;
            }
            if align != .Stretch && align != .Auto {
                let basis = getFlexBasisForItem(item)
                if basis.width > 0 {
                    make.width.equalTo(basis.width).priority(basisPriority)
                } else {
                    let size = item.intrinsicContentSize()
                    if size.width != UIViewNoIntrinsicMetric {
                        make.width.equalTo(size.width).priority(basisPriority)
                    } else {
                        item.setContentHuggingPriority(251, forAxis: .Horizontal)
                        item.setContentCompressionResistancePriority(basisPriority, forAxis: .Horizontal) //no shrinking
                    }
                }
            }
        })
    }

    private func appendRowBlankToItem(item:UIView) -> UIView {
        let space = UIView.init()
        self.addSubview(space)
        space.snp_makeConstraints(closure: { (make) -> Void in
            make.left.equalTo(item.snp_right)
            make.top.height.equalTo(0)
        })
        return space
    }

    private func appendColumnBlankToItem(item:UIView) -> UIView {
        let space = UIView.init()
        self.addSubview(space)
        space.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(item.snp_bottom)
            make.left.width.equalTo(0)
        })
        return space
    }

    override func intrinsicContentSize() -> CGSize {
        var width:CGFloat = 0
        var height:CGFloat = 0
        for item in items {
            let basis = getFlexBasisForItem(item)
            let size = item.intrinsicContentSize()
            if width != UIViewNoIntrinsicMetric {
                if basis.width > 0 {
                    if vertical {
                        width = max(width, basis.width)
                    } else {
                        width += basis.width
                    }
                } else {
                    if size.width != UIViewNoIntrinsicMetric {
                        if vertical {
                            width = max(width, size.width)
                        } else {
                            width += size.width
                        }
                    } else {
                        width = UIViewNoIntrinsicMetric
                    }
                }
            }
            if height != UIViewNoIntrinsicMetric {
                if basis.height > 0 {
                    if vertical {
                        height += basis.height
                    } else {
                        height = max(height, basis.height)
                    }
                } else {
                    if size.height != UIViewNoIntrinsicMetric {
                        if vertical {
                            height += size.height
                        } else {
                            height = max(height, size.height)
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

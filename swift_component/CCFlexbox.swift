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

    func alignSelf(align:Int) -> UIView {
        objc_setAssociatedObject(self, &FlexboxAssociatedKeys.alignSelf, NSNumber.init(long: align), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return self
    }
}

enum JustifyContent {
    case FlexStart, FlexEnd, Center, SpaceBetween, SpaceAround, SpaceSeperate
}

enum AlignItems {
    case FlexStart, FlexEnd, Center, Baseline, Stretch
}

private let basisPriority:Float = 751

class CCFlexbox: UIView {

    private var items: [UIView]
    private var blanks: [UIView]
    var vertical: Bool
    private var justifyContent: JustifyContent
    private var alignItems: AlignItems

    private init(items: [UIView]) {
        self.items = items
        self.blanks = []
        self.vertical = false
        self.justifyContent = .FlexStart
        self.alignItems = .FlexStart
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
        self.alignItems = .FlexStart
        super.init(coder: aDecoder)
    }

    class func row(items: UIView...) -> CCFlexbox {
        let box = CCFlexbox.init(items: items)
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
        if vertical {

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
            for item in items {
                let grow = getFlexGrowForItem(item)
                grows += grow
                let shrink = getFlexShrinkForItem(item)
                if shrink == 0 {
                    hasNoShrink = true
                }
                shrinks += shrink
                let basis = getFlexBasisForItem(item)
                if basis.width >= 0 {
                    contentWidth += basis.width
                    if shrink > 0 {
                        shrinkTotal += basis.width*CGFloat(shrink)
                    }
                } else {
                    let size = item.intrinsicContentSize()
                    if size.width != UIViewNoIntrinsicMetric {
                        contentWidth += size.width

                        if shrink > 0 {
                            shrinkTotal += size.width*CGFloat(shrink)
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
                    let basis = getFlexBasisForItem(item)
                    item.snp_remakeConstraints(closure: { (make) -> Void in
                        make.left.equalTo(index == 0 ? previousItem.snp_left : previousItem.snp_right)

                        if basis.width >= 0 {
                            make.width.equalTo(basis.width).priority(basisPriority)
                        }
                    })
                }
                break
            case .FlexEnd:
                for var index = items.count - 1; index >= 0; index-- {
                    let item = items[index]
                    let previousItem = index == (items.count - 1) ? self : items[index+1]
                    let basis = getFlexBasisForItem(item)
                    item.snp_remakeConstraints(closure: { (make) -> Void in
                        make.right.equalTo(index == (items.count - 1) ? previousItem.snp_right : previousItem.snp_left)
                        if basis.width >= 0 {
                            make.width.equalTo(basis.width).priority(basisPriority)
                        }
                    })
                }
                break
            case .Center:
                let leftSpace = UIView.init()
                self.addSubview(leftSpace)
                leftSpace.snp_makeConstraints(closure: { (make) -> Void in
                    make.left.equalTo(self)
                    make.top.height.equalTo(0)
                })
                for var index = 0; index < items.count; index++ {
                    let item = items[index]
                    let previousItem = index == 0 ? leftSpace : items[index-1]
                    let basis = getFlexBasisForItem(item)
                    item.snp_remakeConstraints(closure: { (make) -> Void in
                        make.left.equalTo(previousItem.snp_right)
                        if basis.width >= 0 {
                            make.width.equalTo(basis.width).priority(basisPriority)
                        }
                    })
                }
                let rightSpace = UIView.init()
                self.addSubview(rightSpace)
                rightSpace.snp_makeConstraints(closure: { (make) -> Void in
                    make.left.equalTo(items[items.count-1].snp_right)
                    make.right.equalTo(self)
                    make.top.height.equalTo(0)
                    make.width.equalTo(leftSpace)
                })
                self.blanks = [leftSpace, rightSpace]
                break
            case .SpaceBetween:
                var previousItem:UIView = self
                for var index = 0; index < items.count; index++ {
                    let item = items[index]
                    if index == 0 {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.left.equalTo(previousItem.snp_left)
                        })
                        self.setWidthConstraintForItem(item, sizePerGrow: sizePerGrow, shrinkPercent: shrinkPercent)
                        let space = UIView.init()
                        self.addSubview(space)
                        space.snp_makeConstraints(closure: { (make) -> Void in
                            make.left.equalTo(item.snp_right)
                            make.top.height.equalTo(0)
                        })
                        blanks.append(space)
                        previousItem = space
                    } else if index == items.count - 1 {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.left.equalTo(previousItem.snp_right)
                            if hasNoShrink {
                                make.right.greaterThanOrEqualTo(self)
                            } else {
                                make.right.equalTo(self)
                            }
                            if basis.width >= 0 {
                                if sizePerGrow > 0 {
                                    make.width.equalTo(basis.width + CGFloat(grow) * sizePerGrow).priority(basisPriority)
                                } else {
                                    if shrink > 0 {
                                        make.width.equalTo(basis.width * (1 - shrinkPercent * CGFloat(shrink))).priority(basisPriority)
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
                                        if shrink > 0 {
                                            make.width.equalTo(size.width * (1 - shrinkPercent * CGFloat(shrink))).priority(basisPriority)
                                        } else {
                                            make.width.equalTo(size.width).priority(basisPriority)
                                        }
                                    }
                                } else {
                                    if sizePerGrow > 0 {
                                        item.setContentHuggingPriority(249, forAxis: .Horizontal)
                                        item.setContentCompressionResistancePriority(basisPriority, forAxis: .Horizontal)
                                    } else {
                                        item.setContentHuggingPriority(251, forAxis: .Horizontal)
                                        item.setContentCompressionResistancePriority(basisPriority - 2, forAxis: .Horizontal)
                                    }
                                }
                            }
                        })
                        for var i = 0; i < blanks.count - 1; i++ {
                            let firstBlank = blanks[i]
                            let secondBlank = blanks[i+1]
                            firstBlank.snp_makeConstraints(closure: { (make) -> Void in
                                make.width.equalTo(secondBlank)
                                if grows > 0 {
                                    make.width.equalTo(0)
                                }
                            })
                        }
                    } else {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.left.equalTo(previousItem.snp_right)
                            if basis.width >= 0 {
                                if sizePerGrow > 0 {
                                    make.width.equalTo(basis.width + CGFloat(grow) * sizePerGrow).priority(basisPriority)
                                } else {
                                    if shrink > 0 {
                                        make.width.equalTo(basis.width * (1 - shrinkPercent * CGFloat(shrink))).priority(basisPriority)
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
                                        if shrink > 0 {
                                            make.width.equalTo(size.width * (1 - shrinkPercent * CGFloat(shrink))).priority(basisPriority)
                                        } else {
                                            make.width.equalTo(size.width).priority(basisPriority)
                                        }
                                    }
                                } else {
                                    item.setContentHuggingPriority(249, forAxis: .Horizontal)
                                    item.setContentCompressionResistancePriority(basisPriority, forAxis: .Horizontal)
                                }
                            }
                        })
                        let space = UIView.init()
                        self.addSubview(space)
                        space.snp_makeConstraints(closure: { (make) -> Void in
                            make.left.equalTo(item.snp_right)
                            make.top.height.equalTo(0)
                        })
                        blanks.append(space)
                        previousItem = space
                    }
                }
                break
            case .SpaceAround:
                let firstSpace = UIView.init()
                self.addSubview(firstSpace)
                firstSpace.snp_makeConstraints(closure: { (make) -> Void in
                    make.left.equalTo(self.snp_left)
                    make.top.height.equalTo(0)
                })
                blanks.append(firstSpace)
                var previousItem = firstSpace
                for var index = 0; index < items.count; index++ {
                    let item = items[index]
                    let basis = getFlexBasisForItem(item)
                    if index < items.count - 1 {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.left.equalTo(previousItem.snp_right)
                            if basis.width >= 0 {
                                make.width.equalTo(basis.width).priority(basisPriority)
                            }
                        })
                        let space = UIView.init()
                        self.addSubview(space)
                        space.snp_makeConstraints(closure: { (make) -> Void in
                            make.left.equalTo(item.snp_right)
                            make.top.height.equalTo(0)
                        })
                        blanks.append(space)
                        previousItem = space
                    } else  {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.left.equalTo(previousItem.snp_right)
                            if basis.width >= 0 {
                                make.width.equalTo(basis.width).priority(basisPriority)
                            }
                        })
                        let space = UIView.init()
                        self.addSubview(space)
                        space.snp_makeConstraints(closure: { (make) -> Void in
                            make.left.equalTo(item.snp_right)
                            make.right.equalTo(self)
                            make.top.height.equalTo(0)
                        })
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
                    }
                }
                break
            case .SpaceSeperate:

                let firstSpace = UIView.init()
                self.addSubview(firstSpace)
                firstSpace.snp_makeConstraints(closure: { (make) -> Void in
                    make.left.equalTo(self.snp_left)
                    make.top.height.equalTo(0)
                })
                blanks.append(firstSpace)
                var previousItem = firstSpace
                for var index = 0; index < items.count; index++ {
                    let item = items[index]
                    let basis = getFlexBasisForItem(item)
                    if index < items.count - 1 {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.left.equalTo(previousItem.snp_right)
                            if basis.width >= 0 {
                                make.width.equalTo(basis.width).priority(basisPriority)
                            }
                        })
                        let space = UIView.init()
                        self.addSubview(space)
                        space.snp_makeConstraints(closure: { (make) -> Void in
                            make.left.equalTo(item.snp_right)
                            make.top.height.equalTo(0)
                        })
                        blanks.append(space)
                        previousItem = space
                    } else  {
                        item.snp_remakeConstraints(closure: { (make) -> Void in
                            make.left.equalTo(previousItem.snp_right)
                            if basis.width >= 0 {
                                make.width.equalTo(basis.width).priority(basisPriority)
                            }
                        })
                        let space = UIView.init()
                        self.addSubview(space)
                        space.snp_makeConstraints(closure: { (make) -> Void in
                            make.left.equalTo(item.snp_right)
                            make.right.equalTo(self)
                            make.top.height.equalTo(0)
                        })
                        blanks.append(space)
                        for var i = 0; i < blanks.count - 1; i++ {
                            let firstBlank = blanks[i]
                            let secondBlank = blanks[i+1]
                            firstBlank.snp_makeConstraints(closure: { (make) -> Void in
                                make.width.equalTo(secondBlank)
                            })
                        }
                    }
                }
                break
            }
        }

        switch alignItems {
        case .FlexStart:
            for item:UIView in items {
                let basis = getFlexBasisForItem(item)
                item.snp_makeConstraints(closure: { (make) -> Void in
                    make.top.equalTo(self)
                    if basis.height >= 0 {
                        make.height.equalTo(basis.height).priority(basisPriority)
                    }
                })
            }
            break
        case .FlexEnd:
            for item:UIView in items {
                let basis = getFlexBasisForItem(item)
                item.snp_makeConstraints(closure: { (make) -> Void in
                    make.bottom.equalTo(self)
                    if basis.height >= 0 {
                        make.height.equalTo(basis.height).priority(basisPriority)
                    }
                })
            }
            break
        case .Center:
            for item:UIView in items {
                let basis = getFlexBasisForItem(item)
                item.snp_makeConstraints(closure: { (make) -> Void in
                    make.centerY.equalTo(self)
                    if basis.height >= 0 {
                        make.height.equalTo(basis.height).priority(basisPriority)
                    }
                })
            }
            break
        case .Baseline:
            for item:UIView in items {
                let basis = getFlexBasisForItem(item)
                item.snp_makeConstraints(closure: { (make) -> Void in
                    make.baseline.equalTo(self)
                    if basis.height >= 0 {
                        make.height.equalTo(basis.height).priority(basisPriority)
                    }
                })
            }
            break
        case .Stretch:
            for item:UIView in items {
                item.snp_makeConstraints(closure: { (make) -> Void in
                    make.top.bottom.equalTo(self)
                })
            }
            break
        }

        super.updateConstraints()
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

    private func setWidthConstraintForItem(item:UIView, sizePerGrow:CGFloat, shrinkPercent:CGFloat) -> Void {
        let basis = getFlexBasisForItem(item)
        let grow = getFlexGrowForItem(item)
        let shrink = getFlexShrinkForItem(item)
        item.snp_makeConstraints(closure: { (make) -> Void in
            if basis.width >= 0 {
                if sizePerGrow > 0 {
                    make.width.equalTo(basis.width + CGFloat(grow) * sizePerGrow).priority(basisPriority)
                } else {
                    if shrink > 0 {
                        make.width.equalTo(basis.width * (1 - shrinkPercent * CGFloat(shrink))).priority(basisPriority)
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
                        if shrink > 0 {
                            make.width.equalTo(size.width * (1 - shrinkPercent * CGFloat(shrink))).priority(basisPriority)
                        } else {
                            make.width.equalTo(size.width).priority(basisPriority)
                        }
                    }
                } else {
                    item.setContentHuggingPriority(249, forAxis: .Horizontal)
                    item.setContentCompressionResistancePriority(basisPriority, forAxis: .Horizontal)
                }
            }
        })
    }

    override func intrinsicContentSize() -> CGSize {
        if vertical {
            return super.intrinsicContentSize()
        } else {
            var width:CGFloat = UIViewNoIntrinsicMetric - 1
            var height:CGFloat = UIViewNoIntrinsicMetric - 1
            for item in items {
                let basis = getFlexBasisForItem(item)
                let size = item.intrinsicContentSize()
                if width != UIViewNoIntrinsicMetric {
                    if basis.width > 0 {
                        width += basis.width
                    } else {
                        if size.width != UIViewNoIntrinsicMetric {
                            width += size.width
                        } else {
                            width = UIViewNoIntrinsicMetric
                        }
                    }
                }
                if height != UIViewNoIntrinsicMetric {
                    if basis.height > 0 {
                        height += basis.height
                    } else {
                        if size.height != UIViewNoIntrinsicMetric {
                            height += size.height
                        } else {
                            height = UIViewNoIntrinsicMetric
                        }
                    }
                }
            }
            return CGSizeMake(width, height)
        }
    }
}

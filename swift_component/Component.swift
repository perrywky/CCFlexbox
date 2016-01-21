//
//  Component.swift
//  swift_component
//
//  Created by Perry on 15/12/28.
//  Copyright © 2015年 Perry. All rights reserved.
//

import UIKit

class Component: NSObject {

    func render() -> UIView {

        let view1 = UIView.init()
        view1.backgroundColor = UIColor.redColor()

        let view2 = UIView.init()
        view2.backgroundColor = UIColor.lightGrayColor()

        let view3 = UIView.init()
        view3.backgroundColor = UIColor.grayColor()

        let label1 = UILabel.init()
//        label1.backgroundColor = UIColor.lightGrayColor()
        label1.text = "Hello World!!"

        let label2 = UILabel.init()
        label2.font = UIFont.systemFontOfSize(20)
//        label2.backgroundColor = UIColor.grayColor()
        label2.text = "你好"

        let label3 = UILabel.init()
        label3.font = UIFont.systemFontOfSize(15)
        label3.backgroundColor = UIColor.lightGrayColor()
        label3.text = "再见"

        let bundle = NSBundle.init(forClass: self.classForCoder)
        let img = UIImage.init(named: "wifi.jpg", inBundle: bundle, compatibleWithTraitCollection: nil)
        let imgV = UIImageView.init(image: img)

        let column = CCFlexbox.column(
            label1.ccLeft(20).ccRight(20),
            label2.ccLeft(20)
        )
        column.backgroundColor = UIColor.lightGrayColor()

        let box = CCFlexbox.row(
            imgV.flexBasis(40, 40).ccLeft(8).ccRight(8).flexShrink(0).alignSelf(.Center),
            column.justifyContent(.SpaceAround).alignSelf(.Stretch).flexShrink(0),
            label3.ccLeft(10).flexBasis(200, 20).ccRight(8).flexShrink(0).ccTop(20).ccBottom(20)
        ).justifyContent(.FlexStart)
        return box
    }
}
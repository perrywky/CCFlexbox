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
        view1.backgroundColor = UIColor.grayColor()

        let view2 = UIView.init()
        view2.backgroundColor = UIColor.whiteColor()

        let view3 = UIView.init()
        view3.backgroundColor = UIColor.grayColor()

        let label1 = UILabel.init()
        label1.backgroundColor = UIColor.whiteColor()
        label1.text = "Hello World!!"

        let label2 = UILabel.init()
        label2.font = UIFont.systemFontOfSize(20)
        label2.backgroundColor = UIColor.grayColor()
        label2.text = "你好"

        let label3 = UILabel.init()
        label3.font = UIFont.systemFontOfSize(15)
        label3.backgroundColor = UIColor.whiteColor()
        label3.text = "再见"

        return CCFlexbox.row(
            view1.flexBasis(CGSizeMake(100, 20)).flexShrink(0),
            view2.flexBasis(CGSizeMake(100, 20)),
            view3.flexBasis(CGSizeMake(100, 20)).flexShrink(0),
            label1.flexShrink(1)
        ).justifyContent(.SpaceBetween).alignItems(.Stretch)
    }
}
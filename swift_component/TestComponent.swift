//
//  TestComponent.swift
//  swift_component
//
//  Created by Perry on 15/12/28.
//  Copyright © 2015年 Perry. All rights reserved.
//

import UIKit

@IBDesignable
class TestComponent: UIView {

    private var label1:UILabel
    private var label2:UILabel
    private var label3:UILabel

    override init(frame: CGRect) {

        label1 = UILabel.init()
        label2 = UILabel.init()
        label3 = UILabel.init()
        label1.backgroundColor = UIColor.lightGrayColor()

        super.init(frame: frame)

        let view1 = UIView.init()
        view1.backgroundColor = UIColor.redColor()

        let view2 = UIView.init()
        view2.backgroundColor = UIColor.lightGrayColor()

        let view3 = UIView.init()
        view3.backgroundColor = UIColor.grayColor()

        label1.text = "Hello World!!"

        label2.font = UIFont.systemFontOfSize(20)
        //        label2.backgroundColor = UIColor.grayColor()
        label2.text = "你好"

        label3.font = UIFont.systemFontOfSize(15)
        label3.backgroundColor = UIColor.lightGrayColor()
        label3.text = "再见"

        let bundle = NSBundle.init(forClass: self.classForCoder)
        let img = UIImage.init(named: "wifi.jpg", inBundle: bundle, compatibleWithTraitCollection: nil)
        let imgV = UIImageView.init(image: img)

        let column = CCFlexbox.column(
            label1,
            label2
        )

        let box = CCFlexbox.row(
            label1,
            label2,
            label3
        ).justifyContent(.SpaceBetween).alignItems(.Center)

        addSubview(box)
        box.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self).inset(EdgeInsetsMake(0, left: 0, bottom: 20, right: 0))
        }

        let button = UIButton.init()
        button.setTitle("button", forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.addTarget(self, action: "click:", forControlEvents: .TouchUpInside)
        addSubview(button)
        button.snp_makeConstraints { (make) -> Void in
            make.left.bottom.equalTo(self)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }


        self.layer.borderWidth = 0.5
    }

    func click(sender:UIButton) {
        if label1.text! != "hello world" {
            label1.text = "hello world"
            label1.font = UIFont.systemFontOfSize(50)
            label3.font = UIFont.systemFontOfSize(100)
        } else {
            label1.text = "Hello World!!Hello World!!"
            label1.font = UIFont.systemFontOfSize(20)
            label3.font = UIFont.systemFontOfSize(10)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        label1 = UILabel.init()
        label1.backgroundColor = UIColor.lightGrayColor()
        label2 = UILabel.init()
        label3 = UILabel.init()
        super.init(coder: aDecoder)

        let view1 = UIView.init()
        view1.backgroundColor = UIColor.redColor()

        let view2 = UIView.init()
        view2.backgroundColor = UIColor.lightGrayColor()

        let view3 = UIView.init()
        view3.backgroundColor = UIColor.grayColor()

        label1.text = "Hello World!!Hello World!!"

        label2.font = UIFont.systemFontOfSize(20)
        //        label2.backgroundColor = UIColor.grayColor()
        label2.text = "你好"

        label3.font = UIFont.systemFontOfSize(15)
        label3.backgroundColor = UIColor.lightGrayColor()
        label3.text = "再见"

        let bundle = NSBundle.init(forClass: self.classForCoder)
        let img = UIImage.init(named: "wifi.jpg", inBundle: bundle, compatibleWithTraitCollection: nil)
        let imgV = UIImageView.init(image: img)

        let column = CCFlexbox.row(
            label1,
            label2
        )
        column.backgroundColor = UIColor.lightGrayColor()

        let box = CCFlexbox.column(
            view1.flexBasis(40, 40).ccTop(8),
            column.ccTop(8),
//            label1.flexShrink(2),
//            label2.ccLeft(5).ccRight(5),
//            label3.ccLeft(MarginAuto)
//            label1.ccLeft(0).flexBasis(200, 20).flexShrink(0),
//            label2.ccLeft(0),
            label3.ccLeft(0).ccTop(8).ccBottom(8)
        ).justifyContent(.SpaceSeperate).alignItems(.Center)

        addSubview(box)
        box.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self).inset(EdgeInsetsMake(0, left: 0, bottom: 20, right: 0))
        }

        let button = UIButton.init()
        button.setTitle("button", forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.addTarget(self, action: "click:", forControlEvents: .TouchUpInside)
        addSubview(button)
        button.snp_makeConstraints { (make) -> Void in
            make.left.bottom.equalTo(self)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        self.layer.borderWidth = 0.5
    }

}

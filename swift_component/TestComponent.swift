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

        setupViews()
    }

    func click(sender:UIButton) {
        if label1.text! == "Hello World!!Hello World!!" {
            label1.text = "Hello World!!Hello World!!Hello World!!Hello World!!Hello World!!Hello World!!Hello World!!Hello World!!"
//            label1.font = UIFont.systemFontOfSize(50)
//            label3.font = UIFont.systemFontOfSize(100)
        } else {
            label1.text = "Hello World!!Hello World!!"
//            label1.font = UIFont.systemFontOfSize(20)
//            label3.font = UIFont.systemFontOfSize(10)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        label1 = UILabel.init()
        label1.backgroundColor = UIColor.lightGrayColor()
        label2 = UILabel.init()
        label3 = UILabel.init()
        super.init(coder: aDecoder)

        setupViews()
    }

    private func setupViews() {
        let view1 = UIView.init()
        view1.backgroundColor = UIColor.redColor()

        let view2 = UIView.init()
        view2.backgroundColor = UIColor.lightGrayColor()

        let view3 = UIView.init()
        view3.backgroundColor = UIColor.grayColor()

        label1.text = "Hello World!!Hello World!!Hello World!!Hello World!!Hello World!!Hello World!!Hello World!!Hello World!!"

        label2.font = UIFont.systemFontOfSize(20)
        //        label2.backgroundColor = UIColor.grayColor()
        label2.text = "你好"

        label3.font = UIFont.systemFontOfSize(15)
        label3.text = "再见"

        let bundle = NSBundle.init(forClass: self.classForCoder)
        let img = UIImage.init(named: "wifi.jpg", inBundle: bundle, compatibleWithTraitCollection: nil)
        let imgV = UIImageView.init(image: img)

        let label4 = UILabel.init()
        label4.text = "总计：$12"
        let button5 = UIButton.init()
        button5.setTitle("支付", forState: .Normal)
        button5.setTitleColor(UIColor.blueColor(), forState: .Normal)

        let box = CCFlexbox.column(
            CCFlexbox.row(
                imgV.flexBasis(40, 40).ccLeft(5),
                CCFlexbox.column(
                    label1,
                    CCFlexbox.row(label2, label3.ccLeft(5)).alignItems(.Baseline).ccTop(5)
                ).justifyContent(.Center).ccLeft(5),
                view1.flexBasis(20, 20)
                ).justifyContent(.FlexStart).alignItems(.Center),
            CCFlexbox.row(label4, button5).justifyContent(.SpaceBetween).ccLeft(5).ccRight(5)
            ).justifyContent(.Center)

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

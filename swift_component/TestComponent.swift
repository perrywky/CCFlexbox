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


    override init(frame: CGRect) {
        super.init(frame: frame)

        let component:Component = Component.init()
        let view:UIView = component.render()
        view.frame = CGRectMake(0, 0, 320, 96)
        view.layer.borderColor = UIColor.lightGrayColor().CGColor
        view.layer.borderWidth = 0.5
        addSubview(view)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

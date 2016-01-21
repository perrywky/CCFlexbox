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
        addSubview(view)
        view.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }

        self.layer.borderWidth = 0.5
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let component:Component = Component.init()
        let view:UIView = component.render()
        addSubview(view)
        view.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }

        self.layer.borderWidth = 0.5
    }

}

//
//  DemoViewController.swift
//  swift_component
//
//  Created by Perry on 16/3/30.
//  Copyright © 2016年 Perry. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {

    private var flexBox:CCFlexbox? = nil
    private var item1:UIView? = nil
    private var item2:UILabel? = nil
    private var item3:UIView? = nil
    private var selectedItem:UIView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        item1 = UIView.init()
        item1!.backgroundColor = UIColor.blueColor()

        item2 = UILabel.init()
        item2!.backgroundColor = UIColor.yellowColor()
        item2!.text = "label"

        item3 = UIView.init()
        item3!.backgroundColor = UIColor.redColor()

        flexBox = CCFlexbox.row(
            item1!.cfb_flexBasis(50, 50),
            item2!,
            item3!.cfb_flexBasis(80, 80)
        )

        flexBox!.layer.borderWidth = 0.5
        flexBox!.layer.borderColor = UIColor.init(white: 0, alpha: 0.1).CGColor

        self.view.addSubview(flexBox!)
        flexBox!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[flexBox]-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["flexBox":flexBox!]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[flexBox(==100)]", options: .DirectionLeadingToTrailing, metrics: nil, views: ["flexBox":flexBox!]))

        selectedItem = item1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func changeItem(sender: AnyObject) {
        let segCtrl = sender as! UISegmentedControl
        if segCtrl.selectedSegmentIndex == 0 {
            selectedItem = item1!
        } else if segCtrl.selectedSegmentIndex == 1 {
            selectedItem = item2!
        } else if segCtrl.selectedSegmentIndex == 2 {
            selectedItem = item3!
        }
    }

    @IBAction func justifyFlexStart(sender: AnyObject) {
        flexBox!.justifyContent(.FlexStart)
    }

    @IBAction func justifyFlexEnd(sender: AnyObject) {
        flexBox!.justifyContent(.FlexEnd)
    }

    @IBAction func justifyCenter(sender: AnyObject) {
        flexBox!.justifyContent(.Center)
    }

    @IBAction func justifySpaceBetween(sender: AnyObject) {
        flexBox!.justifyContent(.SpaceBetween)
    }

    @IBAction func justifySpaceAround(sender: AnyObject) {
        flexBox!.justifyContent(.SpaceAround)
    }

    @IBAction func justifySpaceSeperate(sender: AnyObject) {
        flexBox!.justifyContent(.SpaceSeperate)
    }

    @IBAction func alignFlexStart(sender: AnyObject) {
        flexBox!.alignItems(.FlexStart)
    }

    @IBAction func alignFlexEnd(sender: AnyObject) {
        flexBox!.alignItems(.FlexEnd)
    }

    @IBAction func alignCenter(sender: AnyObject) {
        flexBox!.alignItems(.Center)
    }

    @IBAction func alignBaseline(sender: AnyObject) {
        flexBox!.alignItems(.Baseline)
    }

    @IBAction func alignStetch(sender: AnyObject) {
        flexBox!.alignItems(.Stretch)
    }

    @IBAction func alignAuto(sender: AnyObject) {
        flexBox!.alignItems(.Auto)
    }

    @IBAction func marginTop0(sender: AnyObject) {
        selectedItem!.cfb_top(0)
    }
    @IBAction func marginTop10(sender: AnyObject) {
        selectedItem!.cfb_top(10)
    }
    @IBAction func marginBottom0(sender: AnyObject) {
        selectedItem!.cfb_bottom(0)
    }
    @IBAction func marginBottom10(sender: AnyObject) {
        selectedItem!.cfb_bottom(10)
    }
    @IBAction func marginLeft0(sender: AnyObject) {
        selectedItem!.cfb_left(0)
    }
    @IBAction func marginLeft10(sender: AnyObject) {
        selectedItem!.cfb_left(10)
    }
    @IBAction func marginLeftAuto(sender: AnyObject) {
        selectedItem!.cfb_leftAuto()
    }
    @IBAction func marginRight0(sender: AnyObject) {
        selectedItem!.cfb_right(0)
    }
    @IBAction func marginRight10(sender: AnyObject) {
        selectedItem!.cfb_right(10)
    }
    @IBAction func marginRightAuto(sender: AnyObject) {
        selectedItem!.cfb_rightAuto()
    }

    @IBAction func alignSelfFlexStart(sender: AnyObject) {
        selectedItem!.cfb_alignSelf(.FlexStart)
    }

    @IBAction func alignSelfFlexEnd(sender: AnyObject) {
        selectedItem!.cfb_alignSelf(.FlexEnd)
    }

    @IBAction func alignselfCenter(sender: AnyObject) {
        selectedItem!.cfb_alignSelf(.Center)
    }

    @IBAction func alignSelfBaseline(sender: AnyObject) {
        selectedItem!.cfb_alignSelf(.Baseline)
    }

    @IBAction func alignSelfStetch(sender: AnyObject) {
        selectedItem!.cfb_alignSelf(.Stretch)
    }

    @IBAction func alignSelfAuto(sender: AnyObject) {
        selectedItem!.cfb_alignSelf(.Auto)
    }

    @IBAction func flexGrow0(sender: AnyObject) {
        selectedItem!.cfb_flexGrow(0)
    }
    @IBAction func flexGrow1(sender: AnyObject) {
        selectedItem!.cfb_flexGrow(1)
    }
    @IBAction func flexGrow2(sender: AnyObject) {
        selectedItem!.cfb_flexGrow(2)
    }

    @IBAction func toggleShrink(sender: AnyObject) {
        let swt = sender as! UISwitch
        if swt.on {
            item2!.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        } else {
            item2!.text = "label"
        }
    }
    @IBAction func flexShrink0(sender: AnyObject) {
        selectedItem!.cfb_flexShrink(0)
    }
    @IBAction func flexShrink1(sender: AnyObject) {
        selectedItem!.cfb_flexShrink(1)
    }
    @IBAction func flexShrink2(sender: AnyObject) {
        selectedItem!.cfb_flexShrink(2)
    }
}

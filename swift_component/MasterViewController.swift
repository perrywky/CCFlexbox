//
//  MasterViewController.swift
//  swift_component
//
//  Created by Perry on 15/12/28.
//  Copyright © 2015年 Perry. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 60
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 32
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row < 27 {
            return self.tableView.rowHeight
        } else {
            return 80
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.selectionStyle = .None
        cell.textLabel!.text = ""

        if indexPath.row < 6 {
            let justify = JustifyContent(rawValue: indexPath.row)!
            let label = UILabel.init()
            label.backgroundColor = UIColor.greenColor()
            switch justify {
            case .FlexStart:
                label.text = "FlexStart"
                break;
            case .FlexEnd:
                label.text = "FlexEnd"
                break;
            case .Center:
                label.text = "Center"
                break;
            case .SpaceBetween:
                label.text = "SpaceBetween"
                break;
            case .SpaceAround:
                label.text = "SpaceAround"
                break;
            case .SpaceSeperate:
                label.text = "SpaceSeperate"
                break;
            }
            let img = UIImageView.init(image: UIImage.init(named: "wifi"))
            let label1 = UILabel.init()
            label1.text = "--row--"
            label1.backgroundColor = UIColor.lightGrayColor()
            let flexbox = CCFlexbox.row(
                img.ccLeft(10), label.ccLeft(10).flexGrow(0), label1.ccLeft(10).ccRight(10)
                ).justifyContent(justify)
            flexbox.tag = 1
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
            for _ in 1...5 {
                img.flexBasis(40, 40)
            }
        } else if indexPath.row == 6 {
            let label = UILabel.init()
            label.backgroundColor = UIColor.lightGrayColor()
            label.text = "FlexGrow(0)"

            let label2 = UILabel.init()
            label2.backgroundColor = UIColor.greenColor()
            label2.text = "FlexGrow(1)"
            label2.textAlignment = .Center
            label2.flexGrow(1)

            let flexbox = CCFlexbox.row(label, label2).justifyContent(.FlexStart)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 7 {
            let label = UILabel.init()
            label.backgroundColor = UIColor.lightGrayColor()
            label.text = "FlexGrow(1)"
            label.textAlignment = .Center
            label.flexGrow(1)

            let label2 = UILabel.init()
            label2.backgroundColor = UIColor.greenColor()
            label2.text = "FlexGrow(0)"
            
            let flexbox = CCFlexbox.row(label, label2).justifyContent(.FlexStart)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 8 {
            let label = UILabel.init()
            label.backgroundColor = UIColor.lightGrayColor()
            label.text = "FlexShrink(1): Lorem ipsum"
            label.flexShrink(1)

            let label2 = UILabel.init()
            label2.tag = 1
            label2.backgroundColor = UIColor.greenColor()
            label2.text = "FlexShrink(0): Lorem ipsum"

            let flexbox = CCFlexbox.row(label, label2).justifyContent(.FlexStart)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 9 {
            let label = UILabel.init()
            label.backgroundColor = UIColor.lightGrayColor()
            label.text = "FlexBasis(200, 0)"
            label.tag = 1
            label.flexBasis(200, 0)

            let label2 = UILabel.init()
            label2.backgroundColor = UIColor.greenColor()
            label2.text = "FlexShrink(1): Lorem ipsum"
            label2.flexShrink(1)

            let flexbox = CCFlexbox.row(label, label2).justifyContent(.FlexStart)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 10 {
            let label = UILabel.init()
            label.text = "ccLeft(10)"
            label.backgroundColor = UIColor.lightGrayColor()
            label.ccLeft(10)

            let label2 = UILabel.init()
            label2.backgroundColor = UIColor.greenColor()
            label2.text = "ccLeft(20)"
            label2.ccLeft(20)

            let label3 = UILabel.init()
            label3.text = "ccLeftAuto"
            label3.backgroundColor = UIColor.lightGrayColor()
            label3.ccLeftAuto()

            let flexbox = CCFlexbox.row(label, label2, label3).justifyContent(.FlexEnd)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 11 {
            let label = UILabel.init()
            label.text = "FlexStart"
            label.backgroundColor = UIColor.lightGrayColor()
            label.alignSelf(.FlexStart)

            let label2 = UILabel.init()
            label2.backgroundColor = UIColor.greenColor()
            label2.text = "FlexEnd"
            label2.alignSelf(.FlexEnd)

            let label3 = UILabel.init()
            label3.text = "Center"
            label3.backgroundColor = UIColor.lightGrayColor()
            label3.alignSelf(.Center)

            let label4 = UILabel.init()
            label4.text = "Baseline"
            label4.backgroundColor = UIColor.greenColor()
            label4.alignSelf(.Baseline)

            let label5 = UILabel.init()
            label5.text = "Stretch"
            label5.backgroundColor = UIColor.lightGrayColor()
            label5.alignSelf(.Stretch)

            let flexbox = CCFlexbox.row(label, label2, label3, label4, label5).justifyContent(.FlexStart)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 12 {
            let label = UILabel.init()
            label.text = "column"

            let label2 = UILabel.init()
            label2.text = "FlexStart"

            let flexbox = CCFlexbox.column(label, label2).justifyContent(.FlexStart)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 13 {
            let label = UILabel.init()
            label.text = "column"

            let label2 = UILabel.init()
            label2.text = "FlexEnd"

            let flexbox = CCFlexbox.column(label, label2).justifyContent(.FlexEnd)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 14 {
            let label = UILabel.init()
            label.text = "column"

            let label2 = UILabel.init()
            label2.text = "Center"

            let flexbox = CCFlexbox.column(label, label2).justifyContent(.Center)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 15 {
            let label = UILabel.init()
            label.text = "column"

            let label2 = UILabel.init()
            label2.text = "SpaceBetween"

            let flexbox = CCFlexbox.column(label, label2).justifyContent(.SpaceBetween)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 16 {
            let label = UILabel.init()
            label.text = "column"

            let label2 = UILabel.init()
            label2.text = "SpaceAround"

            let flexbox = CCFlexbox.column(label, label2).justifyContent(.SpaceAround)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 17 {
            let label = UILabel.init()
            label.text = "column"

            let label2 = UILabel.init()
            label2.text = "SpaceSeperate"

            let flexbox = CCFlexbox.column(label, label2).justifyContent(.SpaceSeperate)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 18 {
            let label = UILabel.init()
            label.text = "FlexGrow(0)"
            label.backgroundColor = UIColor.lightGrayColor()
            label.flexGrow(0)

            let label2 = UILabel.init()
            label2.text = "FlexGrow(1)"
            label2.backgroundColor = UIColor.greenColor()
            label2.flexGrow(1)

            let flexbox = CCFlexbox.column(label, label2).justifyContent(.FlexStart)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 19 {
            let label = UILabel.init()
            label.text = "FlexGrow(1)"
            label.backgroundColor = UIColor.lightGrayColor()
            label.flexGrow(1)

            let label2 = UILabel.init()
            label2.text = "FlexGrow(0)"
            label2.backgroundColor = UIColor.greenColor()
            label2.flexGrow(0)

            let flexbox = CCFlexbox.column(label, label2).justifyContent(.FlexStart)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 20 {
            let label = UILabel.init()
            label.text = "FlexShrink(1)"
            label.backgroundColor = UIColor.lightGrayColor()
            label.flexShrink(1)

            let label2 = UILabel.init()
            label2.text = "FlexShrink(0)"
            label2.tag = 1
            label2.backgroundColor = UIColor.greenColor()
            label2.flexShrink(0)
            label2.font = UIFont.systemFontOfSize(40)

            let flexbox = CCFlexbox.column(label, label2).justifyContent(.FlexStart)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 21 {
            let label = UILabel.init()
            label.text = "FlexBasis(0, 50)"
            label.tag = 1
            label.backgroundColor = UIColor.lightGrayColor()
            label.flexBasis(0, 50)

            let label2 = UILabel.init()
            label2.text = "FlexShrink(1)"
            label2.backgroundColor = UIColor.greenColor()
            label2.flexShrink(1)

            let flexbox = CCFlexbox.column(label, label2).justifyContent(.FlexStart)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 22 {
            let label = UILabel.init()
            label.text = "ccTop(5)"
            label.backgroundColor = UIColor.lightGrayColor()
            label.ccTop(5)

            let label3 = UILabel.init()
            label3.text = "ccTopAuto"
            label3.backgroundColor = UIColor.lightGrayColor()
            label3.ccTopAuto()

            let flexbox = CCFlexbox.column(label, label3).justifyContent(.FlexStart)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 23 {
            let label = UILabel.init()
            label.text = "alignSelf(.FlexStart)"
            label.backgroundColor = UIColor.lightGrayColor()
            label.font = UIFont.systemFontOfSize(12)
            label.alignSelf(.FlexStart)

            let label2 = UILabel.init()
            label2.backgroundColor = UIColor.greenColor()
            label2.font = UIFont.systemFontOfSize(10)
            label2.text = "FlexEnd"
            label2.alignSelf(.FlexEnd)

            let label3 = UILabel.init()
            label3.text = "Center"
            label3.font = UIFont.systemFontOfSize(12)
            label3.backgroundColor = UIColor.lightGrayColor()
            label3.alignSelf(.Center)

            let flexbox = CCFlexbox.column(label, label2, label3).justifyContent(.FlexStart)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 24 {

            let label3 = UILabel.init()
            label3.text = "Auto"
            label3.backgroundColor = UIColor.lightGrayColor()
            label3.alignSelf(.Auto)

            let label4 = UILabel.init()
            label4.text = "Baseline: N/A"
            label4.backgroundColor = UIColor.greenColor()
            label4.alignSelf(.Baseline)

            let label5 = UILabel.init()
            label5.text = "Stretch"
            label5.backgroundColor = UIColor.lightGrayColor()
            label5.alignSelf(.Stretch)

            let flexbox = CCFlexbox.column(label3, label4, label5).justifyContent(.FlexStart)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 25 {

            let img = UIImageView.init(image: UIImage.init(named: "wifi"))
            img.flexBasis(40, 40)

            let label1 = UILabel.init()
            label1.text = "Title"

            let label2 = UILabel.init()
            label2.text = "Subtitle"

            let label3 = UILabel.init()
            label3.text = "flexGrow(1)"
            label3.backgroundColor = UIColor.lightGrayColor()
            label3.tag = 1

            let column = CCFlexbox.column(label1, label2)
            column.backgroundColor = UIColor.darkGrayColor()
            column.justifyContent(.SpaceSeperate)
            column.alignSelf(.Stretch)

            let flexbox = CCFlexbox.row(img.ccLeft(8), column.ccLeft(8).ccRight(8), label3.ccRight(8).flexGrow(1)).alignItems(.Center)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 26 {

            let label1 = UILabel.init()
            label1.text = "column1.row1"

            let label2 = UILabel.init()
            label2.text = "column1.row2"

            let label3 = UILabel.init()
            label3.text = "column2.row1"

            let label4 = UILabel.init()
            label4.text = "column2.row2"

            let label5 = UILabel.init()
            label5.text = "column3.row1"

            let label6 = UILabel.init()
            label6.text = "column3.row2"

            let column1 = CCFlexbox.column(label1, label2)
            column1.backgroundColor = UIColor.lightGrayColor()

            let column3 = CCFlexbox.column(label5, label6)
            column3.backgroundColor = UIColor.darkGrayColor()

            let flexbox = CCFlexbox.row(column1, CCFlexbox.column(label3, label4), column3).justifyContent(.SpaceBetween).alignItems(.Center)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        } else if indexPath.row == 27 {

            let label1 = UILabel.init()
            label1.text = "row1"
            label1.backgroundColor = UIColor.lightGrayColor()

            let colimg = UIImageView.init(image: UIImage.init(named: "wifi"))
            colimg.flexBasis(20, 20)

            let label3 = UILabel.init()
            label3.text = "col1"

            let label4 = UILabel.init()
            label4.text = "col2"

            let label5 = UILabel.init()
            label5.text = "col3"

            let column = CCFlexbox.column(label1, colimg, CCFlexbox.row(label3, label4, label5).alignItems(.Center).justifyContent(.SpaceSeperate).alignSelf(.Stretch)).justifyContent(.SpaceBetween).alignItems(.Center)
            column.backgroundColor = UIColor.darkGrayColor()

            let img = UIImageView.init(image: UIImage.init(named: "wifi"))
            img.flexBasis(40, 40)

            let img2 = UIImageView.init(image: UIImage.init(named: "wifi"))
            img2.flexBasis(40, 40)

            let row = CCFlexbox.row(img.ccLeft(16), column.ccLeft(16).flexGrow(1).alignSelf(.Stretch), img2.ccRight(12)).alignItems(.Center)
            cell.contentView.addSubview(row)
            alignFrame(row, view2: cell.contentView)
        } else if indexPath.row == 28 {

            let label1 = UILabel.init()
            label1.text = "row1"

            let label2 = UILabel.init()
            label2.text = "row2"

            let label4 = UILabel.init()
            label4.text = "col3"
            label4.font = UIFont.systemFontOfSize(16)

            let label5 = UILabel.init()
            label5.text = "col4"
            label5.font = UIFont.systemFontOfSize(12)

            let column = CCFlexbox.column(label1, label2, CCFlexbox.row(label4, label5).alignItems(.Baseline)).justifyContent(.SpaceBetween).alignItems(.FlexStart)

            cell.contentView.addSubview(column)
            alignFrame(column, view2: cell.contentView)
        } else if indexPath.row == 29 {

            let label1 = UILabel.init()
            label1.text = "row1 grow(1)"
            label1.backgroundColor = UIColor.lightGrayColor()

            let colimg = UIImageView.init(image: UIImage.init(named: "wifi"))
            colimg.flexBasis(40, 40)

            let label3 = UILabel.init()
            label3.text = "row2"
            label3.backgroundColor = UIColor.darkGrayColor()

            let label4 = UILabel.init()
            label4.text = "col2 grow(0)"
            label4.tag = 1

            let column = CCFlexbox.column(label1, label3.alignSelf(.Center))

            let img = UIImageView.init(image: UIImage.init(named: "wifi"))
            img.flexBasis(40, 40)

            let row = CCFlexbox.row(img.ccLeft(16), column.ccLeft(16).flexGrow(1), label4.ccLeft(12)).alignItems(.Center)
            cell.contentView.addSubview(row)
            alignFrame(row, view2: cell.contentView)
        } else if indexPath.row == 30 {

            let label1 = UILabel.init()
            label1.text = "col1"
            label1.backgroundColor = UIColor.lightGrayColor()

            let colimg = UIImageView.init(image: UIImage.init(named: "wifi"))
            colimg.flexBasis(20, 20)

            let label3 = UILabel.init()
            label3.text = "col2"

            let label4 = UILabel.init()
            label4.text = "row3"

            let row = CCFlexbox.row(label1, label3)

            let column = CCFlexbox.column(colimg, row.flexGrow(1), label4).alignItems(.Center)
            cell.contentView.addSubview(column)
            alignFrame(column, view2: cell.contentView)
        } else if indexPath.row == 31 {

            let label1 = UILabel.init()
            label1.text = "row1.column1"
            label1.font = UIFont.systemFontOfSize(12)

            let label2 = UILabel.init()
            label2.text = "row1.column2"
            label2.font = UIFont.systemFontOfSize(12)

            let label3 = UILabel.init()
            label3.text = "row2.column1"
            label3.font = UIFont.systemFontOfSize(10)

            let label4 = UILabel.init()
            label4.text = "row2.column2"
            label4.font = UIFont.systemFontOfSize(10)

            let label5 = UILabel.init()
            label5.text = "row3.column1"
            label5.font = UIFont.systemFontOfSize(14)

            let label6 = UILabel.init()
            label6.text = "row3.column2"
            label6.font = UIFont.systemFontOfSize(14)

            let row1 = CCFlexbox.row(label1, label2.ccLeft(5))
            row1.backgroundColor = UIColor.lightGrayColor()

            let row3 = CCFlexbox.row(label5, label6.ccLeft(5))
            row3.backgroundColor = UIColor.darkGrayColor()

            let flexbox = CCFlexbox.column(row1, CCFlexbox.row(label3, label4.ccLeft(5)), row3).justifyContent(.SpaceBetween).alignItems(.Center)
            cell.contentView.addSubview(flexbox)
            alignFrame(flexbox, view2: cell.contentView)
        }
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            if let box:CCFlexbox = cell.contentView.viewWithTag(1) as? CCFlexbox {
                NSLog("update count %d", box.updateConstraintsCount)
            }

        } else if indexPath.row == 8 {
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            if let label:UILabel = cell.contentView.viewWithTag(1) as? UILabel {
                if label.text == "FlexShrink(0): Lorem ipsum" {
                    label.flexShrink(2)
                    label.text = "FlexShrink(2): Lorem ipsum"
                } else {
                    label.flexShrink(0)
                    label.text = "FlexShrink(0): Lorem ipsum"
                }
            }
        }else if indexPath.row == 9 {
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            let label = cell.contentView.viewWithTag(1) as! UILabel
            if label.text == "FlexBasis(130, 0)" {
                label.text = "FlexBasis(200, 0)"
                label.flexBasis(200, 0)
            } else {
                label.text = "FlexBasis(130, 0)"
                label.flexBasis(130, 0)
            }
        }else if indexPath.row == 20 {
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            let label = cell.contentView.viewWithTag(1) as! UILabel
            if label.text == "FlexShrink(0)" {
                label.flexShrink(2)
                label.text = "FlexShrink(2)"
            } else {
                label.flexShrink(0)
                label.text = "FlexShrink(0)"
            }
        } else if indexPath.row == 21 {
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            let label = cell.contentView.viewWithTag(1) as! UILabel
            if label.text == "FlexBasis(0, 20)" {
                label.text = "FlexBasis(0, 50)"
                label.flexBasis(0, 50)
            } else {
                label.text = "FlexBasis(0, 20)"
                label.flexBasis(0, 20)
            }
        } else if indexPath.row == 25 {
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            let label = cell.contentView.viewWithTag(1) as! UILabel
            if label.text == "flexGrow(1)" {
                label.flexGrow(0)
                label.text = "flexGrow(0)"
            } else {
                label.flexGrow(1)
                label.text = "flexGrow(1)"
            }
        } else if indexPath.row == 29 {
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            let label = cell.contentView.viewWithTag(1) as! UILabel
            if label.text == "col2 grow(0)" {
                label.flexGrow(2)
                label.text = "col2 grow(2)"
            } else {
                label.flexGrow(0)
                label.text = "col2 grow(0)"
            }
        }
    }

    private func alignFrame(view1:UIView, view2:UIView) {
        view1.translatesAutoresizingMaskIntoConstraints = false;
        let constraint1 = NSLayoutConstraint(item: view1, attribute: .Top, relatedBy: .Equal, toItem: view2, attribute: .Top, multiplier: 1, constant: 0)
        if #available(iOS 8.0, *) {
            constraint1.active = true
        } else {
            view1.addConstraint(constraint1)
        }
        let constraint2 = NSLayoutConstraint(item: view1, attribute: .Bottom, relatedBy: .Equal, toItem: view2, attribute: .Bottom, multiplier: 1, constant: 0)
        if #available(iOS 8.0, *) {
            constraint2.active = true
        } else {
            view1.addConstraint(constraint2)
        }
        let constraint3 = NSLayoutConstraint(item: view1, attribute: .Left, relatedBy: .Equal, toItem: view2, attribute: .Left, multiplier: 1, constant: 0)
        if #available(iOS 8.0, *) {
            constraint3.active = true
        } else {
            view1.addConstraint(constraint3)
        }
        let constraint4 = NSLayoutConstraint(item: view1, attribute: .Right, relatedBy: .Equal, toItem: view2, attribute: .Right, multiplier: 1, constant: 0)
        if #available(iOS 8.0, *) {
            constraint4.active = true
        } else {
            view1.addConstraint(constraint4)
        }
    }


}


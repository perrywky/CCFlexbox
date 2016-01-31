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
        return 12
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.selectionStyle = .None
        cell.textLabel!.text = ""

        if indexPath.row < 6 {
            let justify = JustifyContent(rawValue: indexPath.row)!
            let label = UILabel.init()
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
            img.flexBasis(40, 40)
            let flexbox = CCFlexbox.row(img, label).justifyContent(justify)
            cell.contentView.addSubview(flexbox)
            flexbox.snp_makeConstraints { (make) -> Void in
                make.edges.equalTo(cell.contentView)
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
            flexbox.snp_makeConstraints { (make) -> Void in
                make.edges.equalTo(cell.contentView)
            }
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
            flexbox.snp_makeConstraints { (make) -> Void in
                make.edges.equalTo(cell.contentView)
            }
        } else if indexPath.row == 8 {
            let label = UILabel.init()
            label.backgroundColor = UIColor.lightGrayColor()
            label.text = "FlexShrink(1): Lorem ipsum"
            label.flexShrink(1)

            let label2 = UILabel.init()
            label2.backgroundColor = UIColor.greenColor()
            label2.text = "FlexShrink(0): Lorem ipsum"

            let flexbox = CCFlexbox.row(label, label2).justifyContent(.FlexStart)
            cell.contentView.addSubview(flexbox)
            flexbox.snp_makeConstraints { (make) -> Void in
                make.edges.equalTo(cell.contentView)
            }
        } else if indexPath.row == 9 {
            let label = UILabel.init()
            label.backgroundColor = UIColor.lightGrayColor()
            label.text = "FlexBasis(200, 0)"
            label.flexBasis(210, 0)

            let label2 = UILabel.init()
            label2.backgroundColor = UIColor.greenColor()
            label2.text = "FlexShrink(0): Lorem ipsum"

            let flexbox = CCFlexbox.row(label, label2).justifyContent(.FlexStart)
            cell.contentView.addSubview(flexbox)
            flexbox.snp_makeConstraints { (make) -> Void in
                make.edges.equalTo(cell.contentView)
            }
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

            let flexbox = CCFlexbox.row(label, label2, label3).justifyContent(.FlexStart)
            cell.contentView.addSubview(flexbox)
            flexbox.snp_makeConstraints { (make) -> Void in
                make.edges.equalTo(cell.contentView)
            }
        } else if indexPath.row == 11 {
            let label = UILabel.init()
            label.text = "alignSelf(.FlexStart)"
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
            flexbox.snp_makeConstraints { (make) -> Void in
                make.edges.equalTo(cell.contentView)
            }
        }

        return cell
    }


}


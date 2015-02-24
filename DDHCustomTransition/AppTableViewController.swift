//
//  TableViewController.swift
//  DDHCustomTransition
//
//  Created by dasdom on 23.02.15.
//  Copyright (c) 2015 Dominik Hauser. All rights reserved.
//

import UIKit

let imageKey = "image"
let nameKey = "name"

class AppTableViewController: UITableViewController, TransitionInfoProtocol {

    let data = [[imageKey: "phy", nameKey: "Phy"], [imageKey: "hAppy", nameKey: "hAppy"], [imageKey: "jupp", nameKey: "Jupp"], [imageKey: "fujosi", nameKey: "Fujosi"]]
    var lastSelectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70.0
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! AppTableViewCell

        let cellData = data[indexPath.row]
        println("cellData \(cellData)")
        if let imageName = cellData[imageKey], name = cellData[nameKey] {
            cell.iconImageView.image = UIImage(named: imageName)
            cell.label.text = name
        }

        return cell
    }
    
    func viewsToAnimate() -> [UIView] {
        let cell: AppTableViewCell
        if let indexPath = tableView.indexPathForSelectedRow() {
            cell = tableView.cellForRowAtIndexPath(indexPath) as! AppTableViewCell
        } else {
            cell = tableView.cellForRowAtIndexPath(lastSelectedIndexPath!) as! AppTableViewCell
        }
        
        return [cell.iconImageView, cell.label]
    }
    
    func copyForView(subView: UIView) -> UIView {
        let cell = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow()!) as! AppTableViewCell
        if subView is UIImageView {
            return UIImageView(image: cell.iconImageView.image)
        } else {
            let label = UILabel()
            label.text = cell.label.text
            return label
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = tableView.indexPathForSelectedRow() {
            lastSelectedIndexPath = indexPath
            let appDetailViewController = segue.destinationViewController as! AppDetailViewController
            appDetailViewController.appData = data[indexPath.row]
        }
    }
    

}

//
//  TableViewController.swift
//  DDHCustomTransition

import UIKit

let imageKey = "image"
let nameKey = "name"

class AppTableViewController: UITableViewController, TransitionInfoProtocol {
  
  let data = [[imageKey: "phy", nameKey: "Phy"], [imageKey: "hAppy", nameKey: "hAppy"], [imageKey: "jupp", nameKey: "Jupp"], [imageKey: "fujosi", nameKey: "Fujosi"]]
  var lastSelectedIndexPath: IndexPath?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 70.0
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AppTableViewCell
    
    let cellData = data[indexPath.row]
    print("cellData \(cellData)")
    if let imageName = cellData[imageKey], let name = cellData[nameKey] {
      cell.iconImageView.image = UIImage(named: imageName)
      cell.label.text = name
    }
    
    return cell
  }
  
  func viewsToAnimate() -> [UIView] {
    let cell: AppTableViewCell
    if let indexPath = tableView.indexPathForSelectedRow {
      cell = tableView.cellForRow(at: indexPath) as! AppTableViewCell
    } else {
      cell = tableView.cellForRow(at: lastSelectedIndexPath!) as! AppTableViewCell
    }
    
    return [cell.iconImageView, cell.label]
  }
  
  func copyForView(_ subView: UIView) -> UIView {
    let cell = tableView.cellForRow(at: tableView.indexPathForSelectedRow!) as! AppTableViewCell
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
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let indexPath = tableView.indexPathForSelectedRow {
      lastSelectedIndexPath = indexPath
      let appDetailViewController = segue.destination as! AppDetailViewController
      appDetailViewController.appData = data[indexPath.row]
    }
  }
  
  
}

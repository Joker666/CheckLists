//
//  AllListsViewController.swift
//  CheckLists
//
//  Created by Hasan Rafi on 12/17/15.
//  Copyright © 2015 Hasan Rafi. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedCheckList
        if index >= 0 && index < dataModel.lists.count {
            let checkList = dataModel.lists[index]
            performSegueWithIdentifier("ShowCheckList", sender: checkList)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedCheckList = -1
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellidentifier = "Cell"
        
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellidentifier)

        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellidentifier)
        }
        
        let checkList = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checkList.name
        cell.accessoryType = .DetailDisclosureButton

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        dataModel.indexOfSelectedCheckList = indexPath.row
        let checkList = dataModel.lists[indexPath.row]
        performSegueWithIdentifier("ShowCheckList", sender: checkList)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowCheckList" {
            let controller = segue.destinationViewController as! CheckListViewController
            controller.checkList = sender as! CheckList
        } else if segue.identifier == "AddCheckList" {
            let navigationController = segue.destinationViewController as! UINavigationController
            
            let controller = navigationController.topViewController as! ListDetailViewController
            
            controller.delegate = self
            controller.checkListToEdit = nil
        }
    }
    
    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingCheckList checkList: CheckList) {
        let newRowIndex = dataModel.lists.count
        checkList.id = Int32(newRowIndex)
        dataModel.lists.append(checkList)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.lists.removeAtIndex(indexPath.row)
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let navigationController = storyboard?.instantiateViewControllerWithIdentifier("ListNavigationController") as! UINavigationController
        
        let controller = navigationController.topViewController as! ListDetailViewController
        
        controller.delegate = self
        let checkList = dataModel.lists[indexPath.row]
        controller.checkListToEdit = checkList
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishEditingCheckList checkList: CheckList) {
        if let index = dataModel.lists.indexOf({$0.id == checkList.id}) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                cell.textLabel!.text = checkList.name
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}


public extension String {
    var NS: NSString { return (self as NSString) }
}
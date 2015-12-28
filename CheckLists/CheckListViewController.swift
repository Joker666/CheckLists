//
//  ViewController.swift
//  CheckLists
//
//  Created by Hasan Rafi on 12/2/15.
//  Copyright © 2015 Hasan Rafi. All rights reserved.
//

import UIKit

class CheckListViewController: UITableViewController, ItemDetailViewControllerDelegate {

    var items : [CheckListItem]
    var checkList: CheckList!

    required init? (coder aDecoder: NSCoder) {
        items = [CheckListItem]()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = checkList.name
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkList.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CheckListItem")! as UITableViewCell

        let item = checkList.items[indexPath.row]

        configureTextForCell(cell, withCheckListItem: item)
        configureCheckmarkForCell(cell, withCheckListItem: item)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item = checkList.items[indexPath.row]
            item.toggleChecked()

            configureCheckmarkForCell(cell, withCheckListItem: item)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        checkList.items.removeAtIndex(indexPath.row)
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    func configureCheckmarkForCell(cell: UITableViewCell, withCheckListItem checkListItem: CheckListItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if checkListItem.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }

    func configureTextForCell(cell: UITableViewCell, withCheckListItem checkListitem: CheckListItem) {
        let label = cell.viewWithTag(666) as! UILabel
//        label.text = checkListitem.text
        label.text = "\(checkListitem.itemId): \(checkListitem.text)"
        label.textColor = view.tintColor
    }
    
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: CheckListItem) {
        let newRowIndex = checkList.items.count
        item.itemId = newRowIndex
        checkList.items.append(item)

        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: CheckListItem) {
        if let index = checkList.items.indexOf({$0.itemId == item.itemId}) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                configureTextForCell(cell, withCheckListItem: item)
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            
            let controller = navigationController.topViewController as! ItemDetailViewController
            
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            
            let controller = navigationController.topViewController as! ItemDetailViewController
            
            controller.delegate = self
            
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                controller.itemToEdit = checkList.items[indexPath.row]
            }
        }
    }
}

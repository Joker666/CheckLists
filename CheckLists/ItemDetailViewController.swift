//
//  ItemDetailViewController.swift
//  CheckLists
//
//  Created by Hasan Rafi on 12/4/15.
//  Copyright © 2015 Hasan Rafi. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: CheckListItem)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: CheckListItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    var itemToEdit : CheckListItem?
    weak var delegate: ItemDetailViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.becomeFirstResponder()
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.enabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancel(sender: AnyObject) {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done(sender: AnyObject) {
        if let item = itemToEdit {
            item.text = textField.text!
            
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        } else {
            let item = CheckListItem()
            item.text = textField.text!
            
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        }
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText : NSString = textField.text!
        let newText : NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        doneBarButton.enabled = newText.length > 0
        
        return true
    }
}

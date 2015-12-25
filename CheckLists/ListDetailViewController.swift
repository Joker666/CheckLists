//
//  ListDetailViewController.swift
//  CheckLists
//
//  Created by Hasan Rafi on 12/18/15.
//  Copyright © 2015 Hasan Rafi. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(controller: ListDetailViewController)
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingCheckList checkList: CheckList)
    func listDetailViewController(controller: ListDetailViewController, didFinishEditingCheckList checkList: CheckList)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImageView: UIImageView!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checkListToEdit: CheckList?
    
    var iconName = "Folder"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checkList = checkListToEdit {
            title = "Edit CheckList"
            textField.text = checkList.name
            doneBarButton.enabled = true
            iconName = checkList.iconName
        }
        
        iconImageView.image = UIImage(named: iconName)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let checkList = checkListToEdit {
            checkList.name = textField.text!
            checkList.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditingCheckList: checkList)
        } else {
            let checkList = CheckList(name: textField.text!, iconName: iconName)
            delegate?.listDetailViewController(self, didFinishAddingCheckList: checkList)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destinationViewController as! IconPickerViewController
            controller.delegate = self
        }
    }
    
    func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        navigationController?.popViewControllerAnimated(true)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        doneBarButton.enabled = newText.length > 0
        return true
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
}

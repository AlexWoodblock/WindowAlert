//
//  ViewController.swift
//  WindowAlert
//
//  Created by Alexander on 05/20/2016.
//  Copyright (c) 2016 Alexander. All rights reserved.
//

import UIKit
import WindowAlert

class ActionInfo {
    var title: String?
    
    var style = UIAlertActionStyle.Default
}

class ViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {
    
    //change this to see if app interaction changes when using convenience WindowAlert initializer that automatically pulls a reference window
    static let useConvenienceInitializer = false
    static let cellIdentifier = "WindowAlertPrefsCell"
    
    @IBOutlet var textFieldsCountLabel: UILabel!
    @IBOutlet weak var actionsTableView: UITableView!
    @IBOutlet var hideOnTapSwitch: UISwitch!
    
    var actions = [ActionInfo]()
    
    var textFieldsCount = 0
    
    var windowAlertTitle: String? = "This is a title"
    var windowAlertMessage: String? = "This is a message"
    
    @IBAction func didClickAddWindowAlertAction(sender: UIBarButtonItem) {
        let actionInfo = ActionInfo()
        actionInfo.title = "Action"
        actions.append(actionInfo)
        actionsTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //safe to force-cast since we know it will be WindowAlertActionPreferencesTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier(ViewController.cellIdentifier, forIndexPath: indexPath) as! WindowAlertActionPreferencesTableViewCell
        let row = indexPath.row
        let actionInfo = actions[row]
        
        cell.actionName.text = actionInfo.title
        cell.actionName.delegate = self
        
        cell.boundActionInfo = actionInfo
        
        //safe to force-unwrap because we know this value will be present
        cell.actionTypeSwitch.selectedSegmentIndex = WindowAlertActionPreferencesTableViewCell.styleSegmentMap[actionInfo.style]!
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete) {
            actions.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func didChangeWindowAlertTitle(sender: UITextField) {
        windowAlertTitle = sender.text
    }
    
    @IBAction func didChangeWindowAlertMessage(sender: UITextField) {
        windowAlertMessage = sender.text
    }
    
    @IBAction func didChangeTextFieldsCount(sender: UIStepper) {
        textFieldsCount = Int(abs(sender.value))
        
        textFieldsCountLabel.text = "\(textFieldsCount)"
    }
    
    
    @IBAction func didClickShowAsActionSheetButton(sender: UIBarButtonItem) {
        showWithStyle(.ActionSheet)
    }
    
    @IBAction func didClickShowAsAlertButton(sender: UIBarButtonItem) {
        showWithStyle(.Alert)
    }
    
    private func showWithStyle(style: UIAlertControllerStyle) {
        if let msg = windowAlertMessage, title = windowAlertTitle {
            if ViewController.useConvenienceInitializer {
                guard let alert = WindowAlert(title: title, message: msg, preferredStyle: style) else {
                    print("WindowAlert failed to init with UIWindow from app delegate, try using regular init")
                    return
                    
                }
                configureAlert(alert)
                
                let shown = alert.show()
                print("Called WindowAlert.show(), result: " + (shown ? "true" : "false"))
            } else {
                guard let window = self.view.window else {
                    print("self.view.window was nil, and thus can't init WindowAlert")
                    return
                }
                
                let alert = WindowAlert(title: title, message: msg, preferredStyle: style, referenceWindow: window)
                configureAlert(alert)
                
                let shown = alert.show()
                print("Called WindowAlert.show(), result: " + (shown ? "true" : "false"))
            }
        }
    }
    
    private func configureAlert(alert: WindowAlert) {
        alert.hideOnTapOutside = hideOnTapSwitch.on
        
        if(alert.preferredStyle == .Alert) {
            var index = 0
            while(index < textFieldsCount) {
                let currentIndex = index //we do this to capture current value, not last one
                alert.addTextFieldWithConfigurationHandler { textField in
                    textField.text = "Text field \(currentIndex + 1)"
                }
                
                index = index + 1
            }
        }
        
        actions.filter {$0.title != nil}.forEach {
            alert.addAction(WindowAlertAction(title: $0.title!, style: $0.style, handler: nil))
        }
    }
}


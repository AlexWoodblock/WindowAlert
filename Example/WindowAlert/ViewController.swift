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
    
    var style = UIAlertAction.Style.default
    
    var image: UIImage?
}

class ViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate, WindowAlertDelegate {
    
    //change this to see if app interaction changes when using convenience WindowAlert initializer that automatically pulls a reference window
    static let useConvenienceInitializer = true
    static let cellIdentifier = "WindowAlertPrefsCell"
    
    @IBOutlet var textFieldsCountLabel: UILabel!
    @IBOutlet weak var actionsTableView: UITableView!
    @IBOutlet var hideOnTapSwitch: UISwitch!
    
    var actions = [ActionInfo]()
    
    var textFieldsCount = 0
    
    var windowAlertTitle: String? = "This is a title"
    var windowAlertMessage: String? = "This is a message"
    
    @IBAction func didClickAddWindowAlertAction() {
        let actionInfo = ActionInfo()
        actionInfo.title = "Action"
        actions.append(actionInfo)
        actionsTableView.reloadData()
    }
    
    @IBAction func didClickAttributions() {
        WindowAlert(title: "Attributions", message: "- Icon for action item was made by freepik: https://www.flaticon.com/authors/freepik", singleActionTitle: "OK").show()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //safe to force-cast since we know it will be WindowAlertActionPreferencesTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellIdentifier, for: indexPath) as! WindowAlertActionPreferencesTableViewCell
        let row = (indexPath as NSIndexPath).row
        let actionInfo = actions[row]
        
        cell.actionName.text = actionInfo.title
        cell.actionName.delegate = self
        cell.enableImageSwitch.isOn = actionInfo.image != nil
        
        cell.boundActionInfo = actionInfo
        
        //safe to force-unwrap because we know this value will be present
        cell.actionTypeSwitch.selectedSegmentIndex = WindowAlertActionPreferencesTableViewCell.styleSegmentMap[actionInfo.style]!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            actions.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func didChangeWindowAlertTitle(_ sender: UITextField) {
        windowAlertTitle = sender.text
    }
    
    @IBAction func didChangeWindowAlertMessage(_ sender: UITextField) {
        windowAlertMessage = sender.text
    }
    
    @IBAction func didChangeTextFieldsCount(_ sender: UIStepper) {
        textFieldsCount = Int(abs(sender.value))
        
        textFieldsCountLabel.text = "\(textFieldsCount)"
    }
    
    
    @IBAction func didClickShowAsActionSheetButton(_ sender: UIBarButtonItem) {
        showWithStyle(.actionSheet)
    }
    
    @IBAction func didClickShowAsAlertButton(_ sender: UIBarButtonItem) {
        showWithStyle(.alert)
    }
    
    fileprivate func showWithStyle(_ style: UIAlertController.Style) {
        if let msg = windowAlertMessage, let title = windowAlertTitle {
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
    
    fileprivate func configureAlert(_ alert: WindowAlert) {
        alert.hideOnTapOutside = hideOnTapSwitch.isOn
        alert.delegate = self
        
        var index = 0
        while(index < textFieldsCount) {
            let currentIndex = index //we do this to capture current value, not last one
            alert.addTextField { textField in
                textField.text = "Text field \(currentIndex + 1)"
            }
            
            index = index + 1
        }
        
        actions.filter { $0.title != nil }.forEach {
            alert.add(action: WindowAlertAction(
                id: "ID_\($0.title!)",
                title: $0.title!,
                style: $0.style,
                image: $0.image,
                handler: { action in
                    print("Action \(action.id!) was clicked")
                }
            ))
        }
    }
    
    
    func windowAlertWillShow(windowAlert alert: WindowAlert) {
        print("WindowAlert will be shown soon")
    }
    
    func windowAlertDidShow(windowAlert alert: WindowAlert) {
        print("WindowAlert was shown")
    }
    
    func windowAlertWillHide(windowAlert alert: WindowAlert) {
        print("WindowAlert will be hidden soon")
    }
    
    func windowAlertDidHide(windowAlert alert: WindowAlert) {
        print("WindowAlert did hide")
    }
}


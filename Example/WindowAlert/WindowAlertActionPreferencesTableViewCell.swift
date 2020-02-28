//
//  EditTextTableViewCell.swift
//  WindowAlert
//
//  Created by Александр on 5/21/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class WindowAlertActionPreferencesTableViewCell: UITableViewCell {
    
    static let segmentStyleMap = [
        0 : UIAlertAction.Style.default,
        1 : UIAlertAction.Style.cancel,
        2 : UIAlertAction.Style.destructive
    ]
    
    static let styleSegmentMap = [
        UIAlertAction.Style.default : 0,
        UIAlertAction.Style.cancel : 1,
        UIAlertAction.Style.destructive : 2
    ]
    
    @IBOutlet var actionName: UITextField!
    @IBOutlet var actionTypeSwitch: UISegmentedControl!
    @IBOutlet var enableImageSwitch: UISwitch!
    
    var boundActionInfo: ActionInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        actionName.addTarget(self, action: #selector(WindowAlertActionPreferencesTableViewCell.didChangeText), for: .editingChanged)
        actionTypeSwitch.addTarget(self, action: #selector(WindowAlertActionPreferencesTableViewCell.didChangeType), for: .valueChanged)
        enableImageSwitch.addTarget(self, action: #selector(WindowAlertActionPreferencesTableViewCell.didChangeImageEnabled), for: .valueChanged)
    }
    
    @objc func didChangeText() {
        boundActionInfo?.title = actionName.text
    }
    
    @objc func didChangeType() {
        boundActionInfo?.style = WindowAlertActionPreferencesTableViewCell.segmentStyleMap[actionTypeSwitch.selectedSegmentIndex]!
    }
    
    @objc func didChangeImageEnabled() {
        boundActionInfo?.image = enableImageSwitch.isOn ? UIImage(named: "ActionItem") : nil
    }
    
}

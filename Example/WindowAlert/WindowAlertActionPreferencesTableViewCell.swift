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
    
    static let alignmentSegmentMap = [
        NSTextAlignment.left : 1,
        NSTextAlignment.center : 2,
        NSTextAlignment.right : 3,
    ]
    
    static let segmentAlignmentMap = [
        1 : NSTextAlignment.left,
        2 : NSTextAlignment.center,
        3 : NSTextAlignment.right
        
    ]
    
    @IBOutlet var actionName: UITextField!
    @IBOutlet var actionTypeSwitch: UISegmentedControl!
    @IBOutlet var enableImageSwitch: UISwitch!
    @IBOutlet var alignmentSwitch: UISegmentedControl!
    
    var boundActionInfo: ActionInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        actionName.addTarget(self, action: #selector(WindowAlertActionPreferencesTableViewCell.didChangeText), for: .editingChanged)
        actionTypeSwitch.addTarget(self, action: #selector(WindowAlertActionPreferencesTableViewCell.didChangeType), for: .valueChanged)
        enableImageSwitch.addTarget(self, action: #selector(WindowAlertActionPreferencesTableViewCell.didChangeImageEnabled), for: .valueChanged)
        alignmentSwitch.addTarget(self, action: #selector(WindowAlertActionPreferencesTableViewCell.didChangeTextAlignment), for: .valueChanged)
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
    
    @objc func didChangeTextAlignment() {
        boundActionInfo?.alignment = WindowAlertActionPreferencesTableViewCell.segmentAlignmentMap[alignmentSwitch.selectedSegmentIndex]
    }
    
}

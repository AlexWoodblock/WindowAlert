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
    
    var boundActionInfo: ActionInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        actionName.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        actionTypeSwitch.addTarget(self, action: #selector(didChangeType), for: .valueChanged)
    }
    
    @objc func didChangeText() {
        boundActionInfo?.title = actionName.text
    }
    
    @objc func didChangeType() {
        boundActionInfo?.style = WindowAlertActionPreferencesTableViewCell.segmentStyleMap[actionTypeSwitch.selectedSegmentIndex]!
    }
    
}

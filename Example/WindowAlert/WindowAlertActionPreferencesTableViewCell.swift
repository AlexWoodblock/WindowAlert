//
//  EditTextTableViewCell.swift
//  WindowAlert
//
//  Created by Александр on 5/21/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class WindowAlertActionPreferencesTableViewCell: UITableViewCell {
    
    static let segmentStyleMap = [0 : UIAlertActionStyle.default, 1 : UIAlertActionStyle.cancel, 2 : UIAlertActionStyle.destructive]
    static let styleSegmentMap = [UIAlertActionStyle.default : 0, UIAlertActionStyle.cancel : 1, UIAlertActionStyle.destructive : 2]
    
    @IBOutlet var actionName: UITextField!
    @IBOutlet var actionTypeSwitch: UISegmentedControl!
    
    var boundActionInfo: ActionInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        actionName.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        actionTypeSwitch.addTarget(self, action: #selector(didChangeType), for: .valueChanged)
    }
    
    func didChangeText() {
        boundActionInfo?.title = actionName.text
    }
    
    func didChangeType() {
        boundActionInfo?.style = WindowAlertActionPreferencesTableViewCell.segmentStyleMap[actionTypeSwitch.selectedSegmentIndex]!
    }
    
}

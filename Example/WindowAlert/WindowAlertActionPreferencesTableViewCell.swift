//
//  EditTextTableViewCell.swift
//  WindowAlert
//
//  Created by Александр on 5/21/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class WindowAlertActionPreferencesTableViewCell: UITableViewCell {
    
    static let segmentStyleMap = [0 : UIAlertActionStyle.Default, 1 : UIAlertActionStyle.Cancel, 2 : UIAlertActionStyle.Destructive]
    static let styleSegmentMap = [UIAlertActionStyle.Default : 0, UIAlertActionStyle.Cancel : 1, UIAlertActionStyle.Destructive : 2]
    
    @IBOutlet var actionName: UITextField!
    @IBOutlet var actionTypeSwitch: UISegmentedControl!
    
    var boundActionInfo: ActionInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        actionName.addTarget(self, action: #selector(didChangeText), forControlEvents: .EditingChanged)
        actionTypeSwitch.addTarget(self, action: #selector(didChangeType), forControlEvents: .ValueChanged)
    }
    
    func didChangeText() {
        boundActionInfo?.title = actionName.text
    }
    
    func didChangeType() {
        boundActionInfo?.style = WindowAlertActionPreferencesTableViewCell.segmentStyleMap[actionTypeSwitch.selectedSegmentIndex]!
    }
    
}

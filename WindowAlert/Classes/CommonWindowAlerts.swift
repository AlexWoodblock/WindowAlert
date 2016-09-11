//
//  CommonWindowAlerts.swift
//  Pods
//
//  Created by Александр on 5/27/16.
//
//

import UIKit

extension WindowAlert {
    
    /**
     Creates and returns WindowAlert object with single action and style set to Alert.
     - parameter title: Title of the alert.
     - parameter message: Message of the alert.
     - parameter actionTitle: Title for the action button.
     - returns: New WindowAlert object or nil if app delegate or main window is missing.
    */
    public class func singleActionAlert(title: String, message: String?, actionTitle: String) -> WindowAlert? {
        let alert = WindowAlert(title: title, message: message, preferredStyle: .alert)
        alert?.add(action: WindowAlertAction(title: actionTitle, style: .default, handler: nil))
        return alert
    }
    
    /**
     Creates and returns WindowAlert object with single action and style set to Alert.
     - parameter title: Title of the alert.
     - parameter message: Message of the alert.
     - parameter actionTitle: Title for the action button.
     - parameter tintColor: Tint color for alert. If nil, then default tint color will be used.
     - parameter frame: Size and position of window that contains alert controller. In most cases it should be the same as screen frame or main application window frame.
     - returns: New WindowAlert object.
     */
    public class func singleActionAlert(title: String, message: String?, actionTitle: String, tintColor: UIColor?, frame: CGRect) -> WindowAlert {
        let alert = WindowAlert(title: title, message: message, preferredStyle: .alert, tintColor: tintColor, frame: frame)
        
        alert.add(action: WindowAlertAction(title: actionTitle, style: .default, handler: nil))
        
        return alert
    }
    
    /**
     Creates and returns WindowAlert object with single action and style set to Alert.
     - parameter title: Title of the alert.
     - parameter message: Message of the alert.
     - parameter actionTitle: Title for the action button.
     - parameter referenceWindow: Window to inherit size and tint color from.
     - returns: New WindowAlert object.
     */
    public class func singleActionAlert(title: String, message: String?, actionTitle: String, referenceWindow: UIWindow) -> WindowAlert {
        let alert = WindowAlert(title: title, message: message, preferredStyle: .alert, referenceWindow: referenceWindow)
        alert.add(action: WindowAlertAction(title: actionTitle, style: .default, handler: nil))
        return alert
    }
    
}

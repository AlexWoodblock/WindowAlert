//
//  CommonWindowAlerts.swift
//  Pods
//
//  Created by Александр on 5/27/16.
//
//

import UIKit

extension WindowAlert {
    
    public class func singleActionAlert(title: String, message: String, actionTitle: String) -> WindowAlert? {
        let alert = WindowAlert(title: title, message: message, preferredStyle: .Alert)
        alert?.addAction(WindowAlertAction(title: title, style: .Default, handler: nil))
        return alert
    }
    
    public class func singleActionAlert(title: String, message: String, actionTitle: String, tintColor: UIColor, frame: CGRect) -> WindowAlert {
        let alert = WindowAlert(title: title, message: message, preferredStyle: .Alert, tintColor: tintColor, frame: frame)
        
        alert.addAction(WindowAlertAction(title: title, style: .Default, handler: nil))
        
        return alert
    }
    
    public class func singleActionAlert(title: String, message: String, actionTitle: String, referenceWindow: UIWindow) -> WindowAlert {
        let alert = WindowAlert(title: title, message: message, preferredStyle: .Alert, referenceWindow: referenceWindow)
        alert.addAction(WindowAlertAction(title: title, style: .Default, handler: nil))
        return alert
    }
    
}

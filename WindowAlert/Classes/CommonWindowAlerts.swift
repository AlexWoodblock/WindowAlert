import UIKit

/**
 Extensions for convenience initializers of WindowAlert.
 */
extension WindowAlert {
    /**
     Creates and returns WindowAlert object with single action and style set to Alert.
     - parameter title: Title of the alert.
     - parameter message: Message of the alert or nil if no message is needed.
     - parameter singleActionTitle: Title for the action button.
     - returns: New WindowAlert object. Will crash  if app delegate or main window is missing. This will not happen normally unless you try to initialize this object very early in the app lifecycle.
    */
    public convenience init(title: String, message: String? = nil, singleActionTitle: String) {
        self.init(title: title, message: message, preferredStyle: .alert)!
        
        add(action: WindowAlertAction(title: singleActionTitle, style: .default, handler: nil))
    }
    
}

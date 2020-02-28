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
     - returns: New WindowAlert object. Will crash if app delegate or main window is missing. This will not happen normally unless you try to initialize this object very early in the app lifecycle.
    */
    public convenience init(title: String?, message: String? = nil, singleActionTitle: String) {
        self.init(title: title, message: message, preferredStyle: .alert)
        
        add(action: WindowAlertAction(title: singleActionTitle, style: .default, handler: nil))
    }
    
    /**
     Creates and returns new alert with specified title, message, style and reference window.
     - parameter title: Title for the alert.
     - parameter message: Message for the alert.
     - parameter preferredStyle: Preferred style for the alert.
     - parameter referenceWindow: Window to inherit size and tint color from.
     - returns: New WindowAlert object.
     */
    public convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, referenceWindow: UIWindow) {
        let tint: UIColor? = referenceWindow.tintColor
        self.init(title: title, message: message, preferredStyle: preferredStyle, tintColor: tint, frame: referenceWindow.frame)
    }
    
    /**
     Tries to create and returns new alert with specified title, message, style and main application window
     taken from app delegate as reference window. May fail if main application window or app delegate is missing.
     - parameter title: Title for the alert.
     - parameter message: Message for the alert.
     - parameter preferredStyle: Preferred style for the alert.
     - returns: New WindowAlert object. Will crash if app delegate or main window is missing. This will not happen normally unless you try to initialize this object very early in the app lifecycle.
     */
    public convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style) {
        let delegate = UIApplication.shared.delegate!
        let window = delegate.window!!
        
        self.init(title: title, message: message, preferredStyle: preferredStyle, referenceWindow: window)
    }
    
}

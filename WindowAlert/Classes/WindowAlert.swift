import Foundation
import UIKit

/**
 WindowAlertDelegate protocol defines method that allow objects conforming to this protocol to be notified
 when WindowAlert object is being hidden or shown.
 */
public protocol WindowAlertDelegate {
    
    /**
     Tells the delegate that alert will soon be shown.
     - parameter windowAlert: alert to be shown.
     */
    func windowAlertWillShow(windowAlert alert: WindowAlert)
    
    /**
     Tells the delegate that alert was shown to user.
     - parameter windowAlert: alert that was shown.
     */
    func windowAlertDidShow(windowAlert alert: WindowAlert)
    
    /**
     Tells the delegate that alert will soon be hidden.
     - parameter windowAlert: alert to be hidden.
     */
    func windowAlertWillHide(windowAlert alert: WindowAlert)
    
    /**
     Tells the delegate that alert was hidden.
     - parameter windowAlert: alert that was hidden.
     */
    func windowAlertDidHide(windowAlert alert: WindowAlert)
}

/**
 WindowAlert is a helper object that wraps UIAlertController and UIWindow classes to simplify UIAlertController presentation logic.
 It creates new UIWindow at UIWindowLevelAlert window level(or another one,
 if you wish to redefine it via defaultWindowLevel property of WindowAlert class),
 and sets empty root UIViewController to present UIAlertController from it.
 
 This class uses APIs very similar to UIViewController APIs, but instead of presenting you'll have to call show() method, which makes it
 somewhat similar to UIAlertView.
 
 This class is not thread-safe, calling it's method from threads different from main one will lead
 to weird and buggy behavior.
 */
// TODO: make title optional
public class WindowAlert {
    
    /**
     Default window level for UIWindow that holds UIAlertController.
     Only change this value if you want to change WindowAlert window level globally,
     for per-alert basis please use windowLevel property of WindowAlert.
     */
    public static var defaultWindowLevel: UIWindow.Level = {
        #if swift(>=5.0)
        return UIWindow.Level.alert
        #else
        return UIWindowLevelAlert
        #endif
    }()
    
    /**
     Window level for UIWindow that holds UIAlertController.
     Changing this won't have any effect on alert if it's already visible, so set it before calling show()
     or hide and re-show alert after changing this value.
     */
    public var windowLevel = WindowAlert.defaultWindowLevel
    
    /**
     Set this value to true if you want WindowAlert to be hidden when user taps outside of UIAlertController.
     This is disabled by default as it goes against default behavior of UIAlertController, but can be useful if you want to display dismissable UIAlertController without buttons.
     */
    public var hideOnTapOutside = false
    
    /**
     The actions that user can invoke for this WindowAlert.
     */
    public private(set) var actions: [WindowAlertAction]
    
    /**
     Alert delegate that will receive reports for this alert visibility.
     */
    public var delegate: WindowAlertDelegate?
    
    private var textFieldConfigurationHandlers: [((UITextField) -> Void)?]
    
    private var storedTitle: String?
    
    /**
     The title of the alert.
     */
    public var title: String? {
        get {
            return storedTitle
        }
        
        set(newTitle) {
            storedTitle = newTitle
            alertController?.title = newTitle
        }
    }
    
    private var storedMessage: String?
    
    /**
     The message of the alert.
     */
    public var message: String? {
        get {
            return storedMessage
        }
        
        set(newMessage) {
            storedMessage = newMessage
            alertController?.message = newMessage
        }
    }
    
    private var storedPreferredStyle: UIAlertController.Style
    
    /**
     Preferred style of the alert.
     */
    public var preferredStyle: UIAlertController.Style {
        get {
            return storedPreferredStyle
        }
    }
    
    /**
     The array of text fields displayed by the alert.
     */
    public var textFields: [UITextField]? {
        get {
            return alertController?.textFields
        }
    }
    
    /**
     Holds true if UIWindow that holds UIAlertController, and UIAlertController itself is added to window hierarchy and is visible,
     otherwise false.
     */
    public var visible: Bool {
        get {
            if let window = self.internalWindow {
                return !window.isHidden
            }
            
            //if internalWindow is nil, then it can't be visible, returning false
            return false
        }
    }
    
    fileprivate var internalWindow: TapAwareWindow?
    fileprivate var alertController: UIAlertController?
    private let rootViewController = StatusBarStyleInheritingViewController()
    
    private var internalWindowTintColor: UIColor?
    private var internalWindowFrame: CGRect
    
    /**
     Creates and returns new alert with specified title, message, style, tint color and window size.
     - parameter title: Title for the alert.
     - parameter message: Message for the alert.
     - parameter preferredStyle: Preferred style for the alert.
     - parameter tintColor: Tint color for alert. If nil, then default tint color will be used.
     - parameter frame: Size and position of window that contains alert controller. In most cases it should be the same as screen frame or main application window frame.
     - returns: New WindowAlert object.
     */
    public init(title: String?, message: String?, preferredStyle: UIAlertController.Style, tintColor: UIColor?, frame: CGRect) {
        actions = []
        textFieldConfigurationHandlers = []
        
        storedPreferredStyle = preferredStyle
        storedTitle = title
        storedMessage = message
        internalWindowFrame = frame
        internalWindowTintColor = tintColor
    }
    
    private func createNewWindow() {
        internalWindow = TapAwareWindow(frame: internalWindowFrame)
        
        //safe to unwrap, since, well, we just created it
        internalWindow!.tintColor = internalWindowTintColor
        internalWindow!.windowLevel = windowLevel
        internalWindow!.rootViewController = rootViewController
        
        var clearableStrongSelf: WindowAlert? = self //this is needed to keep reference to self inside of closure until it's called
        internalWindow!.actionOnTap = { touch in
            guard let strongSelf = clearableStrongSelf, strongSelf.hideOnTapOutside else {
                return
            }
            
            guard let controller = strongSelf.alertController else {
                strongSelf.hide()
                return
            }
            
            let locationInView = touch.location(in: nil) //pass nil to get location in window
            if !controller.view.frame.contains(locationInView) {
                strongSelf.hide()
                clearableStrongSelf = nil
            }
        }
    }
    
    private func createAlertController() {
        alertController = UIAlertController(title: storedTitle, message: storedMessage, preferredStyle: storedPreferredStyle)
        
        //safe to unwrap since we just created it
        for action in actions {
            alertController!.addAction(action.asUiAlertAction(in: self))
        }
        
        for textFieldConfigurationHandler in textFieldConfigurationHandlers {
            alertController!.addTextField(configurationHandler: textFieldConfigurationHandler)
        }
    }
    
    /**
     Add new window to window hieararchy at set window level, and present UIAlertController
     on top of invisible root view controller attached to this new window.
     - returns: True if UIAlertController was presented, false otherwise(was already presented, or reference window is missing)
     */
    @discardableResult
    public func show() -> Bool {
        if visible {
            return false
        }
        
        delegate?.windowAlertWillShow(windowAlert: self)
        
        createNewWindow()
        createAlertController()
        
        //at this point alertController is not nil thanks to createAlertController(), so it's safe to unwrap alertController
        //and it's also safe to unwrap internalWindow, since createNewWindow() takes care of it's creation
        internalWindow!.makeKeyAndVisible()
        internalWindow!.rootViewController!.present(alertController!, animated: true, completion: {
            self.delegate?.windowAlertDidShow(windowAlert: self)
        })
        
        return true
    }
    
    
    /**
     Removes window from window hierarchy and dismisses UIAlertController.
     - returns: True if was hidden successfully, false if tried to hide already hidden alert.
     */
    @discardableResult
    public func hide() -> Bool {
        //if WindowAlert is already hidden, no need to proceed
        if !visible {
            return false
        }
        
        guard let window = internalWindow else {
            return false
        }
        
        delegate?.windowAlertWillHide(windowAlert: self)
        
        window.rootViewController!.dismiss(animated: true, completion: {
            self.onHide()
        })
        
        return true
    }
    
    /**
     Attaches an action to this WindowAlert.
     Please remember not to call hide() inside of action handler, as WindowAlert will
     hide automatically when action is invoked.
     - parameter action: Action to add to the alert.
     */
    public func add(action: WindowAlertAction) {
        actions.append(action)
        
        if let alertController = alertController {
            alertController.addAction(action.asUiAlertAction(in: self))
        }
    }
    
    /**
     Adds a text field to an alert.
     - parameter configurationHandler: Action to be invoked with UITextField as argument before
     showing alert to the user. Use this action to configure UITextField parameters.
     */
    public func addTextField(configurationHandler: ((UITextField) -> Void)?) {
        textFieldConfigurationHandlers.append(configurationHandler)
        alertController?.addTextField(configurationHandler: configurationHandler)
    }
    
    fileprivate func onHide() {
        internalWindow?.isHidden = true
        internalWindow?.removeFromSuperview()
        internalWindow?.actionOnTap = nil
        internalWindow = nil
        
        alertController = nil
        
        delegate?.windowAlertDidHide(windowAlert: self)
    }
}

fileprivate extension WindowAlertAction {
    
    private static let imageKey = "image"
    private static let titleTextAlignmentKey = "_titleTextAlignment"
    
    func asUiAlertAction(in windowAlert: WindowAlert) -> UIAlertAction {
        var selfReference: WindowAlert? = windowAlert
        
        let actualAction = action
        let alertAction = UIAlertAction(title: title, style: style) { _ in
            actualAction?(self)
            
            //no need to dismiss UIAlertController, as it's automatically dismissed
            selfReference?.onHide()
            
            //now onto preventing retain cycle
            selfReference = nil
        }
        
        if let image = image {
            if alertAction.responds(to: Selector(WindowAlertAction.imageKey)) {
                alertAction.setValue(image, forKey: WindowAlertAction.imageKey)
            } else {
                NSLog("%@", "Unfortunately, image could not be added to action. If you see this message, please contact the maintainer of WindowAlert.")
            }
        }
        
        if let titleAlignment = titleAlignment {
            if alertAction.responds(to: Selector(WindowAlertAction.titleTextAlignmentKey)) {
                alertAction.setValue(titleAlignment.rawValue, forKey: WindowAlertAction.titleTextAlignmentKey)
            } else {
                NSLog("%@", "Unfortunately, title text alignment could not be applied to action. If you see this message, please contact the maintainer of WindowAlert.")
            }
        }
        
        return alertAction
    }
    
}

// big thanks to https://github.com/ButterflyNetwork for the idea!
fileprivate class StatusBarStyleInheritingViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIApplication.shared.statusBarStyle
    }
    
}

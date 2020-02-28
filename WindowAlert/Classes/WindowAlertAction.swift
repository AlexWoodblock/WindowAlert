import Foundation

/**
 WindowAlertAction describes single action that will be shown in WindowAlert.
 This objects describes action configuration, such as title of the action,
 it's style and behavior when tapping on button corresponding to this action.
 Please note that you must not call WindowAlert hide() method in WindowAlertAction handler,
 as WindowAlert will be hidden automatically after action invocation.
 */
public struct WindowAlertAction {
    
    /**
     Creates and returns action with specified indentifier, title, style and action handler.
     - parameter id: Unique identifier for current action.
     - parameter title: Text that will be displayed on action button. Must be localized.
     - parameter style: Action button style.
     - parameter handler: Action to execute when action button will be selected.
     - parameter image: Image for the action. Depends on Apple internal implementation, so it may stop working without notice on iOS update.
     - parameter titleAlignment: Title alignment for the action. Depends on Apple internal implementation, so it may stop working without notice on iOS update.
     - returns: New WindowAlertAction object.
     */
    public init(
        id: String? = nil,
        title: String,
        style: UIAlertAction.Style,
        image: UIImage? = nil,
        titleAlignment: NSTextAlignment? = nil,
        handler: ((WindowAlertAction) -> Void)? = nil
    ) {
        self.id = id
        self.title = title
        self.style = style
        self.image = image
        self.titleAlignment = titleAlignment
        self.action = handler
    }
    
    /**
     Unique string identifier for this action.
     */
    public let id: String?
    
    /**
     Title that will be displayed on corresponding button.
     */
    public let title: String
    
    /**
     Style for WindowAlertAction. All the styles that are supported in UIAlertAction are also supported here.
     */
    public let style: UIAlertAction.Style
    
    /**
     Image for the action. Depends on Apple internal implementation, so it may stop working without notice on iOS update.
     */
    public let image: UIImage?
    
    /**
    Title alignment for the action. Depends on Apple internal implementation, so it may stop working without notice on iOS update.
     */
    public let titleAlignment: NSTextAlignment?
    
    internal let action: ((WindowAlertAction) -> Void)?
}



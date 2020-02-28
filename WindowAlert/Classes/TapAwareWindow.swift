import UIKit

/**
 UIWindow that checks every event it gets, and if it's a touch,
 call all the closures stored in actionOnTap field.
 This class is needed to avoid using UITapGestureRecognizer with WindowAlert as target, as
 WindowAlert gets deallocated, thus no tap callback is being run.*/
internal class TapAwareWindow: UIWindow {
    
    typealias TapAction = (UITouch) -> (Void)
    var actionOnTap: TapAction?
    
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        
        guard let touches = event.touches(for: self), let tapAction = actionOnTap else {
            return
        }
        
        for touch in touches where touch.phase == .ended && touch.tapCount == 1 {
            tapAction(touch)
        }
    }
}

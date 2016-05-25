//
//  TapAwareWindow.swift
//  Pods
//
//  Created by Александр on 5/25/16.
//
//

import UIKit

/**INTERNAL, DO NOT USE.
 UIWindow that checks every event it gets, and if it's a touch,
 call all the closures stored in actionOnTap field.
 This class is needed to avoid using UITapGestureRecognizer with WindowAlert as target, as
 WindowAlert gets deallocated, thus no tap callback is being run.*/
class TapAwareWindow: UIWindow {
    
    typealias TapAction = (UITouch) -> (Void)
    var actionOnTap: TapAction?
    
    override func sendEvent(event: UIEvent) {
        super.sendEvent(event)
        
        guard let touches = event.touchesForWindow(self), tapAction = actionOnTap else {
            return
        }
        
        for touch in touches {
            guard touch.phase == .Ended && touch.tapCount == 1 else {
                continue
            }
            
            tapAction(touch)
        }
    }
}

//
//  DebugGestureRecognizer.swift
//  EchoBooking
//
//  Created by Pavel Volkhin on 27.11.2019.
//  Copyright © 2019 Magenta Technology. All rights reserved.
//

import Foundation

public class DebugGestureRecognizer: UIGestureRecognizer {
    public var numberOfTouchesRequired = 4
    public var gestureAction : (()->())?

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if ((event.allTouches?.count ?? 0) == self.numberOfTouchesRequired)
        {
            self.state = .recognized
            self.gestureAction?();
            return
        }
        self.state = .failed
    }
}

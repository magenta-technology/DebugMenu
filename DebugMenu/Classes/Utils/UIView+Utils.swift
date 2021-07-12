//
//  UIView+Utils.swift
//  EchoBooking
//
//  Created by Pavel Volkhin on 28.11.2019.
//  Copyright © 2019 Magenta Technology. All rights reserved.
//

import Foundation

extension UIView {
    func isSubviewsExistByIdentifier(by identifier: String) -> UIView? {
        var stack: [UIView] = []
        stack.append(self)
        while let view = stack.popLast() {
            if view.accessibilityIdentifier == identifier {
                    return view
            }
            stack.append(contentsOf: view.subviews)
        }
        return nil
    }
}

//
//  UIViewController+Utils.swift
//  EchoBooking
//
//  Created by Pavel Volkhin on 27.11.2019.
//  Copyright © 2019 Magenta Technology. All rights reserved.
//

import Foundation

extension UIViewController {
    public class var identifier: String {
        return String(describing: self)
    }
}

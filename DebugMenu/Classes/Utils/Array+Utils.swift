//
//  Array+Ytils.swift
//  EchoBooking
//
//  Created by Pavel Volkhin on 29.11.2019.
//  Copyright © 2019 Magenta Technology. All rights reserved.
//

import Foundation

extension Array {
    public func atIndex(_ index: Int) -> Element? {
        if index < 0 || index >= self.count {
            return nil
        }
        return self[index]
    }
}

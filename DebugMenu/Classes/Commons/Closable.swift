//
//  Closable.swift
//  EchoBooking
//
//  Created by Pavel Volkhin on 29.11.2019.
//  Copyright © 2019 Magenta Technology. All rights reserved.
//

import Foundation

@objc public protocol Closable {
    var closeAfterSelect: Bool { get set }
    var close: (()-> (Void))? { get set }
}

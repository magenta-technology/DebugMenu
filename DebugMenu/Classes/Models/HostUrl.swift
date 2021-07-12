//
//  HostUrl.swift
//  DebugMenu
//
//  Created by Pavel Volkhin on 09.12.2019.
//

import Foundation

@objc public class HostUrl: NSObject {
    @objc public let name: String
    @objc public let url: String
    
    @objc public init(name: String,
                      url: String) {
        self.name = name
        self.url = url
        super.init()
    }
}

//
//  Credential.swift
//  DebugMenu
//
//  Created by Pavel Volkhin on 09.12.2019.
//

import Foundation

@objc public class Credential: NSObject {
    @objc public let username: String
    @objc public let password: String
    @objc public let account: String?

    @objc public init(username: String,
                      password: String,
                      account: String?) {
        self.username = username
        self.password = password
        self.account = account
        super.init()
    }
}

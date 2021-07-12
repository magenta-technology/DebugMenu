//
//  AppDelegate.swift
//  DebugMenuExampleApp
//
//  Created by Pavel Volkhin on 02.12.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import DebugMenu
import Fingertips

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? = MBFingerTipWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DebugMenuManager.setup()
        DebugMenuManager.shared.add(title: "Custom") {
            return CustomizeController()
        }
        KeyChainUtils.setDefaultGroupIfNeeded()
        DebugMenuManager.shared.add(title: "templates") {
            let controller = TemplatesController()
            controller.add(title: "username",
                           desc: "username password",
                           parentidentifier: nil,
                           identifierWithValues: [:])
            controller.onViewDidLoadUpdate = {
                let fromKeyChain = KeyChainUtils.getRecentCredentialForUrl(urlString: "http://localhost")
                fromKeyChain.forEach { cred in
                    controller.add(title: "fromKeyChain",
                                    desc: "\(cred.username) \(cred.password) \(cred.account ?? "")",
                                    parentidentifier: nil,
                                    identifierWithValues: ["username": cred.username,
                                                           "password": cred.password,
                                                           "account": cred.account ?? ""])
                }
            }
            return controller
        }
        DebugMenuManager.shared.add(title: "servers") {
            let controller = ServersController()
            var serversList: [HostUrl] = [HostUrl(name: "QA_26", url: "192.0.2.26")]
            serversList.append(contentsOf: KeyChainUtils.getRecentUrls())
            controller.serversList = serversList
            controller.defaultServer = {
                return HostUrl(name: "Prod", url: "http://prod")
            }
            controller.currentServer = {
                return HostUrl(name: "Current", url: "http://localhost")
            }
            return controller
        }
        self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "ViewController")
        self.window?.makeKeyAndVisible()
        return true
    }
}


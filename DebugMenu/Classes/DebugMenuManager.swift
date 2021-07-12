//
//  DebugMenuManager.swift
//  EchoBooking
//
//  Created by Pavel Volkhin on 28.11.2019.
//  Copyright © 2019 Magenta Technology. All rights reserved.
//

import Foundation

@objc public class DebugMenuManager: NSObject {
    @objc public static let shared = DebugMenuManager()

    private override init() {
        super.init()
    }

    @objc public class func setup() {
        guard let window = UIApplication.shared.delegate?.window ?? nil else {
            return
        }

        let gestureRecognizer = DebugGestureRecognizer(target: nil, action: nil)
        gestureRecognizer.gestureAction = {
            if MainDebugController.instance != nil {
                return
            }
            let mainDebugController = MainDebugController()
            mainDebugController.controllers = shared.controllers
            MainDebugController.instance = mainDebugController
            mainDebugController.view.frame = window.rootViewController?.view.bounds ??
                CGRect(x: 0, y: 0, width: 100, height: 100)
            window.addSubview(mainDebugController.view)
        }
        gestureRecognizer.numberOfTouchesRequired = 4
        window.addGestureRecognizer(gestureRecognizer)
    }

    @objc public func add(title: String, initController: @escaping (() -> UIViewController)) {
        controllers.append((title, initController))
    }

    private var controllers: [(title: String, initController: (() -> UIViewController))] = []
}

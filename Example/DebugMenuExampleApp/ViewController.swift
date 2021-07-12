//
//  ViewController.swift
//  DebugMenuExampleApp
//
//  Created by Pavel Volkhin on 02.12.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import DebugMenu

class ViewController: UIViewController {
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var account: UITextField!
    @IBOutlet var server: UITextField!
    @IBOutlet var login: UIButton!
    @IBOutlet var setServer: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginTapped() {
        KeyChainUtils.setRecentCredential(credential: Credential(username: username.text ?? "",
                                                                 password: password.text ?? "",
                                                                 account: account.text),
                                          urlString: "http://localhost")
    }
    
    @IBAction func setServerTapped() {
        KeyChainUtils.saveRecentUrl(hostUrl: HostUrl(name: "test2", url: server.text ?? ""))
    }
}


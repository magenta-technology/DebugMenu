//
//  CustomController.swift
//  EchoBooking
//
//  Created by Pavel Volkhin on 28.11.2019.
//  Copyright © 2019 Magenta Technology. All rights reserved.
//

import Foundation
import Fingertips
import netfox

@objc public class CustomizeController: DebugViewController {
    @IBOutlet var tableView: UITableView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private let cellIdentifier = "customize_cell"
}
extension CustomizeController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        if indexPath.row == 0 {
            if let window = (UIApplication.shared.delegate?.window ?? nil) as? MBFingerTipWindow {
                cell.textLabel?.text = window.alwaysShowTouches ? "Hide touches" : "Show touches"
            } else {
                cell.textLabel?.text = "disabled touches"
            }
        }
        if indexPath.row == 1 {
            cell.textLabel?.text = NFX.sharedInstance().isStarted()  ? "Netfox is active. Just shake it!!!" : "Netfox isn't active"
        }
        return cell
    }
}


extension CustomizeController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false);
        if indexPath.row == 0 {
            if let window = (UIApplication.shared.delegate?.window ?? nil) as? MBFingerTipWindow {
                window.alwaysShowTouches = !window.alwaysShowTouches
            }
        }
        if indexPath.row == 1 {
            if NFX.sharedInstance().isStarted() {
                NFX.sharedInstance().stop()
            } else {
                NFX.sharedInstance().start()
            }
        }
        tableView.reloadData()
    }
}

//
//  ServersController.swift
//  EchoBooking
//
//  Created by Pavel Volkhin on 27.11.2019.
//  Copyright © 2019 Magenta Technology. All rights reserved.
//

import Foundation

@objc public class ServersController: DebugViewController, Closable {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var urlLabel: UILabel!
    
    @objc public var serversList: [HostUrl] = []
    @objc public var defaultServer: (() -> (HostUrl))?
    @objc public var currentServer: (() -> (HostUrl))?
    @objc public var serverDidChange: ((String) -> (Void))?
    
    public var closeAfterSelect: Bool = true
    public var close: (() -> (Void))?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let hostUrl = currentServer?() ?? HostUrl(name: "", url: "")
        nameLabel.text = hostUrl.name
        urlLabel.text = hostUrl.url
        servers = serversList
        if let defaultServer = defaultServer {
            servers.append(defaultServer())
        }
        tableView.reloadData()
    }
    
    private let cellIdentifier = "server_cell"
    private var servers = [HostUrl]()
}

extension ServersController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers.count;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        let hostUrl = servers[indexPath.row]
        cell.textLabel?.text = hostUrl.name
        cell.detailTextLabel?.text = hostUrl.url
        return cell
    }
}

extension ServersController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let hostUrl = servers[indexPath.row]
        serverDidChange?(hostUrl.url)
        if closeAfterSelect {
            close?()
        } else {
            nameLabel.text = hostUrl.name
            urlLabel.text = hostUrl.url
        }
    }
}

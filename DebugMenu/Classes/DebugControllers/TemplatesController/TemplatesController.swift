//
//  TemplatesController.swift
//  EchoBooking
//
//  Created by Pavel Volkhin on 27.11.2019.
//  Copyright © 2019 Magenta Technology. All rights reserved.
//

import Foundation

struct TemplateItem {
    let title: String
    let desc: String?
    let parentidentifier: String?
    let identifierWithValues: [String: String]
}

@objc public class TemplatesController: DebugViewController, Closable {
    @IBOutlet var tableView: UITableView!
    
    @objc public var closeAfterSelect: Bool = true
    @objc public var onViewDidLoadUpdate: (() -> Void)?
    @objc public var close: (() -> (Void))?

    override public func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoadUpdate?()
        tableView.reloadData()
    }

    @objc public func add(title: String, desc: String?, parentidentifier: String?,
                          identifierWithValues: [String: String]) {
        rows.append(TemplateItem(title: title,
                                 desc: desc,
                                 parentidentifier: parentidentifier,
                                 identifierWithValues: identifierWithValues))
    }

    @objc public func remove(by title: String) {
        rows.removeAll(where: { $0.title == title })
    }

    private func setValuesByIndexPath (by indexPath: IndexPath) {
        let item = rows[indexPath.row]
        let window = UIApplication.shared.delegate?.window ?? nil
        if let parentIdentifier = item.parentidentifier {
            if let parent = window?.isSubviewsExistByIdentifier(by: parentIdentifier) {
            findTextFieldsWithSetValue(view: parent, identifierWithValues: item.identifierWithValues)
            }
        } else {
            findTextFieldsWithSetValue(view: window,
                                       identifierWithValues: item.identifierWithValues)
        }
    }

    private func findTextFieldsWithSetValue(view: UIView?, identifierWithValues: [String: String]) {
        if view == nil {
            return
        }
        identifierWithValues.forEach { (identifier, value) in
            if let textField = view?.isSubviewsExistByIdentifier(by: identifier) as? UITextField {
                textField.insertText(value)
            }
        }
    }

    private let cellIdentifier = "template_identifier"
    private var rows: [TemplateItem] = []
}

extension TemplatesController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        let item = rows[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.desc
        return cell
    }
}

extension TemplatesController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false);
        setValuesByIndexPath(by: indexPath)
        if closeAfterSelect {
            close?()
        }
    }
}

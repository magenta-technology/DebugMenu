//
//  DebugViewController.swift
//  DebugMenu
//
//  Created by Pavel Volkhin on 02.12.2019.
//

import Foundation

public class DebugViewController: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: Self.identifier,
                   bundle: Bundle(identifier: String.debugMenuBundle()))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

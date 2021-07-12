//
//  MainDebugController.swift
//  EchoBooking
//
//  Created by Pavel Volkhin on 27.11.2019.
//  Copyright © 2019 Magenta Technology. All rights reserved.
//

import Foundation

@objc public class MainDebugController: DebugViewController {
    public static var instance: MainDebugController? = nil
    @IBOutlet public var containerView: UIView!
    @IBOutlet public var scrollView: UIScrollView!
    @IBOutlet public var navItem: UINavigationItem!
    @IBOutlet public var stackView: UIStackView!
    
    var controllers: [(title: String, initController: (() -> UIViewController))] = []

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                            target: self,
                                            action: #selector(backButtonAction))
        self.navItem.leftBarButtonItem = backBarButton

        self.scrollView.backgroundColor = UIColor.gray
        self.view.backgroundColor = UIColor.black
        self.containerView.backgroundColor = UIColor.gray
        self.containerView.translatesAutoresizingMaskIntoConstraints = false

        createButtons()
        if !controllers.isEmpty {
            self.selectFirstController()
        }
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.containerView.subviews.forEach { view in
            view.frame = self.containerView.bounds
        }
    }
}

fileprivate extension MainDebugController {
    func createButtons() {
        controllers.forEach { (title, _) in
            let button = UIButton()
            button.backgroundColor = .gray
            button.setTitleColor(.white, for: .normal)
            button.setTitle(title, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self,
                             action: #selector(buttonClick),
                             for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc func buttonClick(sender: UIButton) {
        if let forInit = controllers.first(where: { (title, _) -> Bool in
            title == sender.title(for: .normal)
        }) {
            self.setChildController(viewController: forInit.initController())
            self.selectButton(title: forInit.title)
        }
    }
    
    @objc func backButtonAction() {
        DispatchQueue.main.async { () -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
            MainDebugController.instance = nil;
        }
    }
    
    func setChildController(viewController: UIViewController) {
        self.children.forEach { child in
            child.removeFromParent()
        }
        self.containerView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        if let closable = viewController as? Closable {
            closable.close = backButtonAction
        }
        self.addChild(viewController)
        self.containerView.addSubview(viewController.view)
        DebugUtils.addFullSizeConstraints(toView: viewController.view)
    }

    func selectButton(title: String) {
        for button in self.stackView.arrangedSubviews where button is UIButton
        {
            if let button = button as? UIButton {
                button.setTitleColor(button.title(for: .normal) == title ? .green : .white, for: .normal)
            }
        }
    }
    
    func selectFirstController() {
        let controller = controllers.first?.initController() ?? UIViewController()
        self.setChildController(viewController: controller)
        self.selectButton(title: controllers.first?.title ?? "")
    }
}

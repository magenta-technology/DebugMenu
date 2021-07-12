//
//  DebugUtils.swift
//  EchoBooking
//
//  Created by Pavel Volkhin on 27.11.2019.
//  Copyright © 2019 Magenta Technology. All rights reserved.
//

import Foundation

class DebugUtils {
    public class func findTopMostView<ViewType : UIView>(forView: UIView, point: CGPoint, viewType : (ViewType.Type)?) -> UIView? {
        var result : UIView?
        for i in (0..<forView.subviews.count).reversed()
        {
            let subview = forView.subviews[i]
            if !subview.isHidden && subview.frame.contains(point) {
                if viewType != nil && subview is ViewType {
                    return subview
                }
                result = self.findTopMostView(forView: subview, point: forView.convert(point, to: subview), viewType : viewType)
                if result != nil {
                    break
                }
            }
        }
        result = result ?? forView

        if viewType != nil {
            if result is ViewType {
                return result
            }
            else {
                return nil
            }
        }
        else {
            return result;
        }
    }
    
    public class func addFullSizeConstraints(toView: UIView) {
        toView.translatesAutoresizingMaskIntoConstraints = false;
        let dict = ["view": toView]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", metrics: nil, views: dict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", metrics: nil, views: dict))
    }
    
    public class func topMostController() -> UIViewController? {
        guard let window = UIApplication.shared.delegate?.window ?? nil else
        {
            return nil
        }

        for subviews in window.subviews
        {
            let view = DebugUtils.findTopMostView(forView: subviews, point: CGPoint(x: 100, y: 100), viewType: nil)

            var responder = view as UIResponder?
            while true
            {
                guard let r = responder else
                {
                    break
                }
                responder = r.next

                if responder is UIViewController {
                    return responder as? UIViewController;
                }
            }
        }
        return nil;
    }
    
    public class func getServersWithVersions(servers: [String]) -> [String] {
        let withVersion = servers
        return withVersion
    }
}

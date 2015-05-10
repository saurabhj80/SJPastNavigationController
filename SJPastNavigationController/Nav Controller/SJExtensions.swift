//
//  SJExtensions.swift
//  SJPastNavigationController
//
//  Created by Saurabh Jain on 5/9/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func snapshotView() -> UIImage? {
        
        if let window = UIApplication.sharedApplication().windows.first as? UIWindow {
            
            UIGraphicsBeginImageContextWithOptions(window.frame.size, false, 1.0)
            window.drawViewHierarchyInRect(window.bounds, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        
        return nil
    }
    
}


extension UIView {
    
    // Auto adds the subView to self
    func pinSubView(subView: UIView, top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        
        subView.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(subView)
        
        addAttribute(.Top, toSubView: subView, constant: top)
        addAttribute(.Bottom, toSubView: subView, constant: bottom)
        addAttribute(.Left, toSubView: subView, constant: left)
        addAttribute(.Right, toSubView: subView, constant: right)
        
    }
    
    private func addAttribute(attribute: NSLayoutAttribute, toSubView: UIView, constant: CGFloat) {
        addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .Equal, toItem: toSubView, attribute: attribute, multiplier: 1.0, constant: constant))
    }
    
}

//
//  NSLayoutConstraint+Fit.swift
//  SAHistoryNavigationViewController
//
//  Created by 鈴木大貴 on 2015/03/26.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

extension NSLayoutConstraint {
    class func applyAutoLayout(superview: UIView, target: UIView, top: Float?, left: Float?, right: Float?, bottom: Float?, height: Float?, width: Float?) {
        
        target.setTranslatesAutoresizingMaskIntoConstraints(false)
        superview.addSubview(target)
        
        var verticalFormat = "V:"
        if let top = top {
            verticalFormat += "|-(\(top))-"
        }
        verticalFormat += "[target"
        if let height = height {
            verticalFormat += "(\(height))"
        }
        verticalFormat += "]"
        if let bottom = bottom {
            verticalFormat += "-(\(bottom))-|"
        }
        
        let verticalConstrains = NSLayoutConstraint.constraintsWithVisualFormat(verticalFormat, options: nil, metrics: nil, views: [ "target" : target ])
        superview.addConstraints(verticalConstrains)
        
        var horizonFormat = "H:"
        if let left = left {
            horizonFormat += "|-(\(left))-"
        }
        horizonFormat += "[target"
        if let width = width {
            horizonFormat += "(\(width))"
        }
        horizonFormat += "]"
        if let right = right {
            horizonFormat += "-(\(right))-|"
        }
        let horizonConstrains = NSLayoutConstraint.constraintsWithVisualFormat(horizonFormat, options: nil, metrics: nil, views: [ "target" : target ])
        superview.addConstraints(horizonConstrains)
    }
}

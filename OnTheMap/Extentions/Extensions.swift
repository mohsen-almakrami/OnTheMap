//
//  Extensions.swift
//  OnTheMap
//
//  Created by Mohsen Almakrami on 29/02/1441 AH.
//  Copyright © 1441 Mohsen Almakrami. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    class var storyboardID: String {
        return "\(self)"
    }
    
    static func instantiate(from: AppStoryboard) -> Self {
        return from.viewController(viewControllerClass: self)
    }
}

extension UIApplication {
    
    static var loginAnimation: UIView.AnimationOptions = .transitionFlipFromRight
    static var logoutAnimation: UIView.AnimationOptions = .transitionCrossDissolve
    
    public static func setRootView(_ viewController: UIViewController,
                                   options: UIView.AnimationOptions = .transitionFlipFromRight,
                                   animated: Bool = true,
                                   duration: TimeInterval = 0.5,
                                   completion: (() -> Void)? = nil) {
        guard animated else {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            return
        }
        
        UIView.transition(with: UIApplication.shared.keyWindow!, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            UIApplication.shared.keyWindow?.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }) { _ in
            completion?()
        }
    }
}

extension UIViewController {
    class func activateSpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(white: 0.10, alpha: 0.75)
        
        let ai = UIActivityIndicatorView.init(style: .large)
        
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func deactivateSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}


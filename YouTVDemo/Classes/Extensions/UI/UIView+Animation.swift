//
//  UIView+Animation.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/26/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    /// Disables a view transition animation.
    /// - Parameter block: The view transition code that you want to perform without animation.
    func performWithoutAnimation(_ block:@escaping () -> Void) {
        UIView.performWithoutAnimation {
            block()
        }
    }

    /**
     Animate changes to one or more views using the specified duration, delay, options, and completion handler.
     A convenient way to wrap around `UIView.animate` method.

     - seealso: `UIView.animate(withDuration:,delay:,options:,animations:,completion:)`
     */
    func animate(withDuration duration: TimeInterval,
                 delay: TimeInterval = 0,
                 options: UIView.AnimationOptions = [],
                 animations: @escaping () -> Void,
                 completion: ((Bool) -> Void)? = nil) {

        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: options,
                       animations: animations, completion: completion)
    }
}

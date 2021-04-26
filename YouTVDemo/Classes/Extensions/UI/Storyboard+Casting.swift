//
//  Storyboard+Casting.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/26/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import UIKit

/**
 The additional method wrap around instantiate view controller at `UIStoryboard` to cast `UIViewController` conveniently.
 */
extension UIStoryboard {

    /**
     Creates the view controller with the specified identifier and type. Also, initializes it with the data from the storyboard.

     - Parameter identifier: An identifier string that uniquely identifies the view controller in the storyboard file.
                            At design time, put this same string in the Storyboard ID attribute of your view controller in Interface Builder.
     - Returns: The `T` View Controller that is subclass of `UIViewController`.
     */
    func instantiateViewController<T: UIViewController>(identifier: String) -> T? {
        return self.instantiateViewController(identifer: identifier, type: T.self)
    }

    /**
     Creates the view controller with the specified identifier and type. Also, initializes it with the data from the storyboard.

     - Parameters:
       - withIdentifer: An identifier string that uniquely identifies the view controller in the storyboard file. At design time, put this same string in the Storyboard ID attribute of your view controller in Interface Builder.
       - type: The `T` type that you want to cast into. The `T` must be `UIViewController` subclass.
     - Returns: The `T` View Controller that is subclass of `UIViewController`.
     */
    func instantiateViewController <T: UIViewController>(identifer: String, type: T.Type) -> T? {
        return self.instantiateViewController(withIdentifier: identifer) as? T
    }
}

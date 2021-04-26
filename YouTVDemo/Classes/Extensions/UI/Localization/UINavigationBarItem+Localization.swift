//
//  UINavigationBarItem+Localization.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/26/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationItem {

    @IBInspectable
    var localizedTitle: String? {
        get {
            return nil
        }
        set {
            guard let newValue = newValue else { self.title = nil; return }
            self.title = newValue.localized
        }
    }

}

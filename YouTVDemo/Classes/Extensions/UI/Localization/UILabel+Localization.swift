//
//  UILabel+Localization.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/26/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {

    // swiftlint:disable:next empty_first_line
    private struct AssociatedKey {
        static var localizedStringKey = "localizedStringKey"
    }

    /// :nodoc:
    @IBInspectable
    var localizedText: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.localizedStringKey) as? String
        }

        set {
            objc_setAssociatedObject(self, &AssociatedKey.localizedStringKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            guard let value = newValue else {
                return
            }

            self.text = value.localized
        }
    }

}

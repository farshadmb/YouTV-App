//
//  UITextField+Localization.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/26/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import UIKit.UITextField

extension UITextField {

    // swiftlint:disable:next empty_first_line
    private struct AssociatedKey {
        static var placeHolderLocalizedStringKey = "placeHolderLocalizedStringKey"
    }

    /// :nodoc:
    @IBInspectable
    var localizedPlaceHolder: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.placeHolderLocalizedStringKey) as? String
        }

        set {
            objc_setAssociatedObject(self, &AssociatedKey.placeHolderLocalizedStringKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            guard let value = newValue else {
                return
            }

            self.placeholder = value.localized
        }
    }

}

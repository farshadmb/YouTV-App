//
//  UIButton+Localization.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/26/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {

    /// :nodoc:
    @IBInspectable
    var normalLocalizedTitle: String? {
        get {
            return title(for: .normal)
        }

        set {
            performWithoutAnimation { [self] in
                setTitle(newValue?.localized, for: .normal)
            }
        }
    }

    /// :nodoc:
    @IBInspectable
    var selectLocalizedTitle: String? {
        get {
            return title(for: .selected)
        }

        set {
            performWithoutAnimation { [self] in
                setTitle(newValue?.localized, for: .selected)
            }
        }
    }

    /// :nodoc:
    @IBInspectable
    var disableLocalizedTitle: String? {
        get {
            return title(for: .disabled)
        }

        set {
            performWithoutAnimation { [self] in
                setTitle(newValue?.localized, for: .disabled)
            }
        }
    }
    /// :nodoc:
    @IBInspectable
    var highlightLocalizedTitle: String? {
        get {
            return title(for: .highlighted)
        }

        set {
            performWithoutAnimation { [self] in
                setTitle(newValue?.localized, for: .highlighted)
            }
        }
    }

    /// :nodoc:
    @IBInspectable
    var focusLocalizedTitle: String? {
        get {
            return title(for: .focused)
        }

        set {
            performWithoutAnimation { [self] in
                setTitle(newValue?.localized, for: .focused)
            }
        }
    }
}

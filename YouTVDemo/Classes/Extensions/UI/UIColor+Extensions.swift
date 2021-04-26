//
//  UIColor+Extensions.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/26/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    /**
     Create and return UIColor from hex string format
     - Parameter hexString: the hex string object without supporing alpha
     - Note: if you pass hex value with alpha, the alpha value will be ignored.
     */
    convenience init?(hexString: String?) {

        guard let hexString = hexString else {
            return nil
        }

        let scanner = Scanner(string: hexString)
        scanner.scanLocation = 1

        var rgbValue: UInt64 = 0

        if scanner.scanHexInt64(&rgbValue) {

            self.init(rgb: rgbValue)
        } else {
            return nil
        }

    }

    /**
     Create and return UIColor from hex format in `UIInt64`
     - Parameter rgbValue: the `UInt64`of hex value object without supporing alpha
     - Note: if you pass hex value with alpha, the alpha value will be ignored.
     */
    convenience init(rgb rgbValue: UInt64 = 0) {

        let red = CGFloat((rgbValue & 0xFF0000) >> 16)
        let green = CGFloat((rgbValue & 0xFF00) >> 8)
        let blue = CGFloat(rgbValue & 0xFF)

        self.init(
            red: red / 255.0,
            green: green / 255.0,
            blue: blue / 255.0,
            alpha: 1
        )

    }

    /**
     The Hex format value for `UIColor`, `#ffAACC`
     */
    var hexString: String {

            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0

            getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0

            return String(format: "#%06x", rgb)

    }

    /**
     The Hex format value for `UIColor` with alpha. `#ffAACCff`
     */
    var hexAlphaString: String {

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let rgba: Int = (Int)(red * 255) << 32 | (Int)(green * 255) << 16 | (Int)(blue * 255) << 8 | (Int)(alpha * 255) << 0

        return String(format: "#%08x", rgba)

    }

}

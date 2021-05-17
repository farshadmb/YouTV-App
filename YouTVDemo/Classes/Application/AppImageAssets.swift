//
//  AppImageAssets.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/17/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    enum Images: String, ImageAssets {
        case placeHolder
    }

    enum Icon: String, ImageAssets {
        case none
    }

    @available(iOS 13.0, *)
    enum Symbols: String, ImageAssets {

        case circle
        case startFill = "star.fill"
        case heartFill = "heart.fill"
        case circleFill = "circle.fill"
        case checkmarkCircle = "checkmark.circle"
        case xmarkCircle = "xmark.circle"
        case home = "house"
        case homeFill = "house.fill"
        case search = "search"

        var isSymbol: Bool {
            true
        }

        var image: UIImage {
           templateImage
        }
    }
}

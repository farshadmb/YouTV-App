//
//  Storyboarded.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/5/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import UIKit

protocol Storyboarded: class {

    /// <#Description#>
    static var storyboardName: String { get }

    /**
     */
    static func instantiate() throws -> Self
}

/**

 */
enum StoryboardedError: LocalizedError {
    ///
    case notFound(String)

    ///
    case casting(String)
}

extension Storyboarded where Self: UIViewController {

    private static var fileName: String {
        className
    }

    static var className: String {
        return String(describing: self)
    }

    static var storyboardName: String {
        return "Main"
    }

    static func instantiate() throws -> Self {
        try instantiate(bundle: Bundle(for: self))
    }

    static func instantiate(bundle: Bundle = .main) throws -> Self {

        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)

        guard let viewController = storyboard.instantiateViewController(identifier: className) else {
            throw StoryboardedError.notFound("Could not find View Controller named \(className)")
        }

        guard let castedViewController = viewController as? Self else {
            throw StoryboardedError.casting("Could not cast ViewController \(viewController.className) into \(Self.className)")
        }

        return castedViewController
    }

}

extension UIViewController {

    var className: String {
        return String(describing: self)
    }
}

extension UIViewController: Storyboarded {}

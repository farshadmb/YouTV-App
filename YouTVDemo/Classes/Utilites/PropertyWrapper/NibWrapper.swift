//
//  NibWrapper.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/26/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import UIKit

#if swift(>=5.1)
/**
 Property wrapper used to wrapp a view instanciated from a Nib
 */
@propertyWrapper
@dynamicMemberLookup
final class NibWrapper<T: UIView> {

    /**
     Initializer
     */
    init() {
        wrappedValue = T.fromNib()
    }

    /// The wrapped value
    private(set) var wrappedValue: T

    /// The final view
    var unwrapped: T {
        wrappedValue
    }

    /**
     Dynamic member lookup to transfer keypath to the final view
     */
    subscript<U>(dynamicMember keyPath: KeyPath<T,U>) -> U {
        unwrapped[keyPath: keyPath]
    }

    /**
     Dynamic member lookup to transfer writable keypath to the final view
     */
    subscript<U>(dynamicMember keyPath: WritableKeyPath<T,U>) -> U {
        get { unwrapped[keyPath: keyPath] }
        set {
            var unwrappedView = unwrapped
            unwrappedView[keyPath: keyPath] = newValue
        }
    }
}

/**
 Lazy Property wrapper used to wrapp a view instanciated from a Nib whenever wrapperValue called.
 */
@propertyWrapper
@dynamicMemberLookup
final class LazyNibWrapper<T: UIView> {

    /**
     Initializer
     */
    init() {}

    /**
     Initializer
     - Parameter type: Type of the wrapped view
     */
    init(_ type: T.Type) { }

    /// The wrapped value
    lazy var wrappedValue: T = makeWrapper()

    /// :nodoc:
    func makeWrapper() -> T {
        return T.fromNib()
    }

    /**
     Dynamic member lookup to transfer keypath to the final view
     */
    subscript<U>(dynamicMember keyPath: KeyPath<T,U>) -> U {
        wrappedValue[keyPath: keyPath]
    }

    /**
     Dynamic member lookup to transfer writable keypath to the final view
     */
    subscript<U>(dynamicMember keyPath: WritableKeyPath<T,U>) -> U {
        get { wrappedValue[keyPath: keyPath] }
        set {
            var unwrappedView = wrappedValue
            unwrappedView[keyPath: keyPath] = newValue
        }
    }
}

#endif

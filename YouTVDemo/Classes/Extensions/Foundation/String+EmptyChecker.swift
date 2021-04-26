//
//  String+EmptyChecker.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/26/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

// swiftlint:disable empty_first_line

// :nodoc:
protocol OptionalString {}

// :nodoc:
extension String: OptionalString {}
// swiftlint:enable empty_first_line

// :nodoc:
extension Optional where Wrapped: OptionalString {

    /**
     The `Bool` value indicate the optional `String` isEmpty or not.
     */
    var isEmptyOrBlank: Bool {
        return String.isEmptyOrBlankString(self as? String)
    }

}

extension String {

    // :nodoc:
    func toBool() -> Bool? {
        return NSString(string: self).boolValue
    }

    // :nodoc:
    static func isEmptyOrBlankString(_ aString: String?) -> Bool {

        guard let aString = aString else {
            return true
        }

        if aString.isEmpty {
            return true
        }

        if aString.trimmingCharacters(in: CharacterSet.whitespaces).count == 0 {
            return true
        }
        if aString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
            return true
        }

        return false
    }

    /**
     The `Bool` value indicate the `String` isEmpty or not.
     */
    var isEmptyOrBlank: Bool {
        return String.isEmptyOrBlankString(self)
    }

}

// swiftlint:disable all

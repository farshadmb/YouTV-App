//
//  String+Localization.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/26/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

/* Localization Extension made localized string easy to use
 whenever we need localized value we can just call `.localized` property.
 */
extension String {

    /**
     The Localized value. this property wrap around `NSLocalizedString`.
     `String` represents as `Key` to look up in localization.
     */
    var localized: String {
        localized(withComment: "")
    }

    /**
     Return the localized `String` value.

     - Parameters:
        - withComment: the comment section in localization strings files.
        - bundle: the `Bundle` value which the localization strings locate in.
     - Returns: The localized `String` value.
     */
    func localized(withComment: String, bundle: Bundle = .main) -> String {
           return NSLocalizedString(self,
                                    tableName: nil,
                                    bundle: bundle,
                                    value: "",
                                    comment: withComment)
    }

    /**
     Return the localized `String` value with inject the argument values.
     ```
        let greeting = "greeting".localized(withFormat: "John")
        // The result would be: Hello Dear, Thanks to join us, John.
     ```

     - Parameter arguments: the agrument `CVarArgs` values to inject into process.
     - Returns: The localized `String` value with injected arguments.
     */
    func localized(withFormat arguments: CVarArg...) -> String {
        return String(format: localized, locale: nil, arguments: arguments)
    }
}

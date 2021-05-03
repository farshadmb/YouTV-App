//
//  UnitTestError.swift
//  YouTVDemoTests
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

/**
The Custom `Error` to use in Testing purposes.
 */
struct UnitTestError: Error, CustomStringConvertible {

    /// :nodoc:
    var description: String {
        return "UnitTestError \(message)"
    }

    /// :nodoc:
    private var message: String

    /// :nodoc:
    init(message: String) {
        self.message = message
    }
}

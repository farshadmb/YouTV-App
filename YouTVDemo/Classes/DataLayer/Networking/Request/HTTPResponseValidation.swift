//
//  APIJSONValidation.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

/**
 The `HTTPResponseValidation` to determind HTTP response fields validation.
 */
struct HTTPResponseValidation: NetworkResponseValidation {

    /// the `Set<Int>` statusCodes to be used for validation process
    var statusCodes: Set<Int>

    /// The `Array<String>` Http response contentType to be used in validation proccess
    var contentTypes: [String]

    /**
     Default Constructor for `APIJSONValidation`
     - Parameters:
       - statusCodes: The `Set<Int>` response statusCodes to be used for validation process
       - contentTypes: The `Array<String>` Http response contentType to be used in validation proccess
     */
    init(statusCodes: Set<Int>, contentTypes: [String]) {
        self.statusCodes = statusCodes
        self.contentTypes = contentTypes
    }

}

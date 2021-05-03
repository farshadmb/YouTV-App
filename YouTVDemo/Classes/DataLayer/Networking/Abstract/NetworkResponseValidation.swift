//
//  NetworkResponseValidation.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

/**
 <# Property Summery Here#>
 */
protocol NetworkResponseValidation {

   /**
    <# Property Summery Here#>
    */
   var statusCodes: Set<Int> { get }

   /**
    <# Property Summery Here#>
    */
   var contentTypes: [String] { get }
}

// MARK: - abstract default implementation
extension NetworkResponseValidation {

   var statusCodes: Set<Int> { Set(200..<300) }
   var contentTypes: [String] { ["*/*","application/json"] }
}

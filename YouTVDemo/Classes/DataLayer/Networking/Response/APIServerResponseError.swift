//
//  APIServerResponseError.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

enum APIServerResponseError: Error {
    case code(Int)
    case message(code: Int, message: String)
    case unknown
}

extension APIServerResponseError: LocalizedError {

    var errorDescription: String? {
        return self.errorDes
    }

    fileprivate var errorDes: String {
        return self.message
    }
}

extension APIServerResponseError {

    var type: String {
        switch self {
        case .code(let type),
             .message(let type, _):
            return "\(type)"
        case .unknown :
            return "UNKNOWN_ERROR"
        }
    }

    var message: String {

        switch self {
        case .code(let value):
            return "Code: \(value)"
        case .message(let code , let msg):
            return "Code: \(code)\nmessage:\(msg)"
        case .unknown :
            return "Unknown Error Occured. Please Contact Support"
        }
    }

}

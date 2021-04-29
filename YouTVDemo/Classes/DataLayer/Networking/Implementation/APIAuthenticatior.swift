//
//  APIAuthenticatior.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import Alamofire

struct APIAuthenticator: NetworkRequestInterceptor {

    /// The `String` value to authenticate
    let token: String

    /// Default initializer for `APIAuthenticator`
    /// - Parameter token: the value to be used to authenticate api
    init(token: String) {
        self.token = token
    }

    /// :nodoc:
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {

        var request = urlRequest
        request.headers.add(HTTPHeader.authorization(bearerToken: self.token))
        completion(Result { request })
    }

}

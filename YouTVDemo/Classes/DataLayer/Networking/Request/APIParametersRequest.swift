//
//  APIParametersRequest.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import Alamofire

/**

*/
struct APIParametersRequest: NetworkRequest {

    /// `URLConvertible` value to be used as the `URLRequest`'s `URL`.
    let url: URLConvertible

    /// `HTTPMethod` for the `URLRequest`. `.get` by default.
    let method: HTTPMethod

    /**
     `Parameters` (a.k.a. `[String: Any]`) value to be encoded into the `URLRequest`. `nil` by default.
     */
    let parameters: Parameters?

    /** `ParameterEncoding` to be used to encode the `parameters` value into the `URLRequest`.
                          `URLEncoding.default` by default.
     */
    let encoding: ParameterEncoding

    /**
     `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
     */
    let headers: HTTPHeaders?

    /// Closure which provides a `URLRequest` for mutation.
    typealias RequestModifier = Session.RequestModifier

    /**
     `RequestModifier` which will be applied to the `URLRequest` created from the provided
            parameters. `nil` by default.
     */
    let requestModifier: RequestModifier?

    /**
     Default Constructor for `APIParametersRequest`
     - Parameters:
       - url: `URLConvertible` value to be used as the `URLRequest`'s `URL`.
       - method: `HTTPMethod` for the `URLRequest`. `.get` by default.
       - parameters: `Parameters` (a.k.a. `[String: Any]`) value to be encoded into the `URLRequest`. `nil` by default.
       - encoding: `ParameterEncoding` to be used to encode the `parameters` value into the `URLRequest`. `URLEncoding.default` by default.
       - headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
       - requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided
       - validResponse: `NetworkResponseValidation` which will be used in response validation process.
     parameters. `nil` by default.
     - Returns: instace object of `APIParametersRequest`
     */
    init(url: URLConvertible, method: HTTPMethod = .get,
         parameters: Parameters? = nil,encoding: ParameterEncoding = URLEncoding.default,
         headers: HTTPHeaders? = nil, requestModifier: RequestModifier? = nil,
         validResponse: NetworkResponseValidation) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
        self.requestModifier = requestModifier
        self.validResponse = validResponse
    }
    
    // MARK: - Network Request
    var validResponse: NetworkResponseValidation

    /// :nodoc:
    func asURLRequest() throws -> URLRequest {
        let acceptHeader = HTTPHeader(name: "Accept", value: validResponse.contentTypes.joined(separator: ", "))
        var requestHeaders = headers ?? HTTPHeaders([acceptHeader])
        requestHeaders.add(acceptHeader)

        var request = try URLRequest(url: url, method: method, headers: requestHeaders)
        try requestModifier?(&request)

        return try encoding.encode(request, with: parameters)
    }
}

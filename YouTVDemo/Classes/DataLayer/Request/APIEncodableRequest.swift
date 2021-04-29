//
//  APIEncodableRequest.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import Alamofire

/**

 */
struct APIEncodableRequest<Parameters: Encodable>: NetworkRequest {

    /// Closure which provides a `URLRequest` for mutation.
    typealias RequestModifier = Session.RequestModifier

    /**
     `URLConvertible` value to be used as the `APIEncodableRequest`'s `URL`.
     */
    let url: URLConvertible

    /**
     `HTTPMethod` for the `APIEncodableRequest`. `.get` by default.
     */
    let method: HTTPMethod

    /**
     `Encodable` value to be encoded into the `APIEncodableRequest`. `nil` by default.
     */
    let parameters: Parameters?

    /**
     `ParameterEncoder` to be used to encode the `parameters` value into the `URLRequest`.
        `JSONParameterEncoder.default` by default.
     */
    let encoder: ParameterEncoder

    /**
     `HTTPHeaders` value to be added to the `APIEncodableRequest`. `nil` by default.
     */
    let headers: HTTPHeaders?

    /**
     `RequestModifier` which will be applied to the `URLRequest` created from the provided
     */
    let requestModifier: RequestModifier?

    /**
     Default Constructor for `APIEncodableRequest`
     - Parameters:
       - url: `URLConvertible` value to be used as the `APIEncodableRequest`'s `URL`.
       - method: `HTTPMethod` for the `APIEncodableRequest`. `.get` by default.
       - parameters: `Encodable` value to be encoded into the `APIEncodableRequest`. `nil` by default.
       - encoder:  `ParameterEncoder` to be used to encode the `parameters` value into the `APIEncodableRequest`. `JSONParameterEncoder.default` by default.
       - headers: `HTTPHeaders` value to be added to the `APIEncodableRequest`. `nil` by default.
       - requestModifier: `RequestModifier` which will be applied to the `URLRequest` created from the provided.
       - validResponse: `NetworkResponseValidation` which will be used in response validation process.
     parameters. `nil` by default.
     - Returns: instace object of `APIEncodableRequest`
     */
    init(url: URLConvertible, method: HTTPMethod = .get,
         parameters: Parameters? = nil, encoder: ParameterEncoder = JSONParameterEncoder.default,
         headers: HTTPHeaders? = nil, requestModifier: RequestModifier? = nil,
         validResponse: NetworkResponseValidation) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.encoder = encoder
        self.headers = headers
        self.requestModifier = requestModifier
        self.validResponse = validResponse
    }

    // MARK: - Network Request
    var validResponse: NetworkResponseValidation

    func asURLRequest() throws -> URLRequest {
        let acceptHeader = HTTPHeader(name: "Accept", value: validResponse.contentTypes.joined(separator: ", "))
        var requestHeaders = headers ?? HTTPHeaders([acceptHeader])
        requestHeaders.add(acceptHeader)

        var request = try URLRequest(url: url, method: method, headers: requestHeaders)
        try requestModifier?(&request)

        return try parameters.map { try encoder.encode($0, into: request) } ?? request
    }
}

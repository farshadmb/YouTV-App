//
//  MockNetworkHelper.swift
//  YouTVDemoTests
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import Alamofire
@testable import YouTVDemo

class MockNetworkRequest: NetworkRequest {

    var isCalledRequest: Bool = false

    var validResponse: NetworkResponseValidation = MockNetworkResponseValidation()

    func asURLRequest() throws -> URLRequest {
        isCalledRequest = true
        return URLRequest(url: try "https://www.google.com".asURL())
    }

}

struct MockNetworkResponseValidation: NetworkResponseValidation {

}

class MockNetworkService: NetworkService {

    var isCalledExecute: Bool = false

    func execute(request: NetworkRequest, completion: @escaping CompletionCallback<Data>) -> DataRequest {
        isCalledExecute = true
        return AF.request("")
    }

}

class MockInterceptableNetworkService: NetworkServiceInterceptable {

    var isCalledExecute: Bool = false
    var isCalledApply: Bool = false

    func apply(interceptor: NetworkRequestInterceptor) {
        isCalledApply = true
    }

    func execute(request: NetworkRequest, completion: @escaping CompletionCallback<Data>) -> DataRequest {
        isCalledExecute = true
        return AF.request("")
    }

}

struct MockRequestInterceptor: NetworkRequestInterceptor {

}

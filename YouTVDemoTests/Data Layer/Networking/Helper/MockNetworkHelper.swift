//
//  MockNetworkHelper.swift
//  YouTVDemoTests
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
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

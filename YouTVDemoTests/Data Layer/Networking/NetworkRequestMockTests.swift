//
//  NetworkRequestMockTests.swift
//  YouTVDemoTests
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import XCTest
@testable import YouTVDemo

/// :nodoc:
class NetworkRequestMockTests: XCTestCase {

    /// :nodoc:
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    /// :nodoc:
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// :nodoc:
    func testMockNetworkRequest() throws {
        // this test would check and mock the `NetworkRequest`. So if will change the abstract in future, must be ensure that every method is impelemented by impelementors.
        
        let request = MockNetworkRequest()

        _ = try request.asURLRequest()

        XCTAssert(request.isCalledRequest, "The asURLRequest could not be called.")
        XCTAssert(request.validResponse.statusCodes.isEmpty == false, "The Valid Response Status code must not be empty")
        XCTAssert(request.validResponse.contentTypes.isEmpty == false, "The Valid Response content type must not be empty")
        
    }
}

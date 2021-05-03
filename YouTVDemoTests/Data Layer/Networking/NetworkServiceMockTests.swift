//
//  NetworkServiceMockTests.swift
//  YouTVDemoTests
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import XCTest
import Alamofire

@testable import YouTVDemo

/// :nodoc:
class NetworkServiceMockTests: XCTestCase {

    /// :nodoc:
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    /// :nodoc:
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMockNetworkService() throws {
        let service = MockNetworkService()

        XCTAssert(service.isCalledExecute == false, "The execute method is already called, we dont expect that.")
        _ = service.execute(request: MockNetworkRequest()) { _ in

        }

        XCTAssertEqual(service.isCalledExecute, true, "The execute method is not called, we don't expect that.")
    }

    func testMockNetworkServiceInterceptable() throws {

        let service = MockInterceptableNetworkService()

        XCTAssert(service.isCalledExecute == false, "The execute method is already called, we dont expect that.")

        _ = service.execute(request: MockNetworkRequest()) { _ in

        }

        XCTAssertEqual(service.isCalledExecute, true, "The execute method is not called, we don't expect that.")

        XCTAssert(service.isCalledApply == false, "The apply method is already called, we don't expect that.")

        service.apply(interceptor: MockRequestInterceptor())

        XCTAssertEqual(service.isCalledApply, true, "The apply method is not called, we don't expect that.")
    }
}

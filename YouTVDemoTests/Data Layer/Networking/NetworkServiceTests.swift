//
//  NetworkServiceTests.swift
//  YouTVDemoTests
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import XCTest
import Mocker
import Alamofire

@testable import YouTVDemo

// swiftlint:disable all
class NetworkServiceTests: XCTestCase {

    /// :nodoc:
    override func setUpWithError() throws {
        try super.setUpWithError()
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        networkService = APIClientService(configuration: configuration)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    /// :nodoc:
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        networkService = nil
        try super.tearDownWithError()
    }

    var networkService: NetworkService!

    override func setUp() {

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        networkService = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSimpleRequestResponse() {
        let expectedData = NetworkMockingDataFactory.createSimpleJSONData()

        let expectations = self.expectation(description: "SimpleRequestResponse")

        do {
            let url = "https://jsonplaceholder.typicode.com/posts/1"
            let mock = try NetworkMockBuilder(URL: url)
                .set(method: .get)
                .set(statusCode: 200)
                .set(data: [.get: expectedData])
                .set(contentType: .json)
                .build()

            Mocker.register(mock)

            let request = APIParametersRequest(url: url,
                                               validResponse: MockNetworkResponseValidation())
            _ = networkService
                .execute(request: request,
                         completion: { (result: Result<APIPostModel, Error>) in
                            switch result {
                            case .success(let value):
                                print(value)
                            case .failure(let error):
                                XCTFail(error.localizedDescription)
                            }
                            expectations.fulfill()
                         })

        } catch let error {
            XCTFail(error.localizedDescription)
        }

        self.waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(error, "error occured \(error!)")
        }
    }



    func testSimpleResponseContentTypeErrorHandling() {

        let expectedData = NetworkMockingDataFactory.createSimpleJSONData()

        let expectations = self.expectation(description: "SimpleResponseContentTypeErrorHandling")

        do {
            let url = "https://jsonplaceholder.typicode.com/posts/1"
            let mock = try NetworkMockBuilder(URL: url)
                .set(method: .get)
                .set(statusCode: 200)
                .set(data: [.get: expectedData])
                .set(contentType: .html)
                .build()

            Mocker.register(mock)

            let request = APIParametersRequest(url: url,
                                               validResponse: HTTPResponseValidation(statusCodes: [200],
                                                                                contentTypes: ["application/json"]))
            _ = networkService
                .execute(request: request,

                         completion: { ( result: Result<APIPostModel, Error>) in
                            print("result => ", result)
                            switch result {
                            case .success:
                                XCTFail("SimpleResponse should not have a value response")
                            case .failure(let error):
                                print("Error Occured ",error.localizedDescription)
                            }
                            expectations.fulfill()
                         })

        } catch let error {
            XCTFail(error.localizedDescription)
        }

        self.waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(error, "error occured \(error!)")
        }
    }


    func testSimpleResponseStatusCodeError() {

        let expectedData = NetworkMockingDataFactory.createSimpleJSONData()

        let expectations = self.expectation(description: "SimpleResponseStatusCodeError")

        do {
            let url = "https://jsonplaceholder.typicode.com/posts/1"
            let mock = try NetworkMockBuilder(URL: url)
                .set(method: .get)
                .set(statusCode: 400)
                .set(data: [.get: expectedData])
                .set(contentType: .html)
                .build()

            Mocker.register(mock)

            let request = APIParametersRequest(url: url,
                                               validResponse: HTTPResponseValidation(statusCodes: [200],
                                                                                contentTypes: ["application/json"]))
            _ = networkService
                .execute(request: request,
                         completion: { ( result: Result<APIPostModel, Error>) in
                            print("result => ", result)
                            switch result {
                            case .success:
                                XCTFail("SimpleResponse should not have a value response")
                            case .failure(let error):
                                print("Error Occured ",error.localizedDescription)
                            }
                            expectations.fulfill()
                         })

        } catch let error {
            XCTFail(error.localizedDescription)
        }

        self.waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(error, "error occured \(error!)")
        }
    }


    func testRequestWithEmptyResponse() {

        let expectations = self.expectation(description: "EmptyRequestResponse")

        do {
            let url = "https://jsonplaceholder.typicode.com/posts/1"
            let mock = try NetworkMockBuilder(URL: url)
                .set(method: .head)
                .set(statusCode: 204)
                .set(data: [.head: "".data(using: .utf8)!])
                .set(contentType: .json)
                .build()

            Mocker.register(mock)

            let request = APIParametersRequest(url: url,
                                               method: .head,
                                               validResponse: MockNetworkResponseValidation())

            _ = networkService.execute(request: request,
                                completion: { ( result: Result<Empty, Error>) in
                                    print("result => ", result)
                                    switch result {
                                    case .success(let value):
                                        XCTAssert(value is Empty, "The response should had a value.")
                                    case .failure(let error):
                                        print("error descripition :",error,error.localizedDescription)
                                    }
                                    expectations.fulfill()
                                })

        } catch let error {
            XCTFail(error.localizedDescription)
        }

        self.waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(error, "error occured \(error!)")
        }
    }

}

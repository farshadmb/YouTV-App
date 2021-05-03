//
//  APIAuthenticatorTests.swift
//  YouTVDemoTests
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import XCTest
import UIKit
import Mocker
import Alamofire
@testable import YouTVDemo

class APIAuthenticatorTests: XCTestCase {

    var networkService: NetworkServiceInterceptable!

    /// :nodoc:
    override func setUpWithError() throws {
        try super.setUpWithError()
        networkService = createNetworkService()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    /// :nodoc:
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        networkService = nil
        try super.tearDownWithError()
    }

    private func createNetworkService() -> NetworkServiceInterceptable {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let networkService = APIClientService(configuration: configuration)
        return networkService
    }

    private func createRealNetworkService() -> NetworkServiceInterceptable {
        let configuration = URLSessionConfiguration.af.default
        let networkService = APIClientService(configuration: configuration)
        return networkService
    }

    ////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: Unit Test Use Cases
    // MARK: -
    ////////////////////////////////////////////////////////////////

    func testInjectAuthenticationHeader() throws {

        let request = APIParametersRequest(url: "https://www.google.com", validResponse: MockNetworkResponseValidation())
        let token = "Token"
        let authenticator = APIAuthenticator(token: token)

        let urlRequest = try request.asURLRequest()

        authenticator.adapt(urlRequest, for: .default) { (result) in
            switch result {
            case .success(let urlRequest):

                XCTAssertFalse(urlRequest.allHTTPHeaderFields.isEmpty, "The Https headers is nil or empty")

                guard let httpsHeaderFields = urlRequest.allHTTPHeaderFields else {
                    XCTFail("The allHTTPHeaderFields is nil")
                    return
                }

                let expectedHeader = HTTPHeader.authorization(bearerToken: token)

                guard let authHeader = httpsHeaderFields
                        .compactMap({ HTTPHeader(name: $0.key, value: $0.value) })
                        .first(where: { $0.name == expectedHeader.name }) else {
                    XCTFail("Not Found Authentication Header")
                    return
                }

                XCTAssertEqual(authHeader, expectedHeader, "The Authentication is not to a expected auth headers")

            case .failure(let error):
                XCTFail("Occured Error: \(error)")
            }
        }

    }

    func testUnauthenticatedRequest() throws {

        let expectedData = Data()

        let expectations = self.expectation(description: "UnaunthenticatedRequest")

        let url = "https://jsonplaceholder.typicode.com/posts/1"
        let mock = try NetworkMockBuilder(URL: url)
            .set(method: .get)
            .set(statusCode: 401)
            .set(data: [.get: expectedData])
            .set(contentType: .json)
            .build()

        Mocker.register(mock)

        let request = APIParametersRequest(url: url,
                                           validResponse: MockNetworkResponseValidation())

        _ = networkService.execute(request: request,
                                   completion: { (result: Result<Empty, Error>) in
                                    switch result {
                                    case .success(let value):
                                        print(value)
                                        XCTFail("Server must return unauthorized error with status code 401")
                                    case .failure(let error):
                                        print("Response Error => ",error, "localized Info: ", error.localizedDescription)
                                        XCTAssert(error is AFError, "Expected Alamofire Error")

                                        if case let AFError.responseValidationFailed(reason: reason) = error,
                                           case let .unacceptableStatusCode(code: statuseCode) = reason {
                                            XCTAssert(statuseCode == 401, "The status code is \(statuseCode) but we've expected 401")
                                        }else {
                                            XCTFail("Expected Alamofire Error")
                                        }
                                    }

                                    expectations.fulfill()
        })

        self.waitForExpectations(timeout: 30.0) { (error) in
            // swiftlint:disable:next force_unwrapping
            XCTAssertNil(error, "error occured \(error!)")
        }
    }

    func testEmptyAPIKeyAuthenticationRequest() throws {

        let expectations = self.expectation(description: "EmptyAPIKeyAuthentication")
        let authenticator = APIAuthenticator(token: "")

        let url = "https://jsonplaceholder.typicode.com/posts/1"
        let mock = try NetworkMockBuilder(URL: url)
            .set(method: .get)
            .set(statusCode: 401)
            .set(data: [.get: Data()])
            .set(contentType: .json)
            .build()

        Mocker.register(mock)

        let request = APIParametersRequest(url: url,
                                           validResponse: MockNetworkResponseValidation())
        networkService.apply(interceptor: authenticator)

        _ = networkService.execute(request: request,
                                   completion: { (result: Result<Empty, Error>) in
                                    switch result {
                                    case .success(let value):
                                        print(value)
                                        XCTFail("Server must return unauthorized error with status code 401")
                                    case .failure(let error):
                                        print("Response Error => ",error, "localized Info: ", error.localizedDescription)
                                        XCTAssert(error is AFError, "Expected Alamofire Error")

                                        if case let AFError.responseValidationFailed(reason: reason) = error,
                                           case let .unacceptableStatusCode(code: statuseCode) = reason {
                                            XCTAssert(statuseCode == 401, "The status code is \(statuseCode) but we've expected 401")
                                        }else {
                                            XCTFail("Expected Alamofire Error")
                                        }
                                    }

                                    expectations.fulfill()
        })

        self.waitForExpectations(timeout: 30.0) { (error) in
            // swiftlint:disable:next force_unwrapping
            XCTAssertNil(error, "error occured \(error!)")
        }
    }

    func testAuthenticationSuccessfullRequest() throws {

        let expectations = self.expectation(description: "AuthenticationSuccessfull")
        let authenticator = APIAuthenticator(token: "Token")

        let url = "https://jsonplaceholder.typicode.com/posts/1"
        let mock = try NetworkMockBuilder(URL: url)
            .set(method: .get)
            .set(statusCode: 204)
            .set(data: [.get: Data()])
            .set(contentType: .json)
            .build()

        Mocker.register(mock)

        let request = APIParametersRequest(url: url,
                                           validResponse: MockNetworkResponseValidation())
        networkService.apply(interceptor: authenticator)

        _ = networkService.execute(request: request,
                                          completion: { (result: Result<Empty, Error>) in
                                            switch result {
                                            case .success(let value):
                                                print(value)
                                            case .failure(let error):
                                                 XCTFail("Response Error => \(error), localized Info: \(error.localizedDescription)")
                                            }

                                            expectations.fulfill()
        })

        self.waitForExpectations(timeout: 30.0) { (error) in
            // swiftlint:disable:next force_unwrapping
            XCTAssertNil(error, "error occured \(error!)")
        }
    }

    ////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: Integration Use Cases
    // MARK: -
    ////////////////////////////////////////////////////////////////

    func testIntegrationAuthenticationSuccessfull() throws {
        let networkService = createRealNetworkService()
        let expectations = self.expectation(description: "Integration-AuthenticationSuccessfull")

        let url = "https://api.themoviedb.org/3/movie/76341"

        let request = APIParametersRequest(url: url,
                                           validResponse: MockNetworkResponseValidation())
        let authenticator = APIAuthenticator(token: AppConfig.APIKey)
        networkService.apply(interceptor: authenticator)

        _ = networkService.execute(request: request,
                                   completion: { (result: Result<Empty, Error>) in
                                    switch result {
                                    case .success(let value):
                                        print(value)
                                    case .failure(let error):
                                        XCTFail("Response Error => \(error), localized Info: \(error.localizedDescription)")
                                    }

                                    expectations.fulfill()
        })

        self.waitForExpectations(timeout: 30.0) { (error) in
            // swiftlint:disable:next force_unwrapping
            XCTAssertNil(error, "error occured \(error!)")
        }
    }

    func testIntegrationUnauthenticatedRequest() throws {

        let networkService = createRealNetworkService()
        let expectations = self.expectation(description: "Integration-UnaunthenticatedRequest")

        let url = "https://api.themoviedb.org/3/list/1"

        let request = APIParametersRequest(url: url,
                                           validResponse: MockNetworkResponseValidation())

        _ = networkService.execute(request: request,
                                   completion: { (result: Result<Empty, Error>) in
                                    switch result {
                                    case .success(let value):
                                        print(value)
                                        XCTFail("Server must return unauthorized error with status code 401")
                                    case .failure(let error):
                                        print("Response Error => ",error, "localized Info: ", error.localizedDescription)
                                        XCTAssert(error is AFError, "Expected Alamofire Error")

                                        if case let AFError.responseValidationFailed(reason: reason) = error,
                                           case let .unacceptableStatusCode(code: statuseCode) = reason {
                                            XCTAssert(statuseCode == 401, "The status code is \(statuseCode) but we've expected 401")
                                        }else {
                                            XCTFail("Expected Alamofire Error")
                                        }
                                    }

                                    expectations.fulfill()
        })

        self.waitForExpectations(timeout: 30.0) { (error) in
            // swiftlint:disable:next force_unwrapping
            XCTAssertNil(error, "error occured \(error!)")
        }
    }

    func testIntegrationEmptyAPIKeyAuthenticationRequesti() throws {

        let networkService = createRealNetworkService()
        let expectations = self.expectation(description: "Integration-EmptyAPIKeyRequest")

        let url = "https://api.themoviedb.org/3/list/1"

        let request = APIParametersRequest(url: url,
                                           validResponse: MockNetworkResponseValidation())
        let authenticator = APIAuthenticator(token: "")
        networkService.apply(interceptor: authenticator)

        _ = networkService.execute(request: request,
                                   completion: { (result: Result<Empty, Error>) in
                                    switch result {
                                    case .success(let value):
                                        print(value)
                                        XCTFail("Server must return unauthorized error with status code 401")
                                    case .failure(let error):
                                        print("Response Error => ",error, "localized Info: ", error.localizedDescription)
                                        XCTAssert(error is AFError, "Expected Alamofire Error")

                                        if case let AFError.responseValidationFailed(reason: reason) = error,
                                           case let .unacceptableStatusCode(code: statuseCode) = reason {
                                            XCTAssert(statuseCode == 401, "The status code is \(statuseCode) but we've expected 401")
                                        }else {
                                            XCTFail("Expected Alamofire Error")
                                        }
                                    }

                                    expectations.fulfill()
        })

        self.waitForExpectations(timeout: 30.0) { (error) in
            // swiftlint:disable:next force_unwrapping
            XCTAssertNil(error, "error occured \(error!)")
        }
    }
}

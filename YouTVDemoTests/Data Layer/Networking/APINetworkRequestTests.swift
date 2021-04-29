//
//  APINetworkRequestTests.swift
//  YouTVDemoTests
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import XCTest
@testable import YouTVDemo

class APINetworkRequestTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - APIEncodableRequest Tests
    func testAPIEncodableRequestGetMethod() throws {

        let validResponse = HTTPResponseValidation(statusCodes: Set(200...300), contentTypes: [])
        let request = APIEncodableRequest<String>(url: "https://jsonplaceholder.typicode.com/posts",
                                                  method: .get,
                                                  parameters: nil, validResponse: validResponse)

        let urlRequest = try request.asURLRequest()

        guard let expectURL = urlRequest.url else {
            throw UnitTestError(message: "The URL is not set or is nil")
        }

        XCTAssert(expectURL.absoluteString == "https://jsonplaceholder.typicode.com/posts",
                  "The URL is not same as input. \(expectURL)")

        guard let httpMethod = urlRequest.httpMethod else {
            throw UnitTestError(message: "The httpMethod is not set or is nil")
        }

        XCTAssert(httpMethod == "GET", "The request method is not GET. the method is \(httpMethod)")

    }

    func testAPIEncodableRequestPostMethod() throws {

        let validResponse = HTTPResponseValidation(statusCodes: Set(200...300), contentTypes: [])
        let request = APIEncodableRequest(url: "https://jsonplaceholder.typicode.com/posts",
                                          method: .post,
                                          parameters: APIPostModel(title: "Title", body: "Body", userId: 1),
                                          validResponse: validResponse)

        let urlRequest = try request.asURLRequest()

        guard let expectURL = urlRequest.url else {
            throw UnitTestError(message: "The URL is not set or is nil")
        }

        XCTAssert(expectURL.absoluteString == "https://jsonplaceholder.typicode.com/posts",
                  "The URL is not same as input. \(expectURL)")

        guard let httpMethod = urlRequest.httpMethod else {
            throw UnitTestError(message: "The httpMethod is not set or is nil")
        }

        XCTAssert(httpMethod == "POST", "The request method is not GET. the method is \(httpMethod)")
        XCTAssertNotNil(urlRequest.httpBody, "The URL Request http body is nil")
        XCTAssert(urlRequest.httpBody.isEmpty == false, "The URL Request http body is empty")
    }

    func testAPIEncodableRequestPutMethod() throws {
        let validResponse = HTTPResponseValidation(statusCodes: Set(200...300), contentTypes: [])
        let request = APIEncodableRequest(url: "https://jsonplaceholder.typicode.com/posts/1",
                                          method: .put,
                                          parameters: APIPostModel(title: "Title", body: "Body", userId: 1),
                                          validResponse: validResponse)

        let urlRequest = try request.asURLRequest()

        guard let expectURL = urlRequest.url else {
            throw UnitTestError(message: "The URL is not set or is nil")
        }

        XCTAssert(expectURL.absoluteString == "https://jsonplaceholder.typicode.com/posts/1",
                  "The URL is not same as input. \(expectURL)")

        guard let httpMethod = urlRequest.httpMethod else {
            throw UnitTestError(message: "The httpMethod is not set or is nil")
        }

        XCTAssert(httpMethod == "PUT", "The request method is not GET. the method is \(httpMethod)")
    }

    func testAPIEncodableRequestValidResponse() throws {

        let validResponse = HTTPResponseValidation(statusCodes: Set(200...300), contentTypes: ["*/*", "application/json"])
        let request = APIEncodableRequest(url: "https://jsonplaceholder.typicode.com/posts",
                                          method: .post,
                                          parameters: APIPostModel(title: "Title", body: "Body", userId: 1), validResponse: validResponse)

        let urlRequest = try request.asURLRequest()

        guard let expectURL = urlRequest.url else {
            throw UnitTestError(message: "The URL is not set or is nil")
        }

        XCTAssert(expectURL.absoluteString == "https://jsonplaceholder.typicode.com/posts",
                  "The URL is not same as input. \(expectURL)")

        XCTAssertFalse(urlRequest.allHTTPHeaderFields.isEmpty, "The Https headers is nil or empty")
        XCTAssertNotNil(urlRequest.allHTTPHeaderFields?.contains(where: { $0.key == "Accept" }), "The Http Header Accept not found. make sure that is exist.")

    }

    func testAPIEncodableRequestCustomHeaders() throws {
        let validResponse = HTTPResponseValidation(statusCodes: Set(200...300), contentTypes: ["*/*", "application/json"])
        let request = APIEncodableRequest(url: "https://jsonplaceholder.typicode.com/posts",
                                          method: .post,
                                          parameters: APIPostModel(title: "Title", body: "Body", userId: 1),
                                          headers: ["api-key": "google"],
                                          validResponse: validResponse)

        let urlRequest = try request.asURLRequest()

        guard let expectURL = urlRequest.url else {
            throw UnitTestError(message: "The URL is not set or is nil")
        }

        XCTAssert(expectURL.absoluteString == "https://jsonplaceholder.typicode.com/posts",
                  "The URL is not same as input. \(expectURL)")

        XCTAssertFalse(urlRequest.allHTTPHeaderFields.isEmpty, "The Https headers is nil or empty")
        let customHeader = urlRequest.allHTTPHeaderFields?.first(where: { $0.key == "api-key" }).map { $0.value }
        XCTAssertNotNil(customHeader, "The Http Header Accept not found. make sure that is exist.")
        XCTAssert(customHeader == "google")
    }

    // MARK: - APIParametersRequest Tests
    func testAPIParametersRequestGetMethod() throws {

        let validResponse = HTTPResponseValidation(statusCodes: Set(200...300), contentTypes: [])
        let request = APIParametersRequest(url: "https://jsonplaceholder.typicode.com/posts",
                                           method: .get,
                                           parameters: nil, validResponse: validResponse)

        let urlRequest = try request.asURLRequest()

        guard let expectURL = urlRequest.url else {
            throw UnitTestError(message: "The URL is not set or is nil")
        }

        XCTAssert(expectURL.absoluteString == "https://jsonplaceholder.typicode.com/posts",
                  "The URL is not same as input. \(expectURL)")

        guard let httpMethod = urlRequest.httpMethod else {
            throw UnitTestError(message: "The httpMethod is not set or is nil")
        }

        XCTAssert(httpMethod == "GET", "The request method is not GET. the method is \(httpMethod)")

    }

    func testAPIParametersRequestQuery() throws {

        let validResponse = HTTPResponseValidation(statusCodes: Set(200...300), contentTypes: [])
        let request = APIParametersRequest(url: "https://jsonplaceholder.typicode.com/comments",
                                           method: .get,
                                           parameters: ["postId": 1],
                                           validResponse: validResponse)

        let urlRequest = try request.asURLRequest()

        guard let expectURL = urlRequest.url else {
            throw UnitTestError(message: "The URL is not set or is nil")
        }

        XCTAssert(expectURL.absoluteString == "https://jsonplaceholder.typicode.com/comments?postId=1",
                  "The URL is not same as input. \(expectURL)")

        guard let httpMethod = urlRequest.httpMethod else {
            throw UnitTestError(message: "The httpMethod is not set or is nil")
        }

        XCTAssert(httpMethod == "GET", "The request method is not GET. the method is \(httpMethod)")
        guard let components = URLComponents(url: expectURL, resolvingAgainstBaseURL: false) else {
            throw UnitTestError(message: "Could not create URLComponents")
        }

        XCTAssertFalse(components.queryItems.isEmpty, "The Query Items are not exist in URL.")
        guard let queryItems = components.queryItems else {
            throw UnitTestError(message: "The Query Items are not exist in URL.")
        }

        XCTAssert(queryItems.contains(where: { $0.name == "postId" }), "PostId is not found.")

        let postIdValue = queryItems.first(where: { $0.name.lowercased() == "postid" })?.value
        XCTAssert(postIdValue == "1")

    }

    func testAPIParametersRequestPostMethod() throws {

        let validResponse = HTTPResponseValidation(statusCodes: Set(200...300), contentTypes: [])
        let request = APIParametersRequest(url: "https://jsonplaceholder.typicode.com/posts",
                                           method: .post,
                                           parameters: ["title": "Title", "body": "Body", "userId": 1],
                                           validResponse: validResponse)

        let urlRequest = try request.asURLRequest()

        guard let expectURL = urlRequest.url else {
            throw UnitTestError(message: "The URL is not set or is nil")
        }

        XCTAssert(expectURL.absoluteString == "https://jsonplaceholder.typicode.com/posts",
                  "The URL is not same as input. \(expectURL)")

        guard let httpMethod = urlRequest.httpMethod else {
            throw UnitTestError(message: "The httpMethod is not set or is nil")
        }

        XCTAssert(httpMethod == "POST", "The request method is not GET. the method is \(httpMethod)")
        XCTAssertNotNil(urlRequest.httpBody, "The URL Request http body is nil")
        XCTAssert(urlRequest.httpBody.isEmpty == false, "The URL Request http body is empty")
    }

    func testAPIParametersRequestPutMethod() throws {
        let validResponse = HTTPResponseValidation(statusCodes: Set(200...300), contentTypes: [])
        let request = APIParametersRequest(url: "https://jsonplaceholder.typicode.com/posts/1",
                                           method: .put,
                                           parameters: ["title": "Title", "body": "Body", "userId": 1],
                                           validResponse: validResponse)

        let urlRequest = try request.asURLRequest()

        guard let expectURL = urlRequest.url else {
            throw UnitTestError(message: "The URL is not set or is nil")
        }

        XCTAssert(expectURL.absoluteString == "https://jsonplaceholder.typicode.com/posts/1",
                  "The URL is not same as input. \(expectURL)")

        guard let httpMethod = urlRequest.httpMethod else {
            throw UnitTestError(message: "The httpMethod is not set or is nil")
        }

        XCTAssert(httpMethod == "PUT", "The request method is not GET. the method is \(httpMethod)")
    }

    func testAPIParametersRequestValidResponse() throws {

        let validResponse = HTTPResponseValidation(statusCodes: Set(200...300), contentTypes: ["*/*", "application/json"])
        let request = APIParametersRequest(url: "https://jsonplaceholder.typicode.com/posts",
                                           method: .post,
                                           parameters: ["title": "Title", "body": "Body", "userId": 1],
                                           validResponse: validResponse)

        let urlRequest = try request.asURLRequest()

        guard let expectURL = urlRequest.url else {
            throw UnitTestError(message: "The URL is not set or is nil")
        }

        XCTAssert(expectURL.absoluteString == "https://jsonplaceholder.typicode.com/posts",
                  "The URL is not same as input. \(expectURL)")

        XCTAssertFalse(urlRequest.allHTTPHeaderFields.isEmpty, "The Https headers is nil or empty")
        XCTAssertNotNil(urlRequest.allHTTPHeaderFields?.contains(where: { $0.key == "Accept" }), "The Http Header Accept not found. make sure that is exist.")

    }

    func testAPIParametersRequestCustomHeaders() throws {
        let validResponse = HTTPResponseValidation(statusCodes: Set(200...300), contentTypes: ["*/*", "application/json"])
        let request = APIParametersRequest(url: "https://jsonplaceholder.typicode.com/posts",
                                           method: .post,
                                           parameters: ["title": "Title", "body": "Body", "userId": 1],
                                           headers: ["api-key": "google"],
                                           validResponse: validResponse)

        let urlRequest = try request.asURLRequest()

        guard let expectURL = urlRequest.url else {
            throw UnitTestError(message: "The URL is not set or is nil")
        }

        XCTAssert(expectURL.absoluteString == "https://jsonplaceholder.typicode.com/posts",
                  "The URL is not same as input. \(expectURL)")

        XCTAssertFalse(urlRequest.allHTTPHeaderFields.isEmpty, "The Https headers is nil or empty")
        let customHeader = urlRequest.allHTTPHeaderFields?.first(where: { $0.key == "api-key" }).map { $0.value }
        XCTAssertNotNil(customHeader, "The Http Header Accept not found. make sure that is exist.")
        XCTAssert(customHeader == "google")
    }

}

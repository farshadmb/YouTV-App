//
//  MockBuilder.swift
//  YouTVDemoTests
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import UIKit
import Mocker
import Alamofire
@testable import YouTVDemo

class NetworkMockBuilder {

    private var url: URLConvertible
    private var method: Mock.HTTPMethod = .get
    private var contentType: Mock.ContentType = .html
    private var statusCode: Int = 200
    private var data: [Mock.HTTPMethod: Data] = [:]
    private var headers: [String: String] = [:]

    init(URL: URLConvertible) {
        self.url = URL
    }

    func set(method: Mock.HTTPMethod) -> NetworkMockBuilder {
        self.method = method
        return self as NetworkMockBuilder
    }

    func set(contentType: Mock.ContentType) -> NetworkMockBuilder {
        self.contentType = contentType
        return self
    }

    func set(statusCode: Int) -> NetworkMockBuilder {
        self.statusCode = statusCode
        return self
    }

    func set(headers: [String: String]) -> NetworkMockBuilder {
        self.headers = headers
        return self
    }

    func set(data: [Mock.HTTPMethod: Data]) -> NetworkMockBuilder {
        self.data = data
        return self
    }

    func build() throws -> Mock {
        let mock = Mock(url: try url.asURL(),
                    contentType: contentType,
            statusCode: statusCode, data: data, additionalHeaders: headers)

        return mock
    }

}

// swiftlint:disable all
struct NetworkMockingDataFactory {

    static func createSimpleJSONData() -> Data {
        let person = APIPostModel(title: "Title", body: "Body", userId: 1)
        let data = try! JSONEncoder().encode(person)
        return data
    }

    static func createSimpleArrayJSONData() -> Data {
        let persons = Array(repeating: createSimpleJSONData(), count: 10)
        let data = try! JSONEncoder().encode(persons)
        return data
    }


    static func createRealJSONData() -> Data {
        fatalError("")
    }

    static func createImageData() -> Data {
        fatalError("")
    }

}

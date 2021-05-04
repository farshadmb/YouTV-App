//
//  RepositoriesHelper.swift
//  YouTVDemoTests
//
//  Created by Farshad Mousalou on 5/5/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import XCTest
import Mocker

extension XCTestCase {

    func mockResponserFetcher(name: String) throws -> Data {
        let bundle = Bundle(for: type(of: self))
        // swiftlint:disable:next force_unwrapping
        return try Data(contentsOf: bundle.url(forResource: name, withExtension: "json")!)
    }

    func buildMockResponse(url: String,
                           method: Mock.HTTPMethod = .get,
                           statusCode: Int = 200,
                           contentType: Mock.ContentType = .json,
                           data: Data = Data()) throws {

        let mock = try NetworkMockBuilder(URL: url)
            .set(method: method)
            .set(statusCode: statusCode)
            // swiftlint:disable:next force_unwrapping
            .set(data: [method: "".data(using: .utf8)!])
            .set(contentType: contentType)
            .build()

        Mocker.register(mock)
    }
}

//
//  RepositoriesHelper.swift
//  YouTVDemoTests
//
//  Created by Farshad Mousalou on 5/5/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import Alamofire
import Mocker

@testable import YouTVDemo

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
            .set(data: [method: data])
            .set(contentType: contentType)
            .build()

        Mocker.register(mock)
    }
}

// swiftlint:disable:next force_unwrapping
let language = Bundle.main.preferredLocalizations.first!

struct RepositoryDependencyContainer {

    static func createMockService() -> NetworkService {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let networkService = APIClientService(configuration: configuration,
                                              decoder: dataDecoder())
        return networkService
    }

    static func createRealService() -> NetworkServiceInterceptable {
        let configuration = URLSessionConfiguration.af.default
        let networkService = APIClientService(configuration: configuration,
                                              decoder: dataDecoder())
        return networkService
    }

    static func dataDecoder() -> Alamofire.DataDecoder {
        let dataDecoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: language)
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dataDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        dataDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return dataDecoder
    }

    static func validateResponse() -> NetworkResponseValidation {
        let acceptableStatusForError = [400, 401, 403, 404,
                                        405, 406, 422, 429,
                                        500, 501, 502, 503,
                                        504]
        return HTTPResponseValidation(statusCodes: Set((200..<300).map { $0 } + acceptableStatusForError),
                                      contentTypes: ["application/json"])
    }

    static func authenticator() -> NetworkRequestInterceptor {
        return APIAuthenticator(token: AppConfig.APIKey)
    }

}

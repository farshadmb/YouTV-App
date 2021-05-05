//
//  MoviesRepository.swift
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

class MoviesRepositoryTests: XCTestCase {

    let baseURL = AppConfig.baseURL.absoluteString
    var mockService: NetworkService!
    var networkService: NetworkServiceInterceptable!
    // swiftlint:disable:next force_unwrapping
    let language = Bundle.main.preferredLocalizations.first!

    private let integrationTimeExpections = 30.0
    private let timeExpections = 10.0

    let disposeBag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockService = createMockService()
        networkService = createRealService()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
    }

    ////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: Test Cases
    // MARK: -
    ////////////////////////////////////////////////////////////////

    func testSuccessFetchNowPlayingMovies() throws {

        let expectations = self.expectation(description: "\(#function)")
        let data = try mockResponserFetcher(name: "MoviesList")
        let repo: MoviesRepository = MoviesRemoteRepository(service: mockService, baseURL: baseURL, validResponse: validateResponse())
        let page = 1
        let url = baseURL + "/movie/now_playing?language=\(language)&page=\(page)"
        try buildMockResponse(url: url,
                              data: data)

        repo.fetchNowPlayingMovies(at: page, withLanguage: language)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { (pagination) in
                XCTAssert(pagination.page == page, "The received page is not the same as given page: Rec => \(page)")
                XCTAssertNotNil(pagination.results, "We expected that results have the values. ")
                print("result: ",pagination)
                expectations.fulfill()
            }, onError: { (error) in

                XCTFail("Occured error with info:\(error.localizedDescription)")
                expectations.fulfill()
            })
            .disposed(by: disposeBag)

        self.waitForExpectations(timeout: timeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testFailureFetchNowPlayingMovies() throws {
        let expectations = self.expectation(description: "\(#function)")

        guard let data = """
        {
            "success": false,
            "status_code": 34,
            "status_message": "The resource you requested could not be found."
        }
""".data(using: .utf8) else {
            throw UnitTestError(message: "Could not create a mock response data")
        }

        let repo: MoviesRepository = MoviesRemoteRepository(service: mockService, baseURL: baseURL, validResponse: validateResponse())
        let page = 1
        let url = baseURL + "/movie/now_playing?language=\(language)&page=\(page)"

        try buildMockResponse(url: url, statusCode: 404, data: data)

        repo.fetchNowPlayingMovies(at: page, withLanguage: language)
            .subscribe(onNext: { (_) in
                XCTFail("We've expected the error instead of success result.")
                expectations.fulfill()
            }, onError: { (error) in
                print("Occured error with info:\(type(of: error)) \(error.localizedDescription)")
                XCTAssert(error is APIServerResponseError, "The error must be `APIServerResponseError` \(type(of: error)).")

                guard case let APIServerResponseError.message(code,_) = error else {
                    XCTAssert(error is APIServerResponseError, "The error must be `APIServerResponseError` \(type(of: error)).")
                    expectations.fulfill()
                    return
                }

                XCTAssert(code == 34, "We expected server error code \(34) but found \(code).")
                expectations.fulfill()
            })
            .disposed(by: disposeBag)

        self.waitForExpectations(timeout: timeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testSuccessFetchTopRatedMovies() throws {

        let expectations = self.expectation(description: "\(#function)")
        let data = try mockResponserFetcher(name: "MoviesList")
        let repo: MoviesRepository = MoviesRemoteRepository(service: mockService, baseURL: baseURL, validResponse: validateResponse())
        let page = 1
        let url = baseURL + "/movie/top_rated?language=\(language)&page=\(page)"
        try buildMockResponse(url: url,
                              data: data)

        repo.fetchTopRatedMovies(at: page, withLanguage: language)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { (pagination) in
                XCTAssert(pagination.page == page, "The received page is not the same as given page: Rec => \(page)")
                XCTAssertNotNil(pagination.results, "We expected that results have the values. ")
                print("result: ",pagination)
                expectations.fulfill()
            }, onError: { (error) in

                XCTFail("Occured error with info:\(error.localizedDescription)")
                expectations.fulfill()
            })
            .disposed(by: disposeBag)

        self.waitForExpectations(timeout: timeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testFailureFetchTopRatedMovies() throws {
        let expectations = self.expectation(description: "\(#function)")

        guard let data = """
        {
            "success": false,
            "status_code": 22,
            "status_message": "Invalid page: Pages start at 1 and max at 1000. They are expected to be an integer."
        }
""".data(using: .utf8) else {
            throw UnitTestError(message: "Could not create a mock response data")
        }

        let repo: MoviesRepository = MoviesRemoteRepository(service: mockService, baseURL: baseURL, validResponse: validateResponse())
        let page = 0
        let url = baseURL + "/movie/top_rated?language=\(language)&page=\(page)"

        try buildMockResponse(url: url,statusCode: 400, data: data)

        repo.fetchTopRatedMovies(at: page, withLanguage: language)
            .subscribe(onNext: { (_) in
                XCTFail("We've expected the error instead of success result.")
                expectations.fulfill()
            }, onError: { (error) in
                print("Occured error with info:\(type(of: error)) \(error.localizedDescription)")
                XCTAssert(error is APIServerResponseError, "The error must be `APIServerResponseError` \(type(of: error)).")

                guard case let APIServerResponseError.message(code,_) = error else {
                    XCTAssert(error is APIServerResponseError, "The error must be `APIServerResponseError` \(type(of: error)).")
                    expectations.fulfill()
                    return
                }

                XCTAssert(code == 22, "We expected server error code \(22) but found \(code).")
                expectations.fulfill()
            })
            .disposed(by: disposeBag)

        self.waitForExpectations(timeout: timeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testSuccessFetchPopularMovies() throws {

        let expectations = self.expectation(description: "\(#function)")
        let data = try mockResponserFetcher(name: "MoviesList")
        let repo: MoviesRepository = MoviesRemoteRepository(service: mockService, baseURL: baseURL, validResponse: validateResponse())
        let page = 1
        let url = baseURL + "/movie/popular?language=\(language)&page=\(page)"
        try buildMockResponse(url: url,
                              data: data)

        repo.fetchPopularMovies(at: page, withLanguage: language)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { (pagination) in
                XCTAssert(pagination.page == page, "The received page is not the same as given page: Rec => \(page)")
                XCTAssertNotNil(pagination.results, "We expected that results have the values. ")
                print("result: ",pagination)
                expectations.fulfill()
            }, onError: { (error) in

                XCTFail("Occured error with info:\(error.localizedDescription)")
                expectations.fulfill()
            })
            .disposed(by: disposeBag)

        self.waitForExpectations(timeout: timeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testFailureFetchPopularMovies() throws {

        let expectations = self.expectation(description: "\(#function)")

        guard let data = """
        {
            "success": false,
            "status_code": 34,
            "status_message": "The resource you requested could not be found."
        }
""".data(using: .utf8) else {
            throw UnitTestError(message: "Could not create a mock response data")
        }

        let repo: MoviesRepository = MoviesRemoteRepository(service: mockService, baseURL: baseURL, validResponse: validateResponse())
        let page = 1
        let url = baseURL + "/movie/popular?language=\(language)qwe&page=\(page)"

        try buildMockResponse(url: url,statusCode: 404, data: data)

        repo.fetchPopularMovies(at: page, withLanguage: language + "qwe")
            .subscribe(onNext: { (_) in
                XCTFail("We've expected the error instead of success result.")
                expectations.fulfill()
            }, onError: { (error) in
                print("Occured error with info:\(type(of: error)) \(error.localizedDescription)")
                XCTAssert(error is APIServerResponseError, "The error must be `APIServerResponseError` \(type(of: error)).")

                guard case let APIServerResponseError.message(code,_) = error else {
                    XCTAssert(error is APIServerResponseError, "The error must be `APIServerResponseError` \(type(of: error)).")
                    expectations.fulfill()
                    return
                }

                XCTAssert(code == 34, "We expected server error code \(34) but found \(code).")
                expectations.fulfill()
            })
            .disposed(by: disposeBag)

        self.waitForExpectations(timeout: timeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testSuccessFetchRecommandationMovies() throws {

        let expectations = self.expectation(description: "\(#function)")
        let data = try mockResponserFetcher(name: "MoviesList")
        let repo: MoviesRepository = MoviesRemoteRepository(service: mockService, baseURL: baseURL, validResponse: validateResponse())
        let page = 1
        let movieId = 106_912

        let url = baseURL + "/movie/\(movieId)/recommendations?language=\(language)&page=\(page)"
        try buildMockResponse(url: url,
                              data: data)

        repo.fetchRecommandationMovies(forId: movieId, at: page, withLanguage: language)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { (pagination) in
                XCTAssert(pagination.page == page, "The received page is not the same as given page: Rec => \(page)")
                XCTAssertNotNil(pagination.results, "We expected that results have the values. ")
                print("result: ",pagination)
                expectations.fulfill()
            }, onError: { (error) in

                XCTFail("Occured error with info:\(error.localizedDescription)")
                expectations.fulfill()
            })
            .disposed(by: disposeBag)

        self.waitForExpectations(timeout: timeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testFailureFetchRecommandationMovies() throws {

        let expectations = self.expectation(description: "\(#function)")
        
        guard let data = """
        {
            "success": false,
            "status_code": 34,
            "status_message": "The resource you requested could not be found."
        }
""".data(using: .utf8) else {
            throw UnitTestError(message: "Could not create a mock response data")
        }

        let repo: MoviesRepository = MoviesRemoteRepository(service: mockService, baseURL: baseURL, validResponse: validateResponse())
        let page = 1
        let movieId = 106_912

        let url = baseURL + "/movie/\(movieId)/recommendations?language=\(language + "wrong")&page=\(page)"

        try buildMockResponse(url: url, statusCode: 404, data: data)

        repo.fetchRecommandationMovies(forId: movieId, at: page, withLanguage: language + "wrong")
            .subscribe(onNext: { (_) in
                XCTFail("We've expected the error instead of success result.")
                expectations.fulfill()
            }, onError: { (error) in
                XCTAssert(error is APIServerResponseError, "The error must be `APIServerResponseError` \(type(of: error)).")
                print("Occured error with info:\(type(of: error)) \(error.localizedDescription)")
                expectations.fulfill()
            })
            .disposed(by: disposeBag)

        self.waitForExpectations(timeout: timeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testSuccessFetchMovieDetail() throws {
        let expectations = self.expectation(description: "\(#function)")
        let movieId = 550

        let data = try mockResponserFetcher(name: "FightClubMovie")
        let url = baseURL + "/movie/\(movieId)?append_to_response=videos%2Cimages&language=\(language)"

        try buildMockResponse(url: url, data: data)

        let repo: MoviesRepository = MoviesRemoteRepository(service: mockService, baseURL: baseURL, validResponse: validateResponse())

        repo.fetchMovieDetail(forId: movieId, withLanguage: language)
            .subscribe(on: MainScheduler.instance)
            .subscribe { (movie) in
                // swiftlint:disable:next force_unwrapping
                XCTAssert(movie.id == movieId, "The received movie is not the same as given movieId: Rec => \(movie.id!)")
                print("result: ", movie)
                expectations.fulfill()
            } onFailure: { (error) in
                XCTFail("Occured error with info:\(error.localizedDescription)")
                expectations.fulfill()
            }
            .disposed(by: disposeBag)

        self.waitForExpectations(timeout: timeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testFailureFetchMovieDetail() throws {
        let expectations = self.expectation(description: "\(#function)")
        let movieId = 5_500_000_000_000
        guard let data = """
        {
            "success": false,
            "status_code": 34,
            "status_message": "The resource you requested could not be found."
        }
""".data(using: .utf8) else {
            throw UnitTestError(message: "Could not create a mock response data")
        }

        let url = baseURL + "/movie/\(movieId)?append_to_response=videos%2Cimages&language=\(language)"

        try buildMockResponse(url: url, statusCode: 404, data: data)

        let repo: MoviesRepository = MoviesRemoteRepository(service: mockService, baseURL: baseURL, validResponse: validateResponse())

        repo.fetchMovieDetail(forId: movieId, withLanguage: language)
            .subscribe(on: MainScheduler.instance)
            .subscribe { (_) in
                XCTFail("We've expected the error instead of success result.")
                expectations.fulfill()
            } onFailure: { (error) in
                XCTAssert(error is APIServerResponseError, "The error must be `APIServerResponseError` \(type(of: error)).")
                print("Occured error with info:\(type(of: error)) \(error.localizedDescription)")
                expectations.fulfill()
            }
            .disposed(by: disposeBag)

        self.waitForExpectations(timeout: timeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    ////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: Integration Test Caes
    // MARK: -
    ////////////////////////////////////////////////////////////////

    func testSuccessFetchPopularMoviesIntegration() throws {
        let expectations = self.expectation(description: "\(#function)")

        self.wait(for: [expectations], timeout: integrationTimeExpections)
        self.waitForExpectations(timeout: integrationTimeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testFailureFetchPopularMoviesIntegration() throws {
        let expectations = self.expectation(description: "\(#function)")

        self.wait(for: [expectations], timeout: integrationTimeExpections)
        self.waitForExpectations(timeout: integrationTimeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testSuccessFetchMovieDetailIntegration() throws {
        let expectations = self.expectation(description: "\(#function)")

        self.wait(for: [expectations], timeout: integrationTimeExpections)
        self.waitForExpectations(timeout: integrationTimeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testFailureFetchMovieDetailIntegration() throws {
        let expectations = self.expectation(description: "\(#function)")

        self.wait(for: [expectations], timeout: integrationTimeExpections)
        self.waitForExpectations(timeout: integrationTimeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }
}

fileprivate extension MoviesRepositoryTests {

    func createMockService() -> NetworkService {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let networkService = APIClientService(configuration: configuration,
                                              decoder: dataDecoder())
        return networkService
    }

    func createRealService() -> NetworkServiceInterceptable {
        let configuration = URLSessionConfiguration.af.default
        let networkService = APIClientService(configuration: configuration,
                                              decoder: dataDecoder())
        return networkService
    }

    func dataDecoder() -> Alamofire.DataDecoder {
        let dataDecoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: language)
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dataDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        dataDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return dataDecoder
    }

    func validateResponse() -> NetworkResponseValidation {
        let acceptableStatusForError = [400, 401, 403, 404,
                                        405, 406, 422, 429,
                                        500, 501, 502, 503,
                                        504]
        return HTTPResponseValidation(statusCodes: Set((200..<300).map { $0 } + acceptableStatusForError),
                                      contentTypes: ["application/json"])
    }
    
}

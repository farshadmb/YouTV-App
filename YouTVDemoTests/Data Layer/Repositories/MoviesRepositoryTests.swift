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
        let data = try mockResponserFetcher(name: "MovieList")
        let repo: MoviesRepository = MoviesRemoteRepository(service: mockService, baseURL: baseURL)

        try buildMockResponse(url: baseURL + "movie/now_playing", data: data)

        repo.fetchNowPlayingMovies(at: 1, withLanguage: language)
            .subscribe(onNext: { (_) in
                expectations.fulfill()

            }, onError: { (error) in
                expectations.fulfill()
                XCTFail("Occured error with info:\(error)")
            })
            .disposed(by: disposeBag)

        self.wait(for: [expectations], timeout: timeExpections)
        self.waitForExpectations(timeout: timeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testFailureFetchNowPlayingMovies() throws {
        let expectations = self.expectation(description: "\(#function)")

        self.wait(for: [expectations], timeout: timeExpections)
        self.waitForExpectations(timeout: timeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testSuccessFetchTopRatedMovies() throws {
        let expectations = self.expectation(description: "\(#function)")

        self.wait(for: [expectations], timeout: timeExpections)
        self.waitForExpectations(timeout: timeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testFailureFetchTopRatedMovies() throws {
        let expectations = self.expectation(description: "\(#function)")

        self.wait(for: [expectations], timeout: timeExpections)
        self.waitForExpectations(timeout: timeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testSuccessFetchPopularMovies() throws {
        let expectations = self.expectation(description: "\(#function)")

        self.wait(for: [expectations], timeout: timeExpections)
        self.waitForExpectations(timeout: timeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testFailureFetchPopularMovies() throws {
        let expectations = self.expectation(description: "\(#function)")

        self.wait(for: [expectations], timeout: timeExpections)
        self.waitForExpectations(timeout: timeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testSuccessFetchRecommandationMovies() throws {
        let expectations = self.expectation(description: "\(#function)")

        self.wait(for: [expectations], timeout: timeExpections)
        self.waitForExpectations(timeout: timeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testFailureFetchRecommandationMovies() throws {
        let expectations = self.expectation(description: "\(#function)")

        self.wait(for: [expectations], timeout: timeExpections)
        self.waitForExpectations(timeout: timeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testSuccessFetchMovieDetail() throws {
        let expectations = self.expectation(description: "\(#function)")

        self.wait(for: [expectations], timeout: timeExpections)
        self.waitForExpectations(timeout: timeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testFailureFetchMovieDetail() throws {
        let expectations = self.expectation(description: "\(#function)")

        self.wait(for: [expectations], timeout: timeExpections)
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
        let networkService = APIClientService(configuration: configuration)
        return networkService
    }

    func createRealService() -> NetworkServiceInterceptable {
        let configuration = URLSessionConfiguration.af.default
        let networkService = APIClientService(configuration: configuration)
        return networkService
    }

}

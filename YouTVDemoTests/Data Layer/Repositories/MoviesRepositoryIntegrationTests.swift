//
//  MoviesRepositoryIntegrationTests.swift
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

extension MoviesRepositoryTests {

    ////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: Integration Test Cases
    // MARK: -
    ////////////////////////////////////////////////////////////////

    func testSuccessFetchPopularMoviesIntegration() throws {
        let expectations = self.expectation(description: "\(#function)")
        let page = 1
        let repo: MoviesRepository = MoviesRemoteRepository(service: networkService,
                                                            baseURL: baseURL, validResponse: validation)
        networkService.apply(interceptor: RepositoryDependencyContainer.authenticator())

        repo.fetchPopularMovies(at: page, withLanguage: language)
            .subscribe(on: MainScheduler.instance)
            .subscribe { (pagination) in
                XCTAssert(pagination.page == page, "The received page is not the same as given page: Rec => \(page)")
                XCTAssertNotNil(pagination.results, "We expected that results have the values. ")
                print("result: ",pagination)
                expectations.fulfill()
                
            } onError: { (error) in
                print("Occured Error: \(error)")
                XCTFail("Occured error with info:\(error.localizedDescription)")
                expectations.fulfill()

            }
            .disposed(by: disposeBag)

        self.waitForExpectations(timeout: integrationTimeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testFailureFetchRecommendationIntegration() throws {
        let expectations = self.expectation(description: "\(#function)")
        let page = 0
        let repo: MoviesRepository = MoviesRemoteRepository(service: networkService,
                                                            baseURL: baseURL, validResponse: validation)
        let movieId = 106_912

        networkService.apply(interceptor: RepositoryDependencyContainer.authenticator())

        repo.fetchRecommandationMovies(forId: movieId, at: page, withLanguage: language)
            .subscribe(on: MainScheduler.instance)
            .subscribe { (pagination) in
                XCTFail("We didn't expect the results have the values. ")
                print("result: ", pagination)
                expectations.fulfill()

            } onError: { (error) in
                print("Occured error with info:\(type(of: error)) \(error.localizedDescription)")
                XCTAssert(error is APIServerResponseError, "The error must be `APIServerResponseError` \(type(of: error)).")

                guard case let APIServerResponseError.message(code,_) = error else {
                    expectations.fulfill()
                    return
                }
                // according to the site documention
                XCTAssert(code == 22, "We expected server error code \(22) but found \(code).")
                expectations.fulfill()
            }
            .disposed(by: disposeBag)

        self.waitForExpectations(timeout: integrationTimeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testFailureAuthenticationFetchPopularMoviesIntegration() throws {
        let expectations = self.expectation(description: "\(#function)")
        let page = 0
        let repo: MoviesRepository = MoviesRemoteRepository(service: networkService,
                                                            baseURL: baseURL, validResponse: validation)

        repo.fetchPopularMovies(at: page, withLanguage: language)
            .subscribe(on: MainScheduler.instance)
            .subscribe { (pagination) in
                XCTFail("We didn't expect the results have the values. ")
                print("result: ", pagination)
                expectations.fulfill()

            } onError: { (error) in
                print("Occured error with info:\(type(of: error)) \(error.localizedDescription)")
                XCTAssert(error is APIServerResponseError, "The error must be `APIServerResponseError` \(type(of: error)).")

                guard case let APIServerResponseError.message(code,_) = error else {
                    expectations.fulfill()
                    return
                }

                XCTAssert(code == 7, "We expected server error code \(7) but found \(code).")
                expectations.fulfill()

            }
            .disposed(by: disposeBag)

        self.waitForExpectations(timeout: integrationTimeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }

    func testSuccessFetchMovieDetailIntegration() throws {
        let expectations = self.expectation(description: "\(#function)")
        let movieId = 550

        networkService.apply(interceptor: RepositoryDependencyContainer.authenticator())

        let repo: MoviesRepository = MoviesRemoteRepository(service: networkService, baseURL: baseURL, validResponse: validation)

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

    func testFailureFetchMovieDetailIntegration() throws {
        let expectations = self.expectation(description: "\(#function)")
        let movieId = -550

        networkService.apply(interceptor: RepositoryDependencyContainer.authenticator())

        let repo: MoviesRepository = MoviesRemoteRepository(service: networkService, baseURL: baseURL, validResponse: validation)

        repo.fetchMovieDetail(forId: movieId, withLanguage: language)
            .subscribe(on: MainScheduler.instance)
            .subscribe { (_) in
                XCTFail("We've expected the error instead of success result.")
                expectations.fulfill()
            } onFailure: { (error) in
                XCTAssert(error is APIServerResponseError, "The error must be `APIServerResponseError` \(type(of: error)).")
                print("Occured error with info: \(type(of: error)) \(error.localizedDescription)")
                expectations.fulfill()
            }
            .disposed(by: disposeBag)

        self.waitForExpectations(timeout: timeExpections) { (error) in
            if let error = error {
                XCTFail("\(#function) is not fulfulled in expections time with error \(error)")
            }
        }
    }
}

//
//  MoviesRepositoryMockTest.swift
//  YouTVDemoTests
//
//  Created by Farshad Mousalou on 5/5/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import XCTest
import RxSwift
import Alamofire

@testable import YouTVDemo

class MoviesRepositoryMockTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// <#Description#>
    /// - Throws: <#description#>
    func testMethodsImplemention() throws {

        let repository: MoviesRepository = MockMoviesRepository()

        _ = repository.fetchNowPlayingMovies(at: 0, withLanguage: "")
        _ = repository.fetchPopularMovies(at: 0, withLanguage: "")
        _ = repository.fetchTopRatedMovies(at: 0, withLanguage: "")
        _ = repository.fetchMovieDetail(forId: 0, withLanguage: "")
        _ = repository.fetchRecommandationMovies(forId: 0, at: 0, withLanguage: "")

        guard let repos = repository as? MockMoviesRepository else {
            throw UnitTestError(message: "Can not cast Repository to \(String(describing: MockMoviesRepository.self))")
        }

        XCTAssert(repos.isCalledRecommendation == true, "The fetch recommendation method is not called, we don't expect that.")
        XCTAssert(repos.isCalledPopular == true, "The fetch popular method is not called, we don't expect that.")
        XCTAssert(repos.isCalledTopRated == true, "The fetch top rated method is not called, we don't expect that.")
        XCTAssert(repos.isCalledNowPlaying == true, "The fetch now playing method is not called, we don't expect that.")
        XCTAssert(repos.isCalledDetail == true, "The fetch detail method is not called, we don't expect that.")

    }

}

internal final class MockMoviesRepository: MoviesRepository {

    var isCalledRecommendation = false
    var isCalledNowPlaying = false
    var isCalledTopRated = false
    var isCalledPopular = false
    var isCalledDetail = false

    func fetchRecommandationMovies(forId: Int, at page: Int, withLanguage: String) -> Observable<Pagination<Movie>> {
        isCalledRecommendation = true
        return .empty()
    }

    func fetchNowPlayingMovies(at page: Int, withLanguage: String) -> Observable<Pagination<Movie>> {
        isCalledNowPlaying = true
        return .empty()
    }

    func fetchTopRatedMovies(at page: Int, withLanguage: String) -> Observable<Pagination<Movie>> {
        isCalledTopRated = true
        return .empty()
    }

    func fetchPopularMovies(at page: Int, withLanguage: String) -> Observable<Pagination<Movie>> {
        isCalledPopular = true
        return .empty()
    }

    func fetchMovieDetail(for movie: Movie, withLanguage: String) -> Single<Detail> {
        isCalledDetail = true
        return .error(UnitTestError(message: ""))
    }

    func fetchMovieDetail(forId: Int, withLanguage: String) -> Single<Detail> {
        isCalledDetail = true
        return .error(UnitTestError(message: ""))
    }
    
}

//
//  MoviesUseCases.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/5/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import Combine

/**
 <# Property Summery Here#>
 */
protocol MoviesUseCases: class {

    /**
     <# Property Summery Here#>
     - Parameter id: <#id description#>
     - Returns:
     */
    func fetchRecommandation(forId id: Int) -> Single<[MovieSummery]>

    /**
     <# Property Summery Here#>
     - Parameter movie: <#movie description#>
     - Returns:
     */
    func getDetail(forMovie movie: MovieSummery) -> Single<MovieDetail>

    /**
     <# Property Summery Here#>
     - Parameter movie: <#movie description#>
     - Returns:
     */
    func getDetail(forMovie movie: MovieSummery) -> Future<MovieDetail, Error>
}

protocol PopularMoviesUseCases: MoviesUseCases {

    /**
     <# Property Summery Here#>
     - Returns:
     */
    func fetchPopularMovies() -> Single<[MovieSummery]>

    /**
     <# Property Summery Here#>
     - Returns:
     */
    func fetchMorePopularMovies() -> Observable<[MovieSummery]>
}

protocol TopRatedMoviesUseCases: MoviesUseCases {

    /**
     <# Property Summery Here#>
     - Returns:
     */
    func fetchTopRatedMovies() -> Single<[MovieSummery]>

    /**
     <# Property Summery Here#>
     - Returns:
     */
    func fetchMoreTopRatedMovies() -> Observable<[MovieSummery]>
}

protocol NowPlayingMoviesUseCases: MoviesUseCases {

    /**
     <# Property Summery Here#>
     - Returns:
     */
    func fetchNowPlayingMovies() -> Single<[MovieSummery]>

    /**
     <# Property Summery Here#>
     - Returns:
     */
    func fetchMoreNowPlayingMovies() -> Observable<[MovieSummery]>
}

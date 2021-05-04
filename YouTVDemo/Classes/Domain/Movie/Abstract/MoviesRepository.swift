//
//  MoviesRepository.swift
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
protocol MoviesRepository: class {

    /// `Movie` typealiase represent the `MovieSummery`
    typealias Movie = MovieSummery

    /// `Detail` typealiase represent the `MovieDetail`
    typealias Detail = MovieDetail

    /**

     - Parameters:
       - forId: <#forId description#>
       - page: <#page description#>
       - withLanguage: <#withLanguage description#>
     */
    func fetchRecommandationMovies(forId: Int, at page: Int, withLanguage: String) -> Observable<Pagination<Movie>>

    /**
     <# Property Summery Here#>
     - Parameters:
       - page: <#page description#>
       - withLanguage: <#withLanguage description#>
     */
    func fetchNowPlayingMovies(at page: Int, withLanguage: String) -> Observable<Pagination<Movie>>

    /**
     <# Property Summery Here#>
     - Parameters:
       - page: <#page description#>
       - withLanguage: <#withLanguage description#>
     */
    func fetchTopRatedMovies(at page: Int, withLanguage: String) -> Observable<Pagination<Movie>>

    /**
     <# Property Summery Here#>
     - Parameters:
     - page: <#page description#>
     - withLanguage: <#withLanguage description#>
     */
    func fetchPopularMovies(at page: Int, withLanguage: String) -> Observable<Pagination<Movie>>

    /**
     <# Property Summery Here#>
     - Parameters:
       - movie: <#movie description#>
       - withLanguage: <#withLanguage description#>
     */
    func fetchMovieDetail(for movie: Movie, withLanguage: String) -> Single<Detail>

    /**
     <# Property Summery Here#>
     - Parameters:
       - forId: <#forId description#>
       - withLanguage: <#withLanguage description#>
     */
    func fetchMovieDetail(forId: Int, withLanguage: String) -> Single<Detail>
}

extension MoviesRepository {

    /**
     <# Property Summery Here#>
     - Parameters:
       - id: <#id description#>
       - lang: <#lang description#>
     - Returns: <#description#>
     */
    func fetchMovieDetail(forId id: Int, withLanguage lang: String) -> AnyPublisher<Detail, Error> {
        return AnyPublisher.create {[weak base = self] (observer) in

            guard let base = base else {
                observer.onCompleted()
                return CombineDisposable {

                }
            }

            let dispose = base.fetchMovieDetail(forId: id, withLanguage: lang)
                .asObservable()
                .subscribe { (event) in
                    switch event {
                    case .completed:
                        observer.onCompleted()
                    case .error(let error):
                        observer.onError(error)
                    case .next(let value):
                        observer.onNext(value)
                    }
                }

            return CombineDisposable {
                dispose.dispose()
            }
        }
    }

    /**
     <# Property Summery Here#>
     - Parameters:
       - movie: <#movie description#>
       - lang: <#lang description#>
     - Returns: <#description#>
     */
    func fetchMovieDetail(for movie: Movie, withLanguage lang: String) -> AnyPublisher<Detail, Error> {
       return AnyPublisher.create {[weak base = self] (observer) in

            guard let base = base else {
                observer.onCompleted()
                return CombineDisposable {

                }
            }

            let dispose = base.fetchMovieDetail(for: movie, withLanguage: lang)
                .asObservable()
                .subscribe { (event) in
                    switch event {
                    case .completed:
                        observer.onCompleted()
                    case .error(let error):
                        observer.onError(error)
                    case .next(let value):
                        observer.onNext(value)
                    }
                }

            return CombineDisposable {
                dispose.dispose()
            }
       }
    }
}

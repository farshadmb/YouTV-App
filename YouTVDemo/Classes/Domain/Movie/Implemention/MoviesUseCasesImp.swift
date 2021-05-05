//
//  MoviesUseCasesImp.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/5/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

/// <#Description#>
final class MoviesUseCasesImp: MoviesUseCases, PopularMoviesUseCases, TopRatedMoviesUseCases, NowPlayingMoviesUseCases {

    /// <#Description#>
    let repository: MoviesRepository

    /// <#Description#>
    let language: String

    @Atomic
    private var popularPaginator: Pagination<MovieSummery>

    @Atomic
    private var topRatedPaginator: Pagination<MovieSummery>

    @Atomic
    private var nowPlayingPaginator: Pagination<MovieSummery>

    /// Default Initiliazer for `MoviesUseCasesImp`
    /// - Parameters:
    ///   - repository: The `MoviesRepository` to be injected and work with MovieRepository.
    ///   - language: The iso 1361_1 `String` language value.
    init(repository: MoviesRepository, language: String) {
        self.repository = repository
        self.language = language

        popularPaginator = .init(page: 1, results: nil, dates: nil, totalPages: 1, totalResults: 0)
        topRatedPaginator = .init(page: 1, results: nil, dates: nil, totalPages: 1, totalResults: 0)
        nowPlayingPaginator = .init(page: 1, results: nil, dates: nil, totalPages: 1, totalResults: 0)
    }

    // MARK: - MovieUseCases Implemention

    func fetchRecommandation(forId id: Int) -> Single<[MovieSummery]> {
        return repository.fetchRecommandationMovies(forId: id, at: 1, withLanguage: language)
            .map {
                $0.results ?? []
            }
            .asSingle()
    }

    func getDetail(forMovie movie: MovieSummery) -> Single<MovieDetail> {
        return repository.fetchMovieDetail(for: movie, withLanguage: language)
    }

    func getDetail(forMovie movie: MovieSummery) -> Future<MovieDetail, Error> {
        return repository.fetchMovieDetail(for: movie, withLanguage: language).asFuture()
    }

    // MARK: - PopularMoviesUseCases Implemention

    func fetchPopularMovies() -> Single<[MovieSummery]> {
        return repository.fetchPopularMovies(at: 1, withLanguage: language)
            .do(onNext: {[weak self] (pagination) in
                self?.popularPaginator = pagination
            })
            .map {
                $0.results ?? []
            }
            .asSingle()
    }

    func fetchMorePopularMovies() -> Observable<[MovieSummery]> {

        guard popularPaginator.hasNext else {
            return .never()
        }

        return repository.fetchPopularMovies(at: popularPaginator.nextPage(), withLanguage: language)
            .do(onNext: {[weak self] (pagination) in
                self?.popularPaginator = pagination
            })
            .map {
                $0.results ?? []
            }
    }

    // MARK: - TopRatedMoviesUseCases Implemention
    
    func fetchTopRatedMovies() -> Single<[MovieSummery]> {
        return repository.fetchTopRatedMovies(at: 1, withLanguage: language)
            .do(onNext: {[weak self] (pagination) in
                self?.topRatedPaginator = pagination
            })
            .map {
                $0.results ?? []
            }
            .asSingle()
    }

    func fetchMoreTopRatedMovies() -> Observable<[MovieSummery]> {

        guard topRatedPaginator.hasNext else {
            return .never()
        }

        return repository.fetchTopRatedMovies(at: topRatedPaginator.nextPage(), withLanguage: language)
            .do(onNext: {[weak self] (pagination) in
                self?.topRatedPaginator = pagination
            })
            .map {
                $0.results ?? []
            }
    }

    // MARK: - NowPlayingMoviesUseCases Implemention

    func fetchNowPlayingMovies() -> Single<[MovieSummery]> {
        return repository.fetchPopularMovies(at: 1, withLanguage: language)
            .do(onNext: {[weak self] (pagination) in
                self?.nowPlayingPaginator = pagination
            })
            .map {
                $0.results ?? []
            }
            .asSingle()
    }

    func fetchMoreNowPlayingMovies() -> Observable<[MovieSummery]> {
        guard nowPlayingPaginator.hasNext else {
            return .never()
        }

        return repository.fetchPopularMovies(at: nowPlayingPaginator.nextPage(), withLanguage: language)
            .do(onNext: {[weak self] (pagination) in
                self?.nowPlayingPaginator = pagination
            })
            .map {
                $0.results ?? []
            }
    }

}

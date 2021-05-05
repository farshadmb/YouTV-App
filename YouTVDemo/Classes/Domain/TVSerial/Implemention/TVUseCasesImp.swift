//
//  TVUseCasesImp.swift
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
final class TVUseCasesImp: TVUseCases, PopularTVUseCases, TopRatedTVUseCases, OnAirTVUseCases {

    /// <#Description#>
    let repository: TVRepository

    /// <#Description#>
    let language: String

    @Atomic
    private var popularPaginator: Pagination<TVSerialSummery>

    @Atomic
    private var topRatedPaginator: Pagination<TVSerialSummery>

    @Atomic
    private var onAirPaginator: Pagination<TVSerialSummery>

    /// Default Initiliazer for `TVUseCasesImp`
    /// - Parameters:
    ///   - repository: The `TVRepository` to be injected and work with MovieRepository.
    ///   - language: The iso 1361_1 `String` language value.
    init(repository: TVRepository, language: String) {
        self.repository = repository
        self.language = language

        popularPaginator = .init(page: 1, results: nil, dates: nil, totalPages: 1, totalResults: 0)
        topRatedPaginator = .init(page: 1, results: nil, dates: nil, totalPages: 1, totalResults: 0)
        onAirPaginator = .init(page: 1, results: nil, dates: nil, totalPages: 1, totalResults: 0)
    }

    // MARK: - TVUseCases Implemention

    func fetchRecommandation(forId id: Int) -> Single<[TVSerialSummery]> {
        return repository.fetchRecommandationTVSerial(forId: id, at: 1, withLanguage: language)
            .map {
                $0.results ?? []
            }
            .asSingle()
    }

    func getDetail(forSerial serial: TVSerialSummery) -> Single<TVSerialDetail> {
        return repository.fetchTVSerialDetail(forSerial: serial, withLanguage: language)
    }

    func getDetail(forSerial serial: TVSerialSummery) -> Future<TVSerialDetail, Error> {
        return repository.fetchSerialDetail(for: serial, withLanguage: language).asFuture()
    }

    // MARK: - Popular

    func fetchPopularTVSerials() -> Single<[TVSerialSummery]> {
        return repository.fetchPopularTVSerials(at: 1, withLanguage: language)
            .do(onNext: {[weak self] (pagination) in
                self?.popularPaginator = pagination
            })
            .map {
                $0.results ?? []
            }
            .asSingle()
    }

    func fetchMorePopularTVSerials() -> Observable<[TVSerialSummery]> {
        guard popularPaginator.hasNext else {
            return .never()
        }

        return repository.fetchPopularTVSerials(at: popularPaginator.nextPage(), withLanguage: language)
            .do(onNext: {[weak self] (pagination) in
                self?.popularPaginator = pagination
            })
            .map {
                $0.results ?? []
            }
    }

    // MARK: - TopRated
    func fetchTopRatedTVSerials() -> Single<[TVSerialSummery]> {

        return repository.fetchTopRatedTVSerials(at: 1, withLanguage: language)
            .do(onNext: {[weak self] (pagination) in
                self?.topRatedPaginator = pagination
            })
            .map {
                $0.results ?? []
            }
            .asSingle()
    }

    func fetchMoreTopRatedTVSerials() -> Observable<[TVSerialSummery]> {
        guard topRatedPaginator.hasNext else {
            return .never()
        }

        return repository.fetchTopRatedTVSerials(at: topRatedPaginator.nextPage(), withLanguage: language)
            .do(onNext: {[weak self] (pagination) in
                self?.topRatedPaginator = pagination
            })
            .map {
                $0.results ?? []
            }
    }

    // MARK: - OnAirTVUseCases Implemention
    func fetchOnAirTVSerials() -> Single<[TVSerialSummery]> {
        repository.fetchPopularTVSerials(at: 1, withLanguage: language)
            .do(onNext: {[weak self] (pagination) in
                self?.onAirPaginator = pagination
            })
            .map {
                $0.results ?? []
            }
            .asSingle()
    }

    func fetchMoreOnAirTVSerials() -> Observable<[TVSerialSummery]> {
        guard onAirPaginator.hasNext else {
            return .never()
        }

        return repository.fetchPopularTVSerials(at: onAirPaginator.nextPage(), withLanguage: language)
            .do(onNext: {[weak self] (pagination) in
                self?.onAirPaginator = pagination
            })
            .map {
                $0.results ?? []
            }
    }

}

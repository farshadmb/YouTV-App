//
//  TrendingUseCasesImp.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/17/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

/// The `TrendingUseCasesImp` implemented `TrendingUseCase`, `TVTrendingUseCase` and `MovieTrendingUseCase`.
final class TrendingUseCasesImp: TrendingUseCase, TVTrendingUseCase, MovieTrendingUseCase {

    /// The `TrendingRepository` repository.
    let repository: TrendingRepository

    /// The iso 1361_1 `String` language value.
    let language: String

    /// Default Initiliazer for `TrendingUseCasesImp`
    /// - Parameters:
    ///   - repository: The `TrendingRepository` to be injected and work around TrendingRepository.
    ///   - language: The iso 1361_1 `String` language value.
    init(repository: TrendingRepository, language: String) {
        self.repository = repository
        self.language = language
        
    }

    // MARK: - TrendingUseCase Implemention
    func fetchTrendings() -> Single<[Any]> {
        return repository.fetchTredingsContent(at: 1, withLanguage: language)
            .map {
                $0.results ?? []
            }
            .asSingle()
    }
    
    // MARK: - TVTrendingUseCase

    func fetchTVTrendings() -> Single<[TVTrendingUseCase.DataType]> {
        return repository.fetchTVTrendings(at: 1, withLanguage: language)
            .map {
                $0.results ?? []
            }
            .asSingle()
    }

    // MARK: - MovieTrendingUseCase
    func fetchMoviesTrendings() -> Single<[MovieTrendingUseCase.DataType]> {
        repository.fetchMovieTrendings(at: 1, withLanguage: language)
            .map {
                $0.results ?? []
            }
            .asSingle()
    }
}

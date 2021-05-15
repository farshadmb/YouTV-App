//
//  HomeDependencyContainer.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/11/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import UIKit

final class HomeDependencyContainer {

    let movieRepository: MoviesRepository
    let tvRepository: TVRepository
    let remoteImageBuilder: RemoteImageAssetBuilder
    let language: String

    init(appDependecyContainer: AppDependencyContainer) {
        movieRepository = appDependecyContainer.sharedMovieRepository
        tvRepository = appDependecyContainer.sharedShowRepository
        language = appDependecyContainer.language
        remoteImageBuilder = appDependecyContainer.remoteImageBuilder
    }

    // MARK: - HomeViewModelsFactory

    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(factory: self)
    }

    func makeHomeMoviesViewModel(for type: HomeMoviesViewModel.SectionType) -> HomeMoviesViewModel {
        switch type {
        case .nowPlaying:
            return HomeNowPlayingMoviesViewModel(order: 0, useCase: makeNowPlayingUseCase(), factory: self)
        case .popular:
            return HomePopularMoviesViewModel(order: 0, useCase: makePopularMovieUseCase(), factory: self)
        case .topRated:
            return HomeTopRatedMoviesViewModel(order: 0, useCase: makeTopRatedMovieUseCase(), factory: self)
        }
    }

    func makeHomeShowsViewModel(for type: HomeShowsViewModel.SectionType) -> HomeShowsViewModel {
        switch type {
        case .onTheAir:
            return HomeOnTheAirShowsViewModel(order: 0, useCase: makeOnTheAirUseCase(), factory: self)
        case .popular:
            return HomePopularShowsViewModel(order: 0, useCase: makePopularShowUseCase(), factory: self)
        case .topRated:
            fatalError("Not Implemente yet")
        }
    }

    func makeHomeShowViewModel(with model: TVSerialSummery) -> HomeShowViewModel {
        return HomeShowViewModel(model: model, remoteImageBuilder: remoteImageBuilder)
    }

    func makeHomeMovieViewModel(with model: MovieSummery) -> HomeMovieViewModel {
        return HomeMovieViewModel(model: model, remoteImageBuilder: remoteImageBuilder)
    }

    // MARK: - SectionHomeViewControllerFactory
    
    func makeHomeViewController() -> HomeViewController {
        let viewController: HomeViewController = instantiateViewController()
        let viewModel = makeHomeViewModel()
        viewController.bind(to: viewModel)

        return viewController
    }

    private func instantiateViewController<T: UIViewController & Storyboarded & BindableType>() -> T {
        guard let value = try? T.instantiate() else {
            preconditionFailure("Failed to make \(T.self)")
        }

        return value
    }

}

extension HomeDependencyContainer: HomeViewModelsFactory, HomeViewControllerFactory {}

extension HomeDependencyContainer: TVUseCaseFactory {

    func makePopularShowUseCase() -> PopularTVUseCases {
        return TVUseCasesImp(repository: tvRepository, language: language)
    }

    func makeTopRatedShowUseCase() -> TopRatedTVUseCases {
        return TVUseCasesImp(repository: tvRepository, language: language)
    }

    func makeOnTheAirUseCase() -> OnAirTVUseCases {
        return TVUseCasesImp(repository: tvRepository, language: language)
    }

}

extension HomeDependencyContainer: MovieUseCaseFactory {

    func makePopularMovieUseCase() -> PopularMoviesUseCases {
        return MoviesUseCasesImp(repository: movieRepository, language: language)
    }

    func makeTopRatedMovieUseCase() -> TopRatedMoviesUseCases {
        return MoviesUseCasesImp(repository: movieRepository, language: language)
    }

    func makeNowPlayingUseCase() -> NowPlayingMoviesUseCases {
        return MoviesUseCasesImp(repository: movieRepository, language: language)
    }

}

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

    init(movieRepository: MoviesRepository, tvRepository: TVRepository) {
        self.tvRepository = tvRepository
        self.movieRepository = movieRepository
    }

    init(appDependecyContainer: Any) {
        fatalError("Not Implemente Yet")
    }

    // MARK: - HomeViewModelsFactory

    func makeHomeViewModel() -> HomeViewModel {
        fatalError("Not Implemente Yet")
    }

    func makeHomeMoviesViewModel(for type: HomeMoviesViewModel.SectionType) -> HomeMoviesViewModel {
        fatalError("Not Implemente Yet")
    }

    func makeHomeShowsViewModel(for type: HomeShowsViewModel.SectionType) -> HomeShowsViewModel {
        fatalError("Not Implemente Yet")
    }

    func makeHomeShowViewModel(with model: TVSerialSummery) -> HomeShowViewModel {
        return .init(model: model)
    }

    func makeHomeMovieViewModel(with model: MovieSummery) -> HomeMovieViewModel {
        return HomeMovieViewModel(model: model)
    }

    // MARK: - SectionHomeViewControllerFactory
    
    func makeHomeViewController() -> HomeViewController {
        let viewController : HomeViewController = instantiateViewController()
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

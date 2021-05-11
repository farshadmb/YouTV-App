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
        fatalError("Not Implemente Yet")
    }

    func makeHomeMovieViewModel(with model: MovieSummery) -> HomeMovieViewModel {
        fatalError("Not Implemente Yet")
    }

    // MARK: - SectionHomeViewControllerFactory
    
    func makeHomeViewController() -> HomeViewController {
        fatalError("Not Implemente Yet")
    }
}

extension HomeDependencyContainer: HomeViewModelsFactory, HomeViewControllerFactory {}

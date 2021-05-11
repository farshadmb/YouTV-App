//
//  HomeViewModelsFactory.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/11/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

protocol HomeViewModelsFactory {

    func makeHomeViewModel() -> HomeViewModel

    func makeHomeMoviesViewModel(for type: HomeMoviesViewModel.SectionType) -> HomeMoviesViewModel

    func makeHomeShowsViewModel(for type: HomeShowsViewModel.SectionType) -> HomeShowsViewModel

    func makeHomeMovieViewModel(with model: MovieSummery) -> HomeMovieViewModel

    func makeHomeShowViewModel(with model: TVSerialSummery) -> HomeShowViewModel

}

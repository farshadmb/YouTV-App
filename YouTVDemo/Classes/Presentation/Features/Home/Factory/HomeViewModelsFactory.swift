//
//  HomeViewModelsFactory.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/11/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

/**
 <# Property Summery Here#>
 */
protocol HomeViewModelsFactory {

    /**
     <# Property Summery Here#>
     */
    func makeHomeViewModel() -> HomeViewModel

    /**
     <# Property Summery Here#>
     */
    func makeHomeMoviesViewModel(for type: HomeMoviesViewModel.SectionType) -> HomeMoviesViewModel

    /**
     <# Property Summery Here#>
     */
    func makeHomeShowsViewModel(for type: HomeShowsViewModel.SectionType) -> HomeShowsViewModel

    /**
     <# Property Summery Here#>
     */
    func makeHomeMovieViewModel(with model: MovieSummery) -> HomeMovieViewModel

    /**
     <# Property Summery Here#>
     */
    func makeHomeShowViewModel(with model: TVSerialSummery) -> HomeShowViewModel
    
    /**
     <# Property Summery Here#>
     */
    func makeHomeTrendingsViewModel() -> HomeTrendingsViewModel

}

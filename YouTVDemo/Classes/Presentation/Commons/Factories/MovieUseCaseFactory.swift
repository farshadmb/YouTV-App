//
//  MovieUseCaseFactory.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/11/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

protocol MovieUseCaseFactory {

    func makePopularMovieUseCase() -> PopularMoviesUseCases

    func makeTopRatedMovieUseCase() -> TopRatedMoviesUseCases

    func makeNowPlayingUseCase() -> NowPlayingMoviesUseCases
    
}

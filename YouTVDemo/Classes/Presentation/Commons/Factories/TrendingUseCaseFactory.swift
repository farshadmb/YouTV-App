//
//  TrendingUseCaseFactory.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/17/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

protocol TrendingUseCaseFactory {
    
    func makeTVTrendingUseCase() -> TVTrendingUseCase

    func makeMovieTrendingUseCase() -> MovieTrendingUseCase
     
}

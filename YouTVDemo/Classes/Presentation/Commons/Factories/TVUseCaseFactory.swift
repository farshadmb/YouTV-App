//
//  TVUseCaseFactory.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/11/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

protocol TVUseCaseFactory {

    func makePopularShowUseCase() -> PopularTVUseCases

    func makeTopRatedShowUseCase() -> TopRatedTVUseCases

    func makeOnTheAirUseCase() -> OnAirTVUseCases

}

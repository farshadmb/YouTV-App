//
//  TrendingUseCase.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/17/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

protocol TrendingUseCase {
    
    typealias DataType = Any
    
    /**
     Summery
     */
    func fetchTrendings() -> Single<[DataType]>
    
}

protocol TVTrendingUseCase {
    
    typealias DataType = TVSerialSummery
    
    /**
     Summery
     */
    func fetchTVTrendings() -> Single<[DataType]>
    
}

protocol MovieTrendingUseCase {
    
    typealias DataType = MovieSummery
    
    /**
     Summery
     */
    func fetchMoviesTrendings() -> Single<[DataType]>
}

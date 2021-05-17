//
//  TrendingRepository.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/17/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import Combine

/**
 <# Property Summery Here#>
 */
protocol TrendingRepository: class {
    
    /**
     - Parameters:
       - forId: <#forId description#>
       - page: <#page description#>
       - withLanguage: <#withLanguage description#>
     - Returns:
     */
    func fetchTredingsContent(at page: Int, withLanguage: String) -> Observable<Pagination<String>>

    /**
     <# Property Summery Here#>
     - Parameters:
       - page: <#page description#>
       - withLanguage: <#withLanguage description#>
     - Returns:
     */
    func fetchTVTrendings(at page: Int, withLanguage: String) -> Observable<Pagination<TVSerialSummery>>

    /**
     <# Property Summery Here#>
     - Parameters:
       - page: <#page description#>
       - withLanguage: <#withLanguage description#>
     - Returns:
     */
    func fetchMovieTrendings(at page: Int, withLanguage: String) -> Observable<Pagination<MovieSummery>>

}

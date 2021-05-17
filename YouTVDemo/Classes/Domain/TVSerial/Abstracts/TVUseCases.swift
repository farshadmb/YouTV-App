//
//  TVUseCases.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/5/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import Combine

/**
 <# Property Summery Here#>
 */
protocol TVUseCases: class {

    /**
     <# Property Summery Here#>
     - Parameter id: <#id description#>
     - Returns:
     */
    func fetchRecommandation(forId id: Int) -> Single<[TVSerialSummery]>

    /**
     <# Property Summery Here#>
     - Parameter serial: <#movie description#>
     - Returns:
     */
    func getDetail(forSerial serial: TVSerialSummery) -> Single<TVSerialDetail>

    /**
     <# Property Summery Here#>
     - Parameter serial: <#movie description#>
     - Returns:
     */
    func getDetail(forSerial serial: TVSerialSummery) -> Future<TVSerialDetail, Error>
}

protocol PopularTVUseCases: TVUseCases {

    /**
     <# Property Summery Here#>
     - Returns:
     */
    func fetchPopularTVSerials() -> Single<[TVSerialSummery]>

    /**
     <# Property Summery Here#>
     - Returns:
     */
    func fetchMorePopularTVSerials() -> Observable<[TVSerialSummery]>
}

protocol TopRatedTVUseCases: TVUseCases {

    /**
     <# Property Summery Here#>
     - Returns:
     */
    func fetchTopRatedTVSerials() -> Single<[TVSerialSummery]>

    /**
     <# Property Summery Here#>
     - Returns:
     */
    func fetchMoreTopRatedTVSerials() -> Observable<[TVSerialSummery]>
}

protocol OnAirTVUseCases: TVUseCases {

    /**
     <# Property Summery Here#>
     - Returns:
     */
    func fetchOnAirTVSerials() -> Single<[TVSerialSummery]>

    /**
     <# Property Summery Here#>
     - Returns:
     */
    func fetchMoreOnAirTVSerials() -> Observable<[TVSerialSummery]>
}

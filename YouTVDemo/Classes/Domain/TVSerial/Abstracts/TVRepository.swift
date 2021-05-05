//
//  TVRepository.swift
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
protocol TVRepository: class {

    /// `TVSerial` typealiase represent the `TVSerialDetail`
    typealias TVSerial = TVSerialSummery

    /// `Detail` typealiase represent the `TVSerialDetail`
    typealias Detail = TVSerialDetail

    /**

     - Parameters:
       - forId: <#forId description#>
       - page: <#page description#>
       - withLanguage: <#withLanguage description#>
     - Returns:
     */
    func fetchRecommandationTVSerial(forId: Int, at page: Int, withLanguage: String) -> Observable<Pagination<TVSerial>>

    /**
     <# Property Summery Here#>
     - Parameters:
       - page: <#page description#>
       - withLanguage: <#withLanguage description#>
     - Returns:
     */
    func fetchOnAirTVSerials(at page: Int, withLanguage: String) -> Observable<Pagination<TVSerial>>

    /**
     <# Property Summery Here#>
     - Parameters:
       - page: <#page description#>
       - withLanguage: <#withLanguage description#>
     - Returns:
     */
    func fetchTopRatedTVSerials(at page: Int, withLanguage: String) -> Observable<Pagination<TVSerial>>

    /**
     <# Property Summery Here#>
     - Parameters:
       - page: <#page description#>
       - withLanguage: <#withLanguage description#>
     - Returns:
     */
    func fetchPopularTVSerials(at page: Int, withLanguage: String) -> Observable<Pagination<TVSerial>>

    /**
     <# Property Summery Here#>
     - Parameters:
       - serial: <#movie description#>
       - withLanguage: <#withLanguage description#>
     - Returns:
     */
    func fetchTVSerialDetail(forSerial serial: TVSerial, withLanguage: String) -> Single<Detail>

    /**
     <# Property Summery Here#>
     - Parameters:
       - forId: <#forId description#>
       - withLanguage: <#withLanguage description#>
     - Returns:
     */
    func fetchTVSerialDetail(forId: Int, withLanguage: String) -> Single<Detail>
}

extension TVRepository {

    /**
     <# Property Summery Here#>
     - Parameters:
       - id: <#id description#>
       - lang: <#lang description#>
     - Returns: <#description#>
     */
    func fetchSerialDetail(forId id: Int, withLanguage lang: String) -> AnyPublisher<Detail, Error> {
        return AnyPublisher.create {[weak base = self] (observer) in

            guard let base = base else {
                observer.onCompleted()
                return CombineDisposable {

                }
            }

            let dispose = base.fetchTVSerialDetail(forId: id, withLanguage: lang)
                .asObservable()
                .subscribe { (event) in
                    switch event {
                    case .completed:
                        observer.onCompleted()
                    case .error(let error):
                        observer.onError(error)
                    case .next(let value):
                        observer.onNext(value)
                    }
                }

            return CombineDisposable {
                dispose.dispose()
            }
        }
    }

    /**
     <# Property Summery Here#>
     - Parameters:
       - serial: <#movie description#>
       - lang: <#lang description#>
     - Returns: <#description#>
     */
    func fetchSerialDetail(for serial: TVSerial, withLanguage lang: String) -> AnyPublisher<Detail, Error> {
       return AnyPublisher.create {[weak base = self] (observer) in

            guard let base = base else {
                observer.onCompleted()
                return CombineDisposable {

                }
            }

            let dispose = base.fetchTVSerialDetail(forSerial: serial, withLanguage: lang)
                .asObservable()
                .subscribe { (event) in
                    switch event {
                    case .completed:
                        observer.onCompleted()
                    case .error(let error):
                        observer.onError(error)
                    case .next(let value):
                        observer.onNext(value)
                    }
                }

            return CombineDisposable {
                dispose.dispose()
            }
       }
    }
}

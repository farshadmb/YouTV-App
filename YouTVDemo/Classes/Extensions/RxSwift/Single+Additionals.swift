//
//  Single+Additionals.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/8/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
#if canImport(RxSwift)
import RxSwift
#endif

extension ObservableType {

    public func flatMapSingle<Result>(_ selector: @escaping (Element) throws -> Single<Result>) -> Single<Result> {
        let single = Single.from(observable: self)
        return single.flatMap(selector)
    }

    public func compactFirst() -> Single<Element> {
        return first().asObservable().unwrap().asSingle()
    }

}

extension PrimitiveSequenceType where Trait == SingleTrait {

    public static func from<T: ObservableType>(observable: T) -> Single<T.Element> where Element == T.Element {
        return .create { single in
            
            var hasElement = false
            let observer = observable.subscribe { event in
                switch event {
                case .next(let element):
                    if hasElement {
                        single(.failure(RxError.moreThanOneElement))
                        return
                    }
                    hasElement = true
                    single(.success(element))
                case .error(let error):
                    single(.failure(error))
                case .completed:
                    if !hasElement {
                        single(.failure(RxError.noElements))
                    }
                }
            }
            
            return Disposables.create {
                observer.dispose()
            }
        }
    }

}

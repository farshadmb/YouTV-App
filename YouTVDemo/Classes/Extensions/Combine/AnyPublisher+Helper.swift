//
//  AnyPublisher+Helper.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/2/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import Combine

struct AnyCombineObserver<Output, Failure: Error> {
    
    let onNext: ((Output) -> Void)
    let onError: ((Failure) -> Void)
    let onCompleted: (() -> Void)
}

struct CombineDisposable {
    
    let dispose: () -> Void
}

extension AnyPublisher {

    /// Create `AnyPublisher` instance
    /// - seealso: `RxSwift.Observable.create(:)`
    /// - Parameter subscribe: the AnyObserver
    /// - Returns: return `AnyPublisher` instance
    static func create(subscribe: @escaping (AnyCombineObserver<Output, Failure>) -> CombineDisposable) -> Self {
        let subject = PassthroughSubject<Output, Failure>()
        var disposable: CombineDisposable?
        return subject
            .handleEvents(receiveSubscription: { _ in
                disposable = subscribe(AnyCombineObserver(
                    onNext: { output in subject.send(output) },
                    onError: { failure in subject.send(completion: .failure(failure)) },
                    onCompleted: { subject.send(completion: .finished) }
                ))
            }, receiveCancel: { disposable?.dispose() })
            .eraseToAnyPublisher()
    }
}

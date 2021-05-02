//
//  NetworkService.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import Combine

/**
  `NetworkService` Abstract to reduce coupling in project. The abstract help to use this as DI.

   Any type which handle the network request performing and serailize the response.

  - SeeAlso:
    `NetworkService` design in Facade and Command design Pattern.
 */
protocol NetworkService: class {

    /**
     The `CompletionCallback<T>` typealiase to be used in execution since the `NetworkRequest` has been finished.
     */
    typealias CompletionCallback<T> = (_ result: Result<T,Error>) -> Void
    
    typealias DataDecoder = Alamofire.DataDecoder

    /**
     Starts performing the provided `Request`. `completion` to be called since the `Request` has finished.

     - Parameters:
       - request: The `NetworkRequest` to perform.
       - completion: A closure to be called once the request has finished.
     - Returns: `Alamofire.DataRequest` instance
     */
    @discardableResult
    func execute(request: NetworkRequest, completion: @escaping CompletionCallback<Data>) -> DataRequest

    /**
     Starts performing the provided `Request`. `completion` to be called since the `Request` has finished.

     - Parameters:
       - request: The `NetworkRequest` to perform.
       - decoder: `DataDecoder` to use to decode the response.
       - completion: A closure to be called once the request has finished.
     - Returns: `Alamofire.DataRequest` instance
     */
    @discardableResult
    func execute<T: Decodable>(request: NetworkRequest, decoder: DataDecoder?, completion: @escaping CompletionCallback<T>) -> DataRequest

}

/**

 */
typealias NetworkRequestInterceptor = RequestInterceptor

/**

 */
protocol NetworkServiceInterceptable: NetworkService {

    /**
     Set and apply `NetworkRequestInterceptor` instance whether implementer need to work it or doesn't.

     - Parameter interceptor: the `NetworkRequestInterceptor` implementor.
     */
    func apply(interceptor: NetworkRequestInterceptor)
}

extension NetworkService {

    /// :nodoc:
    @discardableResult
    func execute<T: Decodable>(request: NetworkRequest,
                               decoder: DataDecoder? = JSONDecoder(),
                               completion: @escaping CompletionCallback<T>) -> DataRequest {
        return execute(request: request, decoder: decoder, completion: completion)
    }
}

/**
 Reactive extension for `NetworkService`. it can be used whenever the `RxSwift` is defined or used.
 */
extension NetworkService {

    /**
     Starts performing the provided `Request`. `Observable` emit result since the `Request` has finished.
     - Parameter request: The `NetworkRequest` to be perfromed.
     - Returns: The `Observable<T>` instance that emit element whether the result would be success or failed.
     */
    func execute(request: NetworkRequest) -> Observable<Data> {

        return Observable.create { [unowned base = self] observer in

            let dataRequest = base.execute(request: request) { (result) in
                switch result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }

    /**
     Starts performing the provided `Request`. `Observable<T>` emit result since the `Request` has finished.

     - Parameters:
      - request: The `NetworkRequest` to be executed.
      - decoder: `DataDecoder` to be used to decode the response.
     - Returns: The `Observable<T>` instance that emit element whether the result would be success or failed.
     */
    func execute<T: Decodable>(request: NetworkRequest, decoder: DataDecoder? = nil) -> Observable<T> {
        return Observable.create {[unowned base = self] observer in

            let dataRequest = base.execute(request: request, decoder: decoder) { (result: Result<T,Error>) in
                switch result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
}

/**
 Reactive extension for `NetworkService`. it can be used whenever the `Combine` is defined or used.
 */
extension NetworkService {

    /**
     Starts performing the provided `Request`. `AnyPublisher` emit result since the `Request` has finished.

     - Parameter request: The `NetworkRequest` to be performed.
     - Returns: The `AnyPublisher<Data,Error>`
     */
    func execute(request: NetworkRequest) -> AnyPublisher<Data, Error> {

        return .create { [unowned base = self] observer in

            let dataRequest = base.execute(request: request) { (result) in
                switch result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }

            return CombineDisposable {
                dataRequest.cancel()
            }
        }
    }

    /**
     Starts performing the provided `Request`. `AnyPublisher` emit result since the `Request` has finished.

     - Parameters:
       - request: The `NetworkRequest` to be executed.
       - decoder: `DataDecoder` to be used to decode the response.
     - Returns: The `AnyPublisher<T,Error>` where `T` is `Decodable`.
     */
    func execute<T: Decodable>(request: NetworkRequest, decoder: DataDecoder? = nil) -> AnyPublisher<T, Error> {
        return .create {[unowned base = self] observer in

            let dataRequest = base.execute(request: request, decoder: decoder) { (result: Result<T,Error>) in
                switch result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }

            return CombineDisposable {
                dataRequest.cancel()
            }
        }
    }

}

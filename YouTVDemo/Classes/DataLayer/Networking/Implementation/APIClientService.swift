//
//  APIClientService.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import Alamofire

/**
 The `APIClientSerivce` creates and manages Request types during their lifetimes.

 it also to be used to work with the underlying `Alamofire.Session`
 It also provides common functionality for all Requests, including queuing, interception, redirect handling, and response cache handling.

 - Note: The `APIClientService` is the default implementation of `NetworkServiceInterceptable`.
 */
final class APIClientService: NetworkServiceInterceptable {

    /**
     The `Alamofire.Session` session
     */
    let session: Session

    /**
     The  `DispatchQeueu` response serialization queue
     */
    let queue: DispatchQueue

    /**
     The `DataDecoder` value to be used to create `Decodable` response objects.
     */
    var decoder: DataDecoder

    /**
     The `NetworkRequestInterceptor ` to intercept requests
     */
    @Atomic
    private(set) var interceptor: NetworkRequestInterceptor?

    /**
     Default Constructor for `APIClientService` class

     - Parameters:
       - configuration: `URLSessionConfiguration` to be used to create the underlying `Alamofire.Session`.
                            Changes to this value after being passed to this initializer will have no effect.
       - operationQueue: `DispatchQueue` on which to perform all response serialization.
                            By default this queue will use the `networkResponseQueue` as its `target`.
       - decoder: `DataDecoder` to be used to create `Decodable` response objects. By default is `JSONDecoder`.
       - interceptor: `NetworkRequestInterceptor` to be used for all `Request`s created by this instance.
                        `nil` by default.
     - Returns: The created `APIClientService` class.
     */
    init(configuration: URLSessionConfiguration,
         operationQueue: DispatchQueue = .networkResponseQueue,
         decoder: DataDecoder = JSONDecoder(),
         interceptor: NetworkRequestInterceptor? = nil) {
        self.session = Session(configuration: configuration)
        self.queue = operationQueue
        DispatchQueue.registerDetection(of: operationQueue)
        self.interceptor = interceptor
        self.decoder = decoder
    }

    // MARK: - NetworkServiceInterceptable

    func apply(interceptor: NetworkRequestInterceptor) {
        self.interceptor = interceptor
    }

    // MARK: - NetworkService

    func execute(request: NetworkRequest, completion: @escaping CompletionCallback<Data>) -> DataRequest {
        return session.request(request, interceptor: interceptor)
            .validate(statusCode: request.validResponse.statusCodes)
            .validate(contentType: request.validResponse.contentTypes)
            .responseString(completionHandler: { (response) in
                log.debug(response.debugDescription, tag: "\(Self.self)")
            })
            .responseData(queue: queue) { (response) in
                completion(Result { try response.result.get() })
            }
    }

    func execute<T>(request: NetworkRequest,
                    decoder: DataDecoder?,
                    completion: @escaping CompletionCallback<T>) -> DataRequest where T: Decodable {
        return session.request(request, interceptor: interceptor)
            .validate(statusCode: request.validResponse.statusCodes)
            .validate(contentType: request.validResponse.contentTypes)
            .responseString(completionHandler: { (response) in
                log.debug(response.debugDescription, tag: "\(Self.self)")
            })
            .responseDecodable(of: T.self, queue: queue, decoder: decoder ?? self.decoder) { (response) in
                completion(Result { try response.result.get() })
            }

    }

}

// swiftlint:disable:next force_unwrapping
private let queueName = Bundle.main.bundleIdentifier! + ".networking.response"

fileprivate extension DispatchQueue {

    /// Default queue for handling response
    static let networkResponseQueue = DispatchQueue(label: queueName,
                                                    qos: .background,
                                                    attributes: .concurrent,
                                                    autoreleaseFrequency: .workItem)
}

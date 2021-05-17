//
//  LaunchViewModel.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/17/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

struct LaunchViewModel {

    let isLoading = BehaviorRelay(value: false)
    let error = PublishRelay<String>()

    let disposeBag = DisposeBag()

    let service: NetworkService
    let successResponder: AnyObserver<Void>

    private let validResponse: NetworkResponseValidation

    init(service: NetworkService, successResponder: AnyObserver<Void>, validResponse: NetworkResponseValidation) {
        self.service = service
        self.successResponder = successResponder
        self.validResponse = validResponse
    }

    func loadConfiguration() -> Single<Bool> {
        guard !isLoading.value else {
            return .never()
        }

        isLoading.accept(true)

        let url = AppConfig.baseURL
            .appendingPathComponent("configuration").absoluteString
        let request = APIParametersRequest(url: url, validResponse: validResponse)
        let source = service.execute(request: request)
            .map { (response: APIServerResponse<APIConfigs>) in
                return response
            }
            .compactMap { (response: APIServerResponse<APIConfigs>) in
                return response.data?.images
            }
            .share(replay: 1, scope: .whileConnected)
            .debug()

        source.asDriver(onErrorDriveWith: .never())
            .asObservable()
            .map { _ in () }
            .bind(to: successResponder)
            .disposed(by: disposeBag)

        source
            .map { _ in "" }
            .asDriver(onErrorRecover: { (error) -> Driver<String> in
                return .just(error.localizedDescription)
            })
            .filter { !$0.isEmptyOrBlank }
            .asObservable()
            .bind(to: error)
            .disposed(by: disposeBag)

        return source.map { _ in true }
            .asSingle()
            .do {[weak isLoading] _ in
                isLoading?.accept(false)
            }  onError: {[weak isLoading] (_) in
                isLoading?.accept(false)
            }

    }

}

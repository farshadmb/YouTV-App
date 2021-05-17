//
//  LunchingDependencyContainer.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/17/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

final class LunchingDependencyContainer {

    let service: NetworkService
    private let validResponse: NetworkResponseValidation

    init(appDependencyContainer: AppDependencyContainer) {
        self.service = appDependencyContainer.networkService
        self.validResponse = appDependencyContainer.validation
    }

    func makeViewModel(responder: AnyObserver<Void>) -> LaunchViewModel {
        return LaunchViewModel(service: service, successResponder: responder, validResponse: validResponse)
    }

    func makeLaunchingViewController(withResponder responder: AnyObserver<Void>) -> LaunchingViewController {
        let viewController = LaunchingViewController()
        let viewModel = makeViewModel(responder: responder)
        viewController.bind(to: viewModel)

        return viewController
    }

}

extension LunchingDependencyContainer: LaunchViewModelFactory, LaunchingViewControllerFactory {}

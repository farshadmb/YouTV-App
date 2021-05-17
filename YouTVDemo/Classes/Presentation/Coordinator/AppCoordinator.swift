//
//  AppCoordinator.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/5/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import XCoordinator

enum AppRoot: Route {
    case loading
    case main
}

final class AppCoordinator: ViewCoordinator<AppRoot> {

    let factory: CoordinatorFactory & LaunchingViewControllerFactory

    @LateInit
    var window: UIWindow

    required init(factory: CoordinatorFactory & LaunchingViewControllerFactory) {
        self.factory = factory
        super.init(rootViewController: .init())
    }

    override func prepareTransition(for route: AppRoot) -> TransitionType {

        self.children.forEach {
            self.removeChild($0)
        }

        switch route {
        case .loading:
            let responder = PublishSubject<Void>()
            let loadingVC = factory.makeLaunchingViewController(withResponder: responder.asObserver())
            responder.asObservable().bind {[weak self] _ in
                self?.trigger(.main)
            }
            .disposed(by: loadingVC.disposeBag)

            loadingVC.setRoot(for: window)

            return .none()
        case .main:
            let mainCoordiantor = factory.makeMainCoordinator()
            addChild(mainCoordiantor)
            mainCoordiantor.setRoot(for: window)
            return .none()
        }

    }

}

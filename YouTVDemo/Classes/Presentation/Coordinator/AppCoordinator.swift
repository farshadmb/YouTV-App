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

    let coordinatorFactory: CoordinatorFactory

    @LateInit
    var window: UIWindow

    required init(factory: CoordinatorFactory) {
        self.coordinatorFactory = factory
        super.init(rootViewController: .init())
    }

    override func prepareTransition(for route: AppRoot) -> TransitionType {

        self.children.forEach {
            self.removeChild($0)
        }

        switch route {
        case .loading:
            setRoot(for: window)
            return .none()
        case .main:
            let mainCoordiantor = coordinatorFactory.makeMainCoordinator()
            addChild(mainCoordiantor)
            mainCoordiantor.setRoot(for: window)
            return .none()
        }

    }

}

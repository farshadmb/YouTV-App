//
//  MainCoordinator.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/5/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import XCoordinator

enum MainRoute: Route {
    case home
    case search
    case discover
}

final class MainCoordinator: TabBarCoordinator<MainRoute> {

    let factory: CoordinatorFactory
    let homeCoordiantor: HomeCoordinator

    required init(factory: CoordinatorFactory, initialRoute: RouteType) {
        self.factory = factory
        homeCoordiantor = factory.makeHomeCoordinator()
        super.init(tabs: [homeCoordiantor, UIViewController.init()])
    }

    override func prepareTransition(for route: RouteType) -> TransitionType {

        self.children.forEach {
            self.removeChild($0)
        }

        switch route {
        case .home:
            return .select(homeCoordiantor)
        case .discover:
            return .none()
        case .search:
            return .none()
        }
    }
}

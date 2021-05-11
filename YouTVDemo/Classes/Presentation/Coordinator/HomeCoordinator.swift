//
//  HomeCoordinator.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/5/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import XCoordinator

enum HomeRoute: Route {
    case initial
    case movieDetail
    case serialDetail
    case seeMovies
    case seeTVSerails
}

class HomeCoordinator: NavigationCoordinator<HomeRoute> {

    typealias FactoryType = HomeViewModelsFactory & HomeViewControllerFactory

    let factory: FactoryType

    required init(factory: FactoryType) {
        self.factory = factory
        super.init(rootViewController: .init(), initialRoute: .initial)
    }

    override func prepareTransition(for route: RouteType) -> TransitionType {

        switch route {
        case .initial:
            let viewController = factory.makeHomeViewController()
            return .set([viewController])
        case .movieDetail:
            return .none()
        case .serialDetail:
            return .none()
        case .seeMovies:
            return .none()
        case .seeTVSerails:
            return .none()

        }
        
        return .none()
    }

}

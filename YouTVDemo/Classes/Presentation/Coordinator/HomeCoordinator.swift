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

    override func prepareTransition(for route: RouteType) -> TransitionType {

        switch route {
        case .initial:
            return .none()
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

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

final class AppCoordinator: NavigationCoordinator<AppRoot> {

    override func prepareTransition(for route: AppRoot) -> TransitionType {

        self.children.forEach {
            self.removeChild($0)
        }

        switch route {
        case .loading:
            return .none()
        case .main:
            return .none()
        }

        return .none()
    }
}

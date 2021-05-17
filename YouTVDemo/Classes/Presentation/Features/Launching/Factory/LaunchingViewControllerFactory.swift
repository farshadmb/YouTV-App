//
//  LaunchingViewControllerFactory.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/17/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift

protocol LaunchingViewControllerFactory {

    func makeLaunchingViewController(withResponder responder: AnyObserver<Void>) -> LaunchingViewController
}

//
//  CoordinatorFactory.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/12/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

/**
 <# Property Summery Here#>
 */
protocol CoordinatorFactory: class {

    /**
     <# Property Summery Here#>
     */
    typealias CoordinatorType = Any

    /**
     <# Property Summery Here#>
     */
    func makeAppCoordinator() -> AppCoordinator

    /**
     <# Property Summery Here#>
     */
    func makeMainCoordinator() -> MainCoordinator

    /**

     */
    func makeHomeCoordinator() -> HomeCoordinator

}

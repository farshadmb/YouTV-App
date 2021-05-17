//
//  Bindable.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/6/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import UIKit

protocol BindableType: AnyObject {

    associatedtype ViewModelType

    var viewModel: ViewModelType? { get set }

    func bindViewModel()
}

extension BindableType where Self: UIViewController {

    func bind(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}

extension BindableType where Self: UIView {

    func bind(to model: Self.ViewModelType) {
        viewModel = model
        bindViewModel()
    }

}

extension BindableType where Self: UITableViewCell {

    func bind(to model: Self.ViewModelType) {
        viewModel = model
        bindViewModel()
    }
}

extension BindableType where Self: UICollectionViewCell {

    func bind(to model: Self.ViewModelType) {
        viewModel = model
        bindViewModel()
    }
}

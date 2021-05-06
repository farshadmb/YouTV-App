//
//  HomeShowsViewModel.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/6/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class HomeShowsViewModel: HomeSectionBaseViewModel {

    let type: SectionType

    override init(title: String, order: Int, items: [Item] = []) {
        self.type = .popular
        super.init(title: title, order: order, items: items)
    }

    required init(type: SectionType, order: Int) {
        self.type = type
        super.init(title: type.rawValue.localized, order: order)
    }

    override func fetchDataIfNeeded() -> Single<Bool> {
        return .just(false)
    }

}

extension HomeShowsViewModel {

    enum SectionType: String {
        case popular
        case onTheAir
        case topRated
    }

}

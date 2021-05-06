//
//  HomeSectionBaseViewModel.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/6/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class HomeSectionBaseViewModel {

    var title: String
    let order: Int

    typealias Item = HomeSectionItemViewModel

    let tapSeeMore: PublishRelay<Void>

    let items: BehaviorRelay<[Item]>
    let isLoading: BehaviorRelay<Bool>

    var didTapSeeMore: Driver<Void> {
        return tapSeeMore.asDriver(onErrorDriveWith: .never())
    }

    init(title: String, order: Int, items: [Item] = []) {
        self.title = title
        self.order = order
        self.items = .init(value: items)
        self.tapSeeMore = .init()
        self.isLoading = .init(value: false)
    }

    func fetchDataIfNeeded() -> Single<Bool> {
        fatalError("Override this method.")
    }

}

class HomeSectionItemViewModel {

    var title: String
    var rating: Float
    var image: URL?
    
    var type: ItemType {
        return .movie
    }

    init(title: String, rating: Float, image: URL? = nil) {
        self.title = title
        self.rating = rating
        self.image = image
    }

}

extension HomeSectionItemViewModel {

    enum ItemType {
        case movie
        case show
        case trending
    }
}

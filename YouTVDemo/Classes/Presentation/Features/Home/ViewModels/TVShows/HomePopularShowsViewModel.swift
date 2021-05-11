//
//  HomePopularShowsViewModel.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/11/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class HomePopularShowsViewModel: HomeShowsViewModel {

    @AtomicLateInit
    var useCase: PopularTVUseCases

    convenience init(order: Int, useCase: PopularTVUseCases) {
        self.init(type: .popular, order: order)
        self.useCase = useCase
    }

    override func sectionLayout() -> NSCollectionLayoutSection {

        let item = popularShowItem()
        let groupSize = self.groupSize(width: .fractionalWidth(1.0), height: .estimated(1.0))

        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let headerElement = self.headerElement()

        section.boundarySupplementaryItems = [headerElement]

        return section
    }

    override func fetchDataIfNeeded(isRefresh: Bool = false) -> Single<Bool> {

        guard isLoading.value == false else {
            return .never()
        }

        guard isRefresh == true || itemCount == 0 else {
            return .just(false)
        }

        isLoading.accept(true)
        let completion = {[weak isLoading] (_: Any?) -> Void in
            isLoading?.accept(false)
        }

        let source = useCase.fetchPopularTVSerials().asObservable().share()

        source.catch { (_) in
            .just([])
        }.map {
            return Array($0.compactMap { HomeShowViewModel(model: $0) }.prefix(5))
        }
        .bind(to: items)
        .disposed(by: disposeBag)

        return source.map { _ in true }.asSingle()
            .do(onSuccess: completion, onError: completion)

    }

}

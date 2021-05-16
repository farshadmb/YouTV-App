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

    @AtomicLateInit
    var factory: HomeViewModelsFactory

    convenience init(order: Int, useCase: PopularTVUseCases, factory: HomeViewModelsFactory) {
        self.init(type: .popular, order: order)
        self.title = "Popular TV Shows"
        self.useCase = useCase
        self.factory = factory
    }

    override func sectionLayout() -> NSCollectionLayoutSection {

        let item = popularShowItem()
        let groupSize = self.groupSize(width: .fractionalWidth(1.0), height: .estimated(1.0))

        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8.0
        section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)

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

        isLoading.accept(!isRefresh)
        let completion = {[weak isLoading] (_: Any?) -> Void in
            isLoading?.accept(false)
        }

        let source = useCase.fetchPopularTVSerials().asObservable().share()

        let prevItems = self.items.value
            .compactMap({ $0 as? HomeShowViewModel })
            .compactMap { $0.model }

        source.catchAndReturn(prevItems)
            .map {[unowned self] in
                let array = Array($0.compactMap { factory.makeHomeShowViewModel(with: $0) }.prefix(5))
                array.forEach {
                    $0.image = $0.remoteBuilder.set(size: .w780, forType: \.posterSizes)
                        .build(imageName: $0.model.posterPath ?? "")
                    $0.title = $0.title + " (\($0.firstAirDate ?? "-"))"
                }
                return array
            }
            .bind(to: items)
            .disposed(by: disposeBag)

        return source.map { _ in true }.asSingle()
            .do(onSuccess: completion, onError: completion)

    }

}

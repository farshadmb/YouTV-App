//
//  HomeOnTheAirShowsViewModel.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/11/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class HomeOnTheAirShowsViewModel: HomeShowsViewModel {

    @AtomicLateInit
    var useCase: OnAirTVUseCases

    @AtomicLateInit
    var factory: HomeViewModelsFactory

    convenience init(order: Int, useCase: OnAirTVUseCases, factory: HomeViewModelsFactory) {
        self.init(type: .onTheAir, order: order)
        self.useCase = useCase
        self.factory = factory
    }

    override func sectionLayout() -> NSCollectionLayoutSection {

        let item = self.showItem()

        let groupSize = self.groupSize()

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let headerElement = self.headerElement()

        section.boundarySupplementaryItems = [headerElement]
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

        return section
    }

    override func fetchDataIfNeeded(isRefresh: Bool = false) -> Single<Bool> {

        guard isLoading.value == false else {
            return .never()
        }

        guard isRefresh == true || itemCount == 0 else {
            return .just(true)
        }

        isLoading.accept(true)
        let completion = {[weak isLoading] (_: Any?) -> Void in
            isLoading?.accept(false)
        }

        let source = useCase.fetchOnAirTVSerials().asObservable().share()

        source.catch { (_) in
            .just([])
        }.map {[unowned self] in
            return $0.compactMap { factory.makeHomeShowViewModel(with: $0) }
        }
        .bind(to: items)
        .disposed(by: disposeBag)

        return source.map { _ in true }.asSingle()
            .do(onSuccess: completion, onError: completion)

    }

}

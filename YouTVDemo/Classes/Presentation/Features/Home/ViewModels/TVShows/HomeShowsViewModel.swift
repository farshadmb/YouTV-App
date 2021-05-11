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

class HomeShowsViewModel: HomeSectionBaseViewModel {

    let type: SectionType

    override init(title: String, order: Int, items: [Item] = []) {
        self.type = .popular
        super.init(title: title, order: order, items: items)
    }

    required init(type: SectionType, order: Int) {
        self.type = type
        super.init(title: type.rawValue.localized, order: order)
    }

    override func fetchDataIfNeeded(isRefresh: Bool = false) -> Single<Bool> {
        return .just(false)
    }

    open func sectionLayout() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                              heightDimension: .fractionalHeight(1.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .topLeading)
        headerElement.pinToVisibleBounds = true

        section.boundarySupplementaryItems = [headerElement]
        section.orthogonalScrollingBehavior = .groupPagingCentered

        return section
    }

}

extension HomeShowsViewModel {

    enum SectionType: String {
        case popular
        case onTheAir
        case topRated
    }

}

extension HomeShowsViewModel: HomeSectionLayout {}

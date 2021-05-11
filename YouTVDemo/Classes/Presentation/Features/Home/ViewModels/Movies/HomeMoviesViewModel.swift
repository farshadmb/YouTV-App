//
//  HomeMoviesViewModel.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/6/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class HomeMoviesViewModel: HomeSectionBaseViewModel {

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
        if isRefresh {
            items.accept([.init(title: "Movie Title", rating: 0.5)])
        }
        return .just(false)
    }
    
    func sectionLayout() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(1.77))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(150),
                                               heightDimension: .estimated(266.666_666_666_7))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(44))

        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .topLeading)
        headerElement.extendsBoundary = true

        headerElement.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [headerElement]
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
}

extension HomeMoviesViewModel {

    enum SectionType: String {
        case popular
        case nowPlaying
        case topRated
    }

}

extension HomeMoviesViewModel: HomeSectionLayout {}

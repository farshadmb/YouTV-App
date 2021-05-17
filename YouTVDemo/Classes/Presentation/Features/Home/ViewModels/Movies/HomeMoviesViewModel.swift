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
        
        let item = movieItem()
        let groupSize = self.groupSize(width: .absolute(movieWidthSize),
                                       height: .estimated(movieWidthSize * defaultAspectRatio))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .some(.fixed(8.0))

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8.0
        section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)

        let headerElement = self.headerElement()

        section.boundarySupplementaryItems = [headerElement]
        section.orthogonalScrollingBehavior = .continuous
        
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

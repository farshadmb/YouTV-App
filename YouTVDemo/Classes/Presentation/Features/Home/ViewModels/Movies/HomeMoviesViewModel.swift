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
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(movieWidthSize),
                                               heightDimension: .estimated(movieWidthSize * 1.7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)

        let headerElement = self.headerElement()

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

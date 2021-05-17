//
//  HomePopularMoviesViewModel.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/8/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class HomePopularMoviesViewModel: HomeMoviesViewModel {
    
    @AtomicLateInit
    var useCase: PopularMoviesUseCases

    @AtomicLateInit
    var factory: HomeViewModelsFactory

    convenience init(order: Int, useCase: PopularMoviesUseCases, factory: HomeViewModelsFactory) {
        self.init(type: .nowPlaying, order: order)
        self.title = Strings.Home.Section.movieTitle(Strings.Global.popular)
        self.useCase = useCase
        self.factory = factory
    }

    override func sectionLayout() -> NSCollectionLayoutSection {
        
        let item = movieItem()
        let groupSize = self.groupSize(width: .absolute(movieWidthSize),
                                       height: .estimated(movieWidthSize * defaultAspectRatio))

        let subGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        subGroup.interItemSpacing = .some(.fixed(8.0))

        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [subGroup, subGroup])
        group.interItemSpacing = .some(.fixed(8.0))

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8.0
        section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let headerElement = self.headerElement()
        
        section.boundarySupplementaryItems = [headerElement]
        section.orthogonalScrollingBehavior = .continuous

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
        
        let source = useCase.fetchPopularMovies().asObservable().share()
        let prevItems = self.items.value
            .compactMap({ $0 as? HomeMovieViewModel })
            .compactMap { $0.model }

        source.catchAndReturn(prevItems)
            .map {[unowned self] in
                return $0.compactMap { factory.makeHomeMovieViewModel(with: $0) }
            }
            .bind(to: items)
            .disposed(by: disposeBag)
        
        return source.map { _ in true }.asSingle()
            .do(onSuccess: completion, onError: completion)
            
    }
    
}

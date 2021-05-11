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
    
    convenience init(order: Int, useCase: PopularMoviesUseCases) {
        self.init(type: .popular, order: order)
        self.useCase = useCase
    }

    override func sectionLayout() -> NSCollectionLayoutSection {
        
        let item = movieItem()
        let groupSize = self.groupSize(width: .absolute(movieWidthSize),
                                       height: .estimated(movieWidthSize * 1.77))

        let subGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [subGroup, subGroup])

        let section = NSCollectionLayoutSection(group: group)

        let headerElement = self.headerElement()
        
        section.boundarySupplementaryItems = [headerElement]
        section.orthogonalScrollingBehavior = .groupPaging

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
        
        source.catch { (_) -> Observable<[MovieSummery]> in
            .just([])
        }.map {
            return $0.compactMap { HomeMovieViewModel(model: $0) }
        }
        .bind(to: items)
        .disposed(by: disposeBag)
        
        return source.map { _ in true }.asSingle()
            .do(onSuccess: completion, onError: completion)
            
    }
    
}

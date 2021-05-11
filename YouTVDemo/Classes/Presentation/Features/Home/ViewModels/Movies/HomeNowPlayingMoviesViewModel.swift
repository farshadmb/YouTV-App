//
//  HomeNowPlayingMoviesViewModel.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/8/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class HomeNowPlayingMoviesViewModel: HomeMoviesViewModel {
    
    @AtomicLateInit
    var useCase: NowPlayingMoviesUseCases
    
    convenience init(order: Int, useCase: NowPlayingMoviesUseCases) {
        self.init(type: .nowPlaying, order: order)
        self.useCase = useCase
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
        
        let source = useCase.fetchNowPlayingMovies()
            .asObservable().share(replay: 1, scope: .whileConnected)
        
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

 func generateFeaturedAlbumsLayout(isWide: Bool) -> NSCollectionLayoutSection {
   let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                         heightDimension: .fractionalWidth(2 / 3))
   let item = NSCollectionLayoutItem(layoutSize: itemSize)

   // Show one item plus peek on narrow screens, two items plus peek on wider screens
   let groupFractionalWidth = isWide ? 0.475 : 0.95
   let groupFractionalHeight: Float = isWide ? 1 / 3 : 2 / 3
   let groupSize = NSCollectionLayoutSize(
     widthDimension: .fractionalWidth(CGFloat(groupFractionalWidth)),
     heightDimension: .fractionalWidth(CGFloat(groupFractionalHeight)))
   let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
   group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

   let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .estimated(44))
//   let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//     layoutSize: headerSize,
//     elementKind: AlbumsViewController.sectionHeaderElementKind, alignment: .top)

   let section = NSCollectionLayoutSection(group: group)
//   section.boundarySupplementaryItems = [sectionHeader]
   section.orthogonalScrollingBehavior = .groupPaging

   return section
 }

 func generateSharedlbumsLayout() -> NSCollectionLayoutSection {
   let itemSize = NSCollectionLayoutSize(
     widthDimension: .fractionalWidth(1.0),
     heightDimension: .fractionalWidth(1.0))
   let item = NSCollectionLayoutItem(layoutSize: itemSize)

   let groupSize = NSCollectionLayoutSize(
     widthDimension: .absolute(140),
     heightDimension: .absolute(186))
   let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
   group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

   let headerSize = NSCollectionLayoutSize(
     widthDimension: .fractionalWidth(1.0),
     heightDimension: .estimated(44))
//   let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//     layoutSize: headerSize,
//     elementKind: AlbumsViewController.sectionHeaderElementKind,
//     alignment: .top)

   let section = NSCollectionLayoutSection(group: group)
//   section.boundarySupplementaryItems = [sectionHeader]
   section.orthogonalScrollingBehavior = .groupPaging

   return section
 }

 func generateMyAlbumsLayout(isWide: Bool) -> NSCollectionLayoutSection {
   let itemSize = NSCollectionLayoutSize(
     widthDimension: .fractionalWidth(1.0),
     heightDimension: .fractionalHeight(1.0))
   let item = NSCollectionLayoutItem(layoutSize: itemSize)
   item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

   let groupHeight = NSCollectionLayoutDimension.fractionalWidth(isWide ? 0.25 : 0.5)
   let groupSize = NSCollectionLayoutSize(
     widthDimension: .fractionalWidth(1.0),
     heightDimension: groupHeight)
   let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: isWide ? 4 : 2)

   let headerSize = NSCollectionLayoutSize(
     widthDimension: .fractionalWidth(1.0),
     heightDimension: .estimated(44))
//   let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//     layoutSize: headerSize,
//     elementKind: AlbumsViewController.sectionHeaderElementKind,
//     alignment: .top)

   let section = NSCollectionLayoutSection(group: group)
//   section.boundarySupplementaryItems = [sectionHeader]

   return section
 }

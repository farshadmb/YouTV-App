//
//  HomeTrendingsViewModel.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/17/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class HomeTrendingsViewModel: HomeSectionBaseViewModel {

    @AtomicLateInit
    var tvTrendingUseCase: TVTrendingUseCase
    
    @AtomicLateInit
    var movieTrendingUseCase: MovieTrendingUseCase

    @AtomicLateInit
    var factory: HomeViewModelsFactory & TrendingUseCaseFactory

    required init(order: Int,
                  factory: HomeViewModelsFactory & TrendingUseCaseFactory) {
        self.factory = factory
        self.tvTrendingUseCase = factory.makeTVTrendingUseCase()
        self.movieTrendingUseCase = factory.makeMovieTrendingUseCase()
        super.init(title: "", order: order)
    }
    
    override func fetchDataIfNeeded(isRefresh: Bool = false) -> Single<Bool> {
        
        guard isRefresh == true || itemCount == 0 else {
            return .just(true)
        }
        
        guard isLoading.value == false else {
            return .never()
        }
        
        isLoading.accept(true)
        let completion = {[weak isLoading] (_: Any?) -> Void in
            isLoading?.accept(false)
        }
        
        let movies = fetchMovieTrendings().asObservable()
        let tvShows = fetchTVTrendings().asObservable()
        
        let viewModelsObs = Observable.zip(movies, tvShows) {
            return $0 + $1
        }
        .map {
            $0.shuffled()
        }
        .share(replay: 1, scope: .whileConnected)
        
        viewModelsObs.asDriver(onErrorJustReturn: .init())
            .asObservable()
            .bind(to: items)
            .disposed(by: disposeBag)
        
        return viewModelsObs
            .map { _ in true }
            .asSingle()
            .do(onSuccess: completion, onError: completion)
    }

    func sectionLayout() -> NSCollectionLayoutSection {

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

        section.boundarySupplementaryItems = [headerElement]
        section.orthogonalScrollingBehavior = .groupPagingCentered

        return section
    }
    
    private func fetchMovieTrendings() -> Single<[HomeMovieViewModel]> {
        movieTrendingUseCase.fetchMoviesTrendings()
            .map {[unowned self] in
                return $0.compactMap { factory.makeHomeMovieViewModel(with: $0) }
            }
    }
    
    private func fetchTVTrendings() -> Single<[HomeShowViewModel]> {
        tvTrendingUseCase.fetchTVTrendings()
            .map {[unowned self] in
                return $0.compactMap { factory.makeHomeShowViewModel(with: $0) }
            }
    }

}

extension HomeTrendingsViewModel: HomeSectionLayout {}

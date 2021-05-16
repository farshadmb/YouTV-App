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

    @AtomicLateInit
    var factory: HomeViewModelsFactory

    convenience init(order: Int, useCase: NowPlayingMoviesUseCases, factory: HomeViewModelsFactory) {
        self.init(type: .nowPlaying, order: order)
        self.title = "Playing Now Movies"
        self.useCase = useCase
        self.factory = factory
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

        let prevItems = self.items.value
            .compactMap({ $0 as? HomeMovieViewModel })
            .compactMap { $0.model }

        source.catchAndReturn(prevItems)
            .map {[unowned self] in
            $0.compactMap { factory.makeHomeMovieViewModel(with: $0) }
            }
        .bind(to: items)
        .disposed(by: disposeBag)
        
        return source.map { _ in true }.asSingle()
            .do(onSuccess: completion, onError: completion)
            
    }
}

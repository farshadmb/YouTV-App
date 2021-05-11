//
//  HomeTopRatedMoviesViewModel.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/8/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class HomeTopRatedMoviesViewModel: HomeMoviesViewModel {
    
    @AtomicLateInit
    var useCase: TopRatedMoviesUseCases
    
    convenience init(order: Int, useCase: TopRatedMoviesUseCases) {
        self.init(type: .topRated, order: order)
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
        
        let source = useCase.fetchTopRatedMovies().asObservable().share()
        
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

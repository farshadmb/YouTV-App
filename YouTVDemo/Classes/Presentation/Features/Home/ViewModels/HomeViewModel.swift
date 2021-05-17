//
//  HomeViewModel.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/6/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class HomeViewModel {

    let disposeBag = DisposeBag()

    // inputs
    let didAppear = PublishRelay<Void>()
    let refreshTriggle = PublishRelay<Void>()

    var count: Int {
        return items.value.count
    }
    
    // output
    let items = BehaviorRelay<[HomeSectionBaseViewModel]>(value: [])

    let isRefreshing = BehaviorRelay<Bool>(value: false)

    let error = PublishRelay<Error>()

    let factory: HomeViewModelsFactory

    init(factory: HomeViewModelsFactory) {

        self.factory = factory

        didAppear
            .asObservable()
            .compactFirst()
            .asObservable()
            .debug()
            .bind {[unowned self] _ in
                buildSections()
            }
            .disposed(by: disposeBag)

        refreshTriggle.asObservable()
            .bind {[unowned self] _ in
                refreshContents()
            }
            .disposed(by: disposeBag)

    }

    func buildSections() {

        var sections = [HomeSectionBaseViewModel]()

        sections.append(factory.makeHomeMoviesViewModel(for: .nowPlaying))
        sections.append(factory.makeHomeMoviesViewModel(for: .popular))

        sections.append(factory.makeHomeShowsViewModel(for: .onTheAir))
        sections.append(factory.makeHomeShowsViewModel(for: .popular))
        
        items.accept(sections)
    }

    func refreshContents() {
        fetchContents(shouldRefresh: true)
    }

    func fetchContents(shouldRefresh flag: Bool = false) {
        isRefreshing.accept(flag)

        let fetchObserver = Observable<Result<Bool,Error>>.merge(items.value.compactMap {
            $0.fetchDataIfNeeded(isRefresh: flag)
                .map {
                    return Result(value: $0, error: nil)
                }
                .catch { (error) in
                    return .just(Result(catching: { throw error }))
                }
                .asObservable()
        }).share(replay: 1, scope: .whileConnected)

        fetchObserver.asDriver(onErrorDriveWith: .never())
            .asObservable()
            .subscribe {[unowned self] _ in
                isRefreshing.accept(false)
            }.disposed(by: disposeBag)

        fetchObserver
            .compactMap({ $0.failure })
            .takeLast(1)
            .bind(to: error).disposed(by: disposeBag)
    }
    
    subscript(section: Int) -> HomeSectionBaseViewModel? {
        return items.value[safe:section]
    }
    
}

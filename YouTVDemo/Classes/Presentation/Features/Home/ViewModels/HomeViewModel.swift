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

    // output
    let items = BehaviorRelay<[HomeSectionBaseViewModel]>(value: [])

    init() {

        didAppear.asObservable()
            .asSingle()
            .asObservable()
            .bind {[unowned self] _ in
                buildSections()
                fetchContents()
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

        sections.append(HomeMoviesViewModel(type: .nowPlaying, order: 0))
        sections.append(HomeMoviesViewModel(type: .popular, order: 1))
        sections.append(HomeMoviesViewModel(type: .topRated, order: 2))

        sections.append(HomeShowsViewModel(type: .onTheAir, order: 3))
        sections.append(HomeShowsViewModel(type: .popular, order: 4))
        sections.append(HomeShowsViewModel(type: .topRated, order: 5))

        items.accept(sections)
    }

    func refreshContents() {
        fetchContents(shouldRefresh: true)
    }

    func fetchContents(shouldRefresh flag: Bool = false) {
        for section in items.value {
            section.fetchDataIfNeeded(isRefresh: false)
                .subscribe().disposed(by: disposeBag)
        }
    }

}

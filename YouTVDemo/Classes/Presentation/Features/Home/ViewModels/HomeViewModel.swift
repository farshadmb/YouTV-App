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

    init() {

        didAppear
            .asObservable()
            .compactFirst()
            .asObservable()
            .debug()
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
        
        let dataDecoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dataDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        dataDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let acceptableStatusForError = [400, 401, 403, 404,
                                        405, 406, 422, 429,
                                        500, 501, 502, 503,
                                        504]
        
        let validation = HTTPResponseValidation(statusCodes: Set((200..<300).map { $0 } + acceptableStatusForError),
                                                contentTypes: ["application/json"])
        let service = APIClientService(configuration: .default, decoder: dataDecoder)
        let auth = APIAuthenticator(token: AppConfig.APIKey)
        service.apply(interceptor: auth)
        let repository = MoviesRemoteRepository(service: service,
                                                baseURL: AppConfig.baseURL.absoluteString,
                                                validResponse: validation)
        
        let useCase = MoviesUseCasesImp(repository: repository ,
                                         language: "en")

        let tvRepository = TVRemoteRepository(service: service, baseURL: AppConfig.baseURL.absoluteString, validResponse: validation)
        let tvUseCases = TVUseCasesImp(repository: tvRepository, language: "en")
        
        sections.append(HomePopularMoviesViewModel(order: 1, useCase: useCase))
        sections.append(HomeNowPlayingMoviesViewModel(order: 0, useCase: useCase))
        sections.append(HomeTopRatedMoviesViewModel(order: 2, useCase: useCase))

        sections.append(HomeOnTheAirShowsViewModel(order: 3, useCase: tvUseCases))
        sections.append(HomePopularShowsViewModel(order: 4, useCase: tvUseCases))
        
        items.accept(sections.sorted(by: { $0.order < $1.order }))
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
    
    subscript(section: Int) -> HomeSectionBaseViewModel? {
        return items.value[safe:section]
    }
    
}

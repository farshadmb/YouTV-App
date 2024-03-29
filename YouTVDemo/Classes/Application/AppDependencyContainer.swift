//
//  AppDependencyContainer.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/11/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

final class AppDependencyContainer {

    typealias DataDecoder = Alamofire.DataDecoder

    lazy var networkService: NetworkService = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        configuration.timeoutIntervalForRequest = 30.0

        let APIClient = APIClientService(configuration: configuration,
                                         decoder: dataDecoder,
                                         interceptor: authenticator)
        return APIClient
    }()

    lazy var dataDecoder: DataDecoder = {
        let dataDecoder = JSONDecoder()
        let dateFormatter = DateFormatter()

        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dataDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        dataDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return dataDecoder
    }()

    lazy var authenticator: NetworkRequestInterceptor = {
        return APIAuthenticator(token: AppConfig.APIKey)
    }()

    lazy var validation: NetworkResponseValidation = {
        let acceptableStatusForError = [400, 401, 403, 404,
                                        405, 406, 422, 429,
                                        500, 501, 502, 503,
                                        504]

        let validation = HTTPResponseValidation(statusCodes: Set((200..<300).map { $0 } + acceptableStatusForError),
                                                contentTypes: ["application/json"])
        return validation
    }()

    // MARK: - Repository

    lazy var sharedMovieRepository: MoviesRepository = {
        return MoviesRemoteRepository(service: networkService, baseURL: AppConfig.baseURL.absoluteString,
                                      validResponse: validation)
    }()

    lazy var sharedShowRepository: TVRepository = {
        return TVRemoteRepository(service: networkService, baseURL: AppConfig.baseURL.absoluteString, validResponse: validation)
    }()
    
    lazy var sharedTrendingRepository: TrendingRepository = {
        return TrendingRemoteRepository(service: networkService,
                                        baseURL: AppConfig.baseURL.absoluteString,
                                        validResponse: validation)
    }()

    // MARK: - Misc
    var language: String {

        guard let value = Bundle.main.preferredLocalizations.first else {
            return "en-US"
        }

        return value
    }

    lazy var remoteImageBuilder: RemoteImageAssetBuilder = {
        return DefaultImageAssetBuilder(imageConfig: AppConfig.defaultImageConfig)
    }()

    init() {
        
    }

}

extension AppDependencyContainer: TVUseCaseFactory {

    func makePopularShowUseCase() -> PopularTVUseCases {
        return TVUseCasesImp(repository: sharedShowRepository, language: language)
    }

    func makeTopRatedShowUseCase() -> TopRatedTVUseCases {
        return TVUseCasesImp(repository: sharedShowRepository, language: language)
    }

    func makeOnTheAirUseCase() -> OnAirTVUseCases {
        return TVUseCasesImp(repository: sharedShowRepository, language: language)
    }

}

extension AppDependencyContainer: MovieUseCaseFactory {

    func makePopularMovieUseCase() -> PopularMoviesUseCases {
        return MoviesUseCasesImp(repository: sharedMovieRepository, language: language)
    }

    func makeTopRatedMovieUseCase() -> TopRatedMoviesUseCases {
        return MoviesUseCasesImp(repository: sharedMovieRepository, language: language)
    }

    func makeNowPlayingUseCase() -> NowPlayingMoviesUseCases {
        return MoviesUseCasesImp(repository: sharedMovieRepository, language: language)
    }

}

extension AppDependencyContainer: CoordinatorFactory {

    func makeAppCoordinator() -> AppCoordinator {
        let coordinator = AppCoordinator(factory: self)
        return coordinator
    }

    func makeMainCoordinator() -> MainCoordinator {
        return MainCoordinator(factory: self, initialRoute: .home)
    }

    func makeHomeCoordinator() -> HomeCoordinator {
        let dependecy = HomeDependencyContainer(appDependecyContainer: self)
        return HomeCoordinator(factory: dependecy)
    }

}

extension AppDependencyContainer: LaunchingViewControllerFactory {

    func makeLaunchingViewController(withResponder responder: AnyObserver<Void>) -> LaunchingViewController {
        let dependecy = LunchingDependencyContainer(appDependencyContainer: self)
        return dependecy.makeLaunchingViewController(withResponder: responder)
    }
}

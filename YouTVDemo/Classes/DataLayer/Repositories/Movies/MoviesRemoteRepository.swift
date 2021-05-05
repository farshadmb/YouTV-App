//
//  MoviesRemoteRepository.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/2/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import Combine
import Alamofire

final class MoviesRemoteRepository: MoviesRepository {

    let service: NetworkService
    // let decoder: DataDecoder

    private let baseURL: String
    private let responseValidation: NetworkResponseValidation

    init(service: NetworkService, baseURL: String, validResponse: NetworkResponseValidation) {
        self.service = service
        self.baseURL = baseURL
        self.responseValidation = validResponse
    }
    
    // MARK: - MoviesRemoteRepository Implemention
    func fetchRecommandationMovies(forId id: Int,at page: Int, withLanguage language: String) -> Observable<Pagination<Movie>> {
        return service.execute(request: createMovieListRequest(url: baseURL + "/movie/\(id)/recommendations",
                                                               page: page, language: language))
            .map(map(response:))
    }

    func fetchNowPlayingMovies(at page: Int, withLanguage language: String) -> Observable<Pagination<Movie>> {
        return service.execute(request: createMovieListRequest(url: baseURL + "/movie/now_playing",
                                                               page: page, language: language))
            .map(map(response:))
    }

    func fetchTopRatedMovies(at page: Int, withLanguage language: String) -> Observable<Pagination<Movie>> {
        return service.execute(request: createMovieListRequest(url: baseURL + "/movie/top_rated",
                                                               page: page, language: language))
            .map(map(response:))
    }

    func fetchPopularMovies(at page: Int, withLanguage language: String) -> Observable<Pagination<Movie>> {
        return service.execute(request: createMovieListRequest(url: baseURL + "/movie/popular",
                                                               page: page, language: language))
            .map(map(response:))
    }

    func fetchMovieDetail(for movie: Movie, withLanguage language: String) -> Single<Detail> {
        return fetchMovieDetail(forId: movie.id, withLanguage: language)
    }
    
    func fetchMovieDetail(forId id: Int, withLanguage language: String) -> Single<Detail> {
        let request = APIParametersRequest(url: baseURL + "/movie/\(id)",
                                           parameters: ["append_to_response": "videos,images","language": language],
                                           validResponse: validResponse())

        return service.execute(request: request)
            .map(map(response:))
            .asSingle()
    }

    private func map<T: Decodable>(response: APIServerResponse<T>) throws -> T {

        guard let data = response.data else {
            throw APIServerResponseError.unknown
        }

        return data
    }

    private func createMovieListRequest(url: String, page: Int, language: String) -> APIParametersRequest {
        return APIParametersRequest(url: url, parameters: ["page": page, "language": language],
                                    validResponse: validResponse())
    }

    private func validResponse() -> NetworkResponseValidation {
        return responseValidation
    }
}

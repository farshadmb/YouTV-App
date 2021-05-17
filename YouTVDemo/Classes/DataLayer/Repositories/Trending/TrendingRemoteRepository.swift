//
//  TrendingRemoteRepository.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/17/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import Combine
import Alamofire

final class TrendingRemoteRepository: TrendingRepository {
   
    let service: NetworkService

    private let baseURL: String
    private let responseValidation: NetworkResponseValidation

    init(service: NetworkService, baseURL: String, validResponse: NetworkResponseValidation) {
        self.service = service
        self.baseURL = baseURL
        self.responseValidation = validResponse
    }
   
    // MARK: - TrendingRepository
    func fetchTredingsContent(at page: Int, withLanguage language: String) -> Observable<Pagination<String>> {
        let request = createRequest(url: "/trending/all/day", page: 1, language: language)
        return service.execute(request: request)
            .map(map(response:))
    }
    
    func fetchTVTrendings(at page: Int, withLanguage language: String) -> Observable<Pagination<TVSerialSummery>> {
       
        let request = createRequest(url: "/trending/tv/day", page: 1, language: language)
        return service.execute(request: request)
            .map(map(response:))
    }
    
    func fetchMovieTrendings(at page: Int, withLanguage language: String) -> Observable<Pagination<MovieSummery>> {
        
        let request = createRequest(url: "/trending/movie/day", page: 1, language: language)
        
        return service.execute(request: request)
            .map(map(response:))
    }
    
    private func map<T: Decodable>(response: APIServerResponse<T>) throws -> T {

        guard let data = response.data else {
            throw APIServerResponseError.unknown
        }

        return data
    }

    private func createRequest(url: String, page: Int, language: String) -> APIParametersRequest {
        return APIParametersRequest(url: baseURL + url, parameters: ["page": page, "language": language],
                                    validResponse: responseValidation)
    }
    
}

//
//  TVRemoteRepository.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/2/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import Combine
import Alamofire

final class TVRemoteRepository: TVRepository {

    let service: NetworkService

    private let baseURL: String
    private let responseValidation: NetworkResponseValidation

    init(service: NetworkService, baseURL: String, validResponse: NetworkResponseValidation) {
        self.service = service
        self.baseURL = baseURL
        self.responseValidation = validResponse
    }

    // MARK: - TVRepository Implemention

    func fetchRecommandationTVSerial(forId id: Int, at page: Int, withLanguage language: String) -> Observable<Pagination<TVSerial>> {
        return service.execute(request: createRequest(url: baseURL + "/tv/\(id)/recommendations",
                                                      page: page, language: language))
            .map(map(response:))
    }

    func fetchOnAirTVSerials(at page: Int, withLanguage language: String) -> Observable<Pagination<TVSerial>> {
        return service.execute(request: createRequest(url: baseURL + "/tv/on_the_air",
                                                      page: page, language: language))
            .map(map(response:))
    }

    func fetchTopRatedTVSerials(at page: Int, withLanguage language: String) -> Observable<Pagination<TVSerial>> {
        service.execute(request: createRequest(url: baseURL + "/tv/top_rated",
                                                      page: page, language: language))
            .map(map(response:))
    }

    func fetchPopularTVSerials(at page: Int, withLanguage language: String) -> Observable<Pagination<TVSerial>> {
        service.execute(request: createRequest(url: baseURL + "/tv/popular",
                                                      page: page, language: language))
            .map(map(response:))
    }

    func fetchTVSerialDetail(forSerial serial: TVSerial, withLanguage language: String) -> Single<Detail> {
        guard let id = serial.id else {
            return .error(NSError(domain: "TVRepositorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "The Id is nil"]))
        }

        return fetchTVSerialDetail(forId: id, withLanguage: language)
    }

    func fetchTVSerialDetail(forId id: Int, withLanguage language: String) -> Single<Detail> {
        let request = APIParametersRequest(url: baseURL + "/tv/\(id)",
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

    private func createRequest(url: String, page: Int, language: String) -> APIParametersRequest {
        return APIParametersRequest(url: url, parameters: ["page": page, "language": language],
                                    validResponse: validResponse())
    }

    private func validResponse() -> NetworkResponseValidation {
        return responseValidation
    }

}

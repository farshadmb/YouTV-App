//
//  APIConfigs.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/2/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

struct APIConfigs: Codable, Hashable {

    let images: Images?

}

extension APIConfigs {

    // MARK: - Images
    struct Images: Codable, Hashable {

        let baseUrl: URL?
        let secureBaseUrl: URL?
        let backdropSizes: [String]?
        let logoSizes: [String]?
        let posterSizes: [String]?
        let profileSizes: [String]?
        let stillSizes: [String]?

        enum CodingKeys: String, CodingKey {
            case baseUrl
            case secureBaseUrl
            case backdropSizes
            case logoSizes
            case posterSizes
            case profileSizes
            case stillSizes
        }
    }
}

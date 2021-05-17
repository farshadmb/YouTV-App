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
        let backdropSizes: [Size]?
        let logoSizes: [Size]?
        let posterSizes: [Size]?
        let profileSizes: [Size]?
        let stillSizes: [Size]?

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

extension APIConfigs.Images {

    enum Size: String, Codable {
        case w45
        case w92
        case w98
        case w154
        case w185
        case w300
        case w342
        case w500
        case w780
        case w1280
        case h632
        case original
    }

}

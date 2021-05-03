//
//  Video.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/2/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

struct Video: Codable, Hashable {

    let id: String?

    // swiftlint:disable:next identifier_name
    let iso639_1: String?

    // swiftlint:disable:next identifier_name
    let iso3166_1: String?

    let key: String?
    let name: String?
    let site: String?
    let size: Int?
    let type: Type?

    enum CodingKeys: String, CodingKey {
        case id

        // swiftlint:disable:next identifier_name
        case iso639_1 = "iso_639_1"

        // swiftlint:disable:next identifier_name
        case iso3166_1 = "iso_3166_1"
        case key
        case name
        case site
        case size
        case type
    }

}

extension Video {

    enum `Type`: String, Codable, Hashable {
        case featurette = "Featurette"
        case teaser = "Teaser"
        case trailer = "Trailer"
        case clip = "Clip"
        case openingCredits = "Opening Credits"
        case behindetheScenes = "Behind the Scenes"
        case recap = "Recap"
        case bloopers = "Bloopers"
    }

}

struct Videos: Codable, Hashable {
    
    let results: [Video]?
}

//
//  SpokenLanguage.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/2/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

struct SpokenLanguage: Codable, Hashable {

    let englishName: String?
    
    // swiftlint:disable:next identifier_name
    let iso639_1: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case englishName
        // swiftlint:disable:next identifier_name
        case iso639_1 = "iso_639_1"
        case name
    }
}

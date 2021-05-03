//
//  ProductionCountry.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/2/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

struct ProductionCountry: Codable, Hashable {

    // swiftlint:disable:next identifier_name
    let iso3166_1: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        
        // swiftlint:disable:next identifier_name
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

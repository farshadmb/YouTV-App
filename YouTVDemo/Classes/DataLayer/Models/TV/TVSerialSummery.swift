//
//  TVSerialSummery.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/2/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

struct TVSerialSummery: Codable, Hashable {

    let posterPath: String?
    let popularity: Double?
    let id: Int?
    let backdropPath: String?
    let voteAverage: Float?
    let overview: String?
    let firstAirDate: Date?
    let originCountry: [String]?
    let genreIds: [Int]?
    let originalLanguage: String?
    let voteCount: Int?
    let name: String?
    let originalName: String?

}

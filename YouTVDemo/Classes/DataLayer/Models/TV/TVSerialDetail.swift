//
//  TVSerialDetail.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/2/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

// MARK: - TVSerialDetail
struct TVSerialDetail: Codable, Hashable {

    let backdropPath: String?
    let createdBy: [CreatedPerson]?
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let genres: [Genre]?
    let homepage: String?
    let id: Int?
    let inProduction: Bool?
    let languages: [String]?
    let lastAirDate: Date?
    let lastEpisodeToAir: Episode?
    let name: String?
    let nextEpisodeToAir: Episode?
    let networks: [Network]?
    let numberOfEpisodes: Int?
    let numberOfSeasons: Int?
    let originCountry: [String]?
    let originalLanguage: String?
    let originalName: String?
    let overview: String?
    let popularity: Float?
    let posterPath: String?
    let productionCompanies: [Network]?
    let productionCountries: [ProductionCountry]?
    let seasons: [Season]?
    let spokenLanguages: [SpokenLanguage]?
    let status: String?
    let tagline: String?
    let type: String?
    let voteAverage: Float?
    let voteCount: Int?
    let videos: Videos?
    let images: Images?

    enum CodingKeys: String, CodingKey {
        case backdropPath
        case createdBy
        case episodeRunTime
        case firstAirDate
        case genres
        case homepage
        case id
        case inProduction
        case languages
        case lastAirDate
        case lastEpisodeToAir
        case name
        case nextEpisodeToAir
        case networks
        case numberOfEpisodes
        case numberOfSeasons
        case originCountry
        case originalLanguage
        case originalName
        case overview
        case popularity
        case posterPath
        case productionCompanies
        case productionCountries
        case seasons
        case spokenLanguages
        case status
        case tagline
        case type
        case voteAverage
        case voteCount
        case videos
        case images
    }
}

extension TVSerialDetail {

    // MARK: - CreatedPerson
    struct CreatedPerson: Codable, Hashable {

        let id: Int?
        let creditId: String?
        let name: String?
        let gender: Int?
        let profilePath: String?

        enum CodingKeys: String, CodingKey {
            case id
            case creditId
            case name
            case gender
            case profilePath
        }
    }

    // MARK: - Episode
    struct Episode: Codable, Hashable {

        let airDate: Date?
        let episodeNumber: Int?
        let id: Int?
        let name: String?
        let overview: String?
        let productionCode: String?
        let seasonNumber: Int?
        let stillPath: String?
        let voteAverage: Float?
        let voteCount: Int?

        enum CodingKeys: String, CodingKey {
            case airDate
            case episodeNumber
            case id
            case name
            case overview
            case productionCode
            case seasonNumber
            case stillPath
            case voteAverage
            case voteCount
        }
    }

    // MARK: - Network
    struct Network: Codable, Hashable {

        let name: String?
        let id: Int?
        let logoPath: String?
        let originCountry: String?

        enum CodingKeys: String, CodingKey {
            case name
            case id
            case logoPath
            case originCountry
        }
    }

    // MARK: - Season
    struct Season: Codable, Hashable {

        let airDate: Date?
        let episodeCount: Int?
        let id: Int?
        let name: String?
        let overview: String?
        let posterPath: String?
        let seasonNumber: Int?
        let episodes: [Episode]?

        enum CodingKeys: String, CodingKey {
            case airDate
            case episodeCount
            case id
            case name
            case overview
            case posterPath
            case seasonNumber
            case episodes
        }
    }

    // MARK: - Episode Group
    struct EpisodeGroups: Codable, Hashable {

        let results: [EpisodeGroup]?
        let id: Int?
    }

    struct EpisodeGroup: Codable, Hashable {

        let resultDescription: String?
        let episodeCount: Int?
        let groupCount: Int?
        let id: String?
        let name: String?
        let network: Network?
        let type: Int?

        enum CodingKeys: String, CodingKey {
            case resultDescription
            case episodeCount
            case groupCount
            case id
            case name
            case network
            case type
        }
    }
}

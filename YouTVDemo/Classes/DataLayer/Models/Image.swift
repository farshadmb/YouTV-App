//
//  Image.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/2/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

struct Images: Codable, Hashable {

    let backdrops: [Backdrop]?
    let posters: [Poster]?

}

extension Images {

    typealias Poster = Backdrop

    struct Backdrop: Codable, Hashable {

        let aspectRatio: Float?
        let filePath: String?
        let height: Int?
        
        // swiftlint:disable:next identifier_name
        let iso639_1: String?
        let voteAverage: Float?
        let voteCount: Int?
        let width: Int?

        enum CodingKeys: String, CodingKey {
            case aspectRatio
            case filePath
            case height
            
            // swiftlint:disable:next identifier_name
            case iso639_1 = "iso_639_1"
            case voteAverage
            case voteCount
            case width
        }
    }
    
}

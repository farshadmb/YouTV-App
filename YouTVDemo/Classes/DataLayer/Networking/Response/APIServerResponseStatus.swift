//
//  APIServerResponseStatus.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

enum APIServerResponseStatus: String, Codable {

    init(from decoder: Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        let value = try singleContainer.decode(Bool.self)
        self = APIServerResponseStatus(rawValue: String(value)) ?? .failure
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode((self.rawValue as NSString).boolValue)
    }

    case success = "true"
    case failure = "false"

}

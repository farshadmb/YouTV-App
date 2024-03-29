//
//  AppConfig.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import Alamofire

/// The struct that hold the app configuration
/// such as `APIKey` and `BaseURL`
struct AppConfig {

    // put your api code here, this api key would be fulfilled by CI/CD
    static let APIKey = "YOUR-API-Key"

    // swiftlint:disable:next force_unwrapping
    static let baseURL = URL(string: "https://api.themoviedb.org/3")!

    // swiftlint:disable:next force_try
    static var imageBaseURL = try! "https://image.tmdb.org/t/p/".asURL()

    static let defaultImageConfig = APIConfigs.Images(baseUrl: nil,
                                           secureBaseUrl: imageBaseURL,
                                           backdropSizes: [.w300, .w780, .w1280, .original],
                                           logoSizes: [.w45, .w154, .w500, .w300, .original],
                                           posterSizes: [ .w92,.w154, .w185, .w342,.w500,.w780, .original],
                                           profileSizes: nil, stillSizes: [.w98, .w185, .w500, .original])

}

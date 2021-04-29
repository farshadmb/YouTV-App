//
//  AppConfig.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

struct AppConfig {

    // put your api code here, this api key would be fulfilled by CI/CD
    static let APIKey = "YOUR-API-Key"
    // swiftlint:disable:next force_unwrapping
    static let BaseURL = URL(string: "https://newsapi.org/v2/")!
}

//
//  Bundle+Extension.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/26/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

extension Bundle {

    /// The Release Version Value known as Marketing Versions. like 1.0
    var releaseVersionNumber: String? {
        return self.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    /// The Bundle Version Value known as Build Versions. like 1.0
    var buildVersionNumber: String? {
        return self.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }

}

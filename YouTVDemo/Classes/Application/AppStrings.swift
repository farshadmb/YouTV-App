//
//  AppStrings.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/17/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

struct Strings {
    
    struct Home {

        static let title = "home.title".localized
        
        struct Section {
            
            static let seeMore = "home.sections.seeMore.title".localized
            static let tvTitle = { (_ prefix: String) -> String in
                return "home.tv.title".localized(withFormat: prefix)
            }
            
            static let onAir = "home.tv.onAir".localized
            
            static let movieTitle = { (_ prefix: String) -> String in
                return "home.movies.title".localized(withFormat: prefix)
            }
            
            static let nowPlayingTitle = "home.movies.playing".localized
            
            static let trendsTitle = "home.trends.title".localized
        }

    }

}

extension Strings {

    struct Global {
        
        static let cancel = "global.cancel".localized
        static let retry = "global.retry".localized
        static let `continue` = "global.continue".localized
        static let loading = "global.loading".localized
        static let popular = "global.popular".localized
        // swiftlint:disable:next identifier_name
        static let ok = "global.ok".localized
        static let error = "global.error".localized
        static let appTitle = "global.apptitle".localized
    }

    struct Errors {
        
        struct APIResponse {
            
            static let code = { (_ code: Int) -> String in
                "api.response.code".localized(withFormat: code)
            }
            
            static let message = { (_ message: String) -> String in
                "api.response.message".localized(withFormat: message)
            }
            
            static let localizedDescription = { (_ code: Int, _ message: String) -> String in
                "api.response.localizableMessage".localized(withFormat: code, message)
            }
            
            static let unknown = "api.response.unknown".localized
        }
        
    }

}

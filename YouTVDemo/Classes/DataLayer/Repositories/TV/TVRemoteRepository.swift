//
//  TVRemoteRepository.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/2/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import Combine
import Alamofire

final class TVRemoteRepository {

    let service: NetworkService

    init(service: NetworkService) {
        self.service = service
    }

}

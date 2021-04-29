//
//  NetworkRequest.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkRequest: URLRequestConvertible {

    var validResponse: NetworkResponseValidation { get }
}

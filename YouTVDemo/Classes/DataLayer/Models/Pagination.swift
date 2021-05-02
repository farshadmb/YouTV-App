//
//  Pagination.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/2/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

struct Pagination <Result: Decodable>: Decodable {

    let page: Int
    let results: [Result]?
    let dates: Dates
    let totalPages: Int
    let totalResults: Int

}



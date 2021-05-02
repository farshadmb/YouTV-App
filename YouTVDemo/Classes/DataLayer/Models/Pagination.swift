//
//  Pagination.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/2/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

/**
 The `Pagination` is corresponding to works around the server response pagination and control it.
 */
struct Pagination <Result: Decodable>: Decodable {


    /// The `Int` value indicate the current page that fetched
    let page: Int

    /// The `Optional<[Result]>` value that contains the result at current page.
    let results: [Result]?

    /// The `Dates` determined the duration period for the current page.
    let dates: Dates

    /// The `Int` value indicate the total page count.
    let totalPages: Int

    /// The `Int` value indicate the total result count.
    let totalResults: Int


    /// Determind the `Pagination` has the next page or has not.
    var hasNext: Bool {
        return page < totalPages
    }

    /// Determind the `Pagination` has the previous page or has not.
    var hasPrevious: Bool {
        return page > 1 && page > totalPages - 1
    }

    /// The `Bool`value indicating the current page is the last page.
    var isLastPage: Bool {
        return page == totalPages
    }


    /// Increase and return the page by one. if the `Pagination` value has next page, otherwise return the last page.
    /// - Returns: The increased `Int` page value
    func nextPage() -> Int {

        guard hasNext else {
            return page
        }

        return page + 1
    }

}



//
//  RxSwift+Unwrap.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/8/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

#if canImport(RxSwift)
import RxSwift
#endif

extension ObservableType {

    /**
     Takes a sequence of optional elements and returns a sequence of non-optional elements, filtering out any nil values.
     - returns: An observable sequence of non-optional elements
     */

    public func unwrap<Result>() -> Observable<Result> where Element == Result? {
        return self.compactMap { $0 }
    }
}

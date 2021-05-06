//
//  HomeShowViewModel.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/6/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class HomeShowViewModel: HomeSectionItemViewModel {

    let model: TVSerialSummery

    override var type: ItemType {
        return .show
    }

    required init(model: TVSerialSummery) {
        self.model = model
        super.init(title: model.name ?? "No Title", rating: model.voteAverage ?? 0.0, image: URL(string: model.posterPath ?? ""))
    }

}

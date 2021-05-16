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
    let remoteBuilder: RemoteImageAssetBuilder

    lazy var firstAirDate: String? = {
        formatDate()
    }()

    override var type: ItemType {
        return .show
    }

    required init(model: TVSerialSummery, remoteImageBuilder: RemoteImageAssetBuilder) {
        self.model = model
        self.remoteBuilder = remoteImageBuilder

        let imageURL = remoteImageBuilder
            .set(size: .w780, forType: \.backdropSizes)
            .build(imageName: model.posterPath ?? "")

        super.init(title: model.name ?? "No Title", rating: model.voteAverage ?? 0.0, image: imageURL)
    }

    private func formatDate() -> String? {
        guard let date = model.firstAirDate else {
            return nil
        }

        let formatter = DateFormatter.currentZoneFormatter
        formatter.amSymbol = .none
        formatter.timeStyle = .none
        formatter.dateStyle = .none
        formatter.dateFormat = "YYYY"

        return formatter.string(from: date)
    }
}

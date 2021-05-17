//
//  HomeMovieViewModel.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/6/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class HomeMovieViewModel: HomeSectionItemViewModel {

    lazy var releaseDate: String? = {
        formatDate()
    }()

    let model: MovieSummery

    override var type: ItemType {
        return .movie
    }

    required init(model: MovieSummery, remoteImageBuilder: RemoteImageAssetBuilder) {
        self.model = model
        let imageURL = remoteImageBuilder
            .set(size: .w780, forType: \.backdropSizes)
            .build(imageName: model.backdropPath ?? "")

        super.init(title: model.title ?? "No Title",
                   rating: model.voteAverage ?? 0.0,
                   image: imageURL)
    }

    private func formatDate() -> String? {
        guard let date = model.releaseDate else {
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

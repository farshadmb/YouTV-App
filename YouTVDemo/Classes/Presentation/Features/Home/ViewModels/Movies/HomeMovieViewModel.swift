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

    let model: MovieSummery

    override var type: ItemType {
        return .movie
    }

    required init(model: MovieSummery, remoteImageBuilder: RemoteImageAssetBuilder) {
        self.model = model
        let imageURL = remoteImageBuilder
            .set(size: .w342, forType: \.posterSizes)
            .build(imageName: model.posterPath ?? "")

        super.init(title: model.title ?? "No Title",
                   rating: model.voteAverage ?? 0.0,
                   image: imageURL)
    }
}

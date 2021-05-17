//
//  HomeTrendingViewModel.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/17/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

final class HomeTrendingViewModelWrapper: HomeSectionItemViewModel {
    
    override var type: ItemType {
        return .trending
    }
    
    required init(viewModel: HomeSectionItemViewModel) {
        super.init(title: viewModel.title,
                   rating: viewModel.rating,
                   image: viewModel.image
        )
    }
    
}

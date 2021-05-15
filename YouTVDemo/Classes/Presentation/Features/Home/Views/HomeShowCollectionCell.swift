//
//  HomeShowCollectionCell.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/7/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import UIKit

class HomeShowCollectionCell: ShowCollectionViewCell, BindableType {

    var viewModel: HomeShowViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
        self.popularityLabel?.text = nil
        self.ratingLabel.text = nil
        self.posterImageView.cancelCurrentImageLoad()
    }

    override func bindViewModel() {
        self.titleLabel.text = viewModel?.title
        self.ratingLabel.text = "\(viewModel?.rating ?? 0.0)"
        self.popularityLabel?.text = String(viewModel?.model.popularity ?? 0.0)
        self.posterImageView.setImage(url: viewModel?.image)
    }

}

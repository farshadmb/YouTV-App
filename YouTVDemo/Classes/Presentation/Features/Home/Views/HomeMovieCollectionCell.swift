//
//  HomeMovieCollectionCell.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/7/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import UIKit
import MaterialComponents
import RxCocoa
import RxSwift
import SDWebImage

class HomeMovieCollectionCell: MovieCollectionViewCell, BindableType {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var popularityStackView: UIStackView!
    
    var viewModel: HomeMovieViewModel?

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

    func bindViewModel() {
        self.titleLabel.text = viewModel?.title
        self.ratingLabel.text = String(viewModel?.rating ?? 0)
        self.popularityLabel?.text = String(viewModel?.model.popularity ?? 0.0)
        self.releaseDateLabel?.text = viewModel?.model.releaseDate?.description
        self.posterImageView.setImage(url: viewModel?.image)
    }

}

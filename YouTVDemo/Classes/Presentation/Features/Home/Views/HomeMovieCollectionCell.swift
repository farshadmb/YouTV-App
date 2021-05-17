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

    @IBOutlet weak var gradientView: LinearGradientView!

    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var popularityStackView: UIStackView!
    
    var viewModel: HomeMovieViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        gradientView.backgroundColor = .clear

        gradientView.colors = [UIColor.black,
                               .clear].reversed()
        gradientView.direction = .custom(start: CGPoint(x: 0.5, y: 0.0), end: CGPoint(x: 0.5, y: 1.0))
        posterImageView.layer.cornerRadius = 9
        posterImageView.clipsToBounds = true
        gradientView.layer.cornerRadius = 9
        gradientView.clipsToBounds = true

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
        self.releaseDateLabel?.text = viewModel?.releaseDate
        self.posterImageView.setImage(url: viewModel?.image)
    }

}

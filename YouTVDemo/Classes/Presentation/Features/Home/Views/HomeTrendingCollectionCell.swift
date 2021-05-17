//
//  HomeTrendingCollectionCell.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/17/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import UIKit

class HomeTrendingCollectionCell<T: HomeSectionItemViewModel>: UICollectionViewCell, BindableType {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var viewModel: T?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 9
        posterImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        posterImageView.cancelCurrentImageLoad()
    }
    
    func bindViewModel() {
        titleLabel.text = viewModel?.title
        posterImageView.setImage(url: viewModel?.image)
    }

}

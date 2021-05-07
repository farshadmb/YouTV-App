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

    func bindViewModel() {
        
    }

}

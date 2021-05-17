//
//  ShowCollectionViewCell.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/6/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

class ShowCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    @IBOutlet weak var popularityLabel: UILabel?
    @IBOutlet weak var posterImageView: UIImageView!

    @IBOutlet weak var shadowView: UIView?
    @IBOutlet weak var networkLabel: UILabel?

    private(set) var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func bindViewModel() {

    }

}

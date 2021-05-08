//
//  HomeSectionHeaderView.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/7/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import UIKit
import MaterialComponents
import RxSwift
import RxCocoa

class HomeSectionHeaderView: UICollectionReusableView, BindableType {
    
    var viewModel: HomeSectionBaseViewModel?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loadingView: MDCActivityIndicator!
    @IBOutlet weak var seeMoreButton: UIButton!

    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        titleLabel.text = nil
        loadingView.stopAnimating()
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        
        self.rx.seeMoreTap.bind(to: viewModel.tapSeeMore).disposed(by: disposeBag)
        
        titleLabel.text = viewModel.title
        viewModel.isLoading.asDriver().drive(rx.isLoading).disposed(by: disposeBag)
    }

}

extension Reactive where Base: HomeSectionHeaderView {

    var seeMoreTap: ControlEvent<Void> {
        return base.seeMoreButton.rx.tap
    }

    var title: Binder<String?> {
        return base.titleLabel.rx.text
    }

    var isLoading: Binder<Bool> {
        return Binder(base) { base, value in
            if value {
                base.loadingView.startAnimating()
            } else {
                base.loadingView.stopAnimating()
            }
        }
    }

    var seeMoreTitle: Binder<String?> {
        return base.seeMoreButton.rx.title()
    }

}

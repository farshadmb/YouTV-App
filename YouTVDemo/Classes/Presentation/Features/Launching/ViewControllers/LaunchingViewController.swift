//
//  LaunchingViewController.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/17/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
import MaterialComponents
import PureLayout

class LaunchingViewController: UIViewController, BindableType, AlertableView {

    lazy var loadingLabel: UILabel = {
        let label = UILabel(forAutoLayout: ())
        label.font = .systemFont(ofSize: 25.0, weight: .medium)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    lazy var loadingIndicatorView: MDCActivityIndicator = {
        let indicator = MDCActivityIndicator(frame: .zero)
        indicator.cycleColors = [ .blue]
        indicator.indicatorMode = .indeterminate
        indicator.progress = 0.85
        return indicator
    }()

    lazy var retryButton: MDCButton = {
        let button = MDCButton(frame: .zero)
        button.setTitle(Strings.Global.retry, for: .normal)
        button.setTitle(Strings.Global.retry, for: .highlighted)
        button.setTitle(Strings.Global.retry, for: .highlighted)
        button.minimumSize = CGSize(width: 80, height: 44)
        button.layer.cornerRadius = 22
        button.isHidden = true
        return button
    }()

    let disposeBag = DisposeBag()

    var viewModel: LaunchViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayouts()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadConfiguration()
    }

    func setupLayouts() {

        view.addSubview(loadingIndicatorView)
        view.addSubview(loadingLabel)
        view.addSubview(retryButton)

        loadingLabel.text = Strings.Global.loading
        loadingIndicatorView.stopAnimating()

        loadingIndicatorView.autoSetDimension(.height, toSize: 44)
        loadingIndicatorView.autoMatch(.height, to: .width,
                                       of: loadingIndicatorView, withMultiplier: 1.0)
        loadingIndicatorView.autoCenterInSuperview()

        loadingLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        loadingLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)

        loadingLabel.autoPinEdge(.top, to: .bottom, of: loadingIndicatorView, withOffset: 8.0)

        retryButton.autoAlignAxis(toSuperviewMarginAxis: .vertical)
        retryButton.autoPinEdge(.top, to: .bottom, of: loadingLabel, withOffset: 19.0)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func bindViewModel() {
        guard let viewModel = viewModel else {
            return
        }

        viewModel.isLoading.asDriver()
            .drive(onNext: {[weak self] (isLoading) in
                if isLoading {
                    self?.retryButton.isHidden = true
                    self?.loadingLabel.text = Strings.Global.loading
                    self?.loadingIndicatorView.startAnimating()
                }else {
                    self?.loadingIndicatorView.stopAnimating()
                }
            })
            .disposed(by: disposeBag)

        viewModel.error.bind(to: loadingLabel.rx.text).disposed(by: disposeBag)
        viewModel.error.bind {[weak self] (error) in
            self?.retryButton.isHidden = false
            self?.presentAlert(message: error, actionTitle: Strings.Global.retry,
                               config: .error, actionHandler: {
                                self?.loadConfiguration()
                               })
        }
        .disposed(by: disposeBag)

        retryButton.rx.tap.bind(onNext: loadConfiguration)
            .disposed(by: disposeBag)

    }

    func loadConfiguration() {
        viewModel?.loadConfiguration()
            .subscribe()
            .disposed(by: disposeBag)
    }

}

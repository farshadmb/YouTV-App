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
        label.font = .systemFont(ofSize: 17.0, weight: .medium)
        label.textColor = .systemBlue
        return label
    }()

    lazy var loadingIndicatorView: MDCActivityIndicator = {
        let indicator = MDCActivityIndicator(frame: .zero)
        indicator.cycleColors = [ .blue]
        indicator.indicatorMode = .indeterminate
        indicator.progress = 0.85
        return indicator
    }()

    var viewModel: Any?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        // Do any additional setup after loading the view.
    }

    func setupLayouts() {

        view.addSubview(loadingIndicatorView)
        view.addSubview(loadingLabel)

        loadingLabel.text = Strings.Global.loading
        loadingIndicatorView.stopAnimating()

        loadingIndicatorView.autoSetDimension(.height, toSize: 44)
        loadingIndicatorView.autoMatch(.height, to: .width,
                                       of: loadingIndicatorView, withMultiplier: 1.0)
        loadingIndicatorView.autoCenterInSuperview()

        loadingLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 16)
        loadingLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 16)

        loadingLabel.autoPinEdge(.top, to: .bottom, of: loadingIndicatorView, withOffset: 8.0)

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
    }

}

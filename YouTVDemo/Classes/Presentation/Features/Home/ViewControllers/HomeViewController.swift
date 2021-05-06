//
//  HomeViewController.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 5/6/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import MaterialComponents
import PureLayout

class HomeViewController: UIViewController, BindableType {

    @IBOutlet weak var collectionView: UICollectionView!

    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        return refresh
    }()

    let disposeBag = DisposeBag()

    var viewModel: HomeViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<String,String>> {
        return .init { (_, _, _, _) -> UICollectionViewCell in
            return .init(forAutoLayout: ())
        } configureSupplementaryView: { (_, _, _, _) -> UICollectionReusableView in
            return .init(forAutoLayout: ())
        }
    }

    // MARK: - BindableType
    func bindViewModel() {
        guard let viewModel = viewModel else {
             return
        }

        self.rx.sentMessage(#selector(UIViewController.viewDidLoad)).map { _ in Void() }
            .bind(to: viewModel.didAppear)
            .disposed(by: viewModel.disposeBag)
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.refreshTriggle)
            .disposed(by: viewModel.disposeBag)

        viewModel.items.bind(to: collectionView.rx.items(cellIdentifier: "", cellType: UICollectionViewCell.self)) { _ , _ , _ in

        }
        .disposed(by: disposeBag)

    }
}

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

    // MARK: - UI Properties
    @IBOutlet weak var collectionView: UICollectionView!

    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        return refresh
    }()

    
    // MARK: - Logic Properties
    let disposeBag = DisposeBag()

    var viewModel: HomeViewModel? = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        bindViewModel()
        viewModel?.buildSections()
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

    // MARK: - UI layout methods

    private func setupLayouts() {
        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.refreshControl = refreshControl
        collectionView.registerCell(type: HomeShowCollectionCell.self)
        collectionView.registerCell(type: HomeMovieCollectionCell.self)
        collectionView.registerSupplementaryView(type: HomeSectionHeaderView.self,
                                                 Ofkind: UICollectionView.elementKindSectionHeader)
        collectionView.collectionViewLayout = setupCollectionViewLayout()
    }

    private func setupCollectionViewLayout() -> UICollectionViewLayout {
        
        let collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: {[weak self] (section, env) -> NSCollectionLayoutSection? in
            return self?.layoutSection(forAt: section, enviroment: env)
        })
        
//        collectionViewLayout.configuration.scrollDirection = .vertical
        
        return collectionViewLayout
    }

    private func layoutSection(forAt section: Int, enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
       
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                              heightDimension: .fractionalHeight(1.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.5))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .topLeading)
        headerElement.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [headerElement]
        
        return section
    }
    
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

        self.rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .debug()
            .map { _ in Void() }
            .bind(to: viewModel.didAppear)
            .disposed(by: viewModel.disposeBag)
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.refreshTriggle)
            .disposed(by: viewModel.disposeBag)

        viewModel.items.bind(to: collectionView.rx.items(cellIdentifier: "HomeMovieCollectionCell", cellType: HomeMovieCollectionCell.self)) { _ , _ , _ in

        }
        .disposed(by: disposeBag)

    }
}

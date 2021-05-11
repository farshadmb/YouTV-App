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

class HomeViewController: UIViewController, BindableType,
                          UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: - UI Properties
    @IBOutlet weak var collectionView: UICollectionView!

    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        return refresh
    }()
    
    // MARK: - Logic Properties
    let disposeBag = DisposeBag()
    
    var viewModel: HomeViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        bindViewModel()
//        viewModel?.buildSections()
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
        collectionView.registerCell(className: UICollectionViewCell.self)
        collectionView.registerSupplementaryView(type: HomeSectionHeaderView.self,
                                                 Ofkind: UICollectionView.elementKindSectionHeader)
        collectionView.register(HomeSectionHeaderView.nib(),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: String(describing: HomeSectionHeaderView.self))
        
        collectionView.collectionViewLayout = setupCollectionViewLayout()
        collectionView.dataSource = self
    }

    private func setupCollectionViewLayout() -> UICollectionViewLayout {
        
        let collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: {[weak self] (section, env) -> NSCollectionLayoutSection? in
            return self?.layoutSection(forAt: section, enviroment: env)
        })
    
        return collectionViewLayout
    }

    private func layoutSection(forAt section: Int, enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        guard let layout = layoutSection(forAt: section) else {
            return nil
        }
        
        return layout.sectionLayout()
    }
    
    private func layoutSection(forAt section: Int) -> HomeSectionLayout? {
        
        guard let layout = viewModel?[section] as? HomeSectionLayout else {
            return nil
        }
        
        return layout
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = viewModel?[section] else {
            return 1
        }
        
        return section.itemCount + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        guard let sectionViewModel = viewModel?[indexPath.section],
              let viewModel = sectionViewModel[indexPath.item] else {
            return collectionView.dequeueReusableCell(type: UICollectionViewCell.self, forIndexPath: indexPath)
        }
        
        let cell: UICollectionViewCell
        
        switch viewModel.type {
        case .movie:
            let movieCell = collectionView.dequeueReusableCell(type: HomeMovieCollectionCell.self, forIndexPath: indexPath)
            
            if let viewModel = viewModel as? HomeMovieViewModel {
                movieCell.bind(to: viewModel)
            }
            
            cell = movieCell
        case .show:
            let showCell = collectionView.dequeueReusableCell(type: HomeShowCollectionCell.self, forIndexPath: indexPath)
            
            if let viewModel = viewModel as? HomeShowViewModel {
                showCell.bind(to: viewModel)
            }
            
            cell = showCell
        case .trending:
            cell = .init()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let sectionViewModel = viewModel?[indexPath.section] else {
            return .init()
        }
        
        switch kind {
        case UICollectionView
                .elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(type: HomeSectionHeaderView.self, kind: kind, forIndexPath: indexPath)
            headerView.bind(to: sectionViewModel)
            sectionViewModel.items.asDriver()
                .asObservable()
                .distinctUntilChanged(at: \.count)
                .bind {[weak collectionView] _ in
                    collectionView?.reloadSections([indexPath.section],
                                                   animationStyle: .none)
                }
                .disposed(by: headerView.disposeBag)
            
            return headerView
        default:
            return .init()
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    // MARK: - BindableType & Logic
    
    func bindViewModel() {
        guard let viewModel = viewModel else {
             return
        }

        self.rx.methodInvoked(#selector(UIViewController.viewDidAppear(_:)))
            .debug()
            .do(onNext: { (viewDidAppears) in
                viewDidAppears.forEach { print(type(of: $0)) }
            })
            .map { _ in Void() }
            .bind(to: viewModel.didAppear)
            .disposed(by: viewModel.disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.refreshTriggle)
            .disposed(by: viewModel.disposeBag)
        
        viewModel.items
            .bind {[weak collectionView] _ in
                collectionView?.reloadData()
                collectionView?.collectionViewLayout.invalidateLayout()
            }
            .disposed(by: disposeBag)

    }
}

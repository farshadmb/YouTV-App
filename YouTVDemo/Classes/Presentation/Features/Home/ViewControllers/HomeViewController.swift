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
        self.tabBarItem = .init(title: Strings.Home.title, image: UIImage.Symbols.home.image,
                                selectedImage: UIImage.Symbols.homeFill.image)
        self.title = Strings.Home.title
    }

    private func setupCollectionView() {
        collectionView.refreshControl = refreshControl
        collectionView.registerCell(type: HomeShowCollectionCell.self)
        collectionView.registerCell(type: HomeMovieCollectionCell.self)
        collectionView.registerCell(type: HomeTrendingCollectionCell.self)
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
            return 0
        }
        
        return section.itemCount
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
            let viewModelType = type(of: viewModel)
            log.debug("\(viewModelType)")
            let trendingCell = collectionView.dequeueReusableCell(type: HomeTrendingCollectionCell.self, forIndexPath: indexPath)
            
            if let viewModel = viewModel as? HomeTrendingViewModelWrapper {
                trendingCell.bind(to: viewModel)
            }
            
            cell = trendingCell
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

        viewModel.items.asDriver()
            .delay(.milliseconds(500))
            .asObservable()
            .bind {[weak self] sections in
                sections.enumerated().forEach {
                    self?.fetchItems(forSection: $0.element)
                    self?.observeItems(forSection: $0.element, atIndex: $0.offset)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.isRefreshing.asDriver()
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        viewModel.error.asDriver(onErrorDriveWith: .never())
            .asObservable()
            .bind {[weak self] error in
                self?.presentAlert(withError: error, actionTitle: Strings.Global.retry, actionHandler: {
                    self?.viewModel?.fetchContents()
                })
            }
            .disposed(by: disposeBag)

    }
    
    private func fetchItems<T: HomeSectionBaseViewModel>(forSection sectionViewModel: T?) {
        guard let viewModel = sectionViewModel else {
            return
        }
        
        viewModel.fetchDataIfNeeded()
            .asDriver {[weak self] (error) -> Driver<Bool> in
                self?.presentAlert(message: "Opps \(viewModel.title) \n " + error.localizedDescription,
                                   actionTitle: Strings.Global.retry,
                                   config: .error, actionHandler: {[weak self, weak sectionViewModel] in
                                    self?.fetchItems(forSection: sectionViewModel)
                                   })
                return .just(false)
            }.drive()
            .disposed(by: disposeBag)
    }
    
    private func observeItems<T: HomeSectionBaseViewModel>(forSection sectionViewModel: T?,
                                                           atIndex section: Int) {
        sectionViewModel?.items.asDriver()
            .asObservable()
            .bind {[weak collectionView] _ in
                collectionView?.reloadSections([section],
                                               animationStyle: .none)
            }
            .disposed(by: disposeBag)
    }
    
}

extension HomeViewController: AlertableView {}

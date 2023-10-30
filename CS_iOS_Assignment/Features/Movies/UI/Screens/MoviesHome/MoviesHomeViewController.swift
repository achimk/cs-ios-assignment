//
//  MoviesHomeViewController.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit
import RxSwift

final class MoviesHomeViewController: UIViewController {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let refreshControl = UIRefreshControl()
    private let layout = MoviesHomeCollectionViewLayout()
    private let dataSource = MoviesHomeDataSourceAdapter()
    private let viewModel: MoviesHomeViewModel
    private let bag = DisposeBag()
    
    init(viewModel: MoviesHomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: Self.self), bundle: Bundle.currentBundle())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        setupCollectionView()
        setupDataSource()
        makeBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.loadIfNeeded()
    }
    
    private func setupRefreshControl() {
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc
    private func refresh() {
        viewModel.input.refresh()
    }
    
    private func setupCollectionView() {
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        collectionView.collectionViewLayout = layout.createLayout()
        collectionView.backgroundColor = Theme.Color.background
        dataSource.setup(with: collectionView)
    }
    
    private func setupDataSource() {
        dataSource.loadNextPageRequested = viewModel.input.loadNextPage
        dataSource.popularMovieSelected = { [weak self] movieId in
            print("-> selected movie id: \(movieId.value)")
            let viewController = MovieDetailsModuleFactory.make(movieId: movieId)
            viewController.onClosePressed = { [weak viewController] in
                viewController?.dismiss(animated: true)
            }
            viewController.modalTransitionStyle = .crossDissolve
            viewController.isModalInPresentation = true
            self?.present(viewController, animated: true)
        }
    }
    
    private func makeBinding() {
        
        viewModel.output.playingState
            .drive(onNext: dataSource.handle(playingListState:))
            .disposed(by: bag)
        
        viewModel.output.popularState
            .drive(onNext: dataSource.handle(popularListState:))
            .disposed(by: bag)
        
        viewModel.output.error.emit { [weak self] (viewData) in
            self?.handleError(viewData: viewData)
        }.disposed(by: bag)
        
        viewModel.output.isLoading.drive { [weak self] (flag) in
            self?.handleIsLoading(flag)
        }.disposed(by: bag)
    }
    
    private func handleError(viewData: MoviesHomeErrorViewData) {
        presentError(message: viewData.details)
    }
    
    private func handleIsLoading(_ isLoading: Bool) {
        if !isLoading {
            refreshControl.endRefreshing()
        }
    }
}

//
//  MovieDetailsViewController.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 08/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit
import RxSwift

final class MovieDetailsViewController: UIViewController {
    
    @IBOutlet private weak var closeButton: CloseButton!
    
    private let viewModel: MovieDetailsViewModel
    private let bag = DisposeBag()
    
    private var selectedViewController: UIViewController? = nil
    
    private lazy var loadingViewController: MovieDetailsLoadingViewController = {
        return MovieDetailsLoadingViewController()
    }()
    
    private lazy var errorViewController: MovieDetailsErrorViewController = {
        return MovieDetailsErrorViewController(refreshHandler: { [weak self] in
            self?.viewModel.input.refresh.onNext(())
        })
    }()
    
    private lazy var contentViewController: MovieDetailsContentViewController = {
        return MovieDetailsContentViewController(viewModel: viewModel)
    }()
    
    var onClosePressed: (() -> ())?
    
    init(viewModel: MovieDetailsViewModel, onClosePressed: (() -> ())? = nil) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: Self.self), bundle: Bundle.currentBundle())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCloseButton()
        makeBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.loadIfNeeded.onNext(())
    }
    
    private func makeBindings() {
        viewModel.output.state.drive(onNext: { [weak self] (state) in
            self?.configure(with: state)
        }).disposed(by: bag)
    }
    
    private func configure(with state: MovieDetailsState) {
        
        if state.contentLoaded {
            configureContentLoaded(with: state)
            view.bringSubviewToFront(closeButton)
            return
        }
        
        switch state.activity {
        case .initial:
            configureInitial(with: state)
        case .loading:
            configureLoading(with: state)
        case .failure(let message):
            configureFailure(with: state, message: message)
        case .success:
            configureSuccess(with: state)
        }
        
        view.bringSubviewToFront(closeButton)
    }
    
    private func configureContentLoaded(with state: MovieDetailsState) {
        configureSuccess(with: state)
        
        switch state.activity {
        case .failure(let message):
            presentError(message: message)
        default:
            break
        }
    }
    
    private func configureInitial(with state: MovieDetailsState) {
        toggle(from: selectedViewController, to: nil)
    }
    
    private func configureLoading(with state: MovieDetailsState) {
        guard selectedViewController !== loadingViewController else {
            return
        }
        toggle(from: selectedViewController, to: loadingViewController)
        selectedViewController = loadingViewController
    }
    
    private func configureFailure(with state: MovieDetailsState, message: String) {
        guard selectedViewController !== errorViewController else {
            return
        }
        toggle(from: selectedViewController, to: errorViewController)
        errorViewController.message = message
        selectedViewController = errorViewController
    }
    
    private func configureSuccess(with state: MovieDetailsState) {
        guard selectedViewController !== contentViewController else {
            return
        }
        toggle(from: selectedViewController, to: contentViewController)
        selectedViewController = contentViewController
    }
    
    private func setupView() {
        view.backgroundColor = .clear
    }
    
    private func setupCloseButton() {
        let inset: CGFloat = 8.0
        closeButton.iconInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        closeButton.onPressed = { [weak self] in
            self?.onClosePressed?()
        }
    }
}

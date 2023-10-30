//
//  MovieDetailsViewController.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit
import RxSwift
import TagListView
import Kingfisher

final class MovieDetailsContentViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var detailsLabel: UILabel!
    @IBOutlet private weak var tagListView: TagListView!
    
    private let viewModel: MovieDetailsViewModel
    private let bag = DisposeBag()
    
    init(viewModel: MovieDetailsViewModel) {
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
        setupView()
        setupImageView()
        setupLabels()
        setupTagListView()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.loadIfNeeded.onNext(())
    }
    
    private func setupView() {
        view.backgroundColor = Theme.Color.overlay
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = Theme.Color.background?.cgColor
        imageView.backgroundColor = Theme.Color.background
    }
    
    private func setupLabels() {
        Theme.configure(titleLabel, with: .detailsTextTitle)
        Theme.configure(subtitleLabel, with: .detailsTextSubtitle)
        Theme.configure(overviewLabel, with: .detailsTextHeader)
        Theme.configure(detailsLabel, with: .detailsTextDescription)
    }
    
    private func setupTagListView() {
        Theme.configure(tagListView)
    }
    
    private func setupBindings() {
        viewModel.output.state.drive(onNext: { [weak self] (state) in
            self?.configure(with: state)
        }).disposed(by: bag)
    }
    
    private func configure(with state: MovieDetailsState) {
        titleLabel.text = state.title
        subtitleLabel.text = state.subtitle
        overviewLabel.text = "Overview" // FIXME: Localize
        detailsLabel.text = state.overview
        tagListView.removeAllTags()
        tagListView.addTags(state.genres)
        
        imageView.kf.setImage(
            with: state.posterURL,
            options: [
                .transition(.fade(0.25))
            ])
    }
}

//
//  MovieDetailsLoadingViewController.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 08/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit

final class MovieDetailsLoadingViewController: UIViewController {
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.currentBundle())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = Theme.Color.overlay
        activityIndicator.color = .white
        activityIndicator.startAnimating()
    }
}

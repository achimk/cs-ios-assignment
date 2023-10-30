//
//  MovieDetailsErrorViewController.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 08/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit

final class MovieDetailsErrorViewController: UIViewController {
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var refreshButton: UIButton!
    
    @IBAction func refresh() {
        refreshHandler()
    }
    
    private var refreshHandler: () -> ()
    var message: String? {
        set {
            messageLabel.text = newValue
        }
        
        get {
            return messageLabel.text
        }
    }
    
    init(refreshHandler: @escaping () -> ()) {
        self.refreshHandler = refreshHandler
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
        Theme.configure(messageLabel, with: .errorTextPlaceholder)
        refreshButton.titleLabel.map {
            Theme.configure($0, with: .errorButtonText)
        }
        refreshButton.setTitle("Refresh", for: .normal) // FIXME: Localize
        
    }
}

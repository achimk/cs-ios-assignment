//
//  MoviesHomeHeaderCollectionReusableView.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit
import Reusable

final class MoviesHomeHeaderCollectionReusableView: UICollectionReusableView, NibReusable {
    @IBOutlet private weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        backgroundColor = Theme.Color.background
        textLabel.backgroundColor = Theme.Color.background
        Theme.configure(textLabel, with: .cellHeader)
    }
    
    func configure(with text: String?) {
        textLabel.text = text
    }
}

//
//  MoviesHomeNavigationBar.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit

final class MoviesHomeNavigationBar: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        backgroundColor = Theme.Color.primary
    }
    
}

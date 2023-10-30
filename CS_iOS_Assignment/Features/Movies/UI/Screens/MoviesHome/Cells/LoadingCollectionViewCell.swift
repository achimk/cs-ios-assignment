//
//  LoadingCollectionViewCell.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit
import Reusable

final class LoadingCollectionViewCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet private weak var progressIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = Theme.Color.primary
        progressIndicator.color = Theme.Color.textTitle
        progressIndicator.startAnimating()
    }
}

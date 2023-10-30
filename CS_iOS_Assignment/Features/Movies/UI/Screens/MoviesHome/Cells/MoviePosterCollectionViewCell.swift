//
//  MoviePosterCollectionViewCell.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

final class MoviePosterCollectionViewCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Theme.Color.background
    }
    
    func configure(with viewData: PosterViewData) {
        imageView.kf.setImage(
            with: viewData.url,
            options: [
                .transition(.fade(0.25))
            ])
    }
}

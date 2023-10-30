//
//  PopularMovieCollectionViewCell.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

final class PopularMovieCollectionViewCell: UICollectionViewCell, NibReusable {
 
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailsLabel: UILabel!
    @IBOutlet private weak var ratingView: MovieRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = Theme.Color.background?.cgColor
        imageView.backgroundColor = Theme.Color.background
        
        Theme.configure(titleLabel, with: .cellTextTitle)
        Theme.configure(detailsLabel, with: .cellTextDetails)
        titleLabel.numberOfLines = 1
        detailsLabel.numberOfLines = 2
        
        backgroundColor = Theme.Color.primary
    }
    
    func configure(with viewData: MovieViewData) {
        titleLabel.text = viewData.title
        detailsLabel.text = [viewData.releaseDate, viewData.duration]
            .compactMap { $0 }.joined(separator: "\n")
        ratingView.configure(with: CGFloat(viewData.rating ?? 0.0), animated: true)
        imageView.kf.setImage(
            with: viewData.posterURL,
            options: [
                .transition(.fade(0.25))
            ])
    }
}

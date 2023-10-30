//
//  MovieRatingView.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit

final class MovieRatingView: UIView {
    
    private let circularProgess = CircularProgressView()
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        backgroundColor = Theme.Color.primary

        circularProgess.setProgress(0.0)
        addAndFill(circularProgess, insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        
        Theme.configure(textLabel, with: .cellTextRating)
        addAndFill(textLabel, insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        textLabel.text = "0"
        textLabel.textAlignment = .center
    }
    
    func configure(with progress: CGFloat, animated: Bool = false) {
        let divisor = pow(10.0, CGFloat(2))
        let rounded = Int(progress * divisor)
        textLabel.text = "\(rounded)"
        circularProgess.setProgress(progress, animated: animated)
    }
}

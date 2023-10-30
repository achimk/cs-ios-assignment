//
//  CloseButton.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 08/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit

final class CloseButton: UIView {
    
    private let imageView = UIImageView()
    
    var iconInsets: UIEdgeInsets = .zero {
        didSet {
            imageView.removeFromSuperview()
            addAndFill(imageView, insets: iconInsets)
        }
    }
    var onPressed: (() -> ())?
    
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
        addAndFill(imageView, insets: iconInsets)
        backgroundColor = .clear
        imageView.image = UIImage(named: "icon-close")
        imageView.tintColor = Theme.Color.closeIcon
        installTapGesture()
    }
    
    private func installTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(gesture)
    }
    
    @objc
    private func handleTap() {
        onPressed?()
    }
}

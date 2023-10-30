//
//  RatingView.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit

final class CircularProgressView: UIView {
    
    private let range: ClosedRange<CGFloat> = 0.0...1.0
    private let placehoderLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    
    private(set) var progress: CGFloat = 0.0
    
    var lowColor = UIColor(hex: 0xd2d353) {
        didSet { setProgress(progress) }
    }
    var highColor = UIColor(hex: 0x62cc82) {
        didSet { setProgress(progress) }
    }
    
    var lowPlaceholderColor = UIColor(hex: 0x413d17) {
        didSet { setProgress(progress) }
    }
    
    var highPlaceholderColor = UIColor(hex: 0x29442B) {
        didSet { setProgress(progress) }
    }
    
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
        layer.addSublayer(placehoderLayer)
        layer.addSublayer(progressLayer)
        
        placehoderLayer.fillColor = UIColor.clear.cgColor
        placehoderLayer.strokeColor = UIColor.clear.cgColor
        placehoderLayer.lineWidth = 4.0
        
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 4.0
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        placehoderLayer.frame = layer.bounds
        progressLayer.frame = layer.bounds
        
        let path = UIBezierPath(
            roundedRect: layer.bounds,
            cornerRadius: .infinity)
        
        placehoderLayer.path = path.cgPath
        progressLayer.path = path.cgPath
    }
    
    func setProgress(_ value: CGFloat, animated: Bool = false) {
        progress = max(range.lowerBound, min(range.upperBound, value))
        
        progressLayer.strokeEnd = progress
        progressLayer.strokeColor = progress < 0.5 ? lowColor?.cgColor : highColor?.cgColor
        placehoderLayer.strokeColor = progress < 0.5 ? lowPlaceholderColor?.cgColor : highPlaceholderColor?.cgColor
        
        if animated {
            // FIXME: Implement animation
        }
    }
    
}

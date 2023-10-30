//
//  UIView+Extensions.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit

extension UIView {
    
    public typealias Anchors = (
        top: NSLayoutConstraint,
        leading: NSLayoutConstraint,
        bottom: NSLayoutConstraint,
        trailing: NSLayoutConstraint
    )
    
    @discardableResult
    public func addAndFill(_ subview: UIView, insets: UIEdgeInsets = .zero) -> Anchors {
        subview.translatesAutoresizingMaskIntoConstraints = false

        addSubview(subview)
        
        let anchors: Anchors
        anchors.top = subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top)
        anchors.leading = subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left)
        anchors.bottom = subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
        anchors.trailing = subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right)
        
        NSLayoutConstraint.activate([
            anchors.top,
            anchors.leading,
            anchors.bottom,
            anchors.trailing
        ])
        
        return anchors
    }
}

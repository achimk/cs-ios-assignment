//
//  Theme.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit
import TagListView

struct Theme {
    
    struct Color {
        
        static let textHeader = UIColor(hex: 0xfcd052)
        static let textTitle = UIColor(hex: 0xcdcdcd)
        static let textDetails = UIColor(hex: 0xcdcdcd)
        static let primary = UIColor(hex: 0x212121)
        static let background = UIColor(hex: 0x404040)
        static let overlay = UIColor(hex: 0x000000, alpha: 0.88)
        static let closeIcon = UIColor(hex: 0xcdcdcd)
    }
}

extension Theme {
    
    enum LabelStyle {
        case cellHeader
        case cellTextTitle
        case cellTextDetails
        case cellTextRating
        
        case detailsTextTitle
        case detailsTextSubtitle
        case detailsTextHeader
        case detailsTextDescription
        
        case errorTextPlaceholder
        case errorButtonText
    }
    
    static func configure(_ label: UILabel, with style: LabelStyle) {
        switch style {
        case .cellHeader:
            label.textColor = Color.textHeader
            label.font = UIFont(name: "HelveticaNeue", size: 12)
            
        case .cellTextTitle:
            label.textColor = Color.textTitle
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
            
        case .cellTextDetails:
            label.textColor = Color.textDetails
            label.font = UIFont(name: "HelveticaNeue", size: 12)
            
        case .cellTextRating:
            label.textColor = Color.textTitle
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
            
        case .detailsTextTitle:
            label.textColor = Color.textTitle
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
            
        case .detailsTextSubtitle:
            label.textColor = Color.textDetails
            label.font = UIFont(name: "HelveticaNeue", size: 12)
            
        case .detailsTextHeader:
            label.textColor = Color.textTitle
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
            
        case .detailsTextDescription:
            label.textColor = Color.textDetails
            label.font = UIFont(name: "HelveticaNeue", size: 14)
            
        case .errorTextPlaceholder:
            label.textColor = Color.textTitle
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
            
        case .errorButtonText:
            label.textColor = .white
            label.font = UIFont(name: "HelveticaNeue", size: 18)
        }
    }
    
    static func configure(_ tagListView: TagListView) {
        tagListView.textFont = UIFont(name: "HelveticaNeue", size: 10) ?? .systemFont(ofSize: 10)
    }
}


//
//  MoviesHomeCollectionViewLayout.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit

final class MoviesHomeCollectionViewLayout {
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] (section, env) -> NSCollectionLayoutSection? in
            
            guard let section = MoviesHomeSection(rawValue: section) else {
                return nil
            }
            
            switch section {
            case .playing:
                return self?.makePlayingLayoutSection(headerId: section.headerId)
            case .popular:
                return self?.makePopularLayoutSection(headerId: section.headerId)
            }
        }
    }
    
    private func makePlayingLayoutSection(headerId: String) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(106),
            heightDimension: .absolute(160))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [
            makeHeaderSupplementaryItem(for: headerId)
        ]
        
        return section
    }
    
    private func makePopularLayoutSection(headerId: String) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(88.0))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5.0
        section.boundarySupplementaryItems = [
            makeHeaderSupplementaryItem(for: headerId)
        ]
        
        return section
    }

    private func makeHeaderSupplementaryItem(for id: String) -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(25))
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSize,
            elementKind: id,
            alignment: .topLeading)
    }
}

//
//  MoviesHomeDataSourceAdapter.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 07/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import UIKit

final class MoviesHomeDataSourceAdapter: NSObject {
    
    private var posters: [PosterViewData] = []
    private var populars: [MovieViewData] = []
    private var reloadData: () -> () = { }
    private var displayLoadNextPage: Bool = false
    
    var loadNextPageRequested: (() -> ())?
    var popularMovieSelected: ((MovieId) -> ())?
    
    func handle(playingListState: PlayingListState) {
        self.posters = playingListState.posters
        reloadData()
    }
    
    func handle(popularListState: PopularListState) {
        self.populars = popularListState.items
        self.displayLoadNextPage = popularListState.isNextPageAvailable
        reloadData()
    }
    
    func setup(with collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        registerCells(with: collectionView)
        registerSupplementartViews(with: collectionView)
        reloadData = { collectionView.reloadData() }
    }
    
    private func registerCells(with collectionView: UICollectionView) {
        collectionView.register(cellType: MoviePosterCollectionViewCell.self)
        collectionView.register(cellType: PopularMovieCollectionViewCell.self)
        collectionView.register(cellType: LoadingCollectionViewCell.self)
    }
    
    private func registerSupplementartViews(with collectionView: UICollectionView) {
        collectionView.register(supplementaryViewType: MoviesHomeHeaderCollectionReusableView.self, ofKind: MoviesHomeSection.playingHeaderId)
        collectionView.register(supplementaryViewType: MoviesHomeHeaderCollectionReusableView.self, ofKind: MoviesHomeSection.popularHeaderId)
    }
    
}

extension MoviesHomeDataSourceAdapter: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let section = MoviesHomeSection(rawValue: indexPath.section) else {
            return false
        }
        
        switch section {
        case .playing: return false
        case .popular: return displayLoadNextPage ? indexPath.row != populars.count : true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = MoviesHomeSection(rawValue: indexPath.section) else {
            return
        }
        
        switch section {
        case .playing:
            return
        case .popular:
            let viewData = populars[indexPath.row]
            popularMovieSelected?(viewData.id)
        }
    }
}

extension MoviesHomeDataSourceAdapter: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let section = MoviesHomeSection(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: MoviesHomeHeaderCollectionReusableView.reuseIdentifier,
            for: indexPath) as! MoviesHomeHeaderCollectionReusableView

        switch section {
        case .playing:
            header.configure(with: "Playing now") // FIXME: Localize!
        case .popular:
            header.configure(with: "Most popular") // FIXME: Localize!
        }
        
        return header
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MoviesHomeSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return posters.count
        case 1: return populars.count + (displayLoadNextPage ? 1 : 0)
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = MoviesHomeSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch section {
        case .playing:
            return playingCell(collectionView, cellForItemAt: indexPath)
        case .popular:
            return popularCell(collectionView, cellForItemAt: indexPath)
        }
    }
    
    private func playingCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewData = posters[indexPath.row]
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MoviePosterCollectionViewCell.self)
        cell.configure(with: viewData)
        return cell
    }
    
    private func popularCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.row == populars.count) {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: LoadingCollectionViewCell.self)
            loadNextPageRequested?()
            return cell
        }
        
        let viewData = populars[indexPath.row]
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: PopularMovieCollectionViewCell.self)
        cell.configure(with: viewData)
        return cell
    }
    
    
}

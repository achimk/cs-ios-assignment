//
//  MovieRepository.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 06/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift

public protocol MovieRepository {
    func findAll(for categoryQuery: MovieCategoryQuery) -> Single<[Movie]>
    func findAll(for pageQuery: MoviePageQuery) -> Single<MoviePageResult>
    func findDetails(for id: MovieId) -> Single<MovieDetails>
}

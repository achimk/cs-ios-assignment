//
//  MovieDBService.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 08/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift
import RxCocoa

public final class MovieDBService {
    
    private let configuration: MovieDBConfiguration
    private let session = URLSession(configuration: .default)
    
    public init(configuration: MovieDBConfiguration = .default) {
        self.configuration = configuration
    }
    
    public func fetchPlaying() -> Single<ResponseResult<PlayingResponse>> {
        do {
            let params = ["page": "1"]
            let endpoint = MovieDBEndpoint.playing
            let url = try buildURL(with: configuration, endpoint: endpoint, params: params)
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.toHttpMethod()
            return session.rx.response(request: request).map { (response, data) in
                let decode = decodeJson(PlayingResponse.self)
                return mapResponseResult(response, data)(decode(data))
            }.asSingle()
        } catch  {
            return Single.error(error)
        }
    }
    
    public func fetchPopular(for page: Int) -> Single<ResponseResult<PopularResponse>> {
        do {
            let params = ["page": "\(page)"]
            let endpoint = MovieDBEndpoint.popular
            let url = try buildURL(with: configuration, endpoint: endpoint, params: params)
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.toHttpMethod()
            return session.rx.response(request: request).map { (response, data) in
                let decode = decodeJson(PopularResponse.self)
                return mapResponseResult(response, data)(decode(data))
            }.asSingle()
        } catch  {
            return Single.error(error)
        }
    }
    
    public func fetchMovieDetails(for id: Int) -> Single<ResponseResult<MovieDetailsResponse>> {
        do {
            let endpoint = MovieDBEndpoint.movieDetails(id: id)
            let url = try buildURL(with: configuration, endpoint: endpoint)
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.toHttpMethod()
            return session.rx.response(request: request).map { (response, data) in
                let decode = decodeJson(MovieDetailsResponse.self)
                return mapResponseResult(response, data)(decode(data))
            }.asSingle()
        } catch  {
            return Single.error(error)
        }
    }
    
    private func buildURL(with configuration: MovieDBConfiguration, endpoint: MovieDBEndpoint, params: [String: String] = [:]) throws -> URL {
        let path = buildURLPath(with: configuration, endpoint: endpoint, params: params)
        guard let url = URL(string: path) else {
            throw MovieDBServiceError.invalidURL
        }
        return url
    }
    
    private func buildURLPath(with configuration: MovieDBConfiguration, endpoint: MovieDBEndpoint, params: [String: String] = [:]) -> String {
        var params = params
        params["language"] = configuration.language
        params["api_key"] = configuration.apiKey
        let query = toQuery(params)
        let base = (configuration.host + endpoint.toPath())
        return base + query
    }
    
    private func toQuery(_ params: [String: String]) -> String {
        if params.isEmpty { return "" }
        return "?" + params.map { $0 + "=" + $1 }.joined(separator: "&")
    }
}


fileprivate func decodeJson<T: Decodable>(_ type: T.Type) -> (Data) -> Result<T, Error> {
    return { data in
        return Result(catching: {
            try JSONDecoder().decode(T.self, from: data)
        })
    }
}

fileprivate func mapResponseResult<T>(_ response: HTTPURLResponse, _ data: Data) -> (Result<T, Error>) -> ResponseResult<T> {
    return { result in
        switch result {
        case .success(let data): return .valid(data)
        case .failure: return .invalid(response, data)
        }
    }
}

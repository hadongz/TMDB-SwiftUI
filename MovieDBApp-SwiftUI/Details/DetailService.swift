//
//  DetailService.swift
//  MovieDBApp-SwiftUI
//
//  Created by Hadi on 02/07/20.
//  Copyright © 2020 Hadi. All rights reserved.
//

import Foundation
import Combine

class DetailService: BaseService {
    
    func getDetail(_ id: Int32) -> AnyPublisher<DetailModel, ServiceError> {
        var tempURL = self.urlComponents
        tempURL.path = [Constants.API_VERSION, Constants.API_MOVIE_PATH, String(id)].joined(separator: "/")
        guard let finalURL = tempURL.url else { return Fail(error: ServiceError.Other("URL Error")).eraseToAnyPublisher() }
        
        return URLSession.shared.dataTaskPublisher(for: finalURL)
            .tryMap { try self.handleGetResponse($0) }
            .decode(type: DetailModel.self, decoder: JSONDecoder())
            .mapError { self.handleMapError($0) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func getReviews(_ id: Int32) -> AnyPublisher<ReviewsModel, ServiceError> {
        var tempURL = self.urlComponents
        tempURL.path = [Constants.API_VERSION, Constants.API_MOVIE_PATH, String(id), Constants.REVIEWS_PATH].joined(separator: "/")
        guard let finalURL = tempURL.url else { return Fail(error: ServiceError.Other("URL Error")).eraseToAnyPublisher() }
        
        return URLSession.shared.dataTaskPublisher(for: finalURL)
            .tryMap { try self.handleGetResponse($0) }
            .decode(type: ReviewsModel.self, decoder: JSONDecoder())
            .mapError { self.handleMapError($0) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

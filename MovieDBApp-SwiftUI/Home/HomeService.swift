//
//  HomeService.swift
//  MovieDBApp-SwiftUI
//
//  Created by Hadi on 01/07/20.
//  Copyright © 2020 Hadi. All rights reserved.
//

import Foundation
import Combine

class HomeService: BaseService {
    
    func getAll(_ category: CategoryPath) -> AnyPublisher<HomeModel, ServiceError> {
        var tempURL = self.urlComponents
        tempURL.path = [Constants.API_VERSION, Constants.API_MOVIE_PATH, category.rawValue].joined(separator: "/")
        guard let finalURL = tempURL.url else { return Fail(error: ServiceError.Other("URL Error")).eraseToAnyPublisher() }
        
        return URLSession.shared.dataTaskPublisher(for: finalURL)
            .tryMap { try self.handleGetResponse($0) }
            .decode(type: HomeModel.self, decoder: JSONDecoder())
            .mapError { self.handleMapError($0) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
}

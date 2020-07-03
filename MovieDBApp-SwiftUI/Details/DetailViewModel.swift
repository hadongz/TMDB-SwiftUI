//
//  DetailViewModel.swift
//  MovieDBApp-SwiftUI
//
//  Created by Hadi on 02/07/20.
//  Copyright © 2020 Hadi. All rights reserved.
//

import Foundation
import Combine
import UIKit

class DetailViewModel: BaseViewModel {
    @Published private(set) var model: DetailModel?
    @Published private(set) var reviews: [ReviewsModel.ResultModel] = [ReviewsModel.ResultModel]()
    
    private let detailService = DetailService()
    private var cancellable = Set<AnyCancellable>()
    private let defaults = UserDefaults.standard
    
    deinit {
        cancellable.removeAll()
    }
    
    func getDetail(_ id: Int32) {
        detailService.getDetail(id)
            .sink(receiveCompletion: { self.handleCompletion($0) }, receiveValue: { self.model = $0 })
            .store(in: &cancellable)
    }
    
    func getReviews(_ id: Int32) {
        detailService.getReviews(id)
            .sink(receiveCompletion: { self.handleCompletion($0) }, receiveValue: { self.reviews = $0.results })
            .store(in: &cancellable)
    }
    
    func showFullReview(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    func saveToFavorites(_ item: DetailModel) {
        if let data = defaults.value(forKey: Constants.FAVORITE_KEY) as? Data {
            var items = try? PropertyListDecoder().decode([DetailModel].self, from: data)
            items?.append(item)
            defaults.set(try? PropertyListEncoder().encode(items), forKey: Constants.FAVORITE_KEY)
        } else {
            defaults.set(try? PropertyListEncoder().encode([item]), forKey: Constants.FAVORITE_KEY)
        }
    }
    
    func removeFromFavorites(_ id: Int32) {
        if let data = defaults.value(forKey: Constants.FAVORITE_KEY) as? Data {
            var items = try? PropertyListDecoder().decode([DetailModel].self, from: data) as [DetailModel]
            items = items?.filter { $0.id != id }
            defaults.set(try? PropertyListEncoder().encode(items), forKey: Constants.FAVORITE_KEY)
        }
    }
    
    func checkIsFavorited(_ id: Int32) -> Bool {
        if let data = defaults.value(forKey: Constants.FAVORITE_KEY) as? Data {
            let items = try? PropertyListDecoder().decode([DetailModel].self, from: data)
            for item in items! {
                if item.id == id {
                    return true
                }
            }
        }
        return false
    }
}

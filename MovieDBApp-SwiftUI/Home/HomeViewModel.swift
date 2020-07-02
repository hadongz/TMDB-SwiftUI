//
//  HomeViewModel.swift
//  MovieDBApp-SwiftUI
//
//  Created by Hadi on 01/07/20.
//  Copyright © 2020 Hadi. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    
    @Published private(set) var models: [HomeModel.ResultModel] = [HomeModel.ResultModel]()
    @Published private(set) var state: ViewModelState = .Idle
    @Published private(set) var isCategoryShown: Bool = false
    @Published private var category: CategoryPath = .NowPlaying
    
    private let homeService = HomeService()
    private var cancellable: AnyCancellable?
    
    func fetchAllData() {
        self.state = .Fetching
        self.cancellable = self.homeService.getAll(self.category)
            .sink(receiveCompletion: { self.handleCompletion($0) }, receiveValue: { self.models = $0.results })
    }
    
    func calculateWidth(x: Float, y: Float) -> CGFloat {
        let vote = y * 10
        return CGFloat(x * vote / 100.0)
    }
    
    func getBarColor(_ num: Float) -> Color {
        switch num {
        case 7...10:
            return Color.green
        case 3...7:
            return Color.yellow
        default:
            return Color.red
        }
    }
    
    func changeCategory(_ val: Bool) {
        self.isCategoryShown = val
    }
    
    func getCategory(_ value: CategoryPath) {
        self.category = value
        self.fetchAllData()
    }
    
    private func handleCompletion(_ completion: Subscribers.Completion<ServiceError>) {
        switch completion {
        case .finished:
            self.state = .Idle
        case .failure(let error):
            handleError(error)
        }
    }
    
    private func handleError(_ error: ServiceError) {
        switch error {
        case .DecodingError:
            self.state = .Error("Error when processing data")
        case .NetworkingError(let code):
            self.state = .Error("Networking error, try again. Code: \(code)")
        case .Other(let error):
            self.state = .Error(error)
        }
    }
}

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

class HomeViewModel: BaseViewModel {
    @Published private(set) var models: [HomeModel.ResultModel] = [HomeModel.ResultModel]()
    @Published private var category: CategoryPath = .NowPlaying
    
    private let homeService = HomeService()
    private var cancellable: AnyCancellable?
    
    deinit {
        cancellable?.cancel()
    }
    
    func fetchAllData() {
        self.changeState(.Fetching)
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
    
    func getCategory(_ value: CategoryPath) {
        self.category = value
        self.fetchAllData()
    }
}

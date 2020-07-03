//
//  FavoriteViewModel.swift
//  MovieDBApp-SwiftUI
//
//  Created by Hadi on 03/07/20.
//  Copyright © 2020 Hadi. All rights reserved.
//

import Foundation
import SwiftUI

class FavoriteViewModel: ObservableObject {
    @Published private(set) var models: [DetailModel] = [DetailModel]()
    
    private let defaults = UserDefaults.standard
    
    func getAll() {
        if let data = defaults.value(forKey: Constants.FAVORITE_KEY) as? Data {
            let items = try? PropertyListDecoder().decode([DetailModel].self, from: data) as [DetailModel]
            if items != nil {
                self.models = items!
            } else {
                self.models = [DetailModel]()
            }
        } else {
            self.models = [DetailModel]()
        }
    }
    
    func calculateWidth(x: Double, y: Double) -> CGFloat {
        let vote = y * 10
        return CGFloat(x * vote / 100.0)
    }
    
    func getBarColor(_ num: Double) -> Color {
        switch num {
        case 7...10:
            return Color.green
        case 3...7:
            return Color.yellow
        default:
            return Color.red
        }
    }
}

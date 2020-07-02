//
//  HomeModel.swift
//  MovieDBApp-SwiftUI
//
//  Created by Hadi on 01/07/20.
//  Copyright © 2020 Hadi. All rights reserved.
//

import Foundation

struct HomeModel: Decodable {
    var results: [ResultModel]
    
    struct ResultModel: Decodable {
        var popularity: Float32
        var vote_count: Int32
        var video: Bool
        var poster_path: String
        var id: Int32
        var adult: Bool
        var backdrop_path: String?
        var original_language: String
        var original_title: String
        var genre_ids: [Int16]
        var title: String
        var vote_average: Float32
        var overview: String
        var release_date: String
    }
}

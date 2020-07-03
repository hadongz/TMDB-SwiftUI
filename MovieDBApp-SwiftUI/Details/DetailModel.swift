//
//  DetailModel.swift
//  MovieDBApp-SwiftUI
//
//  Created by Hadi on 02/07/20.
//  Copyright © 2020 Hadi. All rights reserved.
//

import Foundation

struct DetailModel: Codable {
    var genres: [Genre]
    var homepage: String
    var id: Int32
    var imdb_id: String
    var original_language: String
    var original_title: String
    var overview: String
    var popularity: Float32
    var poster_path: String
    var release_date: String
    var status: String
    var vote_average: Double
    
    struct Genre: Codable {
        var id: Int32
        var name: String
    }
}

//
//  SharedEnum.swift
//  MovieDBApp-SwiftUI
//
//  Created by Hadi on 01/07/20.
//  Copyright © 2020 Hadi. All rights reserved.
//

import Foundation

enum CategoryPath: String {
    case NowPlaying = "now_playing"
    case Popular = "popular"
    case TopRated = "top_rated"
    case Upcoming = "upcoming"
}

enum ServiceError: Error {
    case DecodingError
    case NetworkingError(Int)
    case Other(String)
}

enum ViewModelState {
    case Idle
    case Fetching
    case Error(String)
}

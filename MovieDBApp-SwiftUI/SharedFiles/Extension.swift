//
//  Extension.swift
//  MovieDBApp-SwiftUI
//
//  Created by Hadi on 02/07/20.
//  Copyright © 2020 Hadi. All rights reserved.
//

import Foundation
import SwiftUI

extension String {
    var toDate: String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd, MMMM yyyy"

        if let formatDate = dateFormatterGet.date(from: self) {
            return dateFormatterPrint.string(from: formatDate)
        } else {
           return self
        }
    }
}

extension EnvironmentValues {
    var imageCaches: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue}
    }
}

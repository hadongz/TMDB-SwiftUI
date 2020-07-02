//
//  Views.swift
//  MovieDBApp-SwiftUI
//
//  Created by Hadi on 01/07/20.
//  Copyright © 2020 Hadi. All rights reserved.
//

import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    @ObservedObject var loader: ImageLoader
    private let placeholder: Placeholder?
    private let configuration: (Image) -> Image
    
    init(url: URL, placeholder: Placeholder? = nil, cache: ImageCache? = nil, configuration: @escaping (Image) -> Image = { $0 }) {
        loader = ImageLoader(url: url, cache: cache)
        self.placeholder = placeholder
        self.configuration = configuration
    }
    
    var body: some View {
        image
            .onAppear { self.loader.load() }
            .onDisappear { self.loader.cancel() }
    }
    
    private var image: some View {
        Group {
            if loader.image != nil {
                configuration(Image(uiImage: loader.image!).resizable())
            } else {
                placeholder
            }
        }
    }
}


//
//  FavoriteView.swift
//  MovieDBApp-SwiftUI
//
//  Created by Hadi on 03/07/20.
//  Copyright © 2020 Hadi. All rights reserved.
//

import SwiftUI

struct FavoriteView: View {
    @ObservedObject var viewModel = FavoriteViewModel()
    
    var body: some View {
        content()
            .navigationBarTitle("Your Favorites", displayMode: .large)
            .onAppear(perform: self.viewModel.getAll)
    }
    
    func content() -> some View {
        Group {
            if self.viewModel.models.count != 0 {
                listView()
            } else {
                Text("You have no favorites")
            }
        }
    }
    
    func listView() -> some View {
        ScrollView {
            ForEach(self.viewModel.models, id: \.id) { item in
                NavigationLink(destination: DetailView(id: item.id)) {
                    FavoriteListItem(item: item).padding(EdgeInsets(top: 6, leading: 8, bottom: 4, trailing: 8))
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct FavoriteListItem: View {
    @ObservedObject var viewModel = FavoriteViewModel()
    @Environment(\.imageCaches) var cache: ImageCache
    
    var item: DetailModel
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: Constants.IMAGE_URL + item.poster_path)!,
                       placeholder: Text("loading..."),
                       cache: self.cache)
                .frame(width: 125, height: 185)
                .aspectRatio(contentMode: .fit)
            VStack(alignment: .leading) {
                Text(item.original_title)
                    .font(.headline)
                    .padding(3)
                Text(item.release_date.toDate)
                    .font(.system(size: 12))
                    .padding(3)
                Text(item.overview)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.leading)
                    .lineLimit(5)
                    .padding(3)
                Spacer()
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8).fill(Color.gray)
                        RoundedRectangle(cornerRadius: 8).fill(self.viewModel.getBarColor(self.item.vote_average))
                            .frame(maxWidth: self.viewModel.calculateWidth(
                                x: Double(geo.size.width),
                                y: self.item.vote_average))
                        Text(String(format: "%g", self.item.vote_average))
                            .frame(maxWidth: geo.size.width, alignment: .center)
                            .foregroundColor(Color.white)
                        
                    }.frame(height: 20)
                }
            }.padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 6))
        }.cornerRadius(10)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 3))
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}

//
//  HomeView.swift
//  MovieDBApp-SwiftUI
//
//  Created by Hadi on 01/07/20.
//  Copyright © 2020 Hadi. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel = HomeViewModel()
    @State var isShown = false
    
    var body: some View {
        NavigationView {
            content()
                .navigationBarTitle("Movie List", displayMode: .large)
                .navigationBarItems(trailing: favoriteButton())
        }.onAppear { self.viewModel.fetchAllData()  }
    }
    
    func content() -> some View {
        switch viewModel.state {
        case .Idle:
            return AnyView(
                ZStack {
                    listView()
                    buttonCategory()
                }
            )
        case .Fetching:
            return AnyView(Text("Fetching all data"))
        case .Error(let error):
            return AnyView(Text(error)
                .foregroundColor(Color.red))
        }
    }
    
    func buttonCategory() -> some View {
        VStack(alignment: .center) {
            Spacer()
            if self.isShown {
                popOver()
                    .transition(.scale)
            }
            Button(action: { withAnimation { self.isShown.toggle() } },
                   label: {
                    Group {
                        if self.isShown {
                            Text("Close").foregroundColor(Color.black).padding()
                        } else {
                            Text("Category").foregroundColor(Color.black).padding()
                        }
                    }
            })
                .frame(width: 135, height: 35)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 1)
                .padding()
        }
    }
    
    func popOver() -> some View {
        VStack {
            Button(action: {
                self.viewModel.getCategory(.NowPlaying)
            }, label: {
                Text("Now Playing")
            })
            
            Divider()
            
            Button(action: {
                self.viewModel.getCategory(.Popular)
            }, label: {
                Text("Popular")
            })
            
            Divider()
            
            Button(action: {
                self.viewModel.getCategory(.TopRated)
            }, label: {
                Text("Top Rated")
            })
            
            Divider()
            
            Button(action: {
                self.viewModel.getCategory(.Upcoming)
            }, label: {
                Text("Upcoming")
            })
        }.padding()
            .background(Color.white)
            .cornerRadius(8)
            .clipped()
            .shadow(radius: 1)
            .frame(width: 200)
    }
    
    func listView() -> some View {
        ScrollView {
            ForEach(self.viewModel.models, id: \.id) { item in
                NavigationLink(destination: DetailView(id: item.id)) {
                    ListItem(item: item).padding(EdgeInsets(top: 6, leading: 8, bottom: 4, trailing: 8))
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    func favoriteButton() -> some View {
        NavigationLink(destination: FavoriteView()) {
            Image(systemName: "heart.fill").foregroundColor(Color.pink)
        }
    }
    
}

struct ListItem: View {
    @ObservedObject var viewModel = HomeViewModel()
    @Environment(\.imageCaches) var cache: ImageCache
    
    var item: HomeModel.ResultModel
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: Constants.IMAGE_URL + item.poster_path)!,
                       placeholder: Text("loading..."),
                       cache: self.cache)
                .frame(width: 125, height: 175)
                .aspectRatio(contentMode: .fit)
            VStack(alignment: .leading) {
                Text(item.title)
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
                                x: Float(geo.size.width),
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

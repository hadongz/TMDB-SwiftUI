//
//  DetailView.swift
//  MovieDBApp-SwiftUI
//
//  Created by Hadi on 02/07/20.
//  Copyright © 2020 Hadi. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel: DetailViewModel = DetailViewModel()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.imageCaches) var cache: ImageCache
    @State var isFavorited: Bool = false
    
    var id: Int32
    
    var body: some View {
        content()
            .edgesIgnoringSafeArea([.top])
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton())
            .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor =  UIColor.clear
                nc.navigationBar.setBackgroundImage(UIImage(), for: .default)
            })
            .onAppear {
                self.viewModel.getDetail(self.id)
                self.viewModel.getReviews(self.id)
                self.isFavorited = self.viewModel.checkIsFavorited(self.id) }
    }
    
    func content() -> some View {
        switch viewModel.state {
        case .Idle:
            guard let item = viewModel.model else {
                self.mode.wrappedValue.dismiss()
                return AnyView(Text("loading.."))
            }
            return AnyView(self.mainContent(item))
        case .Fetching:
            return AnyView(Text("Fetching all data"))
        case .Error(let error):
            return AnyView(Text(error).foregroundColor(Color.red))
        }
    }
    
    func backButton() -> some View {
        Button(action: { self.mode.wrappedValue.dismiss() },
               label:{
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 18, height: 25)
                    .aspectRatio(contentMode: .fill)
        }).foregroundColor(Color.gray)
    }
    
    func mainContent(_ item: DetailModel) -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomTrailing) {
                    AsyncImage(url: URL(string: Constants.POSTER_URL + item.poster_path)!,
                               placeholder: Text("loading...").frame(width: UIScreen.main.bounds.size.width, height: 400),
                               cache: self.cache)
                        .frame(maxWidth: .infinity)
                        .aspectRatio(contentMode: .fit)
                    
                    ZStack {
                        Circle().fill(Color.white).shadow(radius: 5)
                        Button(action: {
                            self.isFavorited ? self.viewModel.removeFromFavorites(self.id) : self.viewModel.saveToFavorites(item)
                            self.isFavorited.toggle()
                        },
                               label: {
                                if self.isFavorited {
                                    Image(systemName: "heart.fill").resizable().frame(width: 25, height: 25)
                                } else {
                                    Image(systemName: "heart").resizable().frame(width: 25, height: 25)
                                }
                                
                        })
                    }.frame(width: 60, height: 60, alignment: .center)
                        .foregroundColor(Color.pink)
                        .padding([.trailing], 16)
                        .padding([.bottom], -30)
                }
                
                VStack(alignment: .leading) {
                    Text(item.original_title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .lineLimit(nil)
                    Text("Release date: " + item.release_date.toDate)
                        .font(.system(size: 14))
                        .padding([.top], 3)
                    HStack {
                        ForEach(item.genres.prefix(3), id: \.id) { genre in
                            ZStack {
                                RoundedRectangle(cornerRadius: 8).fill(Color.green).frame(width: 100, height: 25)
                                Text(genre.name)
                                    .font(.system(size: 12))
                            }.foregroundColor(Color.white)
                        }
                    }
                    Text("Overview: ")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .padding([.bottom], 8)
                    Text(item.overview)
                        .font(.body)
                        .fontWeight(.light)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                }.padding([.leading, .trailing], 16)
                
                Text("Reviews:")
                    .font(.headline)
                    .padding([.top, .leading, .trailing])
                
                ScrollView(.horizontal) {
                    HStack(alignment: .top) {
                        ForEach(self.viewModel.reviews, id: \.id) { item in
                            ReviewsItem(item: item)
                        }
                    }.padding(3)
                }.padding([.leading, .trailing, .bottom])
                
            }
        }
    }
}

struct ReviewsItem: View {
    @ObservedObject var viewModel: DetailViewModel = DetailViewModel()
    @State private var showModal = false
    let item: ReviewsModel.ResultModel
    
    var body: some View {
        VStack {
            Text(self.item.author)
                .frame(width: 200, height: 30)
                .background(Color.orange)
                .foregroundColor(Color.white)
            Text(item.content)
                .padding(6)
                .font(.system(size: 12))
                .multilineTextAlignment(.leading)
            Spacer()
            Button(action: { self.viewModel.showFullReview(self.item.url) },
                   label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5).fill(Color.gray)
                        Text("See full review")
                            .font(.system(size: 14))
                    }
            }).padding([.bottom], 6)
                .frame(width: 150, height: 35, alignment: .center)
                .foregroundColor(Color.white)
        }.cornerRadius(5)
            .frame(minWidth: 0, maxWidth: 200, minHeight: 0, maxHeight: 150, alignment: .topLeading)
            .background(RoundedRectangle(cornerRadius: 5).fill(Color.white).shadow(radius: 2))
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(id: 696374)
    }
}

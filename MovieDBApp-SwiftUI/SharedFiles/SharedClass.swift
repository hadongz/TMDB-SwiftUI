//
//  BaseClass.swift
//  MovieDBApp-SwiftUI
//
//  Created by Hadi on 01/07/20.
//  Copyright © 2020 Hadi. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Base Class for Web Service

class BaseService {
    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = Constants.WEB_PROTOCOL
        components.host = Constants.WEB_HOST
        components.queryItems = [URLQueryItem(name: "api_key", value: Constants.API_SECRET)]
        return components
    }
    
    func handleGetResponse(_ output: URLSession.DataTaskPublisher.Output) throws -> Data {
        if let httpResponse = output.response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                return output.data
            } else {
                throw ServiceError.NetworkingError(httpResponse.statusCode)
            }
        } else {
            throw ServiceError.Other("Cannot get response from source")
        }
    }
    
    func handleMapError(_ error: Error) -> ServiceError {
        print(error)
        switch error {
        case is Swift.DecodingError:
            return .DecodingError
        default:
            return .Other("Unknown Error has occured")
        }
    }
}

// MARK: - Base Class for View Model

class BaseViewModel: ObservableObject {
    
    @Published private(set) var state: ViewModelState = .Idle
    
    func handleCompletion(_ completion: Subscribers.Completion<ServiceError>) {
        switch completion {
        case .finished:
            self.state = .Idle
        case .failure(let error):
            handleError(error)
        }
    }
    
    func handleError(_ error: ServiceError) {
        switch error {
        case .DecodingError:
            self.state = .Error("Error when processing data")
        case .NetworkingError(let code):
            self.state = .Error("Networking error, try again. Code: \(code)")
        case .Other(let error):
            self.state = .Error(error)
        }
    }
    
    func changeState(_ val: ViewModelState){
        self.state = val
    }
}

// MARK: - Async Image service

class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    private let url: URL
    private var cache: ImageCache?
    private(set) var isLoading = false
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    
    private var cancellable: AnyCancellable?
    
    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func load() {
        guard !isLoading else { return }
        
        if let image = cache?[url] {
            self.image = image
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .retry(3)
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveOutput: { [weak self] in self?.cache($0) },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .receive(on: RunLoop.main)
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func cache(_ image: UIImage?){
        image.map { cache?[url] = $0 }
    }
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
}

// MARK: - Configuration for image caching

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL)}
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

// MARK: - Navigation Controller Configuration

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
    
}

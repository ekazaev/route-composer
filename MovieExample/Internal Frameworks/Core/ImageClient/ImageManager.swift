//
// Created by Eugene Kazaev on 2019-09-01.
// Copyright (c) 2019 Eugene Kazaev. All rights reserved.
//

import Foundation
import UIKit

public enum ImageError: Error {
    case noResponse
    case decodingError
    case networkError(error: Error)
}

public struct ImageManager {

    public init() {

    }

    public func fetchImage(for url: URL, completion completionHandler: @escaping (Result<UIImage, ImageError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.noResponse))
                }
                return
            }
            guard error == nil else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.networkError(error: error!)))
                }
                return
            }
            guard let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.decodingError))
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(.success(image))
            }
        }
        task.resume()
    }

}

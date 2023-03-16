//
//  UnsplashAPI.swift
//  Unsplash
//
//  Created by Ben Markowitz on 3/16/23.
//

import Foundation

struct UnsplashAPI {
    static let apiKey = "YOUR-API-KEY"
    static let baseURL = "https://api.unsplash.com/"

    static func randomPhotoURL(completion: @escaping (URL?) -> Void) {
        guard let url = URL(string: "\(baseURL)photos/random?client_id=\(apiKey)") else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let urlString = jsonResponse["urls"] as? [String: Any],
               let regularURL = urlString["regular"] as? String,
               let imageURL = URL(string: regularURL) {
                completion(imageURL)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
 

//
//  Network.swift
//  NasaGallery
//
//  Created by Tom Seymour on 3/29/21.
//

import Foundation

class Network {
    static func fetchData(endpoint: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: endpoint) else {
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(nil, error)
            } else if let data = data {
                completion(data, nil)
            }
        }.resume()
    }
}

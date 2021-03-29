//
//  GalleryViewModel.swift
//  NasaGallery
//
//  Created by Tom Seymour on 3/29/21.
//

import Foundation

protocol GalleryDelegate: AnyObject {
    func contentChanged()
}

class GalleryViewModel {
    
    private let nasaUrl = "https://images-api.nasa.gov/search?q=space&media_type=image"
    
    private(set) var items: [NasaItem]? {
        didSet {
            self.delegate?.contentChanged()
        }
    }
    
    weak var delegate: GalleryDelegate?
    
    func fetchItems() {
        guard let url = URL(string: nasaUrl) else {
            fatalError("invalid URL")
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let data = data {
                do {
                    let collection = try JSONDecoder().decode(NasaCollectionWrapper.self, from: data)
                    self.items = collection.collection.items
                } catch {
                    print(error)
                    fatalError("couldn't decode json")
                }
            }
            
            if let error = error {
                print("network error \(error)")
            }
        }.resume()
    }
}

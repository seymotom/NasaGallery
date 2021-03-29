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
    
    var itemViewModels: [NasaItem: NasaItemViewModel] = [:]
    
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
                    fatalError("couldn't decode json \(error)")
                }
            }
            
            if let error = error {
                print("network error \(error)")
            }
        }.resume()
    }
    
    func itemViewModel(for item: NasaItem) -> NasaItemViewModel {
        if let itemViewModel = self.itemViewModels[item] {
            return itemViewModel
        }
        
        let itemViewModel = NasaItemViewModel(item)
        self.itemViewModels[item] = itemViewModel
        return itemViewModel
    }
}

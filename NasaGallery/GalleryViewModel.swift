//
//  GalleryViewModel.swift
//  NasaGallery
//
//  Created by Tom Seymour on 3/29/21.
//

import Foundation

protocol GalleryDelegate: AnyObject {
    func contentChanged()
    func showError(_ error: Error)
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
        Network.fetchData(endpoint: self.nasaUrl) { [weak self] data, error in
            guard let self = self else { return }
            if let data = data {
                do {
                    let collection = try JSONDecoder().decode(NasaCollectionWrapper.self, from: data)
                    self.items = collection.collection.items
                } catch (let error) {
                    self.delegate?.showError(error)
                }
            }
            
            if let error = error {
                self.delegate?.showError(error)
            }
        }
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

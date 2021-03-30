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
    private(set) var nextPageUrl = "https://images-api.nasa.gov/search?q=space&media_type=image"
    
    private(set) var items: [NasaItem]? {
        didSet {
            self.delegate?.contentChanged()
        }
    }
    
    // caching viewModels
    private var itemViewModels: [NasaItem: GalleryItemViewModel] = [:]
    
    // weak reference to delegate to avoid retain cycle
    weak var delegate: GalleryDelegate?
    
    func fetchItems(testData: Data? = nil) {
        Network.fetchData(endpoint: self.nextPageUrl, testData: testData) { [weak self] data, error in
            guard let self = self else { return }
            if let data = data {
                do {
                    let collection = try JSONDecoder().decode(NasaCollectionWrapper.self, from: data)
                    // appending items to the current collection for pagination
                    self.items = (self.items ?? []) + collection.collection.items
                    if let nextPageUrl = collection.collection.links.first(where: { $0.prompt == "Next" })?.href {
                        self.nextPageUrl = nextPageUrl
                    }
                } catch (let error) {
                    self.delegate?.showError(error)
                }
            }
            
            if let error = error {
                self.delegate?.showError(error)
            }
        }
    }
    
    func itemViewModel(for item: NasaItem) -> GalleryItemViewModel {
        if let itemViewModel = self.itemViewModels[item] {
            return itemViewModel
        }
        // if viewModel doesn't exist create one and store it
        let itemViewModel = GalleryItemViewModel(item)
        self.itemViewModels[item] = itemViewModel
        return itemViewModel
    }
    
    func itemViewModel(for index: Int) -> GalleryItemViewModel? {
        guard let items = self.items else { return nil }
        return self.itemViewModels[items[index]]
    }
}

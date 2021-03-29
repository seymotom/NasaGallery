//
//  NasaItemViewModel.swift
//  NasaGallery
//
//  Created by Tom Seymour on 3/29/21.
//

import Foundation

protocol ImageDelegate: AnyObject {
    func setThumbnail(_ data: Data)
}

class NasaItemViewModel {
    private let item: NasaItem
    
    var title: String { item.title }
    
    private(set) var thumbnailImageData: Data? {
        didSet {
            if let data = thumbnailImageData {
                self.delegate?.setThumbnail(data)
            }
        }
    }
    
    weak var delegate: ImageDelegate?
    
    init(_ item: NasaItem) {
        self.item = item
    }
    
    func fetchThumbnail() {
        Network.fetchData(endpoint: self.item.thumbnailUrl) { [weak self] data, error in
            if let data = data {
                self?.thumbnailImageData = data
            }
            if let error = error {
                print("Error fetching thumbnail image \(error)")
            }
        }
    }
}

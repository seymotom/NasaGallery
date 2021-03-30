//
//  GalleryItemViewModel.swift
//  NasaGallery
//
//  Created by Tom Seymour on 3/29/21.
//

import Foundation

protocol ThumbnailImageDelegate: AnyObject {
    func setThumbnail(_ data: Data?)
}

protocol FullImageDelegate: AnyObject {
    func setFullImage(_ data: Data?)
}

class GalleryItemViewModel {
    private let item: NasaItem
    
    var title: String { item.title }
    var description: String { item.description }
    
    private(set) var thumbnailImageData: Data?
    
    weak var thumbnailDelegate: ThumbnailImageDelegate?
    weak var fullImageDelegate: FullImageDelegate?
    
    init(_ item: NasaItem) {
        self.item = item
    }
    
    func fetchThumbnail() {
        if let thumbnailImageData = thumbnailImageData {
            thumbnailDelegate?.setThumbnail(thumbnailImageData)
        } else {
            Network.fetchData(endpoint: item.thumbnailUrl) { [weak self] data, error in
                if let data = data {
                    self?.thumbnailImageData = data
                    self?.thumbnailDelegate?.setThumbnail(data)
                } else if let error = error {
                    print("Error fetching thumbnail image \(error)")
                    self?.thumbnailDelegate?.setThumbnail(nil)
                }
            }
        }
    }
}

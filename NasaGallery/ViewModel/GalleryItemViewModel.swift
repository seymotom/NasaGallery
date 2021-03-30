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
    private var itemMeta: NasaItemMeta?
    
    var title: String { item.title }
    var description: String { item.description }
    
    var photographer: String {
        var text = "Photographer: "
        if let itemMeta = itemMeta {
            text += itemMeta.photographer.isEmpty ? "Unavailable" : itemMeta.photographer
        } else {
            text += "..."
        }
        return text
    }
    
    var location: String {
        var text = "Location: "
        if let itemMeta = itemMeta {
            text += itemMeta.location.isEmpty ? "Unavailable" : itemMeta.location
        } else {
            text += "..."
        }
        return text
    }
    
    private var thumbnailImageData: Data?
    private var fullImageData: Data?
    
    // weak reference to delegates to avoid retain cycle
    weak var thumbnailDelegate: ThumbnailImageDelegate?
    weak var fullImageDelegate: FullImageDelegate?
    weak var galleryDelegate: GalleryDelegate?
    
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
    
    func fetchFullImageMetaData() {
        if itemMeta != nil {
            fullImageDelegate?.setFullImage(fullImageData)
            galleryDelegate?.contentChanged()
        } else {
            Network.fetchData(endpoint: item.imageCollectionUrl) { [weak self] data, error in
                if let data = data {
                    do {
                        let collection = try JSONDecoder().decode([String].self, from: data)
                        if let imageUrl = collection.first(where: { $0.hasSuffix("orig.jpg") }) {
                            self?.fetchFullImage(imageUrl)
                        }
                        if let metaUrl = collection.first(where: { $0.hasSuffix("metadata.json")}) {
                            self?.fetchMetaData(metaUrl)
                        }
                        
                    } catch (let error) {
                        self?.galleryDelegate?.showError(error)
                    }
                    
                } else if let error = error {
                    self?.galleryDelegate?.showError(error)
                }
            }
        }
    }
    
    private func fetchFullImage(_ url: String) {
        Network.fetchData(endpoint: url) { [weak self] data, error in
            if let data = data {
                self?.fullImageData = data
                self?.fullImageDelegate?.setFullImage(data)
            } else if let error = error {
                print("Error fetching full image \(error)")
                self?.fullImageDelegate?.setFullImage(nil)
            }
        }
    }
    
    private func fetchMetaData(_ url: String) {
        Network.fetchData(endpoint: url) { [weak self] data, error in
            if let data = data {
                do {
                    self?.itemMeta = try JSONDecoder().decode(NasaItemMeta.self, from: data)
                    self?.galleryDelegate?.contentChanged()
                } catch(let error) {
                    self?.galleryDelegate?.showError(error)
                }
            } else if let error = error {
                print("Error fetching full image meta data \(error)")
                self?.galleryDelegate?.showError(error)
            }
        }
    }
}

//
//  NasaItemViewModel.swift
//  NasaGallery
//
//  Created by Tom Seymour on 3/29/21.
//

import Foundation

protocol ImageDelegate: AnyObject {
    func setImage(_ data: Data)
}

class NasaItemViewModel {
    private let item: NasaItem
    
    var title: String { item.title }
    var thumbnailImageData: Data?
    
    weak var delegate: ImageDelegate?
    
    init(_ item: NasaItem) {
        self.item = item
    }
    
    func fetchThumbnail() {
        guard let url = URL(string: self.item.thumbnailUrl) else {
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let data = data {
                self.thumbnailImageData = data
                self.delegate?.setImage(data)
            }
        }.resume()
    }
}

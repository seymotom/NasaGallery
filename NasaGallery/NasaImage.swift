//
//  NasaImage.swift
//  NasaGallery
//
//  Created by Tom Seymour on 3/29/21.
//

import Foundation

public enum APIError: Error {
    case jsonDecodeError
    case unknown
}

struct NasaItem: Decodable {
    let id: String
    let title: String
    let description: String
    var center: String?
    let imageCollectionUrl: String
    let thumbnailUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case data
        case imageCollectionUrl = "href"
        case links
        case id
        case title
        case description
        case center
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imageCollectionUrl = try container.decode(String.self, forKey: .imageCollectionUrl)
        let datas = try container.decode([NasaData].self, forKey: .data)
        guard let data = datas.first  else {
            throw APIError.jsonDecodeError
        }
        self.id = data.nasa_id
        self.title = data.title
        self.description = data.description
        self.center = data.center
        
        let links = try container.decode([ItemLink].self, forKey: .links)
        guard let link = links.first  else {
            throw APIError.jsonDecodeError
        }
        self.thumbnailUrl = link.href
    }
}

struct ItemLink: Codable {
    let render: String
    let href: String
    let rel: String
}

struct NasaData: Decodable {
    let nasa_id: String
    let title: String
    let description: String
    var center: String?
}

struct NasaImage: Decodable {
}

struct NasaItemCollection: Decodable {
    let items: [NasaItem]
    let links: [CollectionLink]
}

struct CollectionLink: Decodable {
    let prompt: String
    let href: String
    let rel: String
}

struct NasaCollectionWrapper: Decodable {
    let collection: NasaItemCollection
}

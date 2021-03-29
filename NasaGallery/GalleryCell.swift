//
//  GalleryCell.swift
//  NasaGallery
//
//  Created by Tom Seymour on 3/29/21.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    private let inset = CGFloat(10)

    let label = UILabel()
    let imageView = UIImageView()
    static let reuseIdentifier = "GalleryCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.backgroundColor = .red
        
        contentView.addSubview(imageView)
        imageView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray2.cgColor
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),

            label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -inset),
            label.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -inset)
            ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }

}

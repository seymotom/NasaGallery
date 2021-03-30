//
//  GalleryCell.swift
//  NasaGallery
//
//  Created by Tom Seymour on 3/29/21.
//

import UIKit

class GalleryCell: UICollectionViewCell, ThumbnailImageDelegate {
    static let reuseIdentifier = "GalleryCell"
    private let inset = CGFloat(4)

    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView()
    
    var viewModel: GalleryItemViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            viewModel.thumbnailDelegate = self
            viewModel.fetchThumbnail()
            activityIndicator.startAnimating()
        }
    }
    
    func setThumbnail(_ data: Data?) {
        DispatchQueue.main.async {
            if let data = data {
//                self.imageView.image = UIImage(data: data)
                self.imageView.image = UIImage(named: "noImage")
            } else {
                self.imageView.image = UIImage(named: "noImage")
            }
            self.activityIndicator.stopAnimating()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.borderColor = UIColor.systemGray2.cgColor
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
            ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
}

//
//  GalleryCell.swift
//  NasaGallery
//
//  Created by Tom Seymour on 3/29/21.
//

import UIKit

class GalleryCell: UICollectionViewCell, ImageDelegate {
    private let inset = CGFloat(4)

    let label = UILabel()
    let imageView = UIImageView()
    let activityIndicator = UIActivityIndicatorView()
    static let reuseIdentifier = "GalleryCell"
    
    var viewModel: GalleryItemViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            viewModel.delegate = self
//            self.label.text = viewModel.title
            if let thumbnailData = viewModel.thumbnailImageData {
                self.setThumbnail(thumbnailData)
            } else {
                viewModel.fetchThumbnail()
                self.activityIndicator.startAnimating()
            }
        }
    }
    
    func setThumbnail(_ data: Data) {
        DispatchQueue.main.async {
            self.imageView.image = UIImage(data: data)
            self.activityIndicator.stopAnimating()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.addSubview(activityIndicator)
        imageView.addSubview(label)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .lightText
        label.adjustsFontForContentSizeCategory = true

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
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -inset),
            label.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -inset)
            ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }

}

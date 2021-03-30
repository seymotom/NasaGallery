//
//  GalleryDetailViewController.swift
//  NasaGallery
//
//  Created by Tom Seymour on 3/29/21.
//

import UIKit

class GalleryDetailViewController: UIViewController, FullImageDelegate {
    private let inset = CGFloat(8)
    private let viewModel: GalleryItemViewModel
    
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView()
    
    required init(viewModel: GalleryItemViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .orange
        
        viewModel.fullImageDelegate = self
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.numberOfLines = 0
        titleLabel.text = viewModel.title
        
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = viewModel.description
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(descriptionLabel)
        imageView.addSubview(activityIndicator)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -inset),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: inset),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: inset),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -inset),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: inset),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -inset),
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
            ])
    }
    
    func setFullImage(_ data: Data?) {
        DispatchQueue.main.async {
            if let data = data {
                self.imageView.image = UIImage(data: data)
            } else {
                self.imageView.image = UIImage(named: "noImage")
            }
            self.activityIndicator.stopAnimating()
        }
    }
}

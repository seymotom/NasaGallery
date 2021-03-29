//
//  GalleryViewController.swift
//  NasaGallery
//
//  Created by Tom Seymour on 3/29/21.
//

import UIKit

class GalleryViewController: UIViewController, GalleryDelegate {
    let viewModel = GalleryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "NASA Gallery"
        self.view.backgroundColor = .blue
        self.viewModel.delegate = self
        self.viewModel.fetchItems()
    }
    
    func contentChanged() {
        print("SUCCESS")
        dump(viewModel.items)
    }
    
}

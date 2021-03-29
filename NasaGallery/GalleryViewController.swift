//
//  GalleryViewController.swift
//  NasaGallery
//
//  Created by Tom Seymour on 3/29/21.
//

import UIKit

class GalleryViewController: UIViewController, GalleryDelegate {
    let viewModel = GalleryViewModel()
    
    enum Section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, NasaItem>! = nil
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "NASA Gallery"
        
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: gridLayout())
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.backgroundColor = .yellow
        self.view.addSubview(collectionView)
        
        
        let cellRegistration = UICollectionView.CellRegistration<GalleryCell, NasaItem> { (cell, indexPath, nasaItem) in
            // Populate the cell with our item description.
            cell.label.text = nasaItem.title
            cell.backgroundColor = .blue
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, NasaItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: NasaItem) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        self.viewModel.delegate = self
        self.viewModel.fetchItems()
    }
    
    func contentChanged() {
        print("SUCCESS")
        dump(viewModel.items)
        if let items = viewModel.items {
            var snapshot = NSDiffableDataSourceSnapshot<Section, NasaItem>()
            snapshot.appendSections([.main])
            snapshot.appendItems(items)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    
    private func gridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

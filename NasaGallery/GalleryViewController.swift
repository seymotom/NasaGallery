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

    var dataSource: UICollectionViewDiffableDataSource<Section, NasaItem>!
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "NASA Gallery"
        
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: gridLayout())
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.backgroundColor = .darkGray
        self.view.addSubview(collectionView)
        
        let cellRegistration = UICollectionView.CellRegistration<GalleryCell, NasaItem> { (cell, indexPath, nasaItem) in
            // Populate the cell with viewModel
            cell.viewModel = self.viewModel.itemViewModel(for: nasaItem)
            
            // if collectionView is populating the last item then fetch next page of items
            if nasaItem == self.viewModel.items?.last {
                self.viewModel.fetchItems()
            }
        }
        
        self.dataSource = UICollectionViewDiffableDataSource<Section, NasaItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: NasaItem) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        self.viewModel.delegate = self
        self.viewModel.fetchItems()
    }
    
    func contentChanged() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, NasaItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.viewModel.items ?? [])
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    private func gridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

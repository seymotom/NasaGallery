//
//  GalleryViewController.swift
//  NasaGallery
//
//  Created by Tom Seymour on 3/29/21.
//

import UIKit

extension GalleryDelegate where Self: UIViewController {
    func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

class GalleryViewController: UIViewController, GalleryDelegate, UICollectionViewDelegate {
    private let viewModel: GalleryViewModel
    
    enum Section {
        case main
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, NasaItem>!
    private var collectionView: UICollectionView!
    
    init(viewModel: GalleryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        title = "NASA Gallery"
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: gridLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        view.addSubview(collectionView)
        
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
        
        viewModel.delegate = self
        viewModel.fetchItems()
    }
    
    func contentChanged() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, NasaItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.items ?? [])
        self.dataSource.apply(snapshot, animatingDifferences: true)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let itemViewModel = viewModel.itemViewModel(for: indexPath.item) {
            navigationController?.pushViewController(GalleryDetailViewController(viewModel: itemViewModel), animated: true)
        }
    }
}

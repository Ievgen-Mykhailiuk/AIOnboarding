//
//  CardsCollectionViewFlowLayout.swift
//  AIOnboarding
//
//  Created by Евгений  on 24/05/2023.
//

import UIKit

final class CardsCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        scrollDirection = .horizontal
        
        minimumLineSpacing = 16
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        itemSize = CGSize(width: UIScreen.main.bounds.width - 64, height: UIScreen.main.bounds.height * 0.72)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override
    
    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        let collectionViewWidth = collectionView.bounds.width
        let contentInset = collectionView.contentInset
        let availableWidth = collectionViewWidth - (contentInset.left + contentInset.right)

        // Calculate the spacing needed to evenly distribute the cells
        let cellSpacing = availableWidth - itemSize.width

        // Center the cells horizontally in the collection view
        sectionInset.left = cellSpacing / 2
        sectionInset.right = cellSpacing / 2
    }
    
}

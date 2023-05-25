//
//  CardsCollectionViewFlowLayout.swift
//  AIOnboarding
//
//  Created by Евгений  on 24/05/2023.
//

import UIKit

final class CardsCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        guard let collectionView else { return }
        
        scrollDirection = .horizontal
        minimumLineSpacing = .spacing
        sectionInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
        itemSize = CGSize(width: collectionView.frame.width - .padding, height: collectionView.frame.height)
  
        let collectionViewWidth = collectionView.bounds.width
        let contentInset = collectionView.contentInset
        let availableWidth = collectionViewWidth - (contentInset.left + contentInset.right)
 
        let cellSpacing = availableWidth - itemSize.width
 
        sectionInset.left = cellSpacing / 2
        sectionInset.right = cellSpacing / 2
    }
    
}

private extension CGFloat {
    static let spacing = 16.0
    static let padding = 64.0
}

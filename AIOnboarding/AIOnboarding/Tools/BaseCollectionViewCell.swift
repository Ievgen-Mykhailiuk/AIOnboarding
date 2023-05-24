//
//  BaseCollectionViewCell.swift
//  AIOnboarding
//
//  Created by Евгений  on 24/05/2023.
//

import UIKit

protocol CellIdentifying: AnyObject {
    static var cellIdentifier: String { get }
}

extension CellIdentifying {
    static var cellIdentifier: String {
        return String(describing: Self.self)
    }
}


protocol CollectionCellRegistable: CellIdentifying {
    static func registerClass(in collection: UICollectionView)
    static func registerNib(in collection: UICollectionView)
}

extension CollectionCellRegistable {
    static func registerNib(in collection: UICollectionView) {
        collection.register(UINib(nibName: cellIdentifier, bundle: nil),
                            forCellWithReuseIdentifier: cellIdentifier)
    }
    
    static func registerClass(in collection: UICollectionView) {
        collection.register(Self.self, forCellWithReuseIdentifier: cellIdentifier)
    }
}

protocol CollectionCellDequeueable: CellIdentifying {
    static func cell<T: BaseCollectionViewCell>(in collection: UICollectionView,
                                                at indexPath: IndexPath) -> T
}

extension CollectionCellDequeueable {
    static func cell<T: BaseCollectionViewCell>(in collection: UICollectionView,
                                                at indexPath: IndexPath) -> T  {
        guard let cell = collection.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                        for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(cellIdentifier)")
        }
        return cell
    }
}

class BaseCollectionViewCell: UICollectionViewCell,
                              CollectionCellRegistable,
                              CollectionCellDequeueable {
}


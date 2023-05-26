//
//  OnboardingCell.swift
//  AIOnboarding
//
//  Created by Евгений  on 24/05/2023.
//

import UIKit

final class OnboardingCollectionViewCell: BaseCollectionViewCell {
   
    // MARK: - Properties
    
    private lazy var container: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        return view
    }()

    // MARK: - Configuring
    
    func configure(with model: OnboardingPage) {
        contentView.addSubview(container)
        container.frame = contentView.bounds
        imageView.image = model.image
        container.addSubview(imageView)
        imageView.frame = container.bounds
    }
    
}

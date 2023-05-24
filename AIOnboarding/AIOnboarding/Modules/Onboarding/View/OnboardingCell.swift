//
//  OnboardingCell.swift
//  AIOnboarding
//
//  Created by Евгений  on 24/05/2023.
//

import UIKit

final class OnboardingCell: BaseCollectionViewCell {
   
    // MARK: - Properties
    private lazy var cardView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        return view
    }()
    
    // MARK: - Configuring
    
    func configure() {
        cardView.addSubview(backgroundImageView)
        cardView.layer.cornerRadius = 20
        cardView.backgroundColor = Colors.cardBackground.color
        contentView.addSubview(cardView)
        cardView.frame = contentView.bounds
    }
    
    
}

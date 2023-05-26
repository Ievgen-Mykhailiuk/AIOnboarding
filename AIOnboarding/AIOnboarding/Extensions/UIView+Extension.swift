//
//  UIView+Extension.swift
//  AIOnboarding
//
//  Created by Евгений  on 24/05/2023.
//

import UIKit

extension UIButton {
    
    func animateSelection(with backgroundColor: UIColor = .gray,
                          animationDuration: Double = 0.2,
                          completion: EmptyBlock? = nil) {
        
        guard let identityBackgroundColor = self.backgroundColor else { return }
        
        isUserInteractionEnabled = false
        self.backgroundColor = backgroundColor
        UIView.animate(
            withDuration: animationDuration,
            delay: .zero,
            options: .curveLinear,
            animations: {
                self.backgroundColor = identityBackgroundColor
            },
            completion: { Void in
                completion?()
                self.isUserInteractionEnabled = true
            }
        )
    }
    
}

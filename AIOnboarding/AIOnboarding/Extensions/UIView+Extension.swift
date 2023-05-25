//
//  UIView+Extension.swift
//  AIOnboarding
//
//  Created by Евгений  on 24/05/2023.
//

import UIKit

extension UIView {
    func animateSelection(animationDuration: Double = 0.2, completion: EmptyBlock? = nil) {
        
        self.isUserInteractionEnabled = false
        self.backgroundColor = .gray
        UIView.animate(
            withDuration: animationDuration,
            delay: .zero,
            options: .curveLinear,
            animations: {
                self.backgroundColor = .white
            },
            completion: { Void in
                completion?()
                self.isUserInteractionEnabled = true
            }
        )
    }
    
}

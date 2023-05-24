//
//  UIView+Extension.swift
//  AIOnboarding
//
//  Created by Евгений  on 24/05/2023.
//

import UIKit

extension UIView {
    func animateSelection(animationDuration: Double = 0.1, completion: EmptyBlock? = nil) {
        
        self.isUserInteractionEnabled = false
        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
        UIView.animate(
            withDuration: animationDuration,
            delay: .zero,
            usingSpringWithDamping: CGFloat(0.9),
            initialSpringVelocity: CGFloat(1.0),
            options: UIView.AnimationOptions.curveEaseInOut,
            animations: {
                self.transform = CGAffineTransform.identity
            },
            completion: { Void in
                completion?()
                self.isUserInteractionEnabled = true
            }
        )
    }
    
}

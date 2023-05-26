//
//  UIFont+Extension.swift
//  AIOnboarding
//
//  Created by Евгений  on 26/05/2023.
//

import UIKit

extension UIFont {
    
    static func SFProTextRegular(of size: CGFloat) -> UIFont {
        return FontFamily.SFProText.regular.font(size: size)
    }
   
    static func SFProTextMedium(of size: CGFloat) -> UIFont {
        return FontFamily.SFProText.medium.font(size: size)
    }
    
    static func SFProMedium(of size: CGFloat) -> UIFont {
        return FontFamily.SFPro.opticalSize17Weight510.font(size: size)
    }
    
}

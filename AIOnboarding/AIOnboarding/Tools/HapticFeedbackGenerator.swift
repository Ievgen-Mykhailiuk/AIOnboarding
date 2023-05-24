//
//  HapticFeedbackGenerator.swift
//  AIOnboarding
//
//  Created by Евгений  on 24/05/2023.
//

import UIKit

final class HapticFeedbackGenerator {
    
    static let shared = HapticFeedbackGenerator()
    
    private init() {}
    
    func vibrateSelectionChanged() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
}


//
//  OnboardingPage.swift
//  AIOnboarding
//
//  Created by Евгений  on 25/05/2023.
//

import UIKit

struct OnboardingPage {
    let image: UIImage
}

let dataSource: [OnboardingPage] = [
    OnboardingPage(image: Images.introduction.image),
    OnboardingPage(image: Images.chat1.image),
    OnboardingPage(image: Images.chat2.image),
    OnboardingPage(image: Images.suggestions.image)
]

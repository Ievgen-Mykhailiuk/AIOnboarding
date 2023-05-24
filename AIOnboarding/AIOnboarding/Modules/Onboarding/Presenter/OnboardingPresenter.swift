//
//  OnboardingPresenter.swift
//  AIOnboarding
//
//  Created by Евгений  on 23/05/2023.
//

import Foundation

protocol OnboardingPresenterProtocol {
    func viewDidLoad()
}

final class OnboardingPresenter {
    
    // MARK: - Properties
    
    private weak var view: OnboardingViewProtocol!
    private let router: OnboardingRouterProtocol
    
    // MARK: - Lifecycle
    
    init(view: OnboardingViewProtocol,
         router: OnboardingRouterProtocol) {
        self.view = view
        self.router = router
    }
}

// MARK: - OnboardingPresenterProtocol

extension OnboardingPresenter: OnboardingPresenterProtocol {
    func viewDidLoad() {
        
    }
    
}

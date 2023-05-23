//
//  OnboardingRouter.swift
//  AIOnboarding
//
//  Created by Евгений  on 23/05/2023.
//

import Foundation

protocol OnboardingRouterProtocol {
    func showOboarding()
}

final class OnboardingRouter: BaseRouter, OnboardingRouterProtocol {
   
    func showOboarding() {
        let viewController = OnboardingModuleBuilder().createOnboardingModule()
        show(viewController: viewController,
             isModal: false,
             animated: true,
             completion: nil)
    }
  
}

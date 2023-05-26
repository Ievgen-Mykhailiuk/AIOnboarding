//
//  OnboardingRouter.swift
//  AIOnboarding
//
//  Created by Евгений  on 23/05/2023.
//

import UIKit

protocol OnboardingRouterProtocol {
    func showOboarding()
    func open(_ url: URL)
    func close()
}

final class OnboardingRouter: BaseRouter, OnboardingRouterProtocol {
   
    func showOboarding() {
        let viewController = OnboardingModuleBuilder().createOnboardingModule()
        show(viewController: viewController,
             isModal: false,
             animated: true,
             completion: nil)
    }
    
    func open(_ url: URL) {
        UIApplication.shared.open(url)
    }
    
    func close() {}
    
}

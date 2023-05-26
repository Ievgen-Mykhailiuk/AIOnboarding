//
//  OnboardingModuleBuilder.swift
//  AIOnboarding
//
//  Created by Евгений  on 23/05/2023.
//

import UIKit

protocol OnboardingModuleBuilderProtocol {
    func createOnboardingModule() -> UIViewController
}

final class OnboardingModuleBuilder:  OnboardingModuleBuilderProtocol {
    
    func createOnboardingModule() -> UIViewController {
        let view  = OnboardingViewController()
        let router = OnboardingRouter(viewController: view)
        let presenter = OnboardingPresenter(view: view,
                                            router: router)
        view.presenter = presenter
        let navigationController = UINavigationController(rootViewController: view)
        return navigationController
    }
    
}

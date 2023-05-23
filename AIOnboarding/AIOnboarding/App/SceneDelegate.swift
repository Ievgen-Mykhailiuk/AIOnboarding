//
//  SceneDelegate.swift
//  AIOnboarding
//
//  Created by Евгений  on 23/05/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        setupRootView(scene)
    }
   
    private func setupRootView(_ scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let view = OnboardingModuleBuilder().createOnboardingModule()
        window?.rootViewController = view
        window?.makeKeyAndVisible()
    }

}


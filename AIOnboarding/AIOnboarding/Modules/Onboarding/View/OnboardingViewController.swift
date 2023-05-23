//
//  ViewController.swift
//  AIOnboarding
//
//  Created by Евгений  on 23/05/2023.
//

import UIKit

protocol OnboardingViewProtocol: AnyObject {
 
}

final class OnboardingViewController: UIViewController {

    var presenter: OnboardingPresenterProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImageView = UIImageView(image: Images.background.image)
        backgroundImageView.frame = view.bounds
        view.addSubview(backgroundImageView)
    }

}

extension OnboardingViewController: OnboardingViewProtocol {
    
}

//
//  UIViewController+Extension.swift
//  AIOnboarding
//
//  Created by Евгений  on 23/05/2023.
//

import UIKit

extension UIViewController {
    
    var isModal: Bool {
        return presentingViewController != nil ||
        navigationController?.presentingViewController != nil
    }
    
}

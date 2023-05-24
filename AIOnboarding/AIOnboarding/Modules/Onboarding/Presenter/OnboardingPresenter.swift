//
//  OnboardingPresenter.swift
//  AIOnboarding
//
//  Created by Евгений  on 23/05/2023.
//

import Foundation

protocol OnboardingPresenterProtocol {
    func viewDidLoad()
    func onActionButtonTapped()
    func getPagesCount() -> Int
    func getPages() -> [Int]
    func getCurrentPageIndex() -> Int
    func isFirstPage() -> Bool
    func isLastPage() -> Bool
}

final class OnboardingPresenter {
    
    // MARK: - Properties
    
    private weak var view: OnboardingViewProtocol!
    private let router: OnboardingRouterProtocol
    
    var pages: [Int] = [1, 2, 3, 4]
    var currentPageIndex: Int = .zero 
    
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
        view.setupUI()
    }
    
    func onActionButtonTapped() {
        let nextPageIndex = currentPageIndex + 1
        if nextPageIndex < pages.count {
            currentPageIndex += 1
            view.nextPage(at: nextPageIndex)
        } else {
            // Handle action when reaching the last page
        }
    }
    
    func getPagesCount() -> Int {
        return pages.count
    }
    
    func getPages() -> [Int] {
         return pages
    }
    
    func getCurrentPageIndex() -> Int {
        return currentPageIndex
    }
    
    func isFirstPage() -> Bool {
        return currentPageIndex + 1 == pages.first
    }
    
    func isLastPage() -> Bool {
        return currentPageIndex + 1 == pages.last
    }

}

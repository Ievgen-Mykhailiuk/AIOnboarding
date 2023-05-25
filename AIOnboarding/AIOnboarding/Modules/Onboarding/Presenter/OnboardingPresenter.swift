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
    func getPageAt(_ index: Int) -> OnboardingPage
    func getCurrentPageIndex() -> Int
    func isFirstPage() -> Bool
    func isLastPage() -> Bool
    func onCloseTapped()
    func onRestorePurchaseTapped()
}

final class OnboardingPresenter {
    
    // MARK: - Properties
    
    private weak var view: OnboardingViewProtocol!
    private let router: OnboardingRouterProtocol
    private var pages: [OnboardingPage] = []
    private var currentPageIndex: Int = .zero
    
    // MARK: - Lifecycle
    
    init(view: OnboardingViewProtocol,
         router: OnboardingRouterProtocol) {
        self.view = view
        self.router = router
        self.pages = dataSource
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
            view.loading(isLoading: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.view.showAlert(title: "Purchase", message: "Trial 7 days", actions: nil)
                self.view.loading(isLoading: false)
            })
        }
    }
    
    func getPagesCount() -> Int {
        return pages.count
    }
    
    func getPageAt(_ index: Int) -> OnboardingPage {
         return pages[index]
    }
    
    func getCurrentPageIndex() -> Int {
        return currentPageIndex
    }
    
    func isLastPage() -> Bool {
        return currentPageIndex == pages.count - 1
    }
    
    func isFirstPage() -> Bool {
        return currentPageIndex == .zero
    }
    
    func onCloseTapped() {
        router.close()
    }

    func onRestorePurchaseTapped() {
         
    }

}

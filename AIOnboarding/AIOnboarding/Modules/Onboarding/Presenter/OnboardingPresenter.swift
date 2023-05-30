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
    func onLinkTapped(_ url: URL)
    func getPagesCount() -> Int
    func getPageFor(_ index: Int) -> OnboardingPage
    func getCurrentPageIndex() -> Int
    func isFirstPage() -> Bool
    func isLastPage() -> Bool
    func onCloseTapped()
    func onRestorePurchaseTapped()
}

final class OnboardingPresenter {
    
    // MARK: - Properties
    
    private weak var view: OnboardingViewProtocol?
    private let router: OnboardingRouterProtocol
    private let purchasesManager: PurchasesManagerProtocol
    private let apiClient: PurchasesAPIClient
    private var pages: [OnboardingPage] = []
    private var currentPageIndex: Int = .zero
   
    // MARK: - Lifecycle
    
    init(view: OnboardingViewProtocol,
         router: OnboardingRouterProtocol,
         purchasesManager: PurchasesManagerProtocol,
         apiClient: PurchasesAPIClient) {
        self.view = view
        self.router = router
        self.purchasesManager = purchasesManager
        self.apiClient = apiClient
    }
    
    private func nextPage(_ index: Int) {
        currentPageIndex += 1
        DispatchQueue.main.async {
            self.view?.nextPage(at: index)
        }
    }
    
    private func purchase() {
        loading(true)
        purchasesManager.purchase { [weak self] result in
            switch result {
            case .success(_):
                self?.apiClient.requestReceiptValidation(endpoint: .receiptValidation) { [weak self] result in
                    switch result {
                    case .success(_):
                        /// Implement succesful receipt validation flow
                        ()
                    case .failure(_):
                        ///Just to simulate  succesful receipt validation
                        self?.view?.showAlert(title: .empty, message: Strings.purchased, actions: nil)
                        ///
//                        self?.handleError(error)
                    }
                }
            case .failure(let error):
                self?.handleError(error)
            }
            self?.loading(false)
        }
    }
    
    private func restorePurchase() {
        loading(true)
        purchasesManager.restorePurchase { [weak self] result in
            switch result {
            case .success(_):
                self?.view?.showAlert(title: .empty, message: Strings.restored, actions: nil)
            case .failure(let error):
                self?.handleError(error)
            }
            self?.loading(false)
        }
    }
    
    private func getPages(_ completion: EmptyBlock) {
        /// Just to simulate an api request
        pages = dataSource
        completion()
    }
    
    private func handleError(_ error: Error) {
        if let purchaseError = error as? PurchaseError {
            self.view?.showAlert(title: Strings.error, message: purchaseError.description , actions: nil)
        } else if let networkError = error as? NetworkError {
            self.view?.showAlert(title: Strings.error, message: networkError.description , actions: nil)
        } else {
            self.view?.showAlert(title: Strings.error, message: error.localizedDescription , actions: nil)
        }
    }
    
    private func loading(_ isLoading: Bool) {
        DispatchQueue.main.async {
            self.view?.loading(isLoading: isLoading)
        }
    }
    
 }

// MARK: - OnboardingPresenterProtocol

extension OnboardingPresenter: OnboardingPresenterProtocol {
    
    func viewDidLoad() {
        getPages {
            view?.setupUI()
        }
    }
    
    func onActionButtonTapped() {
        HapticFeedbackGenerator.shared.vibrateSelectionChanged()
        let nextPageIndex = currentPageIndex + 1
        nextPageIndex < pages.count ? nextPage(nextPageIndex) : purchase()
    }
    
    func onLinkTapped(_ url: URL) {
        HapticFeedbackGenerator.shared.vibrateSelectionChanged()
        router.open(url)
    }
    
    func getPagesCount() -> Int {
        return pages.count
    }
    
    func getPageFor(_ index: Int) -> OnboardingPage {
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
        HapticFeedbackGenerator.shared.vibrateSelectionChanged()
        router.close()
    }
    
    func onRestorePurchaseTapped() {
        HapticFeedbackGenerator.shared.vibrateSelectionChanged()
        restorePurchase()
    }
    
}

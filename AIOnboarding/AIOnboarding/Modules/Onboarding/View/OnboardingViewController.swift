//
//  ViewController.swift
//  AIOnboarding
//
//  Created by Евгений  on 23/05/2023.
//

import UIKit

protocol OnboardingViewProtocol: AnyObject {
    func setupUI()
    func showAlert()
    func nextPage(at index: Int)
}

final class OnboardingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    // MARK: - Properties
    
    var presenter: OnboardingPresenterProtocol!

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CardsCollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private lazy var pageControl: PageControl = {
        let pageControl = PageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    private lazy var mainActionButton: UIButton = {
        let actionButton = UIButton()
        actionButton.backgroundColor = .white
        actionButton.layer.cornerRadius = Constants.actionButtonCornerRadius
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        actionButton.setTitleColor(.black, for: .normal)
        return actionButton
    }()
    private lazy var backgroundImageView: UIImageView = {
       let imageview = UIImageView(image: Images.background.image)
        return imageview
    }()
    private lazy var policyView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var restorePurchaseButton: UIButton = {
        let restorePurchaseButton = UIButton()
        restorePurchaseButton.titleLabel?.font = FontFamily.SFProText.medium.font(size: 14)
        restorePurchaseButton.setTitleColor(Colors.inactivePageIndicator.color, for: .normal)
        restorePurchaseButton.backgroundColor = .clear
        restorePurchaseButton.translatesAutoresizingMaskIntoConstraints = false
        restorePurchaseButton.addTarget(self, action: #selector(restorePurchaseButtonTapped), for: .touchUpInside)
        restorePurchaseButton.setTitle(Constants.restorePurchaseButtonTitle, for: .normal)
        return restorePurchaseButton
    }()
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.backgroundColor = .clear
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.setImage(Images.closeButton.image, for: .normal)
        return closeButton
    }()
    
   // MARK: - Lyficycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    // MARK: - Button Actions

    @objc private func actionButtonTapped(_ sender: UIButton) {
        sender.animateSelection()
        presenter.onActionButtonTapped()
        HapticFeedbackGenerator.shared.vibrateSelectionChanged()
    }
    
    @objc private func restorePurchaseButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc private func closeButtonTapped(_ sender: UIButton) {
 
    }
    
    // MARK: - Private methods
    
    private func initialSetup() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(backgroundImageView)
        backgroundImageView.frame = view.bounds
        setupCollectionView()
        setupPageControl()
        setupPageButton()
        setupPolicyView()
        setupRestorePurchaseButton()
        setupCloseButton()
        refresh()
    }
    
    private func setupCollectionView() {
        OnboardingCell.registerClass(in: collectionView)
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.collectionViewTopPadding),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.collectionViewBottomPadding)
        ])
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = presenter.getPagesCount()
        pageControl.currentPage = presenter.getCurrentPageIndex()
        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.pageControlBottomPadding)
        ])
    }
    
    private func setupmainActionButton() {
        view.addSubview(mainActionButton)
        
        NSLayoutConstraint.activate([
            mainActionButton.heightAnchor.constraint(equalToConstant: Constants.actionButtonHeight),
            mainActionButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.actionButtonInset),
            mainActionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Constants.actionButtonInset),
            mainActionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.actionButtonBottomPadding)
        ])
    }
    
    private func setupRestorePurchaseButton() {
        view.addSubview(restorePurchaseButton)
        
        NSLayoutConstraint.activate([
            restorePurchaseButton.heightAnchor.constraint(equalToConstant: Constants.restorePurchaseButtonHeight),
            restorePurchaseButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.restorePurchaseButtonInset),
            restorePurchaseButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -Constants.restorePurchaseBottomPadding)
        ])
    }
    
    private func setupCloseButton() {
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: Constants.closeButtonHeight),
            closeButton.widthAnchor.constraint(equalToConstant: Constants.closeButtonHeight),
            closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Constants.closeButtonInset),
            closeButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -Constants.closeButtonBottomPadding)
        ])
    }
    
    private func setupPolicyView() {
        // Create the label
        let font = FontFamily.SFPro.opticalSize17Weight400.font(size: 12)
        let label = UILabel()
        label.font = font
        label.textColor = UIColor.gray
        label.text = "By continuing you accept our:"
        
        // Create the attributed string for the links
        
        let termsOfUseLink = NSAttributedString(string: "Terms of Use", attributes: [.link: Constants.termsOfUseURL, .font: font])
        
        let privacyPolicyLink = NSAttributedString(string: "Privacy Policy", attributes: [.link: Constants.privacyPolicyURL, .font: font])
        
        let subscriptionTermsLink = NSAttributedString(string: "Subscription Terms", attributes: [.link: Constants.subscriptiontermsURL, .font: font])
        
        let commaSepatator = NSAttributedString(string: ", ", attributes: [.font: font, .foregroundColor: UIColor.gray])
        
        let andSepatator = NSAttributedString(string: ", and ", attributes: [.font: font, .foregroundColor: UIColor.gray])
     
        // Create the text view
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .link
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = .zero
        
        
        // Combine the attributed strings and set it to the text view
        let fullText = NSMutableAttributedString()
        fullText.append(termsOfUseLink)
        fullText.append(commaSepatator)
        fullText.append(privacyPolicyLink)
        fullText.append(andSepatator)
        fullText.append(subscriptionTermsLink)
        textView.attributedText = fullText
        
        // Handle link tapping
        textView.delegate = self
        
        [label, textView].forEach {
            policyView.addArrangedSubview($0)
        }
        view.addSubview(policyView)
 
        NSLayoutConstraint.activate([
            policyView.leftAnchor.constraint(equalTo: view.leftAnchor),
            policyView.rightAnchor.constraint(equalTo: view.rightAnchor),
            policyView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.privacyViewBottomPadding)
        ])
    }
    
    private func scrollToPage(to index: Int) {
        let indexPath = IndexPath(item: index, section: .zero)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = index
    }

    private func refresh() {
        mainActionButton.setTitle(presenter.isLastPage() ? "Try Free & Subscribe" : "Continue", for: .normal)
        pageControl.isHidden = presenter.isFirstPage() || presenter.isLastPage()
        policyView.isHidden = !(presenter.isFirstPage() || presenter.isLastPage())
        restorePurchaseButton.isHidden = !presenter.isLastPage()
        closeButton.isHidden = !presenter.isLastPage()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getPagesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OnboardingCell = .cell(in: self.collectionView, at: indexPath)
        cell.configure()
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
}

// MARK: - OnboardingViewProtocol

extension OnboardingViewController: OnboardingViewProtocol {
    func setupUI() {
        initialSetup()
    }
    
    func showAlert() {
         
    }
    
    func nextPage(at index: Int) {
        scrollToPage(to: index)
        refresh()
    }
    
}

// MARK: - UITextViewDelegate

extension OnboardingViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}

private extension OnboardingViewController {
    enum Constants {
        static let termsOfUseURL: String = "https://assistai.guru/documents/tos.html"
        static let privacyPolicyURL: String = "https://assistai.guru/documents/privacy.html"
        static let subscriptiontermsURL: String = "https://assistai.guru/documents/subscription.html"
        static let actionButtonHeight: CGFloat = 56.0
        static let actionButtonCornerRadius: CGFloat = 28.0
        static let actionButtonInset: CGFloat = 31.0
        static let collectionViewTopPadding: CGFloat = 100.0
        static let collectionViewBottomPadding: CGFloat = 170.0
        static let pageControlBottomPadding: CGFloat = 50.0
        static let actionButtonBottomPadding: CGFloat = 86.0
        static let privacyViewBottomPadding: CGFloat = 34.0
        static let restorePurchaseButtonTitle: String = "Restore Purchase"
        static let closeButtonHeight: CGFloat = 18.0
        static let closeButtonBottomPadding: CGFloat = 25.0
        static let restorePurchaseBottomPadding: CGFloat = 25.0
        static let restorePurchaseButtonHeight: CGFloat = 18.0
        static let restorePurchaseButtonInset: CGFloat = 17.0
        static let closeButtonInset: CGFloat = 21.0
        
    }
}

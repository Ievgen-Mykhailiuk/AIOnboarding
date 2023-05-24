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
    private lazy var actionButton: UIButton = {
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
    
   // MARK: - Lyficycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    // MARK: - Button Action

    @objc private func actionButtonTapped(_ sender: UIButton) {
        sender.animateSelection()
        presenter.onActionButtonTapped()
        HapticFeedbackGenerator.shared.vibrateSelectionChanged()
    }

    // MARK: - Private methods
    
    private func initialSetup() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(backgroundImageView)
        backgroundImageView.frame = view.bounds
        setupCollectionView()
        setupPageControl()
        setupButton()
        setupPolicyView()
        refresh()
    }
    
    private func setupCollectionView() {
        OnboardingCell.registerClass(in: collectionView)
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * Constants.collectionHeightCoefficient),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -UIScreen.main.bounds.height * Constants.collectionBottomPaddingCoefficient)
        ])
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = presenter.getPagesCount()
        pageControl.currentPage = presenter.getCurrentPageIndex()
        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -UIScreen.main.bounds.height * Constants.pageControlBottomPaddingCoefficient)
        ])
    }
    
    private func setupButton() {
        view.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            actionButton.heightAnchor.constraint(equalToConstant: Constants.actionButtonHeight),
            actionButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.actionButtonInset),
            actionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Constants.actionButtonInset),
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -UIScreen.main.bounds.height * Constants.actionButtonBottomPaddingCoefficient)
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
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = index
    }

    private func refresh() {
        actionButton.setTitle(presenter.isLastPage() ? "Trial&Pay" : "Continue", for: .normal)
        pageControl.isHidden = presenter.isFirstPage() || presenter.isLastPage()
        policyView.isHidden = !(presenter.isFirstPage() || presenter.isLastPage())
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
        static let actionButtonHeight: CGFloat = 56
        static let actionButtonCornerRadius: CGFloat = 28
        static let actionButtonInset: CGFloat = 31
        static let collectionHeightCoefficient: CGFloat = 0.72
        static let collectionBottomPaddingCoefficient: CGFloat = 0.189
        static let pageControlBottomPaddingCoefficient: CGFloat = 0.055
        static let actionButtonBottomPaddingCoefficient: CGFloat = 0.095
        static let privacyViewBottomPadding: CGFloat = 34
    }
}

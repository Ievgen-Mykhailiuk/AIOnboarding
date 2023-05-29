//
//  ViewController.swift
//  AIOnboarding
//
//  Created by Евгений  on 23/05/2023.
//

import UIKit

protocol OnboardingViewProtocol: AnyObject {
    func setupUI()
    func showAlert(title: String, message: String, actions: [UIAlertAction]?)
    func nextPage(at index: Int)
    func loading(isLoading: Bool)
}

final class OnboardingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var presenter: OnboardingPresenterProtocol!
    
    private lazy var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CardsCollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var pageControlView: PageControlView = {
        let pageControl = PageControlView()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var mainActionButton: UIButton = {
        let mainActionButton = UIButton()
        mainActionButton.backgroundColor = .white
        mainActionButton.titleLabel?.font = .SFProMedium(of: .mainActionButtonFontSize)
        mainActionButton.layer.cornerRadius = .mainActionButtonCornerRadius
        mainActionButton.translatesAutoresizingMaskIntoConstraints = false
        mainActionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        mainActionButton.setTitleColor(.black, for: .normal)
        return mainActionButton
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageview = UIImageView(image: Images.background.image)
        return imageview
    }()
    
    private lazy var infoView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var restorePurchaseButton: UIButton = {
        let restorePurchaseButton = UIButton()
        restorePurchaseButton.titleLabel?.font = .SFProTextMedium(of: .restorePurchaseFontSize)
        restorePurchaseButton.setTitleColor(Colors.inactivePageIndicator.color, for: .normal)
        restorePurchaseButton.setTitleColor(Colors.inactivePageIndicator.color.withAlphaComponent(0.5), for: .highlighted)
        restorePurchaseButton.backgroundColor = .clear
        restorePurchaseButton.translatesAutoresizingMaskIntoConstraints = false
        restorePurchaseButton.addTarget(self, action: #selector(restorePurchaseButtonTapped), for: .touchUpInside)
        restorePurchaseButton.setTitle(Strings.restorePurchase, for: .normal)
        return restorePurchaseButton
    }()
    
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.backgroundColor = .clear
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
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
    }
    
    @objc private func restorePurchaseButtonTapped(_ sender: UIButton) {
        presenter.onRestorePurchaseTapped()
    }
    
    @objc private func closeButtonTapped(_ sender: UIButton) {
        presenter.onCloseTapped()
    }
    
    // MARK: - Private methods
    
    private func initialSetup() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(backgroundImageView)
        backgroundImageView.frame = view.bounds
        setupCollectionView()
        setupPageControl()
        setupMainActionButton()
        setupInfoView()
        setupRestorePurchaseButton()
        setupCloseButton()
        refresh()
    }
    
    private func setupCollectionView() {
        OnboardingCollectionViewCell.registerClass(in: collectionView)
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: .collectionViewTopPadding),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.collectionViewBottomPadding)
        ])
    }
    
    private func setupPageControl() {
        pageControlView.numberOfPages = presenter.getPagesCount()
        pageControlView.currentPage = presenter.getCurrentPageIndex()
        view.addSubview(pageControlView)
        
        NSLayoutConstraint.activate([
            pageControlView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControlView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.pageControlViewBottomPadding)
        ])
    }
    
    private func setupMainActionButton() {
        view.addSubview(mainActionButton)
        mainActionButton.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.widthAnchor.constraint(equalToConstant: .loadingViewWidth),
            loadingView.centerYAnchor.constraint(equalTo: mainActionButton.centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: mainActionButton.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mainActionButton.heightAnchor.constraint(equalToConstant: .mainActionButtonHeight),
            mainActionButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: .mainActionButtonInset),
            mainActionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -.mainActionButtonInset),
            mainActionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.mainActionButtonBottomPadding)
        ])
    }
    
    private func setupRestorePurchaseButton() {
        view.addSubview(restorePurchaseButton)
        
        NSLayoutConstraint.activate([
            restorePurchaseButton.heightAnchor.constraint(equalToConstant: .restorePurchaseButtonHeight),
            restorePurchaseButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: .restorePurchaseButtonInset),
            restorePurchaseButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -.restorePurchaseButtonBottomPadding)
        ])
    }
    
    private func setupCloseButton() {
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: .closeButtonHeight),
            closeButton.widthAnchor.constraint(equalToConstant: .closeButtonHeight),
            closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -.closeButtonInset),
            closeButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -.closeButtonBottomPadding)
        ])
    }
    
    private func setupInfoView() {
        let infoViewFont: UIFont = .SFProTextRegular(of: .infoViewFontSize)
       
        // Create the label
        let label = UILabel()
        label.font = infoViewFont
        label.textColor = UIColor.gray
        label.text = Strings.byContinuingYouAcceptOur
        
        // Create the attributed strings for links
        let termsOfUseLink = NSAttributedString(
            string: Strings.termsOfUse,
            attributes: [.link: Link.termsOfUseURL, .font: infoViewFont]
        )
        let privacyPolicyLink = NSAttributedString(
            string: Strings.privacyPolicy,
            attributes: [.link: Link.privacyPolicyURL, .font: infoViewFont]
        )
        let subscriptionTermsLink = NSAttributedString(
            string: Strings.subscriptionTerms,
            attributes: [.link: Link.subscriptiontermsURL, .font: infoViewFont]
        )
        let commaSepatator = NSAttributedString(
            string: .commaSeparator,
            attributes: [.font: infoViewFont, .foregroundColor: Colors.infoText.color]
        )
        let andSepatator = NSAttributedString(
            string: .commaSeparator + Strings.and + .separator,
            attributes: [.font: infoViewFont, .foregroundColor: Colors.infoText.color]
        )
      
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
        [termsOfUseLink, commaSepatator, privacyPolicyLink, andSepatator, subscriptionTermsLink].forEach {
            fullText.append($0)
        }
        textView.attributedText = fullText
        
        // Handle link tapping
        textView.delegate = self
        
        // Final configuring Info view
        [label, textView].forEach {
            infoView.addArrangedSubview($0)
        }
        view.addSubview(infoView)
        
        NSLayoutConstraint.activate([
            infoView.leftAnchor.constraint(equalTo: view.leftAnchor),
            infoView.rightAnchor.constraint(equalTo: view.rightAnchor),
            infoView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.infoViewBottomPadding)
        ])
    }
    
    private func scrollToPage(to index: Int) {
        let indexPath = IndexPath(item: index, section: .zero)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControlView.currentPage = index
    }
    
    private func refresh() {
        mainActionButton.setTitle(presenter.isLastPage() ? Strings.tryFreeSubscribe : Strings.continue, for: .normal)
        pageControlView.isHidden = presenter.isFirstPage() || presenter.isLastPage()
        infoView.isHidden = !(presenter.isFirstPage() || presenter.isLastPage())
        restorePurchaseButton.isHidden = !presenter.isLastPage()
        closeButton.isHidden = !presenter.isLastPage()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getPagesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OnboardingCollectionViewCell = .cell(in: self.collectionView, at: indexPath)
        cell.configure(with: presenter.getPageFor(indexPath.item))
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
}

// MARK: - OnboardingViewProtocol

extension OnboardingViewController: OnboardingViewProtocol {
    
    func loading(isLoading: Bool) {
        mainActionButton.setTitleColor( isLoading ? .clear : .black, for: .normal)
        isLoading ? loadingView.start() : loadingView.stop()
        mainActionButton.isUserInteractionEnabled = !isLoading
    }
    
    func setupUI() {
        initialSetup()
    }
    
    func showAlert(title: String, message: String, actions: [UIAlertAction]?) {
        presentAlert(title: title, message: message, actions: actions)
    }
    
    func nextPage(at index: Int) {
        scrollToPage(to: index)
        refresh()
    }
    
}

// MARK: - UITextViewDelegate

extension OnboardingViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        presenter.onLinkTapped(URL)
        return false
    }
}

private extension CGFloat {
    
    static let pageControlViewBottomPadding = 50.0
    
    static let infoViewBottomPadding = 34.0
    static let infoViewFontSize = 12.0
    
    static let loadingViewWidth = 60.0
    
    static let mainActionButtonHeight = 56.0
    static let mainActionButtonCornerRadius = 28.0
    static let mainActionButtonInset = 31.0
    static let mainActionButtonBottomPadding = 86.0
    static let mainActionButtonFontSize = 17.0
    
    static let collectionViewTopPadding = 100.0
    static let collectionViewBottomPadding = 170.0
    
    static let closeButtonHeight = 18.0
    static let closeButtonBottomPadding = 25.0
    static let closeButtonInset = 21.0
    
    static let restorePurchaseButtonBottomPadding = 25.0
    static let restorePurchaseButtonHeight = 18.0
    static let restorePurchaseButtonInset = 17.0
    static let restorePurchaseFontSize = 14.0
    
}

//
//  ViewController.swift
//  AIOnboarding
//
//  Created by Евгений  on 23/05/2023.
//

import UIKit

protocol OnboardingViewProtocol: AnyObject {
 
}

final class OnboardingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    // MARK: - Properties
    
    var presenter: OnboardingPresenterProtocol!
    var pages: [Int] = [1, 2, 3, 4]
    var currentPageIndex = 0
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CardsCollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .green
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    private lazy var actionButton: UIButton = {
        let actionButton = UIButton()
        actionButton.backgroundColor = .white
        actionButton.layer.cornerRadius = 28
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        actionButton.setTitleColor(.black, for: .normal)
        return actionButton
    }()
    private lazy var backgroundImageView: UIImageView = {
       let imageview = UIImageView(image: Images.background.image)
        return imageview
    }()
    
   // MARK: - Lyficycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - Button Action

    @objc private func actionButtonTapped(_ sender: UIButton) {
        let nextPageIndex = currentPageIndex + 1

        if nextPageIndex < 4 {
            scrollToPage(at: nextPageIndex)
        } else {
            // Handle action when reaching the last page
            // For example, dismiss the onboarding view
            dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - Private methods
    
    private func initialSetup() {
        view.addSubview(backgroundImageView)
        backgroundImageView.frame = view.bounds
        setupCollectionView()
        setupPageControl()
        setupButton()
    }
    
    private func setupCollectionView() {
        OnboardingCell.registerClass(in: collectionView)
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.72),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -UIScreen.main.bounds.height * 0.189)
        ])
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = currentPageIndex
        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.leftAnchor.constraint(equalTo: view.leftAnchor),
            pageControl.rightAnchor.constraint(equalTo: view.rightAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -UIScreen.main.bounds.height * 0.055)
        ])
    }
    
    private func setupButton() {
        view.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            actionButton.heightAnchor.constraint(equalToConstant: 56),
            actionButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 31),
            actionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -31),
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -UIScreen.main.bounds.height * 0.095)
        ])

        updateButtonState()
    }
    
    private func scrollToPage(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = index
        currentPageIndex = index
        updateButtonState()
    }

    private func updateButtonState() {
        if currentPageIndex < pages.count - 1 {
            actionButton.setTitle("Continue", for: .normal)
        } else {
            actionButton.setTitle("Trial&Pay", for: .normal)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
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

extension OnboardingViewController: OnboardingViewProtocol {}

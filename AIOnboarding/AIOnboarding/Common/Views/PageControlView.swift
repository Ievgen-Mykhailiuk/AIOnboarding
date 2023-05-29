//
//  PageControl.swift
//  AIOnboarding
//
//  Created by Евгений  on 24/05/2023.
//

import UIKit

class PageControlView: UIView {
    
    // MARK: - Properties

    private let indicatorSize: CGSize = CGSize(width: .inactiveIndicatorWidth, height: .indicatorHeight)
    private let activeIndicatorWidth: CGFloat = .activeIndicatorWidth
    private let indicatorSpacing: CGFloat = .spacing
    private var indicators: [UIView] = []
    private var indicatorWidthConstraints: [NSLayoutConstraint] = []
    
    var numberOfPages: Int = .zero {
        didSet {
            updateIndicators()
        }
    }
    var currentPage: Int = .zero {
        didSet {
            updateIndicators()
        }
    }
    var indicatorColor: UIColor = Colors.inactivePageIndicator.color {
        didSet {
            updateIndicators()
        }
    }
    var currentIndicatorColor: UIColor = Colors.activePageIndicator.color {
        didSet {
            updateIndicators()
        }
    }
    
    // MARK: - Lyficycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    // MARK: - Override methods
    
    override var intrinsicContentSize: CGSize {
        let width = CGFloat(numberOfPages) * activeIndicatorWidth + CGFloat(max(.zero, numberOfPages - 1)) * indicatorSpacing
        let height = indicatorSize.height
        return CGSize(width: width, height: height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateIndicators()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
                bounds.contains(touch.location(in: self))
        else { return }
        
        let touchX = touch.location(in: self).x
        let indicatorWidth = activeIndicatorWidth + indicatorSpacing
        let newIndex = Int(touchX / indicatorWidth)
        
        if newIndex != currentPage {
            currentPage = newIndex
            animateSelection(to: newIndex)
        }
        
    }
    
    // MARK: - Private methods
    
    private func commonInit() {
        backgroundColor = .clear
    }
    
    private func updateIndicators() {
       
        // Clear indicators
        
        indicators.forEach {
            $0.removeFromSuperview()
        }
        indicators.removeAll()
        indicatorWidthConstraints.removeAll()
        
        // Create a new indicator view
        
        for index in 0 ..< numberOfPages {
            
            let indicatorView = UIView()
            indicatorView.translatesAutoresizingMaskIntoConstraints = false
            indicatorView.backgroundColor = index == currentPage ? currentIndicatorColor : indicatorColor
            indicatorView.layer.cornerRadius = indicatorSize.height / 2
            
            addSubview(indicatorView)
            
            // Create constraints for indicator
            
            let widthConstraint: NSLayoutConstraint
            if index == currentPage {
                widthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: activeIndicatorWidth)
            } else {
                widthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: indicatorSize.width)
            }
            widthConstraint.isActive = true
            
            indicatorWidthConstraints.append(widthConstraint)
            
            NSLayoutConstraint.activate([
                indicatorView.heightAnchor.constraint(equalToConstant: indicatorSize.height),
                indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
            
            if index == .zero {
                NSLayoutConstraint.activate([
                    indicatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
                ])
            } else {
                let previousIndicator = indicators[index - 1]
                NSLayoutConstraint.activate([
                    indicatorView.leadingAnchor.constraint(equalTo: previousIndicator.trailingAnchor, constant: indicatorSpacing),
                ])
            }
            
            // Add the indicator view to the array
            
            indicators.append(indicatorView)
        }
            
        // Position the last indicator at the trailing edge of the view
        
        if let lastIndicator = indicators.last {
            NSLayoutConstraint.activate([
                lastIndicator.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
        }
        
        // Invalidate the intrinsic content size to trigger a layout update
                
        invalidateIntrinsicContentSize()
    }
    
    private func animateSelection(to index: Int) {
        guard index >= .zero && index < indicators.count else { return }
        
        let newIndicator = indicators[index]
        let newWidthConstraint = indicatorWidthConstraints[index]
        let newWidth = index == currentPage ? activeIndicatorWidth : indicatorSize.width
        
        UIView.animate(withDuration: 0.5, delay: .zero, options: [.curveLinear]) {
            newIndicator.backgroundColor = self.currentIndicatorColor
            newWidthConstraint.constant = newWidth
            self.layoutIfNeeded()
        }
    }
    
}

private extension CGFloat {
    
    static let indicatorHeight = 4.0
    static let activeIndicatorWidth = 25.0
    static let inactiveIndicatorWidth = 14.0
    static let spacing = 8.0
    
}

//
//  LoadingView.swift
//  AIOnboarding
//
//  Created by Евгений  on 25/05/2023.
//

import UIKit

final class LoadingView: UIView {
    
    // MARK: - Properties
    
    private var currentViewIndex: Int = .zero
    private var timer: Timer?
    var dotsCount: Int = 5 {
        didSet {
            setup()
            updateDotsSizes()
        }
    }
    
    // MARK: - init
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    deinit {
        stop()
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        isHidden = true
        subviews.forEach({ $0.removeFromSuperview() })
        for _ in 0 ..< dotsCount {
            let view = UIView()
            view.backgroundColor = .black
            addSubview(view)
        }
    }
    
    private func updateDotsSizes() {
        let width = frame.size.width - (CGFloat(dotsCount - 1) * .spacing)
        subviews.enumerated()
            .forEach({ index, view in
                view.layer.cornerRadius = .dotSize / 2
                view.frame = CGRect(x: ((.spacing + .dotSize) * CGFloat(index)),
                                    y: (frame.height / 2) - (.dotSize / 2),
                                    width: .dotSize,
                                    height: .dotSize)
            })
    }
    
    // MARK: - Override Methods
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
        stop()
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateDotsSizes()
    }
    
    // MARK: Animation
    
    @objc
    private func startAnimation() {
        currentViewIndex += 1
        if currentViewIndex >= subviews.count {
            currentViewIndex = 0
        }
        
        let view = subviews[currentViewIndex]
        let defualtColor = view.backgroundColor
        UIView.animate(withDuration: TimeInterval(.animationDuration / 2), delay: .zero) {
            view.transform = CGAffineTransform(scaleX: .increasedScale, y: .increasedScale)
        } completion: { _ in
            UIView.animate(withDuration: TimeInterval(.animationDuration / 2), animations: {
                view.transform = CGAffineTransform(scaleX: .identityScale, y: .identityScale)
                view.backgroundColor = defualtColor
            })
        }
    }
    
    // MARK: (Stop/Start)
    
    func start() {
        isHidden = false
        timer = Timer.scheduledTimer(timeInterval: Double(.animationDuration - .aheadTime),
                                     target: self,
                                     selector: #selector(startAnimation),
                                     userInfo: nil,
                                     repeats: true)
        startAnimation()
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        isHidden = true
    }
    
}

private extension CGFloat {
    static let dotSize = 10.0
    static let spacing = 5.0
    static let animationDuration  = 0.4
    static let aheadTime = 0.2
    static let identityScale = 1.0
    static let increasedScale = 2.0
}


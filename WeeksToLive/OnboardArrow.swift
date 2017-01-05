//
//  OnboardArrow.swift
//  WeeksToLive
//
//  Created by Joey on 1/4/17.
//  Copyright © 2017 NelsonJE. All rights reserved.
//

import UIKit

protocol OnboardArrowDelegate {
    func didTapLeftArrow()
    func didTapRightArrow()
}

class OnboardArrow: UIView {
    
    @IBOutlet var leftArrowView: UIView!
    @IBOutlet var rightArrowView: UIView!
    @IBOutlet weak var rightArrowButton: UIButton!
    @IBOutlet weak var leftArrowButton: UIButton!
    
    var delegate: OnboardArrowDelegate?
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("OnboardRightArrow", owner: self, options: nil)
        guard let rightArrow = rightArrowView else { return }
        
        Bundle.main.loadNibNamed("OnboardLeftArrow", owner: self, options: nil)
        guard let leftArrow = leftArrowView else { return }
        
        let container = UIView()
        
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        container.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(rightArrow)
        rightArrow.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        rightArrow.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        rightArrow.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        rightArrow.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
        leftArrow.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(leftArrow)
        leftArrow.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        leftArrow.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        leftArrow.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        leftArrow.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        leftArrow.isHidden = true
    }
    
    func enable(enabled: Bool) {
        guard let _ = leftArrowButton else { return }
        guard let _ = rightArrowButton else { return }
        
        self.leftArrowButton.isEnabled = enabled
        self.rightArrowButton.isEnabled = enabled
        
        if enabled {
            UIView.animate(withDuration: 0.15, animations: {
                self.rightArrowButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: { void in
                UIView.animate(withDuration: 0.25, animations: {
                    self.rightArrowButton.transform = CGAffineTransform.identity
                }, completion: nil)
            })
        }
    }
    
    @IBAction func rightArrowAction(_ sender: Any) {
        self.delegate?.didTapRightArrow()
        flipRightToLeft()
    }
    
    @IBAction func leftArrowAction(_ sender: Any) {
        self.delegate?.didTapLeftArrow()
        flipLeftToRight()
    }
    
    private func flipRightToLeft() {
        UIView.transition(from: rightArrowView, to: leftArrowView, duration: 0.5, options: [.transitionCrossDissolve, .showHideTransitionViews], completion: nil)
    }
    
    private func flipLeftToRight() {
        UIView.transition(from: leftArrowView, to: rightArrowView, duration: 0.5, options: [.transitionCrossDissolve, .showHideTransitionViews], completion: nil)
    }
}

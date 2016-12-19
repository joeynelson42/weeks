//
//  WeekCollectionViewCell.swift
//  WeeksToLive
//
//  Created by Joey on 12/16/16.
//  Copyright © 2016 NelsonJE. All rights reserved.
//

enum WeekState {
    case past
    case present
    case future
}

import UIKit

class WeekCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    var state = WeekState.future
    var progress: CGFloat = 0
    
    let progressView = UIView()
    let noteIndicator = UIView()
    
    //MARK: Inits
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        self.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.updateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        configureSubviews()
        applyConstraints()
    }
    
    override func prepareForReuse() {
        
    }
    
    private func configureSubviews(){
        backgroundColor = .clear
        layer.borderWidth = 3.0
        
        noteIndicator.layer.cornerRadius = 3.0
        noteIndicator.backgroundColor = .white
        
        addSubview(progressView)
        addSubview(noteIndicator)
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        noteIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func applyConstraints() {
        let progressWidth = self.frame.width * progress
        
        progressView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        progressView.widthAnchor.constraint(equalToConstant: progressWidth)
        
        noteIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        noteIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        noteIndicator.heightAnchor.constraint(equalToConstant: 6).isActive = true
        noteIndicator.widthAnchor.constraint(equalToConstant: 6).isActive = true
    }
}

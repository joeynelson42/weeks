//
//  OnboardingView.swift
//  WeeksToLive
//
//  Created by Joey on 12/21/16.
//  Copyright © 2016 NelsonJE. All rights reserved.
//

import UIKit

class OnboardingView: UIView {
    
    // MARK: Properties
    let scrollView = UIScrollView()
    let tableView = UITableView()

    let colors = [UIColor.moody(), UIColor.robinEgg(), UIColor.midnight()]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        configureSubviews()
        applyConstraints()
    }
    
    private func configureSubviews() {
        backgroundColor = .moody()
        
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delaysContentTouches = false
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
    }
    
    private func applyConstraints() {
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: Constants.screenWidth).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func startBackgroundAnimation() {
        UIView.animate(withDuration: 4, delay: 3, options: [.allowUserInteraction], animations: {
            
            let rand = Int(arc4random_uniform(3))
            self.backgroundColor = self.colors[rand]
            
        }, completion: {void in
            self.startBackgroundAnimation()
        })
    }
}

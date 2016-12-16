//
//  baseView.swift
//  GuildHall
//
//  Created by Joey on 11/26/16.
//  Copyright © 2016 NelsonJE. All rights reserved.
//

import UIKit

class baseView: UIView {
    
    // MARK: Properties
    
    
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
    
    private func configureSubviews(){
        
    }
    
    private func applyConstraints() {
        
    }
}

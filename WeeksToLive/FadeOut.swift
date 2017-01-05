//
//  FadeOut.swift
//  WeeksToLive
//
//  Created by Joey on 1/5/17.
//  Copyright © 2017 NelsonJE. All rights reserved.
//

import UIKit

protocol FadeOut {
    func fadeOut(completion: @escaping () -> Void)
}

extension FadeOut where Self: UIViewController {
    func fadeOut(completion: @escaping () -> Void) {
        let fadeView = UIView()
        fadeView.alpha = 0
        fadeView.backgroundColor = .white
        self.view.addSubview(fadeView)
        fadeView.fillSuperview()
        
        UIView.animate(withDuration: 0.5, animations: {
            fadeView.alpha = 1.0
        }, completion: {void in
            completion()
        })
    }
}

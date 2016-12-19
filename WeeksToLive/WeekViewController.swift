//
//  WeekViewController.swift
//  WeeksToLive
//
//  Created by Joey on 12/16/16.
//  Copyright © 2016 NelsonJE. All rights reserved.
//

import UIKit

class WeekViewController: UIViewController, ZoomTransitionProtocol {
    
    @IBOutlet weak var noteView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    func handleTap() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func viewForTransition() -> UIView {
        return noteView
    }
}

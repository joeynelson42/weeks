//
//  WeekViewController.swift
//  WeeksToLive
//
//  Created by Joey on 12/16/16.
//  Copyright © 2016 NelsonJE. All rights reserved.
//

import UIKit

class WeekViewController: UIViewController, ZoomTransitionProtocol {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noteView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteView.layer.cornerRadius = 4
        noteView.layer.borderWidth = 3.0
        noteView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    func handleTap() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func viewForTransition() -> UIView {
        return collectionView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.bringSubview(toFront: collectionView)
    }
}

extension WeekViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCell", for: indexPath)
        cell.backgroundColor = .green
        return cell
    }
}

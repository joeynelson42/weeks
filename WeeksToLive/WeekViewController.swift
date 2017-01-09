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
        collectionView.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.alpha = 1.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        collectionView.alpha = 0.0
    }
    
    func handleTap() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func viewForTransition() -> UIView {
        return noteView
    }
}

extension WeekViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCell", for: indexPath) as! DetailCollectionCell
        
        cell.containerView.layer.borderColor = UIColor.moody().cgColor
        cell.containerView.layer.borderWidth = 3.0
        cell.containerView.backgroundColor = .mySin()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleTap()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.screenWidth, height: noteView.frame.size.height)
    }
}

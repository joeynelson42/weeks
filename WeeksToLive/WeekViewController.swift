//
//  WeekViewController.swift
//  WeeksToLive
//
//  Created by Joey on 12/16/16.
//  Copyright © 2016 NelsonJE. All rights reserved.
//

import UIKit

class WeekViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedIndex:IndexPath!
    
    var totalWeeks = 4500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        collectionView.reloadData()
        collectionView.scrollToItem(at: selectedIndex, at: .left, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension WeekViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalWeeks
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCell", for: indexPath) as! WeekCollectionViewCell
        
        cell.layer.borderWidth = 0.0
        
        cell.containerView.layer.borderColor = UIColor.mySin().cgColor
        cell.containerView.layer.borderWidth = 3.0
        cell.noteIndicator.alpha = 0.0
        
        if indexPath.row == 500 {
            cell.containerView.backgroundColor = .white
        } else {
            cell.containerView.backgroundColor = .jacarta()
        }
        
        cell.containerView.heroID = "\(indexPath.row)"
        cell.containerView.heroModifiers = [.zPositionIfMatched(3)]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.screenWidth, height: collectionView.frame.size.height - 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
}

//
//  WeeksViewController.swift
//  WeeksToLive
//
//  Created by Joey on 12/16/16.
//  Copyright © 2016 NelsonJE. All rights reserved.
//

import UIKit

class WeeksViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var toggleTimeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        collection.showsVerticalScrollIndicator = false
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let offsetValue = timeSlider.value * (Float(collection.contentSize.height - collection.frame.height))
        collection.contentOffset.y = CGFloat(offsetValue)
    }
}


extension WeeksViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCell", for: indexPath) as! WeekCollectionViewCell
        
        cell.backgroundColor = UIColor.moody()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        timeSlider.value = Float(scrollView.contentOffset.y) / Float(scrollView.contentSize.height)
    }
    
    
}

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
    
    var totalWeeks = 4500
    
    var cellBaseSize: CGFloat = 30
    var cellSize: CGFloat = 30 {
        didSet {
            if cellSize < cellMinSize {
                cellSize = cellMinSize
            } else if cellSize > cellMaxSize {
                cellSize = cellMaxSize
                collection.isPagingEnabled = true
            }
        }
    }
    
    let cellMaxSize: CGFloat = Constants.screenWidth - 20
    var cellMinSize: CGFloat = 13.5
    
    var zoomTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        toggleTimeButton.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let currentCell = sender as? WeekCollectionViewCell,
            let vc = segue.destination as? WeekViewController,
            let currentCellIndex = collection.indexPath(for: currentCell){
            vc.selectedIndex = currentCellIndex
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        return totalWeeks
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCell", for: indexPath) as! WeekCollectionViewCell
        
        cell.layer.borderColor = UIColor.mySin().cgColor
        cell.layer.borderWidth = 3.0
        cell.noteIndicator.alpha = 0.0
        
        if indexPath.row == 500 {
            cell.backgroundColor = .white
        } else {
            cell.backgroundColor = .jacarta()
        }
        
        cell.heroID = "\(indexPath.row)"
        cell.heroModifiers = [.zPositionIfMatched(3)]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        timeSlider.value = Float(scrollView.contentOffset.y) / Float(scrollView.contentSize.height - collection.frame.height)
    }
}

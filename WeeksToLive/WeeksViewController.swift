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
    
    var totalWeeks = 4000
    var cellSize: CGFloat = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        collection.scrollToItem(at: IndexPath(item: 500, section: 0), at: .centeredVertically, animated: false)
        toggleTimeButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateSlider()
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
            cell.layer.borderColor = UIColor.white.cgColor
        } else if indexPath.row < 500{
            cell.backgroundColor = .mySin()
        }  else {
            cell.backgroundColor = .jacarta()
        }
        
        cell.heroID = "\(indexPath.row)"
        cell.heroModifiers = [.zPositionIfMatched(3)]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: collectionView.cellForItem(at: indexPath))
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        let selectedCell = collectionView.cellForItem(at: indexPath)
        
        for cell in collectionView.visibleCells {
            if cell == selectedCell {
                cell.heroModifiers = [.zPositionIfMatched(3), ]
            } else {
                cell.heroModifiers = []
            }
        }
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateSlider()
    }
    
    fileprivate func updateSlider() {
        timeSlider.value = Float(collection.contentOffset.y) / Float(collection.contentSize.height - collection.frame.height)
    }
}

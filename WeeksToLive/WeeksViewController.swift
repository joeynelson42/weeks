//
//  WeeksViewController.swift
//  WeeksToLive
//
//  Created by Joey on 12/16/16.
//  Copyright © 2016 NelsonJE. All rights reserved.
//

import UIKit

class WeeksViewController: UIViewController, ZoomTransitionProtocol {
    
    //MARK: Properties
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var toggleTimeButton: UIButton!
    
    var selectedIndexPath: IndexPath?
    var animationController : ZoomTransition?
    
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
        
        if let navigationController = self.navigationController {
            animationController = ZoomTransition(navigationController: navigationController)
        }
        self.navigationController?.delegate = animationController
        
        toggleTimeButton.isHidden = true
    }
    
    func configureView() {
        collection.showsVerticalScrollIndicator = false
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let offsetValue = timeSlider.value * (Float(collection.contentSize.height - collection.frame.height))
        collection.contentOffset.y = CGFloat(offsetValue)
    }
    
    func viewForTransition() -> UIView {
        guard let index = selectedIndexPath else { return view }
        guard let cell = collection.cellForItem(at: index) else { return view }
        return cell
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
        
        cell.layer.borderColor = UIColor.moody().cgColor
        cell.noteIndicator.alpha = 0.0
        
        if indexPath.row == 500 {
            cell.backgroundColor = .white
            selectedIndexPath = indexPath
        } else {
            cell.backgroundColor = .mySin()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let noteVC = UIStoryboard(name: "Week", bundle: nil).instantiateViewController(withIdentifier: "weekViewController") as! WeekViewController
        self.navigationController?.pushViewController(noteVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if cellSize == cellMaxSize {
            return CGSize(width: cellSize, height: collection.frame.height - cellSize * 0.66)
        } else {
            return CGSize(width: cellSize, height: cellSize)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        timeSlider.value = Float(scrollView.contentOffset.y) / Float(scrollView.contentSize.height - collection.frame.height)
    }
}

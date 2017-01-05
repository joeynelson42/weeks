//
//  WeeksViewController.swift
//  WeeksToLive
//
//  Created by Joey on 12/16/16.
//  Copyright © 2016 NelsonJE. All rights reserved.
//

import UIKit

enum LayoutState {
    case grid
    case detail
}

class WeeksViewController: UIViewController, ZoomTransitionProtocol {
    
    //MARK: Properties
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var toggleTimeButton: UIButton!
    
    var selectedIndexPath: IndexPath?
    var animationController : ZoomTransition?
    
    var layout = LayoutState.grid
    var gridLayout: UICollectionViewFlowLayout!
    var detailLayout: UICollectionViewFlowLayout!
    
    var cellSize: CGFloat = 50
    
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

        detailLayout = UICollectionViewFlowLayout()
        detailLayout.scrollDirection = .horizontal
        detailLayout.itemSize = CGSize(width: Constants.screenWidth - 100, height: Constants.screenHeight - 300)
        detailLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        detailLayout.minimumLineSpacing = 0
        
        
        gridLayout = UICollectionViewFlowLayout()
        gridLayout.scrollDirection = .vertical
        gridLayout.itemSize = CGSize(width: cellSize, height: cellSize)
        gridLayout.minimumLineSpacing = 10
        gridLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
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
        return 4500
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
        
        if layout == .grid {
            collectionView.setCollectionViewLayout(detailLayout, animated: true)
            layout = .detail
            collectionView.isPagingEnabled = true
        } else {
            collectionView.setCollectionViewLayout(gridLayout, animated: true)
            layout = .grid
            collectionView.isPagingEnabled = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if layout == .grid {
            timeSlider.value = Float(scrollView.contentOffset.y) / Float(scrollView.contentSize.height - collection.frame.height)
        } else {
            timeSlider.value = Float(scrollView.contentOffset.x) / Float(scrollView.contentSize.width - collection.frame.width)
        }
        
    }
    
    func zoomIntoView() {
        cellSize *= 1.01
        collection.reloadData()
        collection.scrollToItem(at: selectedIndexPath!, at: .top, animated: false)
    }
    
}

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
    
    @IBOutlet weak var dateView: UIView!
    
    var selectedIndex:IndexPath!
    var panGR = UIPanGestureRecognizer()
    
    var totalWeeks = 4000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        collectionView.reloadData()
        collectionView.scrollToItem(at: selectedIndex, at: .left, animated: false)
        
        panGR.addTarget(self, action: #selector(pan))
        panGR.delegate = self
        collectionView?.addGestureRecognizer(panGR)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func pan(){
        let translation = panGR.translation(in: nil)
        let progress = translation.y / 2 / collectionView!.bounds.height
        switch panGR.state {
        case .began:
            if let nav = navigationController, nav.viewControllers.first != self{
                let _ = nav.popViewController(animated: true)
            } else {
                dismiss(animated: true, completion: nil)
            }
        case .changed:
            Hero.shared.update(progress: Double(progress))
            if let cell = collectionView?.visibleCells[0]  as? WeekCollectionViewCell{
                let currentPos = translation + view.center
                Hero.shared.temporarilySet(view: cell.containerView, modifiers: [.position(currentPos)])
            }
        default:
            if progress + panGR.velocity(in: nil).y / collectionView!.bounds.height > 0.15{
                Hero.shared.end()
            } else {
                Hero.shared.cancel()
            }
        }
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        guard let currentIndexPath = collectionView.indexPathsForVisibleItems.first else { return }
        let newIndexPath = IndexPath(item: currentIndexPath.row + 1, section: 0)
        collectionView.scrollToItem(at: newIndexPath, at: .left, animated: true)
    }
    
    @IBAction func prevAction(_ sender: UIButton) {
        guard let currentIndexPath = collectionView.indexPathsForVisibleItems.first else { return }
        let newIndexPath = IndexPath(item: currentIndexPath.row - 1, section: 0)
        collectionView.scrollToItem(at: newIndexPath, at: .left, animated: true)
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
            cell.containerView.layer.borderColor = UIColor.white.cgColor
        } else if indexPath.row < 500{
            cell.containerView.backgroundColor = .mySin()
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("x offset: \(scrollView.contentOffset.x)")
        print("\(scrollView.contentOffset.x + (Constants.screenWidth / 2) )")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layer = dateView.layer
        var rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -1000
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, CGFloat(M_PI) / 0.3, 0.0, 1.0, 0.0)
        layer.transform = rotationAndPerspectiveTransform
        
        UIView.animate(withDuration: 0.5, animations: {
            layer.transform = CATransform3DIdentity
        })
    }
}

extension WeekViewController:UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let v = panGR.velocity(in: nil)
        return v.y > abs(v.x) && v.y > 0
    }
}

extension WeekViewController:HeroViewControllerDelegate{
    func wantInteractiveHeroTransition() -> Bool {
        if !Hero.shared.presenting && panGR.state == .began{
            return true
        }
        return false
    }
}

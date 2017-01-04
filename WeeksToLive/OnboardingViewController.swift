//
//  OnboardingViewController.swift
//  WeeksToLive
//
//  Created by Joey on 12/21/16.
//  Copyright © 2016 NelsonJE. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: Properties
    let onboardView = OnboardingView()
    var countries = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager().getCountries { (array) in
            DispatchQueue.main.async {
                self.countries = array
                self.onboardView.tableView.reloadData()
                self.updateCellAlpha()
            }
        }
        
        view = onboardView
        onboardView.scrollView.delegate = self
        onboardView.tableView.delegate = self
        onboardView.tableView.dataSource = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        onboardView.startBackgroundAnimation()
        updateCellAlpha()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCellAlpha()
    }
    
    func updateCellAlpha() {
        let cellCount = onboardView.tableView.visibleCells.count
        let alphaInterval:CGFloat = 1.0 / CGFloat(cellCount / 2)
        
        for (index,cell) in (onboardView.tableView.visibleCells as [UITableViewCell]).enumerated() {
            if index < cellCount / 2 {
                cell.alpha = CGFloat(index) * alphaInterval
            } else {
                cell.alpha = CGFloat(cellCount - index) * (alphaInterval)
            }
        }
    }
}

extension OnboardingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = countries[indexPath.row].uppercased()
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.alpha = 0.25
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.centuryGothic(fontSize: 15)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        UIView.animate(withDuration: 0.25, animations: {
            cell.alpha = 1
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let index = tableView.indexPathForSelectedRow else { return indexPath }
        guard let selectedCell = tableView.cellForRow(at: index) else { return indexPath }
        selectedCell.textLabel?.font = UIFont.centuryGothic(fontSize: 15)
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
//        cell?.textLabel?.textColor = UIColor.midnight()
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        cell.textLabel?.font = UIFont.centuryGothic(fontSize: 30)
        
        onboardView.scrollView.setContentOffset(CGPoint(x:Constants.screenWidth, y:0), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.screenHeight / 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let clearHeader = UIView()
        clearHeader.alpha = 0
        return clearHeader
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constants.screenHeight / 2
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let clearFooter = UIView()
        clearFooter.alpha = 0
        return clearFooter
    }
}

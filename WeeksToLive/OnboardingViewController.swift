//
//  OnboardingViewController.swift
//  WeeksToLive
//
//  Created by Joey on 12/21/16.
//  Copyright © 2016 NelsonJE. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    //MARK: Properties
    let onboardView = OnboardingView()
    var countries = [String]()
    
    var formComplete = false {
        didSet {
            onboardView.secondArrow.enable(enabled: formComplete)
            if formComplete {
                updateLifeStats()
            } else {
                onboardView.weeksLived.text = "weeks"
                onboardView.weeksLeft.text = "weeks"
            }
        }
    }
    
    // User info
    var country = ""
    var day = ""
    var month = ""
    var year = ""
    var gender = ""
    var dob: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager().getCountries { (array) in
            DispatchQueue.main.async {
                self.countries = array.sorted()
                self.onboardView.tableView.reloadData()
                self.updateCellAlpha()
            }
        }
        
        view = onboardView
        onboardView.scrollView.delegate = self
        onboardView.dayField.delegate = self
        onboardView.monthField.delegate = self
        onboardView.yearField.delegate = self
        onboardView.tableView.delegate = self
        onboardView.tableView.dataSource = self
        
        addTargets()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        onboardView.startBackgroundAnimation()
        updateCellAlpha()
    }
    
    func addTargets() {
        onboardView.maleButton.addTarget(self, action: #selector(maleButtonAction(_:)), for: .touchUpInside)
        onboardView.femaleButton.addTarget(self, action: #selector(femaleButtonAction(_:)), for: .touchUpInside)
        onboardView.startButton.addTarget(self, action: #selector(startAction), for: .touchUpInside)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCellAlpha()
        onboardView.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case onboardView.dayField:
            day = textField.text!
        case onboardView.monthField:
            month = textField.text!
        case onboardView.yearField:
            year = textField.text!
        default:
            return
        }
        
        checkFormValidity()
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
    
    func maleButtonAction(_ sender: UIButton) {
        onboardView.endEditing(true)
        onboardView.maleButton.isSelected = true
        onboardView.femaleButton.isSelected = false
        gender = "male"
        checkFormValidity()
    }
    
    func femaleButtonAction(_ sender: UIButton) {
        onboardView.endEditing(true)
        onboardView.maleButton.isSelected = false
        onboardView.femaleButton.isSelected = true
        gender = "female"
        checkFormValidity()
    }
    
    func checkFormValidity(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        guard let date = formatter.date(from: "\(year)-\(month)-\(day)") else {
            formComplete = false
            return
        }
        
        dob = date
        
        if year.characters.count < 4 || gender == "" || date > Date() {
            formComplete = false
            return
        }
        
        formComplete = true
    }
    
    func updateLifeStats() {
        onboardView.livedActivityIndicator.startAnimating()
        onboardView.leftActivityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkManager().getLifeExpectancy(gender: gender,
                                           country: country,
                                           dob: "\(year)-\(month)-\(day)",
            completion: { lifeExpectancy in
                DispatchQueue.main.async {
                    let lived = DateManager().totalWeeksSince(date: self.dob)
                    let total = Int(lifeExpectancy * 52)
                    
                    self.onboardView.weeksLived.text = "\(lived) weeks"
                    self.onboardView.weeksLeft.text = "\(total - lived) weeks"
                    
                    self.onboardView.livedActivityIndicator.stopAnimating()
                    self.onboardView.leftActivityIndicator.stopAnimating()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
        })
    }
    
    func startAction() {
        
        UIView.animate(withDuration: 0.4, animations: {
            self.onboardView.fadeView.alpha = 1.0
        }, completion: { void in
            let main = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeeksNavVC") as! UINavigationController
            main.setNavigationBarHidden(true, animated: false)
            
            let window = UIApplication.shared.delegate!.window!
            window!.rootViewController = main
            window!.makeKeyAndVisible()
        })
    }
    
    private func showIncompleteAlert(message: String) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Almost!", message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default)
        actionSheetController.addAction(okAction)
        self.present(actionSheetController, animated: true, completion: nil)
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
        
        UIView.animate(withDuration: 0.25, animations: { cell.alpha = 1 })
        
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
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        cell.textLabel?.font = UIFont.centuryGothic(fontSize: 30)
        country = countries[indexPath.row]
        onboardView.firstArrow.enable(enabled: true)
        checkFormValidity()
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

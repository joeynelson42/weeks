//
//  OnboardingView.swift
//  WeeksToLive
//
//  Created by Joey on 12/21/16.
//  Copyright © 2016 NelsonJE. All rights reserved.
//

import UIKit

class OnboardingView: UIView {
    
    // MARK: Properties
    let scrollView = UIScrollView()
    let formContainer = UIView()
    let tableView = UITableView()
    let maleButton = OutlineButton()
    let femaleButton = OutlineButton()
    
    let ageLabel = UILabel()
    let dayField = UITextField()
    let monthField = UITextField()
    let yearField = UITextField()
    var dobFields = [UITextField]()
    
    let arrow = OnboardArrow()
    let checkmark = UIButton()
    
    let colors = [UIColor.moody(), UIColor.robinEgg(), UIColor.midnight()]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        configureSubviews()
        applyConstraints()
    }
    
    private func configureSubviews() {
        backgroundColor = .moody()
        
        scrollView.contentSize = CGSize(width: Constants.screenWidth * 2, height: Constants.screenHeight)
        scrollView.isPagingEnabled = true
        scrollView.delaysContentTouches = false
        scrollView.isScrollEnabled = false
        
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delaysContentTouches = false
        
        formContainer.backgroundColor = .clear
        
        
        let keyboardAccessory = Bundle.main.loadNibNamed("OnboardKeyboardAccessory", owner: nil, options: nil)?[0] as! OnboardKeyboardAccessory
        keyboardAccessory.doneButton.addTarget(self, action: #selector(endEditing), for: .touchUpInside)
        
        dobFields = [dayField, monthField, yearField]
        for field in dobFields {
            field.font = UIFont.centuryGothic(fontSize: 40)
            field.textColor = .white
            field.inputAccessoryView = keyboardAccessory
            field.keyboardType = .numberPad
            field.textAlignment = .right
        }
        
        dayField.attributedPlaceholder =
            NSAttributedString(string: "DD", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        monthField.attributedPlaceholder =
            NSAttributedString(string: "MM", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        yearField.attributedPlaceholder =
            NSAttributedString(string: "YYYY", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        
        maleButton.setTitle(" MALE ", for: .normal)
        maleButton.setTitleColor(.lightGray, for: .normal)
        maleButton.setTitleColor(.gray, for: .highlighted)
        maleButton.setTitleColor(.white, for: .selected)
        maleButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 40)
        maleButton.outlineWidth = 1.5
        maleButton.contentHorizontalAlignment = .center
        
        femaleButton.setTitle(" FEMALE ", for: .normal)
        femaleButton.setTitleColor(.lightGray, for: .normal)
        femaleButton.setTitleColor(.gray, for: .highlighted)
        femaleButton.setTitleColor(.white, for: .selected)
        femaleButton.titleLabel?.font = UIFont.centuryGothic(fontSize: 40)
        femaleButton.outlineWidth = 1.5
        femaleButton.contentHorizontalAlignment = .center
        
        arrow.delegate = self
        arrow.enable(enabled: false)
        
        checkmark.setImage(#imageLiteral(resourceName: "checkmarkIcon"), for: .normal)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(tableView)
        
        formContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(formContainer)
        
        maleButton.translatesAutoresizingMaskIntoConstraints = false
        formContainer.addSubview(maleButton)
        
        femaleButton.translatesAutoresizingMaskIntoConstraints = false
        formContainer.addSubview(femaleButton)
        
        arrow.translatesAutoresizingMaskIntoConstraints = false
        addSubview(arrow)
        
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        formContainer.addSubview(checkmark)
        
        for field in dobFields {
            field.translatesAutoresizingMaskIntoConstraints = false
            formContainer.addSubview(field)
        }
    }
    
    private func applyConstraints() {
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalToConstant: Constants.screenWidth).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: Constants.screenHeight).isActive = true
        
        arrow.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25).isActive = true
        arrow.rightAnchor.constraint(equalTo: rightAnchor, constant: -25).isActive = true
        arrow.widthAnchor.constraint(equalToConstant: 35).isActive = true
        arrow.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        tableView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: Constants.screenWidth).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: Constants.screenHeight).isActive = true
        
        formContainer.leftAnchor.constraint(equalTo: tableView.rightAnchor).isActive = true
        formContainer.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        formContainer.widthAnchor.constraint(equalToConstant: Constants.screenWidth).isActive = true
        formContainer.heightAnchor.constraint(equalToConstant: Constants.screenHeight).isActive = true
        
        maleButton.rightAnchor.constraint(equalTo: formContainer.rightAnchor, constant: -20).isActive = true
        maleButton.topAnchor.constraint(equalTo: femaleButton.bottomAnchor, constant: 20).isActive = true
        
        femaleButton.rightAnchor.constraint(equalTo: formContainer.rightAnchor, constant: -20).isActive = true
        femaleButton.centerYAnchor.constraint(equalTo: formContainer.centerYAnchor, constant: -100).isActive = true
        
        yearField.rightAnchor.constraint(equalTo: formContainer.rightAnchor, constant: -30).isActive = true
        yearField.bottomAnchor.constraint(equalTo: femaleButton.topAnchor, constant: -20).isActive = true
        
        monthField.rightAnchor.constraint(equalTo: yearField.leftAnchor).isActive = true
        monthField.centerYAnchor.constraint(equalTo: yearField.centerYAnchor).isActive = true
        monthField.widthAnchor.constraint(equalToConstant: 20)
        
        dayField.rightAnchor.constraint(equalTo: monthField.leftAnchor).isActive = true
        dayField.centerYAnchor.constraint(equalTo: yearField.centerYAnchor).isActive = true
        dayField.widthAnchor.constraint(equalToConstant: 20)
        
        checkmark.bottomAnchor.constraint(equalTo: formContainer.bottomAnchor, constant: -25).isActive = true
        checkmark.rightAnchor.constraint(equalTo: formContainer.rightAnchor, constant: -25).isActive = true
        checkmark.widthAnchor.constraint(equalToConstant: 50).isActive = true
        checkmark.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func startBackgroundAnimation() {
        UIView.animate(withDuration: 4, delay: 3, options: [.allowUserInteraction], animations: {
            
            let rand = Int(arc4random_uniform(3))
            self.backgroundColor = self.colors[rand]
            
        }, completion: {void in
            self.startBackgroundAnimation()
        })
    }
}

extension OnboardingView: OnboardArrowDelegate {
    func didTapLeftArrow() {
        arrow.removeAllConstraints()
        arrow.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25).isActive = true
        arrow.rightAnchor.constraint(equalTo: rightAnchor, constant: -25).isActive = true
        arrow.widthAnchor.constraint(equalToConstant: 35).isActive = true
        arrow.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        })
    }
    
    func didTapRightArrow() {
        arrow.removeAllConstraints()
        arrow.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25).isActive = true
        arrow.leftAnchor.constraint(equalTo: leftAnchor, constant: 25).isActive = true
        arrow.widthAnchor.constraint(equalToConstant: 35).isActive = true
        arrow.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
            self.scrollView.contentOffset = CGPoint(x: Constants.screenWidth, y: 0)
        })
    }
}

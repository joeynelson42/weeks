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
    let fadeView = UIView()
    
    // Page 1
    let tableView = UITableView()
    let firstArrow = OnboardArrow()
    
    // Page 2
    let formContainer = UIView()
    let ageLabel = UILabel()
    let dayField = UITextField()
    let monthField = UITextField()
    let yearField = UITextField()
    let maleButton = OutlineButton()
    let femaleButton = OutlineButton()
    var dobFields = [UITextField]()
    let secondArrow = OnboardArrow()
    
    // Page 3
    let statContainer = UIView()
    let topLabel = UILabel()
    let middleLabel = UILabel()
    let bottomLabel = UILabel()
    let weeksLived = UILabel()
    let weeksLeft = UILabel()
    let livedActivityIndicator = UIActivityIndicatorView()
    let leftActivityIndicator = UIActivityIndicatorView()
    let startButton = UIButton()
    
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
        
        scrollView.contentSize = CGSize(width: Constants.screenWidth * 3, height: Constants.screenHeight)
        scrollView.isPagingEnabled = true
        scrollView.delaysContentTouches = false
        scrollView.isScrollEnabled = false
        
        fadeView.alpha = 0.0
        fadeView.backgroundColor = .white
        
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delaysContentTouches = false
        
        formContainer.backgroundColor = .clear
        
        ageLabel.text = "DATE OF BIRTH"
        ageLabel.textColor = .lightGray
        ageLabel.font = UIFont.centuryGothic(fontSize: 12)
        
        let keyboardAccessory = Bundle.main.loadNibNamed("OnboardKeyboardAccessory", owner: nil, options: nil)?[0] as! OnboardKeyboardAccessory
        keyboardAccessory.doneButton.addTarget(self, action: #selector(endEditing), for: .touchUpInside)
        keyboardAccessory.leftArrow.addTarget(self, action: #selector(previousField), for: .touchUpInside)
        keyboardAccessory.rightArrow.addTarget(self, action: #selector(nextField), for: .touchUpInside)
        
        dobFields = [dayField, monthField, yearField]
        for field in dobFields {
            field.font = UIFont.centuryGothic(fontSize: 40)
            field.textColor = .white
            field.inputAccessoryView = keyboardAccessory
            field.keyboardType = .numberPad
            field.textAlignment = .right
        }
        
        dayField.attributedPlaceholder =
            NSAttributedString(string: "DD", attributes: [NSForegroundColorAttributeName : UIColor.extraLightGray()])
        monthField.attributedPlaceholder =
            NSAttributedString(string: "MM", attributes: [NSForegroundColorAttributeName : UIColor.extraLightGray()])
        yearField.attributedPlaceholder =
            NSAttributedString(string: "YYYY", attributes: [NSForegroundColorAttributeName : UIColor.extraLightGray()])
        
        maleButton.setTitle(" MALE ", for: .normal)
        maleButton.setTitleColor(.extraLightGray(), for: .normal)
        maleButton.setTitleColor(.lightGray, for: .highlighted)
        maleButton.setTitleColor(.white, for: .selected)
        maleButton.titleLabel?.font = UIFont.centuryGothic(fontSize: 40)
        maleButton.outlineWidth = 1.5
        maleButton.contentHorizontalAlignment = .center
        
        femaleButton.setTitle(" FEMALE ", for: .normal)
        femaleButton.setTitleColor(.extraLightGray(), for: .normal)
        femaleButton.setTitleColor(.lightGray, for: .highlighted)
        femaleButton.setTitleColor(.white, for: .selected)
        femaleButton.titleLabel?.font = UIFont.centuryGothic(fontSize: 40)
        femaleButton.outlineWidth = 1.5
        femaleButton.contentHorizontalAlignment = .center
        
        statContainer.backgroundColor = .clear
        let labelFontSize: CGFloat = 18
        topLabel.text = "You've been here for"
        topLabel.textColor = .white
        topLabel.font = UIFont.centuryGothic(fontSize: labelFontSize)
        
        middleLabel.text = "and you still have"
        middleLabel.textColor = .white
        middleLabel.font = UIFont.centuryGothic(fontSize: labelFontSize)
        
        weeksLived.text = "weeks"
        weeksLived.textColor = .white
        weeksLived.font = UIFont.centuryGothic(fontSize: 45)
        
        weeksLeft.text = "weeks"
        weeksLeft.textColor = .white
        weeksLeft.font = UIFont.centuryGothic(fontSize: 45)
        
        livedActivityIndicator.hidesWhenStopped = true
        leftActivityIndicator.hidesWhenStopped = true
        
        startButton.setImage(#imageLiteral(resourceName: "checkmarkIcon"), for: .normal)
        
        firstArrow.delegate = self
        firstArrow.enable(enabled: false)
        
        secondArrow.delegate = self
        secondArrow.enable(enabled: false)
        
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
        
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        formContainer.addSubview(ageLabel)
        
        for field in dobFields {
            field.translatesAutoresizingMaskIntoConstraints = false
            formContainer.addSubview(field)
        }
        
        statContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(statContainer)
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        statContainer.addSubview(topLabel)
        
        middleLabel.translatesAutoresizingMaskIntoConstraints = false
        statContainer.addSubview(middleLabel)
        
        weeksLived.translatesAutoresizingMaskIntoConstraints = false
        statContainer.addSubview(weeksLived)
        
        weeksLeft.translatesAutoresizingMaskIntoConstraints = false
        statContainer.addSubview(weeksLeft)
        
        livedActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        statContainer.addSubview(livedActivityIndicator)
        
        leftActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        statContainer.addSubview(leftActivityIndicator)
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        statContainer.addSubview(startButton)
        
        firstArrow.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(firstArrow)
        
        secondArrow.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(secondArrow)
        
        fadeView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(fadeView)
    }
    
    private func applyConstraints() {
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalToConstant: Constants.screenWidth).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: Constants.screenHeight).isActive = true
        
        fadeView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        fadeView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        fadeView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        fadeView.widthAnchor.constraint(equalToConstant: Constants.screenWidth).isActive = true
        fadeView.heightAnchor.constraint(equalToConstant: Constants.screenHeight).isActive = true
        
        firstArrow.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -25).isActive = true
        firstArrow.rightAnchor.constraint(equalTo: tableView.rightAnchor, constant: -25).isActive = true
        firstArrow.widthAnchor.constraint(equalToConstant: 35).isActive = true
        firstArrow.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        secondArrow.bottomAnchor.constraint(equalTo: formContainer.bottomAnchor, constant: -25).isActive = true
        secondArrow.rightAnchor.constraint(equalTo: formContainer.rightAnchor, constant: -25).isActive = true
        secondArrow.widthAnchor.constraint(equalToConstant: 35).isActive = true
        secondArrow.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
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
        
        monthField.rightAnchor.constraint(equalTo: yearField.leftAnchor, constant: -5).isActive = true
        monthField.centerYAnchor.constraint(equalTo: yearField.centerYAnchor).isActive = true
        monthField.widthAnchor.constraint(equalToConstant: 20)
        
        dayField.rightAnchor.constraint(equalTo: monthField.leftAnchor, constant: -5).isActive = true
        dayField.centerYAnchor.constraint(equalTo: yearField.centerYAnchor).isActive = true
        dayField.widthAnchor.constraint(equalToConstant: 20)
        
        ageLabel.rightAnchor.constraint(equalTo: yearField.rightAnchor).isActive = true
        ageLabel.bottomAnchor.constraint(equalTo: yearField.topAnchor).isActive = true
        
        statContainer.leftAnchor.constraint(equalTo: formContainer.rightAnchor).isActive = true
        statContainer.topAnchor.constraint(equalTo: formContainer.topAnchor).isActive = true
        statContainer.widthAnchor.constraint(equalToConstant: Constants.screenWidth).isActive = true
        statContainer.heightAnchor.constraint(equalToConstant: Constants.screenHeight).isActive = true
        
        topLabel.topAnchor.constraint(equalTo: statContainer.topAnchor, constant: 75).isActive = true
        topLabel.centerXAnchor.constraint(equalTo: statContainer.centerXAnchor).isActive = true
        
        let statSpacing: CGFloat = 0
        
        weeksLived.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: statSpacing).isActive = true
        weeksLived.centerXAnchor.constraint(equalTo: statContainer.centerXAnchor).isActive = true
        
        middleLabel.topAnchor.constraint(equalTo: weeksLived.bottomAnchor, constant: statSpacing).isActive = true
        middleLabel.centerXAnchor.constraint(equalTo: statContainer.centerXAnchor).isActive = true
        
        weeksLeft.topAnchor.constraint(equalTo: middleLabel.bottomAnchor, constant: statSpacing).isActive = true
        weeksLeft.centerXAnchor.constraint(equalTo: statContainer.centerXAnchor).isActive = true
        
        livedActivityIndicator.centerYAnchor.constraint(equalTo: weeksLived.centerYAnchor).isActive = true
        livedActivityIndicator.rightAnchor.constraint(equalTo: weeksLived.leftAnchor, constant: -10).isActive = true
        
        leftActivityIndicator.centerYAnchor.constraint(equalTo: weeksLeft.centerYAnchor).isActive = true
        leftActivityIndicator.rightAnchor.constraint(equalTo: weeksLeft.leftAnchor, constant: -10).isActive = true
        
        startButton.topAnchor.constraint(equalTo: weeksLeft.bottomAnchor, constant: 15).isActive = true
        startButton.centerXAnchor.constraint(equalTo: statContainer.centerXAnchor).isActive = true
        startButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func startBackgroundAnimation() {
        UIView.animate(withDuration: 4, delay: 3, options: [.allowUserInteraction], animations: {
            
            let rand = Int(arc4random_uniform(3))
            self.backgroundColor = self.colors[rand]
            
        }, completion: {void in
            self.startBackgroundAnimation()
        })
    }
    
    func nextField() {
        if dayField.isFirstResponder {
            monthField.becomeFirstResponder()
        } else if monthField.isFirstResponder {
            yearField.becomeFirstResponder()
        } else if yearField.isFirstResponder {
            dayField.becomeFirstResponder()
        }
    }
    
    func previousField() {
        if dayField.isFirstResponder {
            yearField.becomeFirstResponder()
        } else if monthField.isFirstResponder {
            dayField.becomeFirstResponder()
        } else if yearField.isFirstResponder {
            monthField.becomeFirstResponder()
        }
    }
}

extension OnboardingView: OnboardArrowDelegate {
    func didTapLeftArrow(arrow: OnboardArrow) {
        var arrowSuperview: UIView!
        var newOffset: CGPoint!
        if arrow == firstArrow {
            arrowSuperview = tableView
            newOffset = CGPoint(x: 0, y: 0)
        } else {
            arrowSuperview = formContainer
            newOffset = CGPoint(x: Constants.screenWidth, y: 0)
        }
        
        arrow.removeAllConstraints()
        arrow.bottomAnchor.constraint(equalTo: arrowSuperview.bottomAnchor, constant: -25).isActive = true
        arrow.rightAnchor.constraint(equalTo: arrowSuperview.rightAnchor, constant: -25).isActive = true
        arrow.widthAnchor.constraint(equalToConstant: 35).isActive = true
        arrow.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
            self.scrollView.contentOffset = newOffset
        })
    }
    
    func didTapRightArrow(arrow: OnboardArrow) {
        var arrowSuperview: UIView!
        var newOffset: CGPoint!
        if arrow == firstArrow {
            arrowSuperview = tableView
            newOffset = CGPoint(x: Constants.screenWidth, y: 0)
        } else {
            arrowSuperview = formContainer
            newOffset = CGPoint(x: Constants.screenWidth * 2, y: 0)
        }
        
        arrow.removeAllConstraints()
        arrow.bottomAnchor.constraint(equalTo: arrowSuperview.bottomAnchor, constant: -25).isActive = true
        arrow.leftAnchor.constraint(equalTo: arrowSuperview.rightAnchor, constant: 25).isActive = true
        arrow.widthAnchor.constraint(equalToConstant: 35).isActive = true
        arrow.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
            self.scrollView.contentOffset = newOffset
        })
    }
}

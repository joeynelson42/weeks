//
//  UserManager.swift
//  WeeksToLive
//
//  Created by Joey on 1/9/17.
//  Copyright © 2017 NelsonJE. All rights reserved.
//

import Foundation


struct UserManager {
    
    /// Stores the user's date of birth in NSUserDefaults
    func storeUser(DOB: Date) {
        UserDefaults.standard.set(DOB, forKey: Constants.Keys.userDOB)
    }
    
    /// Stores the user's life expectancy in NSUserDefaults
    func storeUser(lifeExpectancy: Float) {
        UserDefaults.standard.set(lifeExpectancy, forKey: Constants.Keys.userLifeExpectancy)
    }
    
    /// Fetches the user's date of birth from NSUserDefaults
    func fetchUserDOB(completion: (Date?) -> Void) {
        if let date = UserDefaults.value(forKeyPath: Constants.Keys.userDOB) as? Date {
            completion(date)
        } else {
            completion(nil)
        }
    }
}

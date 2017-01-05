//
//  User.swift
//  WeeksToLive
//
//  Created by Joey on 1/5/17.
//  Copyright © 2017 NelsonJE. All rights reserved.
//

import Foundation

struct User {
    var country: String!
    var dob: Date!
    var gender: String!
    var lifeExpectancy: Float!
    
    init() {
        country = ""
        dob = Date()
        gender = ""
        lifeExpectancy = 0
    }
    
    init(country: String, dob: Date, gender: String, lifeExpectancy: Float) {
        self.country = country
        self.dob = dob
        self.gender = gender
        self.lifeExpectancy = lifeExpectancy
    }
}

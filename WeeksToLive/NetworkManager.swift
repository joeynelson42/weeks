//
//  NetworkManager.swift
//  WeeksToLive
//
//  Created by Joey on 12/17/16.
//  Copyright © 2016 NelsonJE. All rights reserved.
//

import Foundation

struct NetworkManager {
    
    private var standardLifeExpectancy: Float = 80
    
    func get(url: String, completion: @escaping (_ json: [String : AnyObject]) -> Void) {
        let url = URL(string: url)
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    completion(json)
                    
                } catch let error as NSError{
                    print(error)
                    completion([:])
                }
            }
        }).resume()
    }
    
    /* 
     Takes the gender, country and dob of a user and returns the life expectancy
     PARAMETERS:
     gender: String = "male" || "female" || "Not specified"
     country: String
     dob: String = "yyyy-mm-dd"
     */
    func getLifeExpectancy(gender: String, country: String, dob: String, completion: @escaping (Float) -> Void) {
        let countryForRequest = country.replacingOccurrences(of: " ", with: "%20")
        get(url: "http://api.population.io:80/1.0/life-expectancy/total/\(gender)/\(countryForRequest)/\(dob)/", completion: { json in
            if let lifeExpectancy = json["total_life_expectancy"] as? Float {
                completion(lifeExpectancy)
            } else {
                completion(self.standardLifeExpectancy)
            }
        })
    }
    
    /*
     Returns list of all countries
     */
    func getCountries(completion: @escaping ([String]) -> Void) {
        get(url: "http://api.population.io:80/1.0/countries", completion: { json in
            if let countries = json["countries"] as? [String] {
                completion(countries)
            } else {
                completion([])
            }
        })
    }
}

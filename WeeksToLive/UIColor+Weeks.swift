//
//  UIColor+Hint.swift
//  Hint
//
//  Created by Joey on 10/7/16.
//  Copyright © 2016 NelsonJE. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    class func fromHex(rgbValue:UInt32, alpha:Double=1.0) -> UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    class func extraLightGray() -> UIColor {
        return UIColor.fromHex(rgbValue: 0xECECEC)
    }
    
    class func jacarta() -> UIColor {
        return UIColor.fromHex(rgbValue: 0x332E6F)
    }
    
    class func mySin() -> UIColor {
        return UIColor.fromHex(rgbValue: 0xFFB828)
    }
    
    class func sundown() -> UIColor {
        return UIColor.fromHex(rgbValue: 0xF5A7A3)
    }
    
    class func robinEgg() -> UIColor {
        return UIColor.fromHex(rgbValue: 0x00C1CC)
    }
    
    class func moody() -> UIColor {
        return UIColor.fromHex(rgbValue: 0x7E76DE)
    }
    
    class func midnight() -> UIColor {
        return UIColor.fromHex(rgbValue: 0x211E42)
    }
    
    class func stringToHex(s: NSString)->Int{
        let numbers = [
            "a": 10, "A": 10,
            "b": 11, "B": 11,
            "c": 12, "C": 12,
            "d": 13, "D": 13,
            "e": 14, "E": 14,
            "f": 15, "F": 15,
            "0": 0
        ]
        
        var number: Int = Int()
        if(s.intValue > 0){
            number = s.integerValue
        }
        else{
            number = numbers[s as String]!
        }
        return number
    }
    
    
    
    func rgb() -> (red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = CGFloat(fRed * 255.0)
            let iGreen = CGFloat(fGreen * 255.0)
            let iBlue = CGFloat(fBlue * 255.0)
            let iAlpha = CGFloat(fAlpha * 255.0)
            
            return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
    
    class func ColorFromRedGreenBlue(red: NSString, green: NSString, blue: NSString)->UIColor{
        
        var first: NSString = red.substring(to: 1) as NSString
        var second = red.substring(from: 1)
        var varOne = stringToHex(s: first)
        var varTwo = stringToHex(s: second as NSString)
        let redValue: CGFloat = (CGFloat(varOne) * 16.0 + CGFloat(varTwo)) / 255.0
        
        first = green.substring(to: 1) as NSString
        second = green.substring(from: 1)
        varOne = stringToHex(s: first)
        varTwo = stringToHex(s: second as NSString)
        let greenValue: CGFloat = (CGFloat(varOne) * 16.0 + CGFloat(varTwo)) / 255.0
        
        first = blue.substring(to: 1) as NSString
        second = blue.substring(from: 1)
        varOne = stringToHex(s: first)
        varTwo = stringToHex(s: second as NSString)
        let blueValue: CGFloat = (CGFloat(varOne) * 16.0 + CGFloat(varTwo)) / 255.0
        
        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }
    
    var lighterColor: UIColor {
        return lighterColor(removeSaturation: 0.5, resultAlpha: -1)
    }
    
    func lighterColor(removeSaturation val: CGFloat, resultAlpha alpha: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0
        var b: CGFloat = 0, a: CGFloat = 0
        
        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            else {return self}
        
        return UIColor(hue: h,
                       saturation: max(s - val, 0.0),
                       brightness: b,
                       alpha: alpha == -1 ? a : alpha)
    }
}

//
//  UIFont+Weeks.swift
//  WeeksToLive
//
//  Created by Joey on 12/16/16.
//  Copyright © 2016 NelsonJE. All rights reserved.
//

import UIKit

extension UIFont {
    class func centuryGothic(fontSize: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Century Gothic", size: fontSize) else { return UIFont.systemFont(ofSize: fontSize) }
        return font
    }
}

//
//  APConstraints.swift
//  Copyright (c) 2015 Appsidian. All rights reserved.
//

import UIKit

public enum Constraint {
    case leftToLeftRightToRight
    case leftToLeft
    case leftToRight
    case leftToCenterX
    case rightToRight
    case rightToLeft
    case rightToCenterX
    case topToTopBottomToBottom
    case topToTop
    case topToBottom
    case topToCenterY
    case bottomToBottom
    case bottomToTop
    case bottomToCenterY
    case centerXToCenterX
    case centerXToLeft
    case centerXToRight
    case centerYToCenterY
    case centerYToTop
    case centerYToBottom
    case width
    case intrinsicContentWidth // TODO: Confirm this constraint behaves correctly
    case widthToHeight
    case height
    case intrinsicContentHeight // TODO: Confirm this constraint behaves correctly
    case heightToWidth
    case baseline
    case `default`
    
    public static let llrr = Constraint.leftToLeftRightToRight
    public static let ll   = Constraint.leftToLeft
    public static let lr   = Constraint.leftToRight
    public static let lcx  = Constraint.leftToCenterX
    public static let rr   = Constraint.rightToRight
    public static let rl   = Constraint.rightToLeft
    public static let rcx  = Constraint.rightToCenterX
    public static let ttbb = Constraint.topToTopBottomToBottom
    public static let tt   = Constraint.topToTop
    public static let tb   = Constraint.topToBottom
    public static let tcy  = Constraint.topToCenterY
    public static let bb   = Constraint.bottomToBottom
    public static let bt   = Constraint.bottomToTop
    public static let bcy  = Constraint.bottomToCenterY
    public static let cxcx = Constraint.centerXToCenterX
    public static let cxl  = Constraint.centerXToLeft
    public static let cxr  = Constraint.centerXToRight
    public static let cycy = Constraint.centerYToCenterY
    public static let cyt  = Constraint.centerYToTop
    public static let cyb  = Constraint.centerYToBottom
    public static let w    = Constraint.width
    public static let iw   = Constraint.intrinsicContentWidth
    // TODO: Consider making .wh WidthHeight (width and height) and not Width To Height
    public static let wh   = Constraint.widthToHeight
    public static let h    = Constraint.height
    public static let ih   = Constraint.intrinsicContentHeight
    public static let hw   = Constraint.heightToWidth
    public static let bsln = Constraint.baseline
    
    init() {
        self = .default
    }
    
}

public enum DeviceOrientation {
    case portrait, landscape
}

open class APConstraint: NSLayoutConstraint {
    var orientation: DeviceOrientation?
}

public extension UIView {
    
    /// Adds multiple subviews to the receiver, in the order specified in the array
    public func addSubviews(_ subviews: [UIView]) {
        for view in subviews {
            self.addSubview(view)
        }
    }

    /// Applies an array of NSLayoutConstraints to the view, using a multiplier and an offset
    public func constrainUsing(constraints: [Constraint : (of: AnyObject?, multiplier: CGFloat, offset: CGFloat)]) {
        var parent = self.superview!
        
        // Checks if constraining within a TableView/CollectionView cell
        if let superclass: AnyClass? = self.superview?.superview?.superclass {
            if superclass === UICollectionViewCell.self || superclass === UITableViewCell.self {
                parent = self.superview!.superview!
            }
        }
        
        // Remove all existing UIConstraints
        self.removeAllConstraints()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        for constraint in constraints {
            switch constraint.0 {
            case .leftToLeftRightToRight: // In this case, the LeftToLeft constant remains positive, but the RightToRight constant is made negative making the constant argument an inset margin
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: constraint.1.of, attribute: .left, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: constraint.1.of, attribute: .right, multiplier: constraint.1.multiplier, constant: -constraint.1.offset))
            case .leftToLeft:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: constraint.1.of, attribute: .left, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .leftToRight:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: constraint.1.of, attribute: .right, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .leftToCenterX:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: constraint.1.of, attribute: .centerX, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .rightToRight:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: constraint.1.of, attribute: .right, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .rightToLeft:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: constraint.1.of, attribute: .left, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .rightToCenterX:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: constraint.1.of, attribute: .centerX, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .topToTopBottomToBottom:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: constraint.1.of, attribute: .top, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: constraint.1.of, attribute: .bottom, multiplier: constraint.1.multiplier, constant: -constraint.1.offset))
            case .topToTop:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: constraint.1.of, attribute: .top, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .topToBottom:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: constraint.1.of, attribute: .bottom, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .topToCenterY:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: constraint.1.of, attribute: .centerY, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .bottomToBottom:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: constraint.1.of, attribute: .bottom, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .bottomToTop:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: constraint.1.of, attribute: .top, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .bottomToCenterY:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: constraint.1.of, attribute: .centerY, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .centerXToCenterX:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: constraint.1.of, attribute: .centerX, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .centerXToLeft:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: constraint.1.of, attribute: .left, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .centerXToRight:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: constraint.1.of, attribute: .right, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .centerYToCenterY:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: constraint.1.of, attribute: .centerY, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .centerYToTop:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: constraint.1.of, attribute: .top, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .centerYToBottom:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: constraint.1.of, attribute: .bottom, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .width:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: constraint.1.of, attribute: .width, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .intrinsicContentWidth:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: constraint.1.of, attribute: .width, multiplier: constraint.1.multiplier, constant: (constraint.1.of as! UIView).intrinsicContentSize.width + constraint.1.offset))
            case .widthToHeight:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: constraint.1.of, attribute: .height, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .height:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: constraint.1.of, attribute: .height, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .intrinsicContentHeight:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: constraint.1.of, attribute: .height, multiplier: constraint.1.multiplier, constant: (constraint.1.of as! UIView).intrinsicContentSize.height + constraint.1.offset))
            case .heightToWidth:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: constraint.1.of, attribute: .width, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .baseline:
                parent.addConstraint(NSLayoutConstraint(item: self, attribute: .lastBaseline, relatedBy: .equal, toItem: constraint.1.of, attribute: .lastBaseline, multiplier: constraint.1.multiplier, constant: constraint.1.offset))
            case .default:
                break
            }
        }
    }
    
    // MARK: Constraint Functions
//    func constrainUsing(constraints constraints: [Constraint : (of: AnyObject?, multiplier: CGFloat, offset: CGFloat)], forOrientation orientation: DeviceOrientation) {
//        var parent = self.superview!
//        
//        // Checks if constraining within a TableView/CollectionView cell
//        if let superclass: AnyClass? = self.superview?.superview?.superclass {
//            if superclass === UICollectionViewCell.self || superclass === UITableViewCell.self {
//                parent = self.superview!.superview!
//            }
//        }
//        
//        // Remove all existing UIConstraints
//        self.removeAllConstraints()
//        
//        self.translatesAutoresizingMaskIntoConstraints = false
//        for constraint in constraints {
//            switch constraint.0 {
//            case .LeftToLeft:
//                let newConstraint = APConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: constraint.1.of, attribute: .Left, multiplier: constraint.1.multiplier, constant: constraint.1.offset)
//                newConstraint.orientation = orientation
//                parent.addConstraint(newConstraint)
//            case .LeftToRight:
//                let newConstraint = APConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: constraint.1.of, attribute: .Right, multiplier: constraint.1.multiplier, constant: constraint.1.offset)
//                newConstraint.orientation = orientation
//                parent.addConstraint(newConstraint)
//            case .LeftToCenterX:
//                let newConstraint = APConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: constraint.1.of, attribute: .CenterX, multiplier: constraint.1.multiplier, constant: constraint.1.offset)
//                newConstraint.orientation = orientation
//                parent.addConstraint(newConstraint)
//            case .RightToRight:
//                let newConstraint = APConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: constraint.1.of, attribute: .Right, multiplier: constraint.1.multiplier, constant: constraint.1.offset)
//                newConstraint.orientation = orientation
//                parent.addConstraint(newConstraint)
//            case .RightToLeft:
//                let newConstraint = APConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: constraint.1.of, attribute: .Left, multiplier: constraint.1.multiplier, constant: constraint.1.offset)
//                newConstraint.orientation = orientation
//                parent.addConstraint(newConstraint)
//            case .RightToCenterX:
//                let newConstraint = APConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: constraint.1.of, attribute: .CenterX, multiplier: constraint.1.multiplier, constant: constraint.1.offset)
//                newConstraint.orientation = orientation
//                parent.addConstraint(newConstraint)
//            case .TopToTop:
//                let newConstraint = APConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: constraint.1.of, attribute: .Top, multiplier: constraint.1.multiplier, constant: constraint.1.offset)
//                newConstraint.orientation = orientation
//                parent.addConstraint(newConstraint)
//            case .TopToBottom:
//                let newConstraint = APConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: constraint.1.of, attribute: .Bottom, multiplier: constraint.1.multiplier, constant: constraint.1.offset)
//                newConstraint.orientation = orientation
//                parent.addConstraint(newConstraint)
//            case .TopToCenterY:
//                let newConstraint = APConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: constraint.1.of, attribute: .CenterY, multiplier: constraint.1.multiplier, constant: constraint.1.offset)
//                newConstraint.orientation = orientation
//                parent.addConstraint(newConstraint)
//            case .BottomToBottom:
//                let newConstraint = APConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: constraint.1.of, attribute: .Bottom, multiplier: constraint.1.multiplier, constant: constraint.1.offset)
//                newConstraint.orientation = orientation
//                parent.addConstraint(newConstraint)
//            case .BottomToTop:
//                let newConstraint = APConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: constraint.1.of, attribute: .Top, multiplier: constraint.1.multiplier, constant: constraint.1.offset)
//                newConstraint.orientation = orientation
//                parent.addConstraint(newConstraint)
//            case .BottomToCenterY:
//                let newConstraint = APConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: constraint.1.of, attribute: .CenterY, multiplier: constraint.1.multiplier, constant: constraint.1.offset)
//                newConstraint.orientation = orientation
//                parent.addConstraint(newConstraint)
//            case .CenterXToCenterX:
//                let newConstraint = APConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: constraint.1.of, attribute: .CenterX, multiplier: constraint.1.multiplier, constant: constraint.1.offset)
//                newConstraint.orientation = orientation
//                parent.addConstraint(newConstraint)
//            case .CenterYToCenterY:
//                let newConstraint = APConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: constraint.1.of, attribute: .CenterY, multiplier: constraint.1.multiplier, constant: constraint.1.offset)
//                newConstraint.orientation = orientation
//                parent.addConstraint(newConstraint)
//            case .CenterYToTop:
//                let newConstraint = APConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: constraint.1.of, attribute: .Top, multiplier: constraint.1.multiplier, constant: constraint.1.offset)
//                newConstraint.orientation = orientation
//                parent.addConstraint(newConstraint)
//            case .CenterYToBottom:
//                let newConstraint = APConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: constraint.1.of, attribute: .Bottom, multiplier: constraint.1.multiplier, constant: constraint.1.offset)
//                newConstraint.orientation = orientation
//                parent.addConstraint(newConstraint)
//            case .Width:
//                let newConstraint = APConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: constraint.1.of, attribute: .Width, multiplier: constraint.1.multiplier, constant: constraint.1.offset)
//                newConstraint.orientation = orientation
//                parent.addConstraint(newConstraint)
//            case .Height:
//                let newConstraint = APConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: constraint.1.of, attribute: .Height, multiplier: constraint.1.multiplier, constant: constraint.1.offset)
//                newConstraint.orientation = orientation
//                parent.addConstraint(newConstraint)
//            case .Default:
//                break
//            }
//        }
//    }
    
//    public func constrainUsing(constraints constraints: [Constraint: (of: AnyObject?, offset: CGFloat)], forDevices devices: [DeviceTypes]) {
//        let currentDeviceType = UIDevice.currentDevice().deviceType
//        var currentDeviceSupported = false
//        for device in devices {
//            if currentDeviceType == device { currentDeviceSupported = true }
//        }
//        if !currentDeviceSupported { return }
//        var constraintDictionary : [Constraint : (of: AnyObject?, multiplier: CGFloat, offset: CGFloat)] = [Constraint() : (nil, 0, 0)]
//        for constraint in constraints {
//            constraintDictionary[constraint.0] = (constraint.1.of, CGFloat(1), constraint.1.offset)
//        }
//        constrainUsing(constraints: constraintDictionary)
//    }
    
//    func constrainUsing(constraints constraints: [Constraint: (of: AnyObject?, offset: CGFloat)], forOrientation orientation: DeviceOrientation) {
//        var constraintDictionary : [Constraint : (of: AnyObject?, multiplier: CGFloat, offset: CGFloat)] = [Constraint() : (nil, 0, 0)]
//        for constraint in constraints {
//            constraintDictionary[constraint.0] = (constraint.1.of, CGFloat(1), constraint.1.offset)
//        }
//        constrainUsing(constraints: constraintDictionary, forOrientation: orientation)
//    }
    
    public func constrainUsing(constraints: [Constraint: (of: AnyObject?, offset: CGFloat)]) {
        var constraintDictionary : [Constraint : (of: AnyObject?, multiplier: CGFloat, offset: CGFloat)] = [Constraint() : (nil, 0, 0)]
        for constraint in constraints {
            constraintDictionary[constraint.0] = (constraint.1.of, CGFloat(1), constraint.1.offset)
        }
        constrainUsing(constraints: constraintDictionary)
    }
    
    public func constrainUsing(constraints: [Constraint : AnyObject?]) {
        var constraintDictionary : [Constraint : (of: AnyObject?, multiplier: CGFloat, offset: CGFloat)] = [Constraint() : (nil, 0, 0)]
        for constraint in constraints {
            constraintDictionary[constraint.0] = (constraint.1, 1.0, 0)
        }
        constrainUsing(constraints: constraintDictionary)
    }
    
    public func fillSuperview() {
        constrainUsing(constraints: [
            .leftToLeft : (of: self.superview, multiplier: 1.0, offset: 0),
            .rightToRight : (of: self.superview, multiplier: 1.0, offset: 0),
            .topToTop : (of: self.superview, multiplier: 1.0, offset: 0),
            .bottomToBottom : (of: self.superview, multiplier: 1.0, offset: 0)])
    }
    
    public func centerInSuperview() {
        constrainUsing(constraints: [
            .centerXToCenterX : (of: self.superview, multiplier: 1.0, offset: 0),
            .centerYToCenterY : (of: self.superview, multiplier: 1.0, offset: 0)])
    }
    
    public func removeAllConstraints() {
        if let parent = self.superview {
            for constraint in parent.constraints as [NSLayoutConstraint] {
                if constraint.firstItem as? UIView == self {
                    parent.removeConstraint(constraint)
                }
            }
        }
    }
    
    public func updateConstraint(constraint: Constraint, offset: CGFloat) {
        var firstAttribute: NSLayoutAttribute?
        var secondAttribute: NSLayoutAttribute?
        switch constraint {
        case .leftToLeftRightToRight:
            print("Updating constraint .llrr is not yet supported")
            return
        case .leftToLeft:
            firstAttribute = .left; secondAttribute = .left
        case .leftToRight:
            firstAttribute = .left; secondAttribute = .right
        case .leftToCenterX:
            firstAttribute = .left; secondAttribute = .centerX
        case .rightToRight:
            firstAttribute = .right; secondAttribute = .right
        case .rightToLeft:
            firstAttribute = .right; secondAttribute = .left
        case .rightToCenterX:
            firstAttribute = .right; secondAttribute = .centerX
        case .topToTopBottomToBottom:
            print("Updating constraint .ttbb is not yet supported")
            return
        case .topToTop:
            firstAttribute = .top; secondAttribute = .top
        case .topToBottom:
            firstAttribute = .top; secondAttribute = .bottom
        case .topToCenterY:
            firstAttribute = .top; secondAttribute = .centerY
        case .bottomToBottom:
            firstAttribute = .bottom; secondAttribute = .bottom
        case .bottomToTop:
            firstAttribute = .bottom; secondAttribute = .top
        case .bottomToCenterY:
            firstAttribute = .bottom; secondAttribute = .centerY
        case .centerXToCenterX:
            firstAttribute = .centerX; secondAttribute = .centerX
        case .centerXToLeft:
            firstAttribute = .centerX; secondAttribute = .left
        case .centerXToRight:
            firstAttribute = .centerX; secondAttribute = .right
        case .centerYToCenterY:
            firstAttribute = .centerY; secondAttribute = .centerY
        case .centerYToTop:
            firstAttribute = .centerY; secondAttribute = .top
        case .centerYToBottom:
            firstAttribute = .centerY; secondAttribute = .bottom
        case .width:
            firstAttribute = .width; secondAttribute = .width
        case .intrinsicContentWidth:
            print("Updating constraint .iw is not yet supported")
            return
        case .widthToHeight:
            firstAttribute = .width; secondAttribute = .height
        case .height:
            firstAttribute = .height; secondAttribute = .height
        case .heightToWidth:
            firstAttribute = .height; secondAttribute = .width
        case .intrinsicContentHeight:
            print("Updating constraint .ih is not yet supported")
            return
        case .baseline:
            firstAttribute = .lastBaseline; secondAttribute = .lastBaseline
        case .default:
            break
        }
        for existingConstraint in self.constraints {
            if existingConstraint.firstAttribute == firstAttribute && existingConstraint.secondAttribute == secondAttribute {
                existingConstraint.constant = offset
            }
        }
        self.setNeedsUpdateConstraints()
    }
    
//    public func addSubviewForDevices(subview: UIView, devices: [DeviceTypes]) {
//        let currentDeviceType = UIDevice.currentDevice().deviceType
//        for device in devices {
//            if currentDeviceType == device {
//                self.addSubview(subview)
//            }
//        }
//    }
    
    public func activateConstraintsForOrientation(_ orientation: DeviceOrientation) {
        for constraint in self.constraints as! [APConstraint] {
            if constraint.orientation == orientation {
                constraint.isActive = true
            }
        }
    }
    
    public func deactivateConstraintsForOrientation(_ orientation: DeviceOrientation) {
        for constraint in self.constraints as! [APConstraint] {
            if constraint.orientation == orientation {
                constraint.isActive = false
            }
        }
    }
    
    // NOTE: This method is deprecated - use APStackView instead.
    public func spaceHorizontalWithInset(views: [UIView], inset: UIEdgeInsets) {
        assert(inset.right == inset.left, "Error! Left and Right insets must be equal")
        let parent = self
        parent.layoutIfNeeded()
        var totalWidthOfViews: CGFloat = 0
        for view in views as [UIView] {
            totalWidthOfViews += view.intrinsicContentSize.width
        }
        let padding = (parent.frame.width - totalWidthOfViews - (inset.right + inset.left)) / CGFloat(views.count)
        
        for (index, view) in views.enumerated() {
            view.translatesAutoresizingMaskIntoConstraints = false
            parent.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: parent.frame.height))
            parent.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: view.intrinsicContentSize.width + padding))
            parent.addConstraint(NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: parent, attribute: .centerY, multiplier: 1.0, constant: inset.top))
            
            if view == views.first! {
                parent.addConstraint(NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: parent, attribute: .left, multiplier: 1.0, constant: inset.left))
            } else {
                parent.addConstraint(NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: views[index - 1], attribute: .right, multiplier: 1.0, constant: 0))
            }
        }
    }
    
    
}

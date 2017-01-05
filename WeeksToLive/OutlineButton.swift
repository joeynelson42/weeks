
//  Created by Joey on 1/4/17.
//  Copyright © 2017 NelsonJE. All rights reserved.


import UIKit

class OutlineButton: UIButton {
    
    private let pathLayer: CAShapeLayer = CAShapeLayer()
    
    public var outlineColor = UIColor.white
    public var outlineWidth: CGFloat = 2.0
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                drawOutline()
            } else {
                removeOutline()
            }
        }
    }
    
    private func drawOutline() {
        let realFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        let path: UIBezierPath = UIBezierPath(rect: realFrame)
        
        //Create a CAShape Layer
        pathLayer.frame = self.bounds
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = outlineColor.cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = outlineWidth
        pathLayer.lineJoin = kCALineJoinRound
        
        self.layer.addSublayer(pathLayer)
        
        let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 0.5
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        //Animation will happen right away
        pathLayer.add(pathAnimation, forKey: "strokeEnd")
    }
    
    private func removeOutline() {
        pathLayer.removeFromSuperlayer()
    }
}

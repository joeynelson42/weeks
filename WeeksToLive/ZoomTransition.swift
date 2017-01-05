
//  Modified version of Tristan Himmelman's ZoomTransition

import Foundation
import UIKit

@objc public protocol ZoomTransitionProtocol {
    func viewForTransition() -> UIView
}

open class ZoomTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    fileprivate var navigationController: UINavigationController
    fileprivate var fromView: UIView?
    fileprivate var toView: UIView?
    fileprivate var fromFrame: CGRect?
    fileprivate var toFrame: CGRect?
    fileprivate var transitionView: UIView?
    fileprivate var transitionContext: UIViewControllerContextTransitioning?
    fileprivate var fromViewController: UIViewController?
    fileprivate var toViewController: UIViewController?
    fileprivate var isPresenting: Bool = true
    fileprivate var shouldCompleteTransition: Bool = false
    fileprivate let completionThreshold: CGFloat = 0.7
    fileprivate var interactive: Bool = false
    
    // Background Zoom
    fileprivate var shouldBackgroundZoom = false
    fileprivate var backgroundScale: CGFloat = 1.0
    fileprivate var backgroundTranslationX: CGFloat = 0
    fileprivate var backgroundTranslationY: CGFloat = 0
    
    var allowsInteractiveGesture = true
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - UIViewControllerAnimatedTransition Protocol
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if interactive {
            return 0.7
        }
        
        return 0.5
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        if let viewController = toViewController as? ZoomTransitionProtocol {
            toView = viewController.viewForTransition()
        }
        if let viewController = fromViewController as? ZoomTransitionProtocol {
            fromView = viewController.viewForTransition()
        }
        
        // make sure toViewController is layed out
        toViewController?.view.frame = transitionContext.finalFrame(for: toViewController!)
        toViewController?.updateViewConstraints()
        
        assert(fromView != nil && toView != nil, "fromView and toView need to be set")
        
        let container = self.transitionContext!.containerView
        
        // add toViewController to Transition Container
        if let view = toViewController?.view {
            if (isPresenting){
                container.addSubview(view)
            } else {
                container.insertSubview(view, belowSubview: fromViewController!.view)
            }
        }
        toViewController?.view.layoutIfNeeded()
        
        // Calculate animation frames within container view
        fromFrame = container.convert(fromView!.bounds, from: fromView)
        toFrame = container.convert(toView!.bounds, from: toView)
        
        if isPresenting {
            let cellView = UIView()
            if let _ = fromView {
                cellView.backgroundColor = fromView!.backgroundColor
                cellView.layer.cornerRadius = fromView!.layer.cornerRadius
                cellView.layer.borderColor = fromView!.layer.borderColor
                cellView.layer.borderWidth = fromView!.layer.borderWidth
                
                toView?.backgroundColor = fromView!.backgroundColor
                toView?.layer.borderColor = fromView!.layer.borderColor
            }
            
            transitionView = cellView
        } else {
            let noteView = UIView()
            if let _ = fromView {
                noteView.backgroundColor = fromView!.backgroundColor
                noteView.layer.cornerRadius = fromView!.layer.cornerRadius
                noteView.layer.borderColor = fromView!.layer.borderColor
                noteView.layer.borderWidth = fromView!.layer.borderWidth
            }
            
            transitionView = noteView
        }
        
        if let view = transitionView {
            view.clipsToBounds = true
            view.frame = fromFrame!
            view.contentMode = fromView!.contentMode
            container.addSubview(view)
        }
        
        // Calculate the background scale
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        if isPresenting {
//            backgroundTranslationX = ((screenWidth / 2) - fromView!.frame.origin.x)
//            backgroundTranslationY = ((screenHeight / 2) - fromView!.frame(forAlignmentRect: fromView!.superview!.frame).origin.y) / 2
//            backgroundScale = (toView!.frame.width / fromView!.frame.width) * 0.75
//            backgroundScale = 6.0
        } else {
//            backgroundTranslationX = ((screenWidth / 2) - toView!.frame.origin.x)
//            backgroundTranslationY = ((screenHeight / 2) - toView!.frame(forAlignmentRect: toView!.superview!.frame).origin.y) / 2
//            backgroundScale = fromView!.frame.width / toView!.frame.width * 0.75
//            backgroundScale = 6.0
        }
        
        if isPresenting {
            animateZoomInTransition()
        } else {
            animateZoomOutTransition()
        }
    }
    
    // MARK: - Zoom animations
    
    func animateZoomInTransition(){
//        if allowsInteractiveGesture {
//            // add pan gesture to new viewcontroller
//            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ZoomTransition.handlePanGesture(_:)))
//            panGesture.delegate = self
//            toViewController?.view.addGestureRecognizer(panGesture)
//        }
        
        toViewController?.view.alpha = 0
        toView?.isHidden = true
        fromView?.alpha = 0
        
        let duration = transitionDuration(using: transitionContext!)
    
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            
            self.fromViewController?.view.transform = CGAffineTransform(scaleX: self.backgroundScale, y: self.backgroundScale).translatedBy(x: self.backgroundTranslationX, y: self.backgroundTranslationY)
            
            self.toViewController?.view.alpha = 1
            if (self.interactive == false){
                self.transitionView?.frame = self.toFrame!
            }
            
        }) { (finished) -> Void in
            self.transitionView?.removeFromSuperview()
            self.fromViewController?.view.alpha = 1
            self.fromViewController?.view.transform = CGAffineTransform.identity
            self.toView?.isHidden = false
            self.fromView?.alpha = 1
            
            if (self.transitionContext!.transitionWasCancelled){
                self.toViewController?.view.removeFromSuperview()
                self.isPresenting = true
                self.transitionContext!.completeTransition(false)
            } else {
                self.isPresenting = false
                self.transitionContext!.completeTransition(true)
            }
        }
    }
    
    func animateZoomOutTransition(){
        transitionView?.contentMode = toView!.contentMode
        
        toViewController?.view.alpha = 1
        
        toView?.isHidden = true
        fromView?.alpha = 0
        let duration = transitionDuration(using: transitionContext!)
        self.toViewController?.view.transform = CGAffineTransform(scaleX: backgroundScale, y: backgroundScale).translatedBy(x: backgroundTranslationX, y: backgroundTranslationY)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            self.toViewController?.view.transform = CGAffineTransform.identity
            self.fromViewController?.view.alpha = 0
            if (self.interactive == false){
                self.transitionView?.frame = self.toFrame!
            }
        }) { (finished) -> Void in
            if self.interactive == false {
                self.zoomOutTransitionComplete()
            }
        }
    }
    
    func zoomOutTransitionComplete(){
        if (self.transitionView?.superview == nil){
            return
        }
        self.fromViewController?.view.alpha = 1
        self.toView?.isHidden = false
        self.fromView?.alpha = 1
        self.transitionView?.removeFromSuperview()
        
        if (self.transitionContext!.transitionWasCancelled){
            self.toViewController?.view.removeFromSuperview()
            self.isPresenting = false
            self.transitionContext!.completeTransition(false)
        } else {
            self.isPresenting = true
            self.transitionContext!.completeTransition(true)
        }
    }
    
    // MARK: - Gesture Recognizer Handlers
    
    func handlePanGesture(_ gesture: UIPanGestureRecognizer){
        let view = gesture.view!

        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            interactive = true
            // begin transition
            self.navigationController.popViewController(animated: true)

        case .changed:
            transitionView?.center = CGPoint(x:transitionView!.center.x + translation.x, y:transitionView!.center.y + translation.y)
            gesture.setTranslation(CGPoint.zero, in: view)
            
            let diff = transitionView!.center.y - (Constants.screenHeight / 2)
            
            let scale = 1 - (diff / (Constants.screenHeight * 0.66))
            self.shouldCompleteTransition = (scale < completionThreshold)

            update(1 - scale)
            
        case .cancelled, .ended:
            var animationFrame = toFrame
            let cancelAnimation = (self.shouldCompleteTransition == false) || gesture.state == UIGestureRecognizerState.cancelled

            if (cancelAnimation){
                animationFrame = fromFrame
                fromViewController!.view.layoutIfNeeded()
                cancel()
            } else {
                finish()
            }
            
            let duration = transitionDuration(using: transitionContext!)
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
                
                if let frame = animationFrame {
                    self.transitionView?.frame = frame
                }
                self.transitionView?.contentMode = self.toView!.contentMode
                
            }, completion: { (finished) -> Void in
                self.zoomOutTransitionComplete()
                self.interactive = false
            })
        default:
            return
        }
    }
    
    // MARK: - UINavigationControllerDelegate
    
    open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if (fromVC.conforms(to: ZoomTransitionProtocol.self) && toVC.conforms(to: ZoomTransitionProtocol.self)){
            return self
        }
        
        return nil
    }
    
    open func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if (self.interactive){
            return self
        }
        
        return nil
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

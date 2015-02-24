//
//  CustomTransition.swift
//  DDHCustomTransition
//
//  Created by dasdom on 21.02.15.
//  Copyright (c) 2015 Dominik Hauser. All rights reserved.
//

import UIKit

@objc protocol TransitionInfoProtocol {
    var view: UIView! { get set }
    
    // Return the views which shoud be animated in the transition
    func viewsToAnimate() -> [UIView]
    
    // Return a copy of the view which is passed in
    // The passed in view is one of the views to animate
    func copyForView(subView: UIView) -> UIView
    
    // Optionally return the frames for the views which should be
    // animated. This is needed sometimes because for example
    // with custom container view contrllers the transitioning code
    // can't figure out where on screen the view is actually visible
    // when loaded.
    optional func frameForView(subView: UIView) -> CGRect
}

class CustomTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var operation: UINavigationControllerOperation = .Push
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! TransitionInfoProtocol
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! TransitionInfoProtocol
        
        transitionContext.containerView().addSubview(fromViewController.view)
        transitionContext.containerView().addSubview(toViewController.view)
        
        if operation == .Pop {
            transitionContext.containerView().bringSubviewToFront(fromViewController.view)
        }
        
        toViewController.view.setNeedsLayout()
        toViewController.view.layoutIfNeeded()
        
        fromViewController.view.setNeedsLayout()
        fromViewController.view.layoutIfNeeded()
        
        let fromViews = fromViewController.viewsToAnimate()
        let toViews = toViewController.viewsToAnimate()

        assert(fromViews.count == toViews.count, "Number of elements in fromViews and toViews have to be the same.")
        
        var intermediateViews = [UIView]()
        
        var toFrames = [CGRect]()
        
        for i in 0..<fromViews.count {
            let fromView = fromViews[i]
            var fromFrame = fromView.superview!.convertRect(fromView.frame, toView: nil)
            fromView.alpha = 0
            
            let intermediateView = fromViewController.copyForView(fromView)
            intermediateView.frame = fromFrame
            transitionContext.containerView().addSubview(intermediateView)
            intermediateViews.append(intermediateView)

            let toView = toViews[i]
            var toFrame: CGRect
            if let tempToFrame = toViewController.frameForView?(toView) {
                toFrame = tempToFrame
            } else {
                toFrame = toView.superview!.convertRect(toView.frame, toView: nil)
            }
            toFrames.append(toFrame)
            toView.alpha = 0
        }
        
        if operation == .Push {
            toViewController.view.frame = CGRectOffset(fromViewController.view.frame, fromViewController.view.frame.size.width, 0)
        }
                
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            if self.operation == .Pop {
                fromViewController.view.frame = CGRectOffset(fromViewController.view.frame, fromViewController.view.frame.size.width, 0)
            } else {
                toViewController.view.frame = fromViewController.view.frame
            }
            
            for i in 0..<intermediateViews.count {
                let intermediateView = intermediateViews[i]
                intermediateView.frame = toFrames[i]
            }
        }) { (_) -> Void in
            for i in 0..<intermediateViews.count {
                intermediateViews[i].removeFromSuperview()
                
                fromViews[i].alpha = 1
                toViews[i].alpha = 1
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
        
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.6
    }
}

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    var recipeInteractiveTransition: UIPercentDrivenInteractiveTransition?
    let customTransition = CustomTransition()
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       
        customTransition.operation = operation
        return customTransition
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return recipeInteractiveTransition
    }
}
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
  func copyForView(_ subView: UIView) -> UIView
  
  // Optionally return the frames for the views which should be
  // animated. This is needed sometimes because for example
  // with custom container view contrllers the transitioning code
  // can't figure out where on screen the view is actually visible
  // when loaded.
  @objc optional func frameForView(_ subView: UIView) -> CGRect
}

class CustomTransition: NSObject, UIViewControllerAnimatedTransitioning {
  
  var operation: UINavigationController.Operation = .push
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! TransitionInfoProtocol
    let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! TransitionInfoProtocol
    
    let containerView = transitionContext.containerView
    
    containerView.addSubview(fromViewController.view)
    containerView.addSubview(toViewController.view)
    
    if operation == .pop {
      containerView.bringSubviewToFront(fromViewController.view)
    }
    
    toViewController.view.setNeedsLayout()
    toViewController.view.layoutIfNeeded()
        
//    fromViewController.view.setNeedsLayout()
//    fromViewController.view.layoutIfNeeded()
    
    let fromViews = fromViewController.viewsToAnimate()
    let toViews = toViewController.viewsToAnimate()
    
    assert(fromViews.count == toViews.count, "Number of elements in fromViews and toViews have to be the same.")
    
    var intermediateViews = [UIView]()
    
    var toFrames = [CGRect]()
    
    for i in 0..<fromViews.count {
      let fromView = fromViews[i]
      let fromFrame = fromView.superview!.convert(fromView.frame, to: nil)
      fromView.alpha = 0
      
      let intermediateView = fromViewController.copyForView(fromView)
      intermediateView.frame = fromFrame
      containerView.addSubview(intermediateView)
      intermediateViews.append(intermediateView)
      
      let toView = toViews[i]
      var toFrame: CGRect
      if let tempToFrame = toViewController.frameForView?(toView) {
        toFrame = tempToFrame
      } else {
        toFrame = toView.superview!.convert(toView.frame, to: nil)
      }
      toFrames.append(toFrame)
      toView.alpha = 0
    }
    
    if operation == .push {
      toViewController.view.frame = fromViewController.view.frame.offsetBy(dx: fromViewController.view.frame.size.width, dy: 0)
    }
    
    UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: [], animations: { () -> Void in
      if self.operation == .pop {
        fromViewController.view.frame = fromViewController.view.frame.offsetBy(dx: fromViewController.view.frame.size.width, dy: 0)
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
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
    
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.6
  }
}

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
  
  var recipeInteractiveTransition: UIPercentDrivenInteractiveTransition?
  let customTransition = CustomTransition()
  
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    customTransition.operation = operation
    return customTransition
  }
  
  func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return recipeInteractiveTransition
  }
}

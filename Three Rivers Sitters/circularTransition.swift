//
//  circularTransition.swift
//  secondTRS
//
//  Created by Vikesh Inbasekharan on 11/25/16.
//  Copyright © 2016 MSE. All rights reserved.
//

import UIKit

class circularTransition: NSObject {
    
    // declare the UIview design
    var circle = UIView()
    var startingPoint = CGPoint.zero{
    
        didSet{
        circle.center = startingPoint
        }
    }
    
    var circleColor = UIColor.white
    var durationCircle = 0.4
    
    enum CircleTransitionEffect : Int {
    
        case present, dismiss ,pop
        
    }
    var transitionMode:CircleTransitionEffect = .present
    
    
}

extension circularTransition:UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transationContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return durationCircle
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if transitionMode == .present{
        
            if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to){
            let viewCenter = presentedView.center
            let viewSize = presentedView.frame.size
            
            circle = UIView()
            circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
            
            circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startingPoint
                circle.backgroundColor = circleColor
                circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                containerView.addSubview(circle)
                
                presentedView.center = startingPoint
                presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                presentedView.alpha = 0
                containerView.addSubview(presentedView)
                
                UIView.animate(withDuration: durationCircle, animations: {
                self.circle.transform = CGAffineTransform.identity
                    presentedView.transform = CGAffineTransform.identity
                    presentedView.alpha = 1
                    presentedView.center = viewCenter
                
                }, completion: { (success:Bool) in
                
                    transitionContext.completeTransition(success)
                })
            }
            
        }else{
            let transitionModeKey = (transitionMode == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
            
            if let returingView = transitionContext.view(forKey: transitionModeKey) {
                let viewCenter = returingView.center
                let viewSize = returingView.frame.size
                
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                    circle.layer.cornerRadius = circle.frame.size.height / 2
                    circle.center = startingPoint
                
                UIView.animate(withDuration: durationCircle, animations: {
                    self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returingView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returingView.center = self.startingPoint
                    returingView.alpha = 0
                    
                    if self.transitionMode == .pop{
                    returingView.insertSubview(returingView, belowSubview: returingView)
                    returingView.insertSubview(self.circle, belowSubview: returingView)
                    }
                }, completion: { (success:Bool) in
                
                    returingView.center = viewCenter
                    returingView.removeFromSuperview()
                    
                    self.circle.removeFromSuperview()
                    transitionContext.completeTransition(success)
                })
                
            }
        }
    }

    func frameForCircle(withViewCenter viewCenter:CGPoint, size viewSize:CGSize, startPoint:CGPoint )-> CGRect{
    
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
        
        let offsetVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offsetVector, height: offsetVector)
    
        return CGRect(origin: CGPoint.zero, size: size)
        
    }
    
    
}




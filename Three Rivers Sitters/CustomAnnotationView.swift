//
//  CustomAnnotationView.swift
//  SwiftMapViewCustomCallout
//  Suitable Modification to the source by Vikesh Inbasekharan on 11/15/16
//  This code is a modification of the original source by Robert Ryan https://github.com/robertmryan/CustomMapViewAnnotationCalloutSwift under the licence stated below.
//  This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
//  http://creativecommons.org/licenses/by-sa/4.0/



import UIKit
import MapKit

/// overridding builtin annotation with simple subclass of `MKPinAnnotationView` which includes reference for any currently
/// visible callout bubble

class CustomAnnotationView: MKPinAnnotationView {
    
    weak var calloutView: BookingCalloutView?
    
    override var annotation: MKAnnotation? {
        willSet {
            calloutView?.removeFromSuperview()
        }
    }
    
    /// Animation duration in seconds.
    
    let animationDuration: TimeInterval = 0.40
    
    // MARK: - Initialization methods
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        canShowCallout = false
        animatesDrop = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
  
    // If the annotation is selected, show the callout; if unselected, remove it
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.calloutView?.removeFromSuperview()
            
            let calloutView = BookingCalloutView(annotation: annotation as! MKShape)
            calloutView.add(to: self)
            self.calloutView = calloutView
            
            if animated {
                calloutView.alpha = 0
                UIView.animate(withDuration: animationDuration) {
                    calloutView.alpha = 1
                }
            }
        } else {
            guard let calloutView = calloutView else { return }
            
            if animated {
                UIView.animate(withDuration: animationDuration, animations: {
                    calloutView.alpha = 0
                }, completion: { finished in
                    calloutView.removeFromSuperview()
                })
            } else {
                calloutView.removeFromSuperview()
            }
        }
    }
    
    // Make sure that if the cell is reused that we remove it from the super view.
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        calloutView?.removeFromSuperview()
    }
    
    // MARK: - Detect taps on callout
    
    // Per the Location and Maps Programming Guide, if you want to detect taps on callout,
    // you have to expand the hitTest for the annotation itself.
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) { return hitView }
        
        if let calloutView = calloutView {
            let pointInCalloutView = convert(point, to: calloutView)
            return calloutView.hitTest(pointInCalloutView, with: event)
        }
        
        return nil
    }
    
}


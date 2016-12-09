//
//  BookingCalloutView.swift
//  SwiftMapViewCustomCallout
//  Suitable Modification to the source by Vikesh Inbasekharan on 11/15/16
//  This code is a modification of the original source by Robert Ryan https://github.com/robertmryan/CustomMapViewAnnotationCalloutSwift under the licence stated below.
//  This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
//  http://creativecommons.org/licenses/by-sa/4.0/


import UIKit
import MapKit


class BookingCalloutView: CalloutView {

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 64.0/255.0, alpha: 1.0)
        label.font = .preferredFont(forTextStyle: .callout)
        
        return label
    }()
    
    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 64.0/255.0, alpha: 1.0)
        label.font = .preferredFont(forTextStyle: .caption1)
        
        return label
    }()
    
    private var detailsButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Book", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 3
        
        return button
    }()
    
    init(annotation: MKShape) {
        super.init()
        
        configure()
        
        updateContents(for: annotation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Should not call init(coder:)")
    }
    
    /// Update callout contents
    
    private func updateContents(for annotation: MKShape) {
        titleLabel.text = annotation.title ?? "Unknown"
        subtitleLabel.text = annotation.subtitle
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(detailsButton)
        detailsButton.addTarget(self, action: #selector(didTapDetailsButton(_:)), for: .touchUpInside)

        let views: [String: UIView] = [
            "titleLabel": titleLabel,
            "subtitleLabel": subtitleLabel,
            "detailsButton": detailsButton
        ]
        
        let vflStrings = [
            "V:|[titleLabel][subtitleLabel][detailsButton]|",
            "H:|[titleLabel]|",
            "H:|[subtitleLabel]|",
            "H:|[detailsButton]|"
        ]
        
        for vfl in vflStrings {
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vfl, metrics: nil, views: views))
        }
    }
    
    override func didTouchUpInCallout(_ sender: Any) {
        print("didTouchUpInCallout")
    }

    func didTapDetailsButton(_ sender: UIButton) {
        print("didTapDetailsButton")
        print(subtitleLabel.text!)
    }
}

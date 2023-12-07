//
//  ConfigurationView.swift
//  Summarize
//
//  Created by Sameel Syed on 11/30/23.
//

import Foundation
import UIKit

class ConfigurationView: UIView {
    var switch1: UISwitch
//    var switch2: UISwitch
//    var switch3: UISwitch
//    var button1: UIButton
//    var button2: UIButton
    
    override init(frame: CGRect) {
        // Initialize switches and buttons
        switch1 = UISwitch()
//        switch2 = UISwitch()
//        switch3 = UISwitch()
//        button1 = UIButton()
//        button2 = UIButton()
//
        super.init(frame: frame)
        
        // Setup and configure the view
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Add subviews
        addSubview(switch1)
//        addSubview(switch2)
//        addSubview(switch3)
//        addSubview(button1)
//        addSubview(button2)
        
        // Additional setup code for switches and buttons
        
        // Set up constraints for centered positioning and size
        translatesAutoresizingMaskIntoConstraints = false
        
//        NSLayoutConstraint.activate([
//            // Centered vertically and horizontally
//            centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
//            centerYAnchor.constraint(equalTo: superview!.centerYAnchor),
//
//            // Width and height constraints (5/8 of screen)
//            widthAnchor.constraint(equalTo: superview!.widthAnchor, multiplier: 5/8),
//            heightAnchor.constraint(equalTo: superview!.heightAnchor, multiplier: 5/8),
//        ])
//
//        // Additional constraints for switches and buttons
//
//        // Example constraints for switch1
//        switch1.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            switch1.centerXAnchor.constraint(equalTo: centerXAnchor),
//            switch1.topAnchor.constraint(equalTo: topAnchor, constant: 20), // Adjust as needed
//        ])
//        
        // Add more constraints for switch2, switch3, button1, and button2
    }
}

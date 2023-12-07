//
//  CollectionTableViewCell.swift
//  Summarize
//
//  Created by Sameel Syed on 11/29/23.
//

import Foundation
import UIKit

class CollectionsTableViewCell: UITableViewCell {
    
    let collectionsDisplay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    let collectionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Collection"
        label.font = UIFont(name: "Lato-Medium", size: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        // Add noteDisplay to the cell's content view
        contentView.addSubview(collectionsDisplay)
        
        // Add noteLabel and noteDescriptionLabel to noteDisplay
        collectionsDisplay.addSubview(collectionsLabel)
        
        // Configure constraints
        NSLayoutConstraint.activate([
            // Set constraints for collectionsDisplay with rounded corners and reduced width
            collectionsDisplay.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            collectionsDisplay.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            collectionsDisplay.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7.5),
            collectionsDisplay.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            collectionsDisplay.widthAnchor.constraint(equalToConstant: 340), // Adjust the width as needed
            collectionsDisplay.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7.5),
            collectionsDisplay.heightAnchor.constraint(equalToConstant: 129),
            
            
            // Set constraints for collectionsLabel
            collectionsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            collectionsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


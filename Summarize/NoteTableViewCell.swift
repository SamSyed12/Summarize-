//
//  NoteTableViewCell.swift
//  Summarize
//
//  Created by Sameel Syed on 11/28/23.
//

import Foundation
import UIKit

class NoteTableViewCell: UITableViewCell {
    
    let noteDisplay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    let noteLabel: UILabel = {
        let label = UILabel()
        label.text = "Note"
        label.font = UIFont(name: "Lato-Medium", size: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let noteDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Note description"
        label.font = UIFont(name: "Lato-Light", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        // Add noteDisplay to the cell's content view
        contentView.addSubview(noteDisplay)
        
        // Add noteLabel and noteDescriptionLabel to noteDisplay
        noteDisplay.addSubview(noteLabel)
        noteDisplay.addSubview(noteDescriptionLabel)
        
        // Configure constraints
        NSLayoutConstraint.activate([
            // Set constraints for noteDisplay with rounded corners and reduced width
            noteDisplay.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            noteDisplay.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            noteDisplay.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7.5),
            noteDisplay.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            noteDisplay.widthAnchor.constraint(equalToConstant: 340), // Adjust the width as needed
            noteDisplay.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7.5),
            noteDisplay.heightAnchor.constraint(equalToConstant: 129),
            
            
            // Set constraints for noteLabel
            noteLabel.topAnchor.constraint(equalTo: noteDisplay.topAnchor, constant: 10),
            noteLabel.leadingAnchor.constraint(equalTo: noteDisplay.leadingAnchor, constant: 10),
            noteLabel.trailingAnchor.constraint(equalTo: noteDisplay.trailingAnchor, constant: -10),
            noteLabel.heightAnchor.constraint(equalToConstant: 60),
            
            // Set constraints for noteDescriptionLabel
            noteDescriptionLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 10),
            noteDescriptionLabel.leadingAnchor.constraint(equalTo: noteDisplay.leadingAnchor, constant: 10),
            noteDescriptionLabel.trailingAnchor.constraint(equalTo: noteDisplay.trailingAnchor, constant: -10),
            noteDescriptionLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

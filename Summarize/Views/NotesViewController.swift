//
//  ViewController.swift
//  Summarize
//
//  Created by Sameel Syed on 11/9/23.
//

import UIKit

class NotesViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNotesLayout()
    }

    func setUpNotesLayout() {
        let numberOfRectangles = 10 // will be dependent on the number of notes stored.
        let rectangleWidth: CGFloat = 300
        let rectangleHeight: CGFloat = 150
        let initialYPosition: CGFloat = 100
        let verticalSpacing: CGFloat = 10

        for i in 0..<numberOfRectangles {
            let yPosition = initialYPosition + CGFloat(i) * (rectangleHeight + verticalSpacing)

            let noteDisplay = UIView(frame: CGRect(x: 20, y: yPosition, width: rectangleWidth, height: rectangleHeight))
            noteDisplay.backgroundColor = UIColor.blue
            mainView.addSubview(noteDisplay)

            // Ensure that the rectangles do not exceed the bounds of mainView
            noteDisplay.clipsToBounds = true

            // Center the rectangles horizontally within mainView
            noteDisplay.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true

            noteDisplay.layer.cornerRadius = 10

            let noteLabel = UILabel(frame: CGRect(x: 10, y: 10, width: rectangleWidth - 20, height: 50))
            noteLabel.text = "Note"
            noteLabel.font = UIFont.systemFont(ofSize: 32)

            let noteDescriptionLabel = UILabel(frame: CGRect(x: 10, y: 70, width: rectangleWidth - 20, height: 30))
            noteDescriptionLabel.text = "Note description"
            noteDescriptionLabel.font = UIFont.systemFont(ofSize: 16)

            noteDisplay.addSubview(noteLabel)
            noteDisplay.addSubview(noteDescriptionLabel)
        }
    }
}



import UIKit

class AllNotesViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpNotesLayout()
        setUpNotesCollectionsTab()
    }
    
    func setUpNotesCollectionsTab(){
        
        // create font for button
        guard let buttonFont = UIFont(name: "Lato-Medium", size: 24) else {
            fatalError("""
                Failed to load the "Lato-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        let noteTabButton = UIButton(type: .system)
        noteTabButton.setTitle("Notes", for: .normal)
        noteTabButton.setTitleColor(UIColor.black, for: .normal)
        noteTabButton.setTitleColor(UIColor.black, for: .highlighted)
        noteTabButton.frame = CGRect(x: 20, y: 95, width: 100, height: 20)
        noteTabButton.addTarget(self, action: #selector(noteTabButtonTapped), for: .touchUpInside)
        noteTabButton.titleLabel?.font = buttonFont
        mainView.addSubview(noteTabButton)
        
        // Create the second button
        let collectionsTabButton = UIButton(type: .system)
        collectionsTabButton.setTitle("Collections", for: .normal)
        collectionsTabButton.setTitleColor(UIColor.black, for: .normal)
        collectionsTabButton.setTitleColor(UIColor.black, for: .highlighted)
        collectionsTabButton.titleLabel?.font = buttonFont
        collectionsTabButton.frame = CGRect(x: 210, y: 95, width: 200, height: 20)
        collectionsTabButton.addTarget(self, action: #selector(collectionsTabButtonTapped), for: .touchUpInside)
        mainView.addSubview(collectionsTabButton)
        }
    
    // Action that occurs when noteTabButton is tapped
    @objc func noteTabButtonTapped() {
        print("Note button tapped!")
        // Add your code here to handle the tap on Button 1
    }
    
    // Action that occurs when collectionsTabButton is pressed.
    @objc func collectionsTabButtonTapped() {
        print("Collections button tapped!")
        // Add your code here to handle the tap on Button 2
    }

    func setUpNotesLayout() {
        let numberOfRectangles = 5 // will be based on the number of notes held in core data
        let rectangleWidth: CGFloat = 340
        let rectangleHeight: CGFloat = 125
        let verticalSpacing: CGFloat = 15
        let initialYPosition: CGFloat = 125
        
        for i in 0..<numberOfRectangles {
            let noteDisplay = UIView()
            noteDisplay.backgroundColor = UIColor.lightGray
            noteDisplay.translatesAutoresizingMaskIntoConstraints = false
            mainView.addSubview(noteDisplay)
            
            // Ensure that the rectangles do not exceed the bounds of mainView
            noteDisplay.clipsToBounds = true
            
            // Center the rectangles horizontally within mainView
            noteDisplay.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
            
            // Set the top constraint based on initialYPosition and vertical spacing
            let topConstraintConstant = initialYPosition + CGFloat(i) * (rectangleHeight + verticalSpacing)
            noteDisplay.topAnchor.constraint(equalTo: mainView.topAnchor, constant: topConstraintConstant).isActive = true
            
            noteDisplay.widthAnchor.constraint(equalToConstant: rectangleWidth).isActive = true
            noteDisplay.heightAnchor.constraint(equalToConstant: rectangleHeight).isActive = true
            noteDisplay.layer.cornerRadius = 20
            
            guard let noteLabelFont = UIFont(name: "Lato-Medium", size: 32) else {
                fatalError("""
                    Failed to load the "Lato-Light" font.
                    Make sure the font file is included in the project and the font name is spelled correctly.
                    """
                )
            }
            
            guard let noteDescriptionFont = UIFont(name: "Lato-Light", size: 16) else {
                fatalError("""
                    Failed to load the "Lato-Light" font.
                    Make sure the font file is included in the project and the font name is spelled correctly.
                    """
                )
            }
            
            
            let noteLabel = UILabel()
            noteLabel.text = "Note"
            noteLabel.font = noteLabelFont
            noteLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let noteDescriptionLabel = UILabel()
            noteDescriptionLabel.text = "Note description"
            noteDescriptionLabel.font = noteDescriptionFont
            noteDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            
            noteDisplay.addSubview(noteLabel)
            noteDisplay.addSubview(noteDescriptionLabel)
            
            // Add constraints for noteLabel and noteDescriptionLabel
            NSLayoutConstraint.activate([
                noteLabel.topAnchor.constraint(equalTo: noteDisplay.topAnchor, constant: 10),
                noteLabel.leadingAnchor.constraint(equalTo: noteDisplay.leadingAnchor, constant: 10),
                noteLabel.trailingAnchor.constraint(equalTo: noteDisplay.trailingAnchor, constant: -10),
                noteLabel.heightAnchor.constraint(equalToConstant: 50),
                
                noteDescriptionLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 10),
                noteDescriptionLabel.leadingAnchor.constraint(equalTo: noteDisplay.leadingAnchor, constant: 10),
                noteDescriptionLabel.trailingAnchor.constraint(equalTo: noteDisplay.trailingAnchor, constant: -10),
                noteDescriptionLabel.heightAnchor.constraint(equalToConstant: 30),
            ])
        }
    }
}

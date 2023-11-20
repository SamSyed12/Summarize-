import UIKit

class CollectionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNotesLayout()
    }
    
    func SetUpNotesLayout() {
        // The total number of rectangles you want to display (Number will eventually be based off of number of notes that user will have.
        let numberOfRectangles = 6
        
        // The width and height of each rectangle
        let rectangleWidth: CGFloat = 328
        let rectangleHeight: CGFloat = 167
        
        // The initial X position for the first rectangle
        let initialXPosition: CGFloat = 165
        
        // Vertical spacing between rectangles
        let verticalSpacing: CGFloat = 20
        
        // Loop to create and position the rectangles with labels
        for i in 0..<numberOfRectangles {
            let xPosition = initialXPosition + (CGFloat(i) * (rectangleWidth + verticalSpacing))
            
            // Create a UIView for each rectangle
            let rectangleView = UIView(frame: CGRect(x: xPosition, y: 100, width: rectangleWidth, height: rectangleHeight))
            rectangleView.backgroundColor = UIColor.blue // Set your desired background color
            
            // Make the rectangle slightly rounded
            rectangleView.layer.cornerRadius = 10
            
            // Create the first label (font size 32)
            let label1 = UILabel(frame: CGRect(x: 10, y: 10, width: rectangleWidth - 20, height: 50))
            label1.text = "Label 1"
            label1.font = UIFont.systemFont(ofSize: 32)
            
            // Create the second label (font size 16)
            let label2 = UILabel(frame: CGRect(x: 10, y: 70, width: rectangleWidth - 20, height: 30))
            label2.text = "Label 2"
            label2.font = UIFont.systemFont(ofSize: 16)
            
            // Add labels to the rectangle view
            rectangleView.addSubview(label1)
            rectangleView.addSubview(label2)
            
            // Add the rectangle view to the main view
            view.addSubview(rectangleView)
        }
    }
}

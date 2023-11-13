import UIKit

class TranscriptionPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's background color
        view.backgroundColor = .white

        // Create a button to go back to the home screen
        let backButton = UIButton(type: .system)
        backButton.setTitle("Back to Home", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // Layout the button
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }

    @objc func backButtonTapped() {
        // Dismiss the current view controller
        dismiss(animated: true, completion: nil)
    }
}

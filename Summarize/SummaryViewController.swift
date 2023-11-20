import UIKit

class SummaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray

        // Exit Button
        let exitButton = UIButton(type: .system)
        exitButton.setTitle("Exit", for: .normal)
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)

        // Layout Exit Button
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            exitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])

        // Regenerate Button
        let regenerateButton = UIButton(type: .system)
        regenerateButton.setTitle("Regenerate", for: .normal)
        regenerateButton.addTarget(self, action: #selector(regenerateButtonTapped), for: .touchUpInside)

        // Layout Regenerate Button
        regenerateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(regenerateButton)
        NSLayoutConstraint.activate([
            regenerateButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            regenerateButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }

    @objc func exitButtonTapped() {
        // Dismiss the current view controller and navigate to the main tab bar home page
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            window.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }

    @objc func regenerateButtonTapped() {
        // Placeholder for future implementation
    }
}

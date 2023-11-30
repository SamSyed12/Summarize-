import UIKit

class SummaryViewController: UIViewController {

    var summaryLabel = UILabel()
    var transcriptionText: String?
    var completionService = OpenAICompletionService()
    
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
        
        summaryLabel.numberOfLines = 0
                summaryLabel.textAlignment = .center
                summaryLabel.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(summaryLabel)

                NSLayoutConstraint.activate([
                    summaryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
                    summaryLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                    summaryLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
                ])
    }

    @objc func exitButtonTapped() {
        // Dismiss the current view controller and navigate to the main tab bar home page
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            window.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }

    @objc func regenerateButtonTapped() {
            guard let transcriptionText = transcriptionText else { return }
            
            completionService.getSummary(for: transcriptionText) { [weak self] summary in
                DispatchQueue.main.async {
                    if let summary = summary {
                        self?.updateSummary(with: summary)
                    } else {
                        print("Failed to regenerate summary")
                    }
                }
            }
        }
    
    func updateSummary(with text: String) {
        print(text)
        print("heyo")
        summaryLabel.text = text
    }
}

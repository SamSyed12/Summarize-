import UIKit

class TranscriptionPageViewController: UIViewController {
    
    let transcriptionLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        transcriptionLabel.numberOfLines = 0 // Allows multiple lines
                transcriptionLabel.textAlignment = .center
                transcriptionLabel.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(transcriptionLabel)

        // Back Button
        let backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    
        // Layout Back Button
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
        
        
        
        // Summarize Button
        let summarizeButton = UIButton(type: .system)
        summarizeButton.setTitle("Summarize", for: .normal)
        summarizeButton.addTarget(self, action: #selector(summarizeButtonTapped), for: .touchUpInside)

        // Layout Summarize Button
        summarizeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(summarizeButton)
        NSLayoutConstraint.activate([
            summarizeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            summarizeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            // You may also add height and width constraints if needed
        ])
        
        NSLayoutConstraint.activate([
                    transcriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100), // 20 points top margin
                    transcriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                    transcriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
                ])
    }
    
    let completionService = OpenAICompletionService()

    // When the "Summarize" button is pressed
    @objc func summarizeButtonTapped() {
        let transcriptionText = transcriptionLabel.text ?? ""
        completionService.getSummary(for: transcriptionText) { summary in
            DispatchQueue.main.async {
                if let summary = summary {
                    print("Summary: \(summary)")
                    // Handle the summary (e.g., display it in the UI)
                } else {
                    print("Failed to get summary")
                }
            }
        }
    }
    
    func updateTranscription(text: String) {
            transcriptionLabel.text = text
        }

    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    
}


import UIKit

class TranscriptionPageViewController: UIViewController {
    
    let transcriptionTextView = UITextView() // Changed to UITextView
    let titleTextField = UITextField()
    let ScreenLabel = UILabel()
    let backButton = UIButton(type: .system)
    let summarizeButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Screen Label
        ScreenLabel.text = "Your Transcription"
        ScreenLabel.textAlignment = .center
        ScreenLabel.translatesAutoresizingMaskIntoConstraints = false
        ScreenLabel.font = UIFont(name: "Lato-Semibold", size: 28)
        view.addSubview(ScreenLabel)
        
        NSLayoutConstraint.activate([
            ScreenLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            ScreenLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        // Customizing Back Button
        backButton.backgroundColor = .yellow
        let chevronLeftImage = UIImage(systemName: "chevron.left")
        backButton.setImage(chevronLeftImage, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.tintColor = .black
        backButton.layer.cornerRadius = 8.0
        view.addSubview(backButton)
        
        
        // Placing Back Button
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
        ])
        
        // Customizing Summarize Button
        summarizeButton.backgroundColor = .yellow
        let chevronRightImage = UIImage(systemName: "chevron.right")
        summarizeButton.setImage(chevronRightImage, for: .normal)
        summarizeButton.layer.cornerRadius = 8.0
        summarizeButton.addTarget(self, action: #selector(summarizeButtonTapped), for: .touchUpInside)
        summarizeButton.tintColor = .black
        
        // Placing Summarize Button
        summarizeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(summarizeButton)
        
        NSLayoutConstraint.activate([
            summarizeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            summarizeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            summarizeButton.widthAnchor.constraint(equalToConstant: 50), // Adjusted width constraint if needed
            summarizeButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
        
        titleTextField.placeholder = "Add Title"
        titleTextField.font = UIFont(name: "Lato-Semibold", size: 32)
        titleTextField.layer.borderWidth = 2.0
        titleTextField.layer.borderColor = UIColor.clear.cgColor
        titleTextField.layer.cornerRadius = 5
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleTextField)
        
        // Placing TitleTextField
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: summarizeButton.bottomAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            titleTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Customizing TranscriptionTextView
        transcriptionTextView.layer.borderWidth = 2.0
        transcriptionTextView.layer.borderColor = UIColor.clear.cgColor
        transcriptionTextView.layer.cornerRadius = 5
        transcriptionTextView.text = ""
        transcriptionTextView.font = UIFont(name: "Lato-Medium", size: 20)
        transcriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        transcriptionTextView.isScrollEnabled = true
        transcriptionTextView.isUserInteractionEnabled = true
        
        view.addSubview(transcriptionTextView)
        
        NSLayoutConstraint.activate([
            transcriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: -5),
            transcriptionTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor, constant: -3),
            transcriptionTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            transcriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    let completionService = OpenAICompletionService()

    // When summarize button is pressed
    @objc func summarizeButtonTapped() {
        
        let transcriptionText = transcriptionTextView.text ?? ""
        showOverlay()
        
        completionService.getSummary(for: transcriptionText) { [weak self] summary in
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                if let summary = summary {
                    print("Summary: \(summary)")
                    
                    
                    let summaryVC = SummaryViewController()
                    summaryVC.modalTransitionStyle = .crossDissolve
                    strongSelf.present(summaryVC, animated: false, completion: nil)

                } else {
                    print("Failed to get summary")
                }
            }
        }
    }
    
    func showOverlay() {
        // Create a semi-transparent overlay view
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Adjust the alpha as needed
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        
        // Add constraints to cover the entire view
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
//        let configurationView = configurationView() // Replace with the actual view you want to present
//            configurationView.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview(configurationView)
//
//            // Add constraints to center the custom view within the view controller
//            NSLayoutConstraint.activate([
//                configurationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//                configurationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//            ])
//        }
    }
    
    func updateTranscription(text: String) {
            transcriptionTextView.text = text
        }
    
    //when backbutton is pressed
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    
}


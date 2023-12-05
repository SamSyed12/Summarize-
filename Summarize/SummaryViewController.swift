import UIKit

class SummaryViewController: UIViewController {

    let summaryTextView = UITextView() // For displaying and editing the summary
    let titleTextField = UITextField()
    let screenLabel = UILabel()
    let backButton = UIButton(type: .system)
    let summarizeButton = UIButton(type: .system)
    let saveButton = UIButton(type: .system)
    var transcriptionText: String?
    var completionService = OpenAICompletionService()
    var titleText: String?
    let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        if let titleText = titleText {
            titleTextField.text = titleText
        }
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(activityIndicator)

            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }

    private func setupUI() {
        // Screen Label
        screenLabel.text = "Summary"
        screenLabel.textAlignment = .center
        screenLabel.translatesAutoresizingMaskIntoConstraints = false
        screenLabel.font = UIFont(name: "Lato-Semibold", size: 28)
        view.addSubview(screenLabel)

        NSLayoutConstraint.activate([
            screenLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            screenLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
        let chevronRightImage = UIImage(systemName: "arrow.clockwise")
        summarizeButton.setImage(chevronRightImage, for: .normal)
        summarizeButton.layer.cornerRadius = 8.0
        summarizeButton.addTarget(self, action: #selector(summarizeButtonTapped), for: .touchUpInside)
        summarizeButton.tintColor = .black
        
        // Placing Summarize Button
        summarizeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(summarizeButton)
        
        NSLayoutConstraint.activate([
            summarizeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            summarizeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -70),
            summarizeButton.widthAnchor.constraint(equalToConstant: 50), // Adjusted width constraint if needed
            summarizeButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
        // Customizing Summarize Button
        saveButton.backgroundColor = .green
        let checkmarkImage = UIImage(systemName: "checkmark")
        saveButton.setImage(checkmarkImage, for: .normal)
        saveButton.layer.cornerRadius = 8.0
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.tintColor = .black
        
        // Placing Summarize Button
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            saveButton.widthAnchor.constraint(equalToConstant: 50), // Adjusted width constraint if needed
            saveButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
        
        
        

        // Title Text Field
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

        // Summary Text View
        summaryTextView.layer.borderWidth = 2.0
        summaryTextView.layer.borderColor = UIColor.clear.cgColor
        summaryTextView.layer.cornerRadius = 5
        summaryTextView.text = ""
        summaryTextView.font = UIFont(name: "Lato-Medium", size: 20)
        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
        summaryTextView.isScrollEnabled = true
        summaryTextView.isUserInteractionEnabled = true
        
        view.addSubview(summaryTextView)
        
        NSLayoutConstraint.activate([
            summaryTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: -5),
            summaryTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor, constant: -3),
            summaryTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            summaryTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc func summarizeButtonTapped() {
        guard let transcriptionText = transcriptionText else { return }
        activityIndicator.startAnimating()


        completionService.getSummary(for: transcriptionText) { [weak self] summary in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()

                if let summary = summary {
                    self?.summaryTextView.text = summary
                } else {
                    print("Failed to regenerate summary")
                }
            }
        }
    }

    func updateSummary(with text: String) {
        summaryTextView.text = text
    }
    
    @objc func saveButtonTapped() {
        // Dismiss the current view controller or navigate to the main screen
        view.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }
}


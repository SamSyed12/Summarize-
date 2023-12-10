import UIKit

class SummaryDetailViewController: UIViewController {

    var summaryTextView = UITextView()
    var titleTextField = UITextField()
    var screenLabel = UILabel()
    var transcriptionText: String?
    var titleText: String?
    let backButton = UIButton(type: .system)
    var summary: Summary?
    var onDismiss: (() -> Void)?
    let deleteButton = UIButton(type: .system)


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()

        if let titleText = titleText {
            titleTextField.text = titleText
        }

        if let transcriptionText = transcriptionText {
            summaryTextView.text = transcriptionText
        }
    }

    private func setupUI() {
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


        
        //screenLabel
        screenLabel.text = "Summary"
        screenLabel.textAlignment = .center
        screenLabel.translatesAutoresizingMaskIntoConstraints = false
        screenLabel.font = UIFont(name: "Lato-Semibold", size: 28)
        view.addSubview(screenLabel)

        NSLayoutConstraint.activate([
            screenLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            screenLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        // Customizing Summarize Button
        deleteButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.5) // Light red color
        let trashImage = UIImage(systemName: "trash")
        deleteButton.setImage(trashImage, for: .normal)
        deleteButton.layer.cornerRadius = 8.0
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.tintColor = .black
        
        // Placing Summarize Button
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            deleteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            deleteButton.widthAnchor.constraint(equalToConstant: 50), // Adjusted width constraint if needed
            deleteButton.heightAnchor.constraint(equalToConstant: 50)
            
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
            titleTextField.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 5),
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
        saveChanges()
        dismiss(animated: true, completion: nil)
    }

    func updateSummary(with text: String) {
        summaryTextView.text = text
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onDismiss?()
    }
    
    @objc func deleteButtonTapped() {
        guard let summaryToDelete = summary else {
            print("Summary not found.")
            return
        }

        guard let context = summaryToDelete.managedObjectContext else {
            print("Context not found.")
            return
        }

        context.delete(summaryToDelete)

        do {
            try context.save()
            print("Summary deleted successfully.")
            NotificationCenter.default.post(name: NSNotification.Name("SummaryDeleted"), object: nil)
            dismiss(animated: true, completion: nil)
        } catch {
            print("Failed to delete summary: \(error)")
        }
    }

    
//    private func saveSummaryToCoreData() {
//        guard let summaryText = summaryTextView.text, !summaryText.isEmpty,
//              let titleText = titleTextField.text, !titleText.isEmpty else {
//            print("Summary or title is empty. Not saving.")
//            return
//        }
//
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let newSummary = Summary(context: context)
//        newSummary.date = Date()
//        newSummary.text = summaryText
//        newSummary.title = titleText
//
//        do {
//            try context.save()
//            print("Summary saved successfully.")
//        } catch {
//            print("Failed to save summary: \(error)")
//        }
//    }
    
    private func saveChanges() {
        guard let summary = summary else { return }

        summary.title = titleTextField.text
        summary.text = summaryTextView.text

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        do {
            try context.save()
            print("Summary updated successfully.")
        } catch {
            print("Failed to save summary: \(error)")
        }
    }

    
}


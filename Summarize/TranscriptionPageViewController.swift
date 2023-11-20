import UIKit

class TranscriptionPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

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
        ])
    }

    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc func summarizeButtonTapped() {
        let summaryVC = SummaryViewController()
        summaryVC.modalPresentationStyle = .fullScreen
        present(summaryVC, animated: true, completion: nil)
    }
}

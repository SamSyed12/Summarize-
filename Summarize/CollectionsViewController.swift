import UIKit
import AVFAudio

class CollectionsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var recordButton: UIButton!
    var isRecording = false
    var audioRecorder: AVAudioRecorder!
    var transcriptionService = TranscriptionService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpCollectionsLayout()
        setUpNotesCollectionsTab()
        setUpAudio()
    }
    
    func setUpNotesCollectionsTab(){
        
        // create font for button
        guard let buttonFont = UIFont(name: "Lato-Medium", size: 24) else {
            fatalError("""
                Failed to load the "Lato-Light" font.
                """
            )
        }
        
        let customRect2 = CustomRectangleView(x: 240, y: 120, width: 120, height: 3.5)
        view.addSubview(customRect2)
        
        let noteTabButton = UIButton(type: .system)
        noteTabButton.setTitle("All Notes", for: .normal)
        noteTabButton.setTitleColor(UIColor.black, for: .normal)
        noteTabButton.setTitleColor(UIColor.black, for: .highlighted)
        noteTabButton.frame = CGRect(x: 37.5, y: 95, width: 100, height: 20)
        noteTabButton.addTarget(self, action: #selector(noteTabButtonTapped), for: .touchUpInside)
        noteTabButton.titleLabel?.font = buttonFont
        view.addSubview(noteTabButton)
        
        // Create the second button
        let collectionsTabButton = UIButton(type: .system)
        collectionsTabButton.setTitle("Collections", for: .normal)
        collectionsTabButton.setTitleColor(UIColor.black, for: .normal)
        collectionsTabButton.setTitleColor(UIColor.black, for: .highlighted)
        collectionsTabButton.titleLabel?.font = buttonFont
        collectionsTabButton.frame = CGRect(x: 200, y: 95, width: 200, height: 20)
        collectionsTabButton.addTarget(self, action: #selector(collectionsTabButtonTapped), for: .touchUpInside)
        view.addSubview(collectionsTabButton)
    }
    
    // Action that occurs when noteTabButton is tapped
    @objc func noteTabButtonTapped() {
        print("Note button tapped!")
        let notesVC = AllNotesViewController()
        notesVC.modalPresentationStyle = .fullScreen
        notesVC.modalTransitionStyle = .crossDissolve
        present(notesVC, animated: false, completion: nil)
        
    }
    
    // Action that occurs when collectionsTabButton is pressed.
    @objc func collectionsTabButtonTapped() {
        print("Collections button tapped!")
        
    }

    func setUpCollectionsLayout() {
        let numberOfRectangles = 5 // will be based on the number of collections held in core data
        let rectangleWidth: CGFloat = 340
        let rectangleHeight: CGFloat = 125
        let verticalSpacing: CGFloat = 15
        let initialYPosition: CGFloat = 130
        
        for i in 0..<numberOfRectangles {
            let CollectionsDisplay = UIView()
            CollectionsDisplay.backgroundColor = UIColor.yellow
            CollectionsDisplay.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(CollectionsDisplay)
            
            // Ensure that the rectangles do not exceed the bounds of mainView
            CollectionsDisplay.clipsToBounds = true
            
            // Center the rectangles horizontally within mainView
            CollectionsDisplay.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            // Set the top constraint based on initialYPosition and vertical spacing
            let topConstraintConstant = initialYPosition + CGFloat(i) * (rectangleHeight + verticalSpacing)
            CollectionsDisplay.topAnchor.constraint(equalTo: view.topAnchor, constant: topConstraintConstant).isActive = true
            
            CollectionsDisplay.widthAnchor.constraint(equalToConstant: rectangleWidth).isActive = true
            CollectionsDisplay.heightAnchor.constraint(equalToConstant: rectangleHeight).isActive = true
            CollectionsDisplay.layer.cornerRadius = 20
            
            guard let collectionsLabelFont = UIFont(name: "Lato-Medium", size: 32) else {
                fatalError("""
                    Failed to load the "Lato-Light" font.
                    """
                )
            }
            
            let collectionsLabel = UILabel()
            collectionsLabel.text = "Collection"
            collectionsLabel.font = collectionsLabelFont
            collectionsLabel.translatesAutoresizingMaskIntoConstraints = false
            collectionsLabel.textAlignment = .center
            
            CollectionsDisplay.addSubview(collectionsLabel)
            
            NSLayoutConstraint.activate([
                collectionsLabel.centerXAnchor.constraint(equalTo: CollectionsDisplay.centerXAnchor),
                collectionsLabel.centerYAnchor.constraint(equalTo: CollectionsDisplay.centerYAnchor),
                collectionsLabel.widthAnchor.constraint(equalTo: CollectionsDisplay.widthAnchor, constant: -20), // Optional: Adjust the constant based on your requirements
                collectionsLabel.heightAnchor.constraint(equalToConstant: 50),
            ])
        }
    }
    
    private func setUpAudio(){
        setupRecordButton()
        setupAudioSession()
    }
    
    private func setupRecordButton() {
        recordButton = UIButton(type: .custom)
        recordButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        recordButton.tintColor = .white
        recordButton.backgroundColor = .red
        recordButton.layer.cornerRadius = 32
        recordButton.layer.masksToBounds = true
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recordButton)
        
        NSLayoutConstraint.activate([
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 754),
            recordButton.widthAnchor.constraint(equalToConstant: 64),
            recordButton.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        view.bringSubviewToFront(recordButton)
    }
    
    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    @objc func recordButtonTapped() {
        if isRecording {
            finishRecording(success: true)
        } else {
            startRecording()
        }
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            isRecording = true
            recordButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
            audioRecorder.stop()
            audioRecorder = nil
            isRecording = false
            recordButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)

            if success {
                let audioFileURL = getDocumentsDirectory().appendingPathComponent("recording.m4a")
                transcribeAudio(audioFileURL: audioFileURL)
                let recordingStoppedVC = TranscriptionPageViewController()
                recordingStoppedVC.modalPresentationStyle = .fullScreen
                present(recordingStoppedVC, animated: true, completion: nil)
            } else {
                print("Recording was not successful.")
            }
        }

        private func transcribeAudio(audioFileURL: URL) {
            transcriptionService.transcribeAudio(fileURL: audioFileURL) { [weak self] transcription in
                DispatchQueue.main.async {
                    if let transcription = transcription {
                        print("Transcription: \(transcription)")
                        self?.updateTranscriptionViewController(with: transcription)

                        // Here you can handle the transcription, e.g., show it in a new view controller
                    } else {
                        print("Failed to transcribe audio")
                    }
                }
            }
        }

    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // MARK: - AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    private func updateTranscriptionViewController(with transcription: String) {
        if let transcriptionVC = presentedViewController as? TranscriptionPageViewController {
            transcriptionVC.updateTranscription(text: transcription)
        }
    }

}


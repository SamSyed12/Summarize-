import UIKit
import AVFAudio

class AllNotesViewController: UIViewController, AVAudioRecorderDelegate {
    
    var recordButton: UIButton!
    var isRecording = false
    var audioRecorder: AVAudioRecorder!
    var transcriptionService = TranscriptionService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpNotesLayout()
        setUpNotesCollectionsTab()
        setUpAudio()
    }
    
    func setUpNotesCollectionsTab(){
        
        // create font for button
        guard let buttonFont = UIFont(name: "Lato-Medium", size: 24) else {
            fatalError("""
                Failed to load the "Lato-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        let customRect1 = CustomRectangleView(x: 30, y: 120, width: 120, height: 3.5)
        view.addSubview(customRect1)
        
        
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
    }
    
    // Action that occurs when collectionsTabButton is pressed.
    @objc func collectionsTabButtonTapped() {
        print("Collections button tapped!")
        let collectionsVC = CollectionsViewController()
        collectionsVC.modalPresentationStyle = .fullScreen
        collectionsVC.modalTransitionStyle = .crossDissolve
        present(collectionsVC, animated: false, completion: nil)
        
    }

    func setUpNotesLayout() {
        let numberOfRectangles = 5 // will be based on the number of notes held in core data
        let rectangleWidth: CGFloat = 340
        let rectangleHeight: CGFloat = 125
        let verticalSpacing: CGFloat = 15
        let initialYPosition: CGFloat = 130
        
        for i in 0..<numberOfRectangles {
            let noteDisplay = UIView()
            noteDisplay.backgroundColor = UIColor.yellow
            noteDisplay.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(noteDisplay)
            
            // Ensure that the rectangles do not exceed the bounds of mainView
            noteDisplay.clipsToBounds = true
            
            // Center the rectangles horizontally within mainView
            noteDisplay.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            // Set the top constraint based on initialYPosition and vertical spacing
            let topConstraintConstant = initialYPosition + CGFloat(i) * (rectangleHeight + verticalSpacing)
            noteDisplay.topAnchor.constraint(equalTo: view.topAnchor, constant: topConstraintConstant).isActive = true
            
            noteDisplay.widthAnchor.constraint(equalToConstant: rectangleWidth).isActive = true
            noteDisplay.heightAnchor.constraint(equalToConstant: rectangleHeight).isActive = true
            noteDisplay.layer.cornerRadius = 20
            
            guard let noteLabelFont = UIFont(name: "Lato-Medium", size: 32) else {
                fatalError("""
                    Failed to load the "Lato-Light" font.
                    Make sure the font file is included in the project and the font name is spelled correctly.
                    """
                )
            }
            
            guard let noteDescriptionFont = UIFont(name: "Lato-Light", size: 16) else {
                fatalError("""
                    Failed to load the "Lato-Light" font.
                    Make sure the font file is included in the project and the font name is spelled correctly.
                    """
                )
            }
            
            
            let noteLabel = UILabel()
            noteLabel.text = "Note"
            noteLabel.font = noteLabelFont
            noteLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let noteDescriptionLabel = UILabel()
            noteDescriptionLabel.text = "Note description"
            noteDescriptionLabel.font = noteDescriptionFont
            noteDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            
            noteDisplay.addSubview(noteLabel)
            noteDisplay.addSubview(noteDescriptionLabel)
            
            // Add constraints for noteLabel and noteDescriptionLabel
            NSLayoutConstraint.activate([
                noteLabel.topAnchor.constraint(equalTo: noteDisplay.topAnchor, constant: 10),
                noteLabel.leadingAnchor.constraint(equalTo: noteDisplay.leadingAnchor, constant: 10),
                noteLabel.trailingAnchor.constraint(equalTo: noteDisplay.trailingAnchor, constant: -10),
                noteLabel.heightAnchor.constraint(equalToConstant: 50),
                
                noteDescriptionLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 10),
                noteDescriptionLabel.leadingAnchor.constraint(equalTo: noteDisplay.leadingAnchor, constant: 10),
                noteDescriptionLabel.trailingAnchor.constraint(equalTo: noteDisplay.trailingAnchor, constant: -10),
                noteDescriptionLabel.heightAnchor.constraint(equalToConstant: 30),
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


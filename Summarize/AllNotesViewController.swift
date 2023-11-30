import UIKit
import AVFAudio

class AllNotesViewController: UIViewController, AVAudioRecorderDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var recordButton: UIButton!
    var isRecording = false
    var audioRecorder: AVAudioRecorder!
    var transcriptionService = TranscriptionService()
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpTableView()
        registerTableViewCells()
        setUpNotesCollectionsTab()
        setUpAudio()
    }
    
    private func registerTableViewCells() {
           tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: "NoteCell")
       }
    

    private func setUpTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 122.5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:16), // Adjust the leading constant
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-16), // Adjust the trailing constant
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 10 // Adjust the number of rows based on your data
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
            // Configure the cell with your data
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Handle the selection of a row
            print("Row \(indexPath.row) selected")
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
        
        view.bringSubviewToFront(customRect1)
        view.bringSubviewToFront(noteTabButton)
        view.bringSubviewToFront(collectionsTabButton)
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



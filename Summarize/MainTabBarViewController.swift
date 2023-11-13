import UIKit
import AVFoundation

class MainTabBarController: UITabBarController, AVAudioRecorderDelegate {
    
    var recordButton: UIButton!
    var isRecording = false
    var audioRecorder: AVAudioRecorder!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstVC = AllNotesViewController()
        firstVC.tabBarItem = UITabBarItem(title: "First", image: UIImage(systemName: "1.circle"), tag: 0)

        let secondVC = CollectionsViewController()
        secondVC.tabBarItem = UITabBarItem(title: "Second", image: UIImage(systemName: "2.circle"), tag: 1)

        
        self.viewControllers = [firstVC, secondVC]

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
        
        // Use Auto Layout to place the record button
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recordButton)
        
        NSLayoutConstraint.activate([
            recordButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            recordButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: -32),
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
            // Handle the error of setting up the audio session.
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
            let recordingStoppedVC = TranscriptionPageViewController()
            recordingStoppedVC.modalPresentationStyle = .fullScreen
            present(recordingStoppedVC, animated: true, completion: nil)
        } else {
            // Handle recording failure
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
    

}

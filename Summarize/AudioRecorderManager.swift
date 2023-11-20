import AVFoundation

class AudioRecorderManager: NSObject, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder?
    var audioRecordingSession: AVAudioSession?
    var isRecording = false

    override init() {
        super.init()
        setupRecorder()
    }

    private func setupRecorder() {
        audioRecordingSession = AVAudioSession.sharedInstance()

        do {
            try audioRecordingSession?.setCategory(.playAndRecord, mode: .default)
            try audioRecordingSession?.setActive(true)
            audioRecordingSession?.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.prepareRecorder()
                    } else {
                        // Handle the failure to gain permission
                    }
                }
            }
        } catch {
            // Handle the error if setting up the audio session fails
        }
    }

    private func prepareRecorder() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.prepareToRecord()
        } catch {
            // Handle error in setting up the recorder
        }
    }

    func startRecording() {
        guard let audioRecorder = audioRecorder, !audioRecorder.isRecording else { return }
        audioRecorder.record()
        isRecording = true
    }

    func stopRecording(completion: @escaping (Data?) -> Void) {
        guard let audioRecorder = audioRecorder, audioRecorder.isRecording else { return }
        audioRecorder.stop()
        isRecording = false

        // Fetch the recorded audio data
        do {
            let data = try Data(contentsOf: audioRecorder.url)
            completion(data)
        } catch {
            // Handle error in fetching the audio data
            completion(nil)
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

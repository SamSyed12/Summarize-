import Foundation

class TranscriptionService {
    // Replace with your actual API key
    private let apiKey = "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"

    func transcribeAudio(fileURL: URL, completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://api.openai.com/v1/audio/transcriptions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        var body = Data()

        // Add the audio file part
        if let audioData = try? Data(contentsOf: fileURL) {
            let audioFilename = fileURL.lastPathComponent
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(audioFilename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(contentType(for: audioFilename))\r\n\r\n".data(using: .utf8)!)
            body.append(audioData)
            body.append("\r\n".data(using: .utf8)!)
        }

        // Add the model part
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        body.append("whisper-1\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        print("Error during HTTP request: \(error?.localizedDescription ?? "Unknown error")")
                        completion(nil)
                        return
                    }

                    do {
                        let transcriptionResult = try JSONDecoder().decode(TranscriptionResponse.self, from: data)
                        completion(transcriptionResult.text)
                    } catch {
                        print("Error decoding transcription response: \(error)")
                        completion(nil)
                    }
                }
                task.resume()
    }

    private func contentType(for filename: String) -> String {
        // You can extend this function to handle different file types
        return "audio/mpeg"
    }
    

}

struct TranscriptionResponse: Codable {
    let text: String
}

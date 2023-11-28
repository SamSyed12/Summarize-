import Foundation

class OpenAICompletionService {
    
    func getSummary(for text: String, completion: @escaping (String?) -> Void) {
        // Prepare the URL and URLRequest
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            print("Invalid URL")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Prepare the JSON body
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "Summarize the following text with 3-5 sentences."],
                ["role": "user", "content": text]
            ]
        ]

        // Convert body to JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Failed to encode request body")
            completion(nil)
            return
        }

        request.httpBody = jsonData

        // Perform the network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        print("Error during HTTP request: \(error?.localizedDescription ?? "Unknown error")")
                        completion(nil)
                        return
                    }

                    // Parse the JSON response
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let choices = jsonResult["choices"] as? [[String: Any]],
                           let firstChoice = choices.first,
                           let message = firstChoice["message"] as? [String: Any],
                           let summary = message["content"] as? String {
                            completion(summary)
                        } else {
                            print("Invalid response format")
                            completion(nil)
                        }
                    } catch {
                        print("Error decoding response: \(error)")
                        completion(nil)
                    }
                }
                task.resume()
    }
}

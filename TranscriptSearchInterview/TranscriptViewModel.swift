//
//  TranscriptViewModel.swift
//  TranscriptSearchInterview
//
//  Created by Baurzhan on 10/24/25.
//

import Foundation

enum CustomErrors: Error {
    case invalidURL
    case errorResponse
}

enum ViewState {
    case loading, empty, loaded
}

@Observable
class TranscriptViewModel {
    var transcripts: [Transcript] = []
    var searchText: String = ""
    var answer: String = ""
    var questionResponseViewState = ViewState.empty
    @ObservationIgnored private var searchTask: Task<Void, Never>?
    
    func loadTranscripts() {
        guard let url = Bundle.main.url(forResource: "Transcripts", withExtension: "json") else {
            print("JSON file not found")
            return
        }
            
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([Transcript].self, from: data)
            
            transcripts = jsonData
        } catch {
            print("Error loading JSON: \(error)")
        }
    }
    
    func search() -> [Transcript] {
        if searchText.isEmpty {
            return transcripts
        }
        
        return transcripts.filter { transcript in
            transcript.text.localizedCaseInsensitiveContains(searchText) ||
            transcript.application.localizedCaseInsensitiveContains(searchText) ||
            transcript.windowName.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func getDebouncedIsQuestion() {
        searchTask?.cancel()
                
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            
            guard !Task.isCancelled else { return }
            
            try? await getIsQuestion()
        }
    }
    
    // https://ts-endpoint.vercel.app/is-question
    func getIsQuestion() async throws {
        guard let url = URL(string: "https://ts-endpoint.vercel.app/is-question") else {
            throw CustomErrors.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["text": searchText]
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw CustomErrors.errorResponse
            }
            
            if let decoded = try? JSONDecoder().decode(QuestionResponse.self, from: data) {
                if decoded.question {
                    
                    await MainActor.run {
                        questionResponseViewState = .loading
                    }
                    
                    try? await answerQuestion()
                }
            }
        } catch {
            print("error: \(error)")
        }
    }
    
    func answerQuestion() async throws {
        print("answerQuestion")
        guard let url = URL(string: "https://ts-endpoint.vercel.app/answer-question") else {
            throw CustomErrors.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Gather all transcript text as context
        let context = transcripts.map { $0.text }.joined(separator: "\n")
        
        let body = [
            "question": searchText,
            "context": context
        ]
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw CustomErrors.errorResponse
        }
        print("here")
        // Decode and handle response
        let decoded = try JSONDecoder().decode(AnswerResponse.self, from: data)
        print("decoded")
        await MainActor.run {
            questionResponseViewState = .loaded
            print("anser: \(decoded.answer)")
            answer = decoded.answer
        }
    }
}

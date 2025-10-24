//
//  types.swift
//  TranscriptSearchInterview
//
//  Created by Lawrence Liu on 8/5/25.
//
import Foundation

struct Transcript: Identifiable, Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case date
        case application
        case windowName
    }
    
    let id: String
    let text: String
    let date: Date
    let application: String
    let windowName: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        application = try container.decode(String.self, forKey: .application)
        windowName = try container.decode(String.self, forKey: .windowName)
        
        // Decode date from string
        let dateString = try container.decode(String.self, forKey: .date)
        let formatter = ISO8601DateFormatter()
        
        if let parsedDate = formatter.date(from: dateString) {
            date = parsedDate
        } else {
            // Fallback for other date formats
            let fallbackFormatter = DateFormatter()
            fallbackFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // adjust to your format
            
            if let parsedDate = fallbackFormatter.date(from: dateString) {
                date = parsedDate
            } else {
                throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Date string does not match expected format")
            }
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


struct RuntimeError: LocalizedError {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var errorDescription: String? {
        description
    }
}


struct QuestionResponse: Codable {
    var question: Bool
}

struct AnswerResponse: Codable {
    var answer: String
}

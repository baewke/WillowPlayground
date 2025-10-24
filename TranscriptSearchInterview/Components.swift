//
//  Components.swift
//  TranscriptSearchInterview
//
//  Created by Lawrence Liu on 8/6/25.
//
import SwiftUI


struct TranscriptRow: View {
    let transcript: Transcript
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(transcript.application)
                    .font(.system(size: 12, weight: .medium))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.gray.opacity(0.2))
                    )
                
                Spacer()
                
                Text(transcript.formattedDate)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.gray)
            }
            
            Text(transcript.text)
                .font(.system(size: 14))
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}


struct SearchBar: View {
    @Binding var searchText: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search transcripts...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .focused($isFocused)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 0.5)
                .opacity(isFocused ? 1 : 0.3)
        )
        .padding(.horizontal, 16)
        .frame(maxWidth: 280)
    }

}

//
//  TranscriptView.swift
//  TranscriptSearchInterview
//
//  Created by Lawrence Liu on 8/17/25.
//

import Foundation
import SwiftUI

struct TranscriptView: View {
    @State private var viewModel = TranscriptViewModel()
    
    var body: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchText)
                .onChange(of: viewModel.searchText) {
                    viewModel.getDebouncedIsQuestion()
                }
            
            answerView
            
            ScrollView {
                ForEach(viewModel.search()) { transcript in
                    TranscriptRow(transcript: transcript)
                }
            }
        }
        .onAppear {
            viewModel.loadTranscripts()
        }
    }
    
    private var answerView: some View {
        Group {
            switch viewModel.questionResponseViewState {
            case .empty:
                EmptyView()
            case .loaded:
                Text(viewModel.answer)
                    .padding()
            case .loading:
                ProgressView()
                    .padding()
            }
        }
    }
}

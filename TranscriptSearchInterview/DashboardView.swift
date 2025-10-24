//
//  ContentView.swift
//  TranscriptSearchInterview
//
//  Created by Lawrence Liu on 8/5/25.
//

import SwiftUI

struct DashboardView: View {
    @State var selectedTab = SidebarSelection.home
    
    var body: some View {
        HStack(alignment: .center, spacing: 24) {
        
        SidebarView(selection: $selectedTab)
            
        switch selectedTab {
            
            case .home:
                HStack{
                    Image(systemName: "magnifyingglass")
                        .imageScale(.large)
                        .foregroundStyle(.green)
                    Text("Welcome to Transcript Searcher :)")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .transcripts:
                TranscriptView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .preferredColorScheme(.light)
    }
}

#Preview {
    DashboardView()
}


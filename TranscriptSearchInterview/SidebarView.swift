//
//  SidebarView.swift
//  TranscriptSearchInterview
//
//  Created by Lawrence Liu on 8/5/25.
//

import Foundation
import SwiftUI


enum SidebarSelection: String, Identifiable, CaseIterable {
    case home
    case transcripts
    
    var id: String { rawValue }
}

struct SidebarView: View {
    
    @Binding var selection: SidebarSelection
    
    var body: some View {
        HStack {
            
            VStack {
                
                ForEach(SidebarSelection.allCases) { tab in
                    Button(action: {selection = tab}) {
                        Text(tab.rawValue.capitalized)

  
                    }
                    .buttonStyle(SidebarButtonStyle())
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.black.opacity(tab == selection ? 0.2 : 0))    
                    )
                }
                
                
                Spacer()
            }
            .padding(8)
            
            Rectangle()
                .frame(width: 1)
                .foregroundColor(Color("Black")).opacity(0.3)
            
        }

    }
}


struct SidebarButtonStyle: ButtonStyle {
    @State private var isHovering = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 36)
            .padding(8)
            .frame(width: 96)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.black.opacity(isHovering ? 0.05 : 0))
            )
            .shadow(color: .black.opacity(isHovering ? 0.12 : 0.08), radius: isHovering ? 3 : 2, y: isHovering ? 1 : 0.5)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
            .animation(.easeOut(duration: 0.15), value: isHovering)
            .onHover { hovering in
                isHovering = hovering
            }
    }
}

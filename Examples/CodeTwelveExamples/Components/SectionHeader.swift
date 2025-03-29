//
//  SectionHeader.swift
//  CodeTwelveExamples
//
//  Created on 29/03/25.
//

import SwiftUI
import CodetwelveUI

/// A header component for sections with optional code toggle functionality.
public struct SectionHeader: View {
    let title: String
    @Binding var showCode: Bool
    
    public init(title: String, showCode: Binding<Bool>) {
        self.title = title
        self._showCode = showCode
    }
    
    public var body: some View {
        HStack {
            Text(title)
                .ctHeading3()
            
            Spacer()
            
            Button(action: {
                showCode.toggle()
            }) {
                Image(systemName: "chevron.right")
                    .rotationEffect(.degrees(showCode ? 90 : 0))
                    .imageScale(.small)
                Text(showCode ? "Hide Code" : "Show Code")
                    .ctCaption()
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, CTSpacing.s)
            .padding(.vertical, CTSpacing.xxs)
            .background(Color.ctSecondary.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

// MARK: - Previews

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: CTSpacing.m) {
            SectionHeader(title: "Basic Usage", showCode: .constant(false))
            SectionHeader(title: "Advanced Features", showCode: .constant(true))
        }
        .padding()
    }
} 
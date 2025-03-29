import SwiftUI
import CodetwelveUI

/// A button that toggles the visibility of code examples
struct ToggleCodeButton: View {
    @Binding var isExpanded: Bool
    
    var body: some View {
        Button(action: {
            withAnimation {
                isExpanded.toggle()
            }
        }) {
            HStack {
                Text(isExpanded ? "Hide code" : "Show code")
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            }
            .font(.footnote)
            .foregroundColor(.accentColor)
        }
    }
}

/// A view that displays code examples in a monospaced font
struct CodePreview: View {
    let code: String
    
    init(_ code: String) {
        self.code = code
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(code)
                .font(.system(.footnote, design: .monospaced))
                .padding(8)
        }
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
    }
} 

/// A header for each section with optional code toggle
struct SectionHeader: View {
    let title: String
    @Binding var showCode: Bool
    
    var body: some View {
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

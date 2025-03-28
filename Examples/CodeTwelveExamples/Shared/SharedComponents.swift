import SwiftUI

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
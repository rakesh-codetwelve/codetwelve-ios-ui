import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Text("Welcome to CodeTwelve UI")
                .font(.title)
        }
        .padding()
    }
}

#Preview {
    ContentView()
} 

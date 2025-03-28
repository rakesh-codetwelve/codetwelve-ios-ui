import SwiftUI
import CodetwelveUI

struct ComponentCatalog: View {
    var body: some View {
        NavigationView {
            List {
                Section("Basic Components") {
                    NavigationLink("Buttons", destination: ButtonExamples())
                    NavigationLink("Icons", destination: IconExamples())
                    NavigationLink("Text", destination: TextExamples())
                    NavigationLink("Dividers", destination: DividerExamples())
                }
                
                Section("Layout Components") {
                    NavigationLink("Stack", destination: StackExamples())
                    NavigationLink("Container", destination: ContainerExamples())
                    NavigationLink("Card", destination: CardExamples())
                    NavigationLink("Grid", destination: GridExamples())
                }
                
                Section("Form Components") {
                    NavigationLink("Text Fields", destination: TextFieldExamples())
                    NavigationLink("Checkboxes", destination: CheckboxExamples())
                    NavigationLink("Radio Groups", destination: RadioGroupExamples())
                    NavigationLink("Toggles", destination: ToggleExamples())
                }
                
                Section("Feedback Components") {
                    NavigationLink("Alerts", destination: AlertExamples())
                    NavigationLink("Toast", destination: ToastExamples())
                    NavigationLink("Progress", destination: ProgressExamples())
                }
            }
            .navigationTitle("Codetwelve UI")
        }
    }
}

struct ButtonExamples: View {
    var body: some View {
        Text("Button Examples Coming Soon")
    }
}

struct IconExamples: View {
    var body: some View {
        Text("Icon Examples Coming Soon")
    }
}

struct TextExamples: View {
    var body: some View {
        Text("Text Examples Coming Soon")
    }
}

struct DividerExamples: View {
    var body: some View {
        Text("Divider Examples Coming Soon")
    }
}

struct StackExamples: View {
    var body: some View {
        Text("Stack Examples Coming Soon")
    }
}

struct ContainerExamples: View {
    var body: some View {
        Text("Container Examples Coming Soon")
    }
}

struct CardExamples: View {
    var body: some View {
        Text("Card Examples Coming Soon")
    }
}

struct GridExamples: View {
    var body: some View {
        Text("Grid Examples Coming Soon")
    }
}

struct TextFieldExamples: View {
    var body: some View {
        Text("TextField Examples Coming Soon")
    }
}

struct CheckboxExamples: View {
    var body: some View {
        Text("Checkbox Examples Coming Soon")
    }
}

struct RadioGroupExamples: View {
    var body: some View {
        Text("Radio Group Examples Coming Soon")
    }
}

struct ToggleExamples: View {
    var body: some View {
        Text("Toggle Examples Coming Soon")
    }
}

struct AlertExamples: View {
    var body: some View {
        Text("Alert Examples Coming Soon")
    }
}

struct ToastExamples: View {
    var body: some View {
        Text("Toast Examples Coming Soon")
    }
}

struct ProgressExamples: View {
    var body: some View {
        Text("Progress Examples Coming Soon")
    }
}

#Preview {
    ComponentCatalog()
} 
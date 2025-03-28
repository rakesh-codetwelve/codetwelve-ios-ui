//
//  BadgeExamples.swift
//  CodeTwelveExamples
//
//  Created on 28/03/25.
//

import SwiftUI
import CodetwelveUI

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

/// Badge content enum for switching between numeric and text content
enum BadgeContent: Equatable {
    case number(Int)
    case text(String)
    
    var isNumber: Bool {
        if case .number = self {
            return true
        }
        return false
    }
    
    var isText: Bool {
        if case .text = self {
            return true
        }
        return false
    }
}

/// A simple implementation of a badge component
struct CTBadge: View {
    // MARK: - Properties
    
    private let content: BadgeContent
    private let size: CTBadgeSize
    private let style: CTBadgeStyle
    private let isCircular: Bool
    private let isPulsing: Bool
    
    @State private var isAnimating = false
    
    // MARK: - Initialization
    
    init(_ number: Int, 
         size: CTBadgeSize = .medium,
         style: CTBadgeStyle = .primary,
         isCircular: Bool = true,
         isPulsing: Bool = false) {
        self.content = .number(number)
        self.size = size
        self.style = style
        self.isCircular = isCircular
        self.isPulsing = isPulsing
    }
    
    init(_ text: String,
         size: CTBadgeSize = .medium,
         style: CTBadgeStyle = .primary,
         isCircular: Bool = false,
         isPulsing: Bool = false) {
        self.content = .text(text)
        self.size = size
        self.style = style
        self.isCircular = isCircular
        self.isPulsing = isPulsing
    }
    
    // MARK: - Body
    
    var body: some View {
        contentView
            .padding(size.padding)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .clipShape(isCircular ? AnyShape(Circle()) : AnyShape(RoundedRectangle(cornerRadius: 8)))
            .scaleEffect(isAnimating ? 1.2 : 1.0)
            .opacity(isAnimating ? 0.8 : 1.0)
            .animation(isPulsing ? Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true) : .none, value: isAnimating)
            .onAppear {
                if isPulsing {
                    isAnimating = true
                }
            }
    }
    
    // MARK: - Private Views and Properties
    
    private var contentView: some View {
        Group {
            switch content {
            case .number(let number):
                if number > 99 {
                    Text("99+")
                        .font(size.font)
                        .fontWeight(.semibold)
                } else {
                    Text("\(number)")
                        .font(size.font)
                        .fontWeight(.semibold)
                }
            case .text(let text):
                Text(text)
                    .font(size.font)
                    .fontWeight(.semibold)
            }
        }
        .lineLimit(1)
        .minimumScaleFactor(0.8)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return .blue
        case .secondary:
            return .gray
        case .success:
            return .green
        case .warning:
            return .orange
        case .error:
            return .red
        case .info:
            return .teal
        case .custom(let backgroundColor, _):
            return backgroundColor
        }
    }
    
    private var textColor: Color {
        switch style {
        case .custom(_, let textColor):
            return textColor
        default:
            return .white
        }
    }
}

/// Badge style options
enum CTBadgeStyle: Hashable, Equatable {
    case primary
    case secondary
    case success
    case warning
    case error
    case info
    case custom(backgroundColor: Color, textColor: Color)
    
    static func == (lhs: CTBadgeStyle, rhs: CTBadgeStyle) -> Bool {
        switch (lhs, rhs) {
        case (.primary, .primary),
             (.secondary, .secondary),
             (.success, .success),
             (.warning, .warning),
             (.error, .error),
             (.info, .info):
            return true
        case (.custom, .custom):
            // For custom styles, we consider them equal for the purpose of UI updates
            // A proper implementation would compare the colors
            return true
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .primary:
            hasher.combine(0)
        case .secondary:
            hasher.combine(1)
        case .success:
            hasher.combine(2)
        case .warning:
            hasher.combine(3)
        case .error:
            hasher.combine(4)
        case .info:
            hasher.combine(5)
        case .custom:
            hasher.combine(6)
        }
    }
}

/// Badge size options
enum CTBadgeSize: String, CaseIterable, Identifiable, Hashable {
    case small
    case medium
    case large
    
    var id: String { rawValue }
    
    var padding: EdgeInsets {
        switch self {
        case .small:
            return EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6)
        case .medium:
            return EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        case .large:
            return EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10)
        }
    }
    
    var font: Font {
        switch self {
        case .small:
            return .caption2
        case .medium:
            return .caption
        case .large:
            return .subheadline
        }
    }
}

/// A view that showcases CTBadge component examples
///
/// This view demonstrates different aspects of the CTBadge component:
/// - Badge with numeric values
/// - Badge with text content
/// - Different badge sizes
/// - Different badge styles
/// - Custom styling options
/// - Usage examples in common scenarios
struct BadgeExamples: View {
    // MARK: - State Properties
    
    @State private var selectedContent: BadgeContent = .number(5)
    @State private var selectedSize: CTBadgeSize = .medium
    @State private var selectedStyle: CTBadgeStyle = .primary
    @State private var isCircular: Bool = true
    @State private var isPulsing: Bool = false
    @State private var showCode: Bool = false
    @State private var customBackgroundColor: Color = .purple
    @State private var customTextColor: Color = .white
    @State private var badgeNumberFloat: Double = 5
    @State private var badgeTextValue: String = "New"
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Basic usage
                basicUsageSection
                
                Divider()
                
                // Styles showcase
                stylesSection
                
                Divider()
                
                // Sizes showcase
                sizesSection
                
                Divider()
                
                // Shapes showcase
                shapesSection
                
                Divider()
                
                // Animations showcase
                animationsSection
                
                Divider()
                
                // Interactive badge builder
                interactiveBadgeBuilderSection
            }
            .padding()
        }
        .navigationTitle("Badge")
    }
    
    // MARK: - Content Sections
    
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Basic Usage").font(.headline)
            
            Text("Badges are used to highlight information like counts or status.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("With numbers:")
                HStack(spacing: 16) {
                    CTBadge(1)
                    CTBadge(5)
                    CTBadge(99)
                    CTBadge(999) // Shows how overflow is handled
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("With text:")
                HStack(spacing: 16) {
                    CTBadge("New")
                    CTBadge("Hot")
                    CTBadge("Featured")
                    CTBadge("Premium")
                }
            }
            
            if showCode {
                CodePreview("""
                // Number badges
                CTBadge(1)
                CTBadge(5)
                CTBadge(99)
                
                // Text badges
                CTBadge("New")
                CTBadge("Hot")
                CTBadge("Featured")
                """)
            }
            
            ToggleCodeButton(isExpanded: $showCode)
        }
    }
    
    private var stylesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Styles").font(.headline)
            
            Text("Badges come in different predefined styles or can be customized.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 12) {
                styleBadgeRow(style: .primary, name: "Primary")
                styleBadgeRow(style: .secondary, name: "Secondary")
                styleBadgeRow(style: .success, name: "Success")
                styleBadgeRow(style: .warning, name: "Warning")
                styleBadgeRow(style: .error, name: "Error") 
                styleBadgeRow(style: .info, name: "Info")
                
                HStack {
                    Text("Custom: ")
                        .frame(width: 100, alignment: .leading)
                    
                    CTBadge("Custom", style: .custom(backgroundColor: .purple, textColor: .white))
                    CTBadge(5, style: .custom(backgroundColor: .purple, textColor: .white))
                }
            }
            
            if showCode {
                CodePreview("""
                CTBadge("Primary", style: .primary)
                CTBadge("Secondary", style: .secondary)
                CTBadge("Success", style: .success)
                CTBadge("Warning", style: .warning)
                CTBadge("Error", style: .error)
                CTBadge("Info", style: .info)
                
                // Custom style
                CTBadge("Custom", style: .custom(backgroundColor: .purple, textColor: .white))
                """)
            }
        }
    }
    
    private var sizesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sizes").font(.headline)
            
            Text("Badges are available in different sizes.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center, spacing: 16) {
                    Text("Small:")
                        .frame(width: 100, alignment: .leading)
                    
                    CTBadge(5, size: .small)
                    CTBadge("Small", size: .small)
                }
                
                HStack(alignment: .center, spacing: 16) {
                    Text("Medium:")
                        .frame(width: 100, alignment: .leading)
                    
                    CTBadge(5, size: .medium)
                    CTBadge("Medium", size: .medium)
                }
                
                HStack(alignment: .center, spacing: 16) {
                    Text("Large:")
                        .frame(width: 100, alignment: .leading)
                    
                    CTBadge(5, size: .large)
                    CTBadge("Large", size: .large)
                }
            }
            
            if showCode {
                CodePreview("""
                // Small
                CTBadge(5, size: .small)
                CTBadge("Small", size: .small)
                
                // Medium
                CTBadge(5, size: .medium)
                CTBadge("Medium", size: .medium)
                
                // Large
                CTBadge(5, size: .large)
                CTBadge("Large", size: .large)
                """)
            }
        }
    }
    
    private var shapesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Shapes").font(.headline)
            
            Text("Badges can be circular or rounded rectangle shaped.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center, spacing: 16) {
                    Text("Circular:")
                        .frame(width: 100, alignment: .leading)
                    
                    CTBadge(5, isCircular: true)
                    CTBadge("5", isCircular: true)
                    CTBadge("New", isCircular: true)
                }
                
                HStack(alignment: .center, spacing: 16) {
                    Text("Rounded:")
                        .frame(width: 100, alignment: .leading)
                    
                    CTBadge(5, isCircular: false)
                    CTBadge("5", isCircular: false)
                    CTBadge("New", isCircular: false)
                }
            }
            
            if showCode {
                CodePreview("""
                // Circular
                CTBadge(5, isCircular: true)
                CTBadge("New", isCircular: true)
                
                // Rounded rectangle
                CTBadge(5, isCircular: false)
                CTBadge("New", isCircular: false)
                """)
            }
        }
    }
    
    private var animationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Animations").font(.headline)
            
            Text("Badges can pulse to draw attention.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 16) {
                VStack(spacing: 8) {
                    Text("Static")
                    CTBadge(5, isPulsing: false)
                }
                
                VStack(spacing: 8) {
                    Text("Pulsing")
                    CTBadge(5, isPulsing: true)
                }
            }
            .padding()
            
            if showCode {
                CodePreview("""
                // Static badge
                CTBadge(5, isPulsing: false)
                
                // Pulsing badge
                CTBadge(5, isPulsing: true)
                """)
            }
        }
    }
    
    private var interactiveBadgeBuilderSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Badge Builder").font(.headline)
            
            Text("Try different badge combinations:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Preview of the badge
            HStack {
                Spacer()
                badgePreview
                Spacer()
            }
            .padding(.vertical, 24)
            
            // Configuration options
            VStack(alignment: .leading, spacing: 16) {
                // Content type
                contentTypeSelector
                
                // Size picker
                sizePicker
                
                // Style picker
                stylePicker
                
                // Shape toggle
                shapeToggle
                
                // Animation toggle
                animationToggle
                
                // Custom colors if showing custom style
                if selectedStyle == .custom(backgroundColor: customBackgroundColor, textColor: customTextColor) {
                    customColorPickers
                }
            }
            
            // Code preview
            generatedCodePreview
                .padding(.top, 16)
        }
    }
    
    // MARK: - Helper Views
    
    private func styleBadgeRow(style: CTBadgeStyle, name: String) -> some View {
        HStack {
            Text("\(name): ")
                .frame(width: 100, alignment: .leading)
            
            CTBadge(name, style: style)
            CTBadge(5, style: style)
        }
    }
    
    private var badgePreview: some View {
        Group {
            switch selectedContent {
            case .number(let value):
                CTBadge(
                    value,
                    size: selectedSize,
                    style: customStyleValue,
                    isCircular: isCircular,
                    isPulsing: isPulsing
                )
            case .text(let text):
                CTBadge(
                    text,
                    size: selectedSize,
                    style: customStyleValue,
                    isCircular: isCircular,
                    isPulsing: isPulsing
                )
            }
        }
    }
    
    private var customStyleValue: CTBadgeStyle {
        if selectedStyle == .custom(backgroundColor: .purple, textColor: .white) {
            return .custom(backgroundColor: customBackgroundColor, textColor: customTextColor)
        }
        return selectedStyle
    }
    
    private var contentTypeSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Content:")
                .font(.headline)
            
            HStack {
                Button(action: {
                    selectedContent = .number(5)
                }) {
                    HStack {
                        Image(systemName: "number")
                        Text("Number")
                    }
                    .padding(8)
                    .background(selectedContent.isNumber ? Color.accentColor.opacity(0.2) : Color.secondary.opacity(0.1))
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    selectedContent = .text("Badge")
                }) {
                    HStack {
                        Image(systemName: "text.badge")
                        Text("Text")
                    }
                    .padding(8)
                    .background(selectedContent.isText ? Color.accentColor.opacity(0.2) : Color.secondary.opacity(0.1))
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // If number, show a slider
            if case .number = selectedContent {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Value: \(badgeNumberValue)")
                        .font(.caption)
                    
                    Slider(value: $badgeNumberFloat, in: 0...99, step: 1)
                        .onChange(of: badgeNumberFloat) { _ in
                            updateBadgeNumber()
                        }
                }
                .padding(.vertical, 8)
            }
            
            // If text, show a textfield
            if case .text = selectedContent {
                TextField("Badge text", text: $badgeTextValue)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .onChange(of: badgeTextValue) { _ in
                        updateBadgeText()
                    }
            }
        }
    }
    
    private var sizePicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Size:")
                .font(.headline)
            
            Picker("Size", selection: $selectedSize) {
                Text("Small").tag(CTBadgeSize.small)
                Text("Medium").tag(CTBadgeSize.medium)
                Text("Large").tag(CTBadgeSize.large)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    private var stylePicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Style:")
                .font(.headline)
            
            Picker("Style", selection: $selectedStyle) {
                Text("Primary").tag(CTBadgeStyle.primary)
                Text("Secondary").tag(CTBadgeStyle.secondary)
                Text("Success").tag(CTBadgeStyle.success)
                Text("Warning").tag(CTBadgeStyle.warning)
                Text("Error").tag(CTBadgeStyle.error)
                Text("Info").tag(CTBadgeStyle.info)
                Text("Custom").tag(CTBadgeStyle.custom(backgroundColor: customBackgroundColor, textColor: customTextColor))
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
    
    private var shapeToggle: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Shape:")
                .font(.headline)
            
            Picker("Shape", selection: $isCircular) {
                Text("Circular").tag(true)
                Text("Rounded").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    private var animationToggle: some View {
        Toggle(isOn: $isPulsing) {
            Text("Pulsing Animation")
                .font(.headline)
        }
    }
    
    private var customColorPickers: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Custom Colors:")
                .font(.headline)
            
            HStack {
                Text("Background:")
                ColorPicker("", selection: $customBackgroundColor)
                    .labelsHidden()
            }
            
            HStack {
                Text("Text color:")
                ColorPicker("", selection: $customTextColor)
                    .labelsHidden()
            }
        }
    }
    
    private var generatedCodePreview: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Generated Code:")
                .font(.headline)
            
            CodePreview(badgeCodePreview)
        }
    }
    
    // MARK: - Helper Methods
    
    private func sizeString(for size: CTBadgeSize) -> String {
        switch size {
        case .small: return ".small"
        case .medium: return ".medium"
        case .large: return ".large"
        }
    }
    
    private func styleString(for style: CTBadgeStyle) -> String {
        switch style {
        case .primary: return ".primary"
        case .secondary: return ".secondary"
        case .success: return ".success"
        case .warning: return ".warning"
        case .error: return ".error"
        case .info: return ".info"
        case .custom(let bgColor, let txtColor):
            let bgHex = bgColor.description
            let txtHex = txtColor.description
            return ".custom(backgroundColor: \(bgHex), textColor: \(txtHex))"
        }
    }
    
    // MARK: - Computed Properties
    
    private var badgeNumberValue: Int {
        if case .number(let value) = selectedContent {
            return value
        }
        return 0
    }
    
    // Update number badge when slider changes
    private func updateBadgeNumber() {
        self.selectedContent = .number(Int(badgeNumberFloat))
    }
    
    // Update text badge when text field changes
    private func updateBadgeText() {
        let text = badgeTextValue.isEmpty ? "Badge" : badgeTextValue
        self.selectedContent = .text(text)
    }
    
    private var badgeCodePreview: String {
        let sizeStr = selectedSize == .small ? "" : "size: \(sizeString(for: selectedSize)), "
        let styleStr = selectedStyle == .primary ? "" : "style: \(styleString(for: selectedStyle)), "
        let circularStr = isCircular ? "" : "isCircular: false, "
        let pulsingStr = isPulsing ? "isPulsing: true" : ""
        
        // Remove trailing comma if needed
        var params = sizeStr + styleStr + circularStr + pulsingStr
        if params.hasSuffix(", ") {
            params = String(params.dropLast(2))
        }
        
        switch selectedContent {
        case .number(let value):
            return "CTBadge(\(value)\(params.isEmpty ? "" : ", \(params)"))"
        case .text(let text):
            return "CTBadge(\"\(text)\"\(params.isEmpty ? "" : ", \(params)"))"
        }
    }
}

// MARK: - Preview

struct BadgeExamples_Previews: PreviewProvider {
    static var previews: some View {
        BadgeExamples()
    }
}

// Add this helper to wrap different shape types
private struct AnyShape: Shape {
    private let builder: @Sendable (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        builder = { rect in
            shape.path(in: rect)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        builder(rect)
    }
} 

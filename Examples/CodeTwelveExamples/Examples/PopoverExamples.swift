//
//  PopoverExamples.swift
//  CodeTwelveExamples
//
//  Created on 28/03/25.
//

import SwiftUI
import CodetwelveUI

/// Examples demonstrating the usage of the CTPopover component
struct PopoverExamples: View {
    // MARK: - State Properties
    
    /// State for popover visibility
    @State private var isBasicPopoverPresented = false
    @State private var isCustomPopoverPresented = false
    @State private var isTopPositionPopoverPresented = false
    @State private var isBottomPositionPopoverPresented = false
    @State private var isLeadingPositionPopoverPresented = false
    @State private var isTrailingPositionPopoverPresented = false
    @State private var isInteractivePopoverPresented = false
    
    /// Toggle for showing code examples
    @State private var showBasicCode = false
    @State private var showPositionCode = false
    @State private var showStylingCode = false
    @State private var showDismissalCode = false
    @State private var showInteractiveCode = false
    
    /// Interactive example options
    @State private var selectedPosition: CTPopoverArrowPosition = .top
    @State private var selectedStyle = 0
    @State private var popoverWidth: Double = 250
    @State private var cornerRadius: Double = 12
    @State private var backdropDismissal = true
    @State private var customColor = Color.ctSurface
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                basicPopoverSection
                positionsSection
                stylingSection
                dismissalSection
                interactiveSection
            }
            .padding()
        }
        .navigationTitle("Popover")
    }
    
    // MARK: - Basic Popover Section
    
    private var basicPopoverSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Basic Popover", showCode: $showBasicCode)
            
            Text("Popovers display content in a floating container.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            PopoverDemoButton(
                title: "Show Basic Popover",
                isPresented: $isBasicPopoverPresented
            )
            
            if showBasicCode {
                CodePreview(code: """
                @State private var isPopoverPresented = false
                
                Button("Show Popover") {
                    isPopoverPresented = true
                }
                .ctPopover(isPresented: $isPopoverPresented) {
                    VStack(alignment: .leading, spacing: CTSpacing.m) {
                        Text("Popover Title")
                            .ctHeading3()
                            
                        Text("This is a basic popover with default styling.")
                            .ctBody()
                            
                        CTButton("Close") {
                            isPopoverPresented = false
                        }
                    }
                    .padding()
                    .frame(width: 250)
                }
                """)
            }
        }
        .ctPopover(isPresented: $isBasicPopoverPresented) {
            PopoverContentExample(
                title: "Basic Popover",
                message: "This is a basic popover with default styling.",
                onClose: { isBasicPopoverPresented = false }
            )
        }
    }
    
    // MARK: - Popover Positions Section
    
    private var positionsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Popover Positions", showCode: $showPositionCode)
            
            Text("Popovers can be positioned with the arrow pointing in different directions.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: CTSpacing.m) {
                // Top arrow popover
                VStack {
                    Text("Top Arrow").ctBody().fontWeight(.medium)
                    PopoverDemoButton(
                        title: "Show Popover",
                        isPresented: $isTopPositionPopoverPresented
                    )
                    .ctPopover(
                        isPresented: $isTopPositionPopoverPresented,
                        arrowPosition: .top
                    ) {
                        PopoverContentExample(
                            title: "Top Arrow Popover",
                            message: "The arrow is positioned at the top.",
                            onClose: { isTopPositionPopoverPresented = false }
                        )
                    }
                }
                
                // Bottom arrow popover
                VStack {
                    Text("Bottom Arrow").ctBody().fontWeight(.medium)
                    PopoverDemoButton(
                        title: "Show Popover",
                        isPresented: $isBottomPositionPopoverPresented
                    )
                    .ctPopover(
                        isPresented: $isBottomPositionPopoverPresented,
                        arrowPosition: .bottom
                    ) {
                        PopoverContentExample(
                            title: "Bottom Arrow Popover",
                            message: "The arrow is positioned at the bottom.",
                            onClose: { isBottomPositionPopoverPresented = false }
                        )
                    }
                }
                
                // Leading arrow popover
                VStack {
                    Text("Leading Arrow").ctBody().fontWeight(.medium)
                    PopoverDemoButton(
                        title: "Show Popover",
                        isPresented: $isLeadingPositionPopoverPresented
                    )
                    .ctPopover(
                        isPresented: $isLeadingPositionPopoverPresented,
                        arrowPosition: .leading
                    ) {
                        PopoverContentExample(
                            title: "Leading Arrow Popover",
                            message: "The arrow is positioned at the leading edge.",
                            onClose: { isLeadingPositionPopoverPresented = false }
                        )
                    }
                }
                
                // Trailing arrow popover
                VStack {
                    Text("Trailing Arrow").ctBody().fontWeight(.medium)
                    PopoverDemoButton(
                        title: "Show Popover",
                        isPresented: $isTrailingPositionPopoverPresented
                    )
                    .ctPopover(
                        isPresented: $isTrailingPositionPopoverPresented,
                        arrowPosition: .trailing
                    ) {
                        PopoverContentExample(
                            title: "Trailing Arrow Popover",
                            message: "The arrow is positioned at the trailing edge.",
                            onClose: { isTrailingPositionPopoverPresented = false }
                        )
                    }
                }
            }
            
            if showPositionCode {
                CodePreview(code: """
                // Top Arrow
                .ctPopover(
                    isPresented: $isPopoverPresented,
                    arrowPosition: .top
                ) {
                    // Popover content
                }
                
                // Bottom Arrow
                .ctPopover(
                    isPresented: $isPopoverPresented,
                    arrowPosition: .bottom
                ) {
                    // Popover content
                }
                
                // Leading Arrow
                .ctPopover(
                    isPresented: $isPopoverPresented,
                    arrowPosition: .leading
                ) {
                    // Popover content
                }
                
                // Trailing Arrow
                .ctPopover(
                    isPresented: $isPopoverPresented,
                    arrowPosition: .trailing
                ) {
                    // Popover content
                }
                """)
            }
        }
    }
    
    // MARK: - Styling Section
    
    private var stylingSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Popover Styling", showCode: $showStylingCode)
            
            Text("Popovers can be styled with different visual appearances.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            // Custom styled popover
            PopoverDemoButton(
                title: "Show Custom Styled Popover",
                isPresented: $isCustomPopoverPresented
            )
            .ctPopover(
                isPresented: $isCustomPopoverPresented,
                arrowPosition: .top,
                style: .custom(
                    backgroundColor: Color.ctPrimary,
                    cornerRadius: 16,
                    shadowRadius: 10,
                    shadowOpacity: 0.3
                )
            ) {
                VStack(alignment: .leading, spacing: CTSpacing.m) {
                    Text("Custom Styled Popover")
                        .ctHeading3()
                        .foregroundColor(.white)
                        
                    Text("This popover has custom styling with custom colors, corner radius, and shadow.")
                        .ctBody()
                        .foregroundColor(.white)
                        
                    CTButton("Close", style: .outline) {
                        isCustomPopoverPresented = false
                    }
                    .foregroundColor(.white)
                }
                .padding()
                .frame(width: 250)
            }
            
            if showStylingCode {
                CodePreview(code: """
                // Default Style
                .ctPopover(
                    isPresented: $isPopoverPresented,
                    style: .default
                ) {
                    // Content
                }
                
                // Modern Style
                .ctPopover(
                    isPresented: $isPopoverPresented,
                    style: .modern
                ) {
                    // Content
                }
                
                // Minimal Style
                .ctPopover(
                    isPresented: $isPopoverPresented,
                    style: .minimal
                ) {
                    // Content
                }
                
                // Custom Style
                .ctPopover(
                    isPresented: $isPopoverPresented,
                    style: .custom(
                        backgroundColor: Color.ctPrimary,
                        cornerRadius: 16,
                        shadowRadius: 10,
                        shadowOpacity: 0.3
                    )
                ) {
                    // Content with appropriate text color for contrast
                }
                """)
            }
        }
    }
    
    // MARK: - Dismissal Section
    
    private var dismissalSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Dismissal Behavior", showCode: $showDismissalCode)
            
            Text("Control whether a popover can be dismissed by tapping outside.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            HStack(spacing: CTSpacing.m) {
                // Popover with backdrop dismissal
                VStack {
                    Text("With Backdrop Dismissal").ctBody().fontWeight(.medium)
                    
                    @State var isPopoverWithDismissalPresented = false
                    PopoverDemoButton(
                        title: "Show Popover",
                        isPresented: $isPopoverWithDismissalPresented
                    )
                    .ctPopover(
                        isPresented: $isPopoverWithDismissalPresented,
                        dismissOnBackgroundTap: true
                    ) {
                        PopoverContentExample(
                            title: "Backdrop Dismissal",
                            message: "Tap outside to dismiss this popover.",
                            onClose: { isPopoverWithDismissalPresented = false }
                        )
                    }
                }
                
                // Popover without backdrop dismissal
                VStack {
                    Text("Without Backdrop Dismissal").ctBody().fontWeight(.medium)
                    
                    @State var isPopoverWithoutDismissalPresented = false
                    PopoverDemoButton(
                        title: "Show Popover",
                        isPresented: $isPopoverWithoutDismissalPresented
                    )
                    .ctPopover(
                        isPresented: $isPopoverWithoutDismissalPresented,
                        dismissOnBackgroundTap: false
                    ) {
                        PopoverContentExample(
                            title: "No Backdrop Dismissal",
                            message: "You must use the button to close this popover.",
                            onClose: { isPopoverWithoutDismissalPresented = false }
                        )
                    }
                }
            }
            
            if showDismissalCode {
                CodePreview(code: """
                // With backdrop dismissal
                .ctPopover(
                    isPresented: $isPopoverPresented,
                    dismissOnBackgroundTap: true
                ) {
                    // Popover content
                }
                
                // Without backdrop dismissal
                .ctPopover(
                    isPresented: $isPopoverPresented,
                    dismissOnBackgroundTap: false
                ) {
                    // Popover content with explicit close button
                    VStack {
                        Text("You must use the button to close")
                        
                        Button("Close") {
                            isPopoverPresented = false
                        }
                    }
                }
                """)
            }
        }
    }
    
    // MARK: - Interactive Section
    
    private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Interactive Example")
                .ctHeading3()
                .padding(.bottom, CTSpacing.s)
            
            Text("Configure your popover by adjusting the options below.")
                .ctBody()
                .padding(.bottom, CTSpacing.m)
            
            // Configuration options
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                // Arrow position picker
                HStack {
                    Text("Arrow Position:").ctBody().frame(width: 120, alignment: .leading)
                    Picker("Position", selection: $selectedPosition) {
                        Text("Top").tag(CTPopoverArrowPosition.top)
                        Text("Bottom").tag(CTPopoverArrowPosition.bottom)
                        Text("Leading").tag(CTPopoverArrowPosition.leading)
                        Text("Trailing").tag(CTPopoverArrowPosition.trailing)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Style picker
                HStack {
                    Text("Style:").ctBody().frame(width: 120, alignment: .leading)
                    Picker("Style", selection: $selectedStyle) {
                        Text("Default").tag(0)
                        Text("Modern").tag(1)
                        Text("Minimal").tag(2)
                        Text("Custom").tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Width slider
                HStack {
                    Text("Width:").ctBody().frame(width: 120, alignment: .leading)
                    Slider(value: $popoverWidth, in: 150...350, step: 10)
                    Text("\(Int(popoverWidth))").ctCaption().frame(width: 40)
                }
                
                // Corner radius slider
                HStack {
                    Text("Corner Radius:").ctBody().frame(width: 120, alignment: .leading)
                    Slider(value: $cornerRadius, in: 0...30, step: 1)
                    Text("\(Int(cornerRadius))").ctCaption().frame(width: 40)
                }
                
                // Background color (only for custom style)
                if selectedStyle == 3 {
                    HStack {
                        Text("Background:").ctBody().frame(width: 120, alignment: .leading)
                        ColorPicker("", selection: $customColor)
                    }
                }
                
                // Backdrop dismissal
                HStack {
                    Text("Backdrop Dismissal:").ctBody().frame(width: 120, alignment: .leading)
                    Toggle("", isOn: $backdropDismissal)
                }
            }
            .padding()
            .background(Color.ctSurface)
            .cornerRadius(12)
            
            // Preview
            Button("Show Interactive Popover") {
                isInteractivePopoverPresented = true
            }
            .ctButton(style: .primary)
            .padding(.top, CTSpacing.m)
            
            if showInteractiveCode {
                CodePreview(code: generateInteractiveCode())
            } else {
                Button("Show Code") {
                    showInteractiveCode = true
                }
                .padding(.top, CTSpacing.s)
            }
        }
        .ctPopover(
            isPresented: $isInteractivePopoverPresented,
            arrowPosition: selectedPosition,
            style: getSelectedStyle(),
            dismissOnBackgroundTap: backdropDismissal,
            width: popoverWidth
        ) {
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                Text("Interactive Popover")
                    .ctHeading3()
                    .foregroundColor(selectedStyle == 3 ? (isDarkColor(customColor) ? .white : .black) : .ctText)
                    
                Text("This popover is configured with your custom settings.")
                    .ctBody()
                    .foregroundColor(selectedStyle == 3 ? (isDarkColor(customColor) ? .white : .black) : .ctText)
                    
                CTButton("Close", style: selectedStyle == 3 ? .outline : .primary) {
                    isInteractivePopoverPresented = false
                }
                .foregroundColor(selectedStyle == 3 && isDarkColor(customColor) ? .white : nil)
            }
            .padding()
        }
    }
    
    // MARK: - Helper Methods
    
    /// Get the selected style based on the picker selection
    private func getSelectedStyle() -> CTPopover<AnyView>.CTPopoverStyle {
        switch selectedStyle {
        case 0:
            return .default
        case 1:
            return .modern
        case 2:
            return .minimal
        case 3:
            return .custom(
                backgroundColor: customColor,
                cornerRadius: cornerRadius,
                shadowRadius: 8,
                shadowOpacity: 0.2
            )
        default:
            return .default
        }
    }
    
    /// Generate code for the interactive example
    private func generateInteractiveCode() -> String {
        let styleName: String
        switch selectedStyle {
        case 0: styleName = "default"
        case 1: styleName = "modern"
        case 2: styleName = "minimal"
        case 3: styleName = "custom(backgroundColor: \(colorToString(customColor)), cornerRadius: \(Int(cornerRadius)), shadowRadius: 8, shadowOpacity: 0.2)"
        default: styleName = "default"
        }
        
        let positionName: String
        switch selectedPosition {
        case .top: positionName = "top"
        case .bottom: positionName = "bottom"
        case .leading: positionName = "leading"
        case .trailing: positionName = "trailing"
        }
        
        var code = """
        @State private var isPopoverPresented = false
        
        Button("Show Popover") {
            isPopoverPresented = true
        }
        .ctPopover(
            isPresented: $isPopoverPresented,
            arrowPosition: .\(positionName),
        """
        
        // Add style if not default
        if selectedStyle != 0 {
            code += "\n    style: .\(styleName),"
        }
        
        // Add dismissal behavior if not default
        if !backdropDismissal {
            code += "\n    dismissOnBackgroundTap: false,"
        }
        
        // Add width
        code += "\n    width: \(Int(popoverWidth)),"
        
        // Close function parameters and add content
        code += "\n) {\n"
        code += "    VStack(alignment: .leading, spacing: CTSpacing.m) {\n"
        code += "        Text(\"Interactive Popover\")\n"
        code += "            .ctHeading3()\n"
        code += "            \n"
        code += "        Text(\"This popover is configured with your custom settings.\")\n"
        code += "            .ctBody()\n"
        code += "            \n"
        code += "        CTButton(\"Close\") {\n"
        code += "            isPopoverPresented = false\n"
        code += "        }\n"
        code += "    }\n"
        code += "    .padding()\n"
        code += "}"
        
        return code
    }
    
    /// Determine if a color is dark (for text contrast)
    private func isDarkColor(_ color: Color) -> Bool {
        // This is a simplistic approach, ideally you'd convert to RGB and check luminance
        return color == Color.ctPrimary || color == Color.black || color == Color.gray
    }
    
    /// Convert a color to a string representation
    private func colorToString(_ color: Color) -> String {
        if color == Color.ctSurface {
            return "Color.ctSurface"
        } else if color == Color.ctPrimary {
            return "Color.ctPrimary"
        } else {
            return "Color.primary" // Fallback
        }
    }
}

// MARK: - Helper Views

/// Button for demonstrating popover functionality
struct PopoverDemoButton: View {
    let title: String
    @Binding var isPresented: Bool
    
    var body: some View {
        Button(title) {
            isPresented = true
        }
        .ctButton(style: .secondary)
    }
}

/// Standard popover content for examples
struct PopoverContentExample: View {
    let title: String
    let message: String
    var onClose: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text(title)
                .ctHeading3()
                
            Text(message)
                .ctBody()
                
            if let onClose = onClose {
                CTButton("Close") {
                    onClose()
                }
            }
        }
        .padding()
        .frame(width: 250)
    }
}

// MARK: - Preview Provider

struct PopoverExamples_Previews: PreviewProvider {
    static var previews: some View {
        PopoverExamples()
    }
}

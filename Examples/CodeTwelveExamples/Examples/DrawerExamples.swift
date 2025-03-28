//
//  DrawerExamples.swift
//  CodeTwelveExamples
//
//  Created on 28/03/25.
//

import SwiftUI
import CodetwelveUI

/// Examples demonstrating the usage of the CTDrawer component
struct DrawerExamples: View {
    // MARK: - State Properties
    
    /// State for each drawer example
    @State private var isLeadingDrawerPresented = false
    @State private var isTrailingDrawerPresented = false
    @State private var isTopDrawerPresented = false
    @State private var isBottomDrawerPresented = false
    @State private var isCustomDrawerPresented = false
    
    /// Toggle for showing code examples
    @State private var showDirectionCode = false
    @State private var showStylingCode = false
    @State private var showDismissalCode = false
    @State private var showCustomSizeCode = false
    
    /// Interactive example options
    @State private var selectedEdge: Edge = .leading
    @State private var isInteractiveDrawerPresented = false
    @State private var customBackgroundColor = Color.ctSurface
    @State private var customCornerRadius: Double = 12
    @State private var customSize: Double = 250
    @State private var closeOnBackdropTap = true
    @State private var showInteractiveCode = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                positionExamplesSection
                stylingExamplesSection
                dismissalExamplesSection
                sizeExamplesSection
                interactiveSection
            }
            .padding()
        }
        .navigationTitle("Drawer")
    }
    
    // MARK: - Position Examples
    
    private var positionExamplesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Drawer Positions", showCode: $showDirectionCode)
            
            Text("Drawers can slide in from any edge of the screen.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: CTSpacing.m) {
                // Leading drawer
                DrawerDemoButton(title: "Leading Drawer", isPresented: $isLeadingDrawerPresented)
                
                // Trailing drawer
                DrawerDemoButton(title: "Trailing Drawer", isPresented: $isTrailingDrawerPresented)
                
                // Top drawer
                DrawerDemoButton(title: "Top Drawer", isPresented: $isTopDrawerPresented)
                
                // Bottom drawer
                DrawerDemoButton(title: "Bottom Drawer", isPresented: $isBottomDrawerPresented)
            }
            
            if showDirectionCode {
                CodePreview(code: """
                // State variables
                @State private var isLeadingDrawerPresented = false
                @State private var isTrailingDrawerPresented = false
                @State private var isTopDrawerPresented = false
                @State private var isBottomDrawerPresented = false
                
                // Leading drawer
                Button("Show Leading Drawer") {
                    isLeadingDrawerPresented = true
                }
                .ctDrawer(isPresented: $isLeadingDrawerPresented, edge: .leading) {
                    DrawerContent()
                }
                
                // Trailing drawer
                Button("Show Trailing Drawer") {
                    isTrailingDrawerPresented = true
                }
                .ctDrawer(isPresented: $isTrailingDrawerPresented, edge: .trailing) {
                    DrawerContent()
                }
                
                // Top drawer
                Button("Show Top Drawer") {
                    isTopDrawerPresented = true
                }
                .ctDrawer(isPresented: $isTopDrawerPresented, edge: .top) {
                    DrawerContent()
                }
                
                // Bottom drawer
                Button("Show Bottom Drawer") {
                    isBottomDrawerPresented = true
                }
                .ctDrawer(isPresented: $isBottomDrawerPresented, edge: .bottom) {
                    DrawerContent()
                }
                
                // For convenience, you can also use the edge-specific helpers:
                .ctLeadingDrawer(isPresented: $isLeadingDrawerPresented) { ... }
                .ctTrailingDrawer(isPresented: $isTrailingDrawerPresented) { ... }
                .ctTopDrawer(isPresented: $isTopDrawerPresented) { ... }
                .ctBottomDrawer(isPresented: $isBottomDrawerPresented) { ... }
                """)
            }
        }
        .ctDrawer(isPresented: $isLeadingDrawerPresented, edge: .leading) {
            DrawerContentExample(title: "Leading Drawer")
        }
        .ctDrawer(isPresented: $isTrailingDrawerPresented, edge: .trailing) {
            DrawerContentExample(title: "Trailing Drawer")
        }
        .ctDrawer(isPresented: $isTopDrawerPresented, edge: .top) {
            DrawerContentExample(title: "Top Drawer")
        }
        .ctDrawer(isPresented: $isBottomDrawerPresented, edge: .bottom) {
            DrawerContentExample(title: "Bottom Drawer")
        }
    }
    
    // MARK: - Styling Examples
    
    private var stylingExamplesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Custom Styling", showCode: $showStylingCode)
            
            Text("Drawers can be customized with different background colors, corner radius, and more.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            // Custom styled drawer button
            DrawerDemoButton(title: "Custom Styled Drawer", isPresented: $isCustomDrawerPresented)
                .padding(.top, CTSpacing.s)
            
            if showStylingCode {
                CodePreview(code: """
                // Create a custom drawer style
                let customStyle = CTDrawerStyle(
                    backgroundColor: Color.ctPrimary,
                    cornerRadius: 24,
                    backdropOpacity: 0.6
                )
                
                // Apply the custom style to a drawer
                .ctDrawer(
                    isPresented: $isDrawerPresented,
                    edge: .leading,
                    style: customStyle
                ) {
                    // Drawer content
                    VStack(alignment: .leading, spacing: CTSpacing.m) {
                        Text("Custom Styled Drawer")
                            .ctHeading3()
                            .foregroundColor(.white)
                            
                        Text("This drawer has custom styling with a primary color background.")
                            .ctBody()
                            .foregroundColor(.white)
                            
                        Spacer()
                    }
                    .padding()
                    .frame(width: 280)
                }
                """)
            }
        }
        .ctDrawer(
            isPresented: $isCustomDrawerPresented,
            edge: .leading,
            style: CTDrawerStyle(
                backgroundColor: Color.ctPrimary,
                cornerRadius: 24,
                backdropOpacity: 0.6
            )
        ) {
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                Text("Custom Styled Drawer")
                    .ctHeading3()
                    .foregroundColor(.white)
                    
                Text("This drawer has custom styling with a primary color background.")
                    .ctBody()
                    .foregroundColor(.white)
                    
                Spacer()
                
                CTButton("Close", style: .outline) {
                    isCustomDrawerPresented = false
                }
                .foregroundColor(.white)
            }
            .padding()
            .frame(width: 280)
        }
    }
    
    // MARK: - Dismissal Examples
    
    private var dismissalExamplesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Dismissal Behavior", showCode: $showDismissalCode)
            
            Text("You can control whether a drawer can be dismissed by tapping the backdrop.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            HStack(spacing: CTSpacing.m) {
                // Drawer with backdrop dismissal
                VStack {
                    Text("With Backdrop Dismissal").ctBody().fontWeight(.medium)
                    
                    @State var isDrawerWithDismissalPresented = false
                    DrawerDemoButton(title: "Open Drawer", isPresented: $isDrawerWithDismissalPresented)
                        .ctDrawer(
                            isPresented: $isDrawerWithDismissalPresented,
                            edge: .bottom,
                            closeOnBackdropTap: true
                        ) {
                            DrawerContentExample(
                                title: "Backdrop Dismissal Enabled",
                                subtitle: "Tap outside to dismiss"
                            )
                        }
                }
                
                // Drawer without backdrop dismissal
                VStack {
                    Text("Without Backdrop Dismissal").ctBody().fontWeight(.medium)
                    
                    @State var isDrawerWithoutDismissalPresented = false
                    DrawerDemoButton(title: "Open Drawer", isPresented: $isDrawerWithoutDismissalPresented)
                        .ctDrawer(
                            isPresented: $isDrawerWithoutDismissalPresented,
                            edge: .bottom,
                            closeOnBackdropTap: false
                        ) {
                            DrawerContentExample(
                                title: "Backdrop Dismissal Disabled",
                                subtitle: "Use the button to close",
                                showCloseButton: true,
                                onClose: { isDrawerWithoutDismissalPresented = false }
                            )
                        }
                }
            }
            
            if showDismissalCode {
                CodePreview(code: """
                // With backdrop dismissal
                .ctDrawer(
                    isPresented: $isDrawerPresented,
                    edge: .bottom,
                    closeOnBackdropTap: true
                ) {
                    // Drawer content
                }
                
                // Without backdrop dismissal
                .ctDrawer(
                    isPresented: $isDrawerPresented,
                    edge: .bottom,
                    closeOnBackdropTap: false
                ) {
                    VStack {
                        Text("Must use button to close")
                        
                        Button("Close") {
                            isDrawerPresented = false
                        }
                    }
                }
                """)
            }
        }
    }
    
    // MARK: - Size Examples
    
    private var sizeExamplesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Custom Sizes", showCode: $showCustomSizeCode)
            
            Text("Drawers can have custom sizes to fit your content.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            HStack(spacing: CTSpacing.m) {
                // Small drawer
                VStack {
                    Text("Small Drawer").ctBody().fontWeight(.medium)
                    
                    @State var isSmallDrawerPresented = false
                    DrawerDemoButton(title: "Open Drawer", isPresented: $isSmallDrawerPresented)
                        .ctDrawer(
                            isPresented: $isSmallDrawerPresented,
                            edge: .leading,
                            size: 200
                        ) {
                            DrawerContentExample(title: "Small Drawer", subtitle: "Width: 200pt")
                        }
                }
                
                // Large drawer
                VStack {
                    Text("Large Drawer").ctBody().fontWeight(.medium)
                    
                    @State var isLargeDrawerPresented = false
                    DrawerDemoButton(title: "Open Drawer", isPresented: $isLargeDrawerPresented)
                        .ctDrawer(
                            isPresented: $isLargeDrawerPresented,
                            edge: .leading,
                            size: 300
                        ) {
                            DrawerContentExample(title: "Large Drawer", subtitle: "Width: 300pt")
                        }
                }
            }
            
            if showCustomSizeCode {
                CodePreview(code: """
                // Small drawer (width: 200pt)
                .ctDrawer(
                    isPresented: $isDrawerPresented,
                    edge: .leading,
                    size: 200
                ) {
                    // Drawer content
                }
                
                // Large drawer (width: 300pt)
                .ctDrawer(
                    isPresented: $isDrawerPresented,
                    edge: .leading,
                    size: 300
                ) {
                    // Drawer content
                }
                
                // For top/bottom drawers, this controls the height
                .ctDrawer(
                    isPresented: $isDrawerPresented,
                    edge: .bottom,
                    size: 250
                ) {
                    // Drawer content
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
            
            Text("Configure your drawer by adjusting the options below.")
                .ctBody()
                .padding(.bottom, CTSpacing.m)
            
            // Configuration options
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                // Edge selection
                HStack {
                    Text("Edge:").ctBody().frame(width: 150, alignment: .leading)
                    Picker("Edge", selection: $selectedEdge) {
                        Text("Leading").tag(Edge.leading)
                        Text("Trailing").tag(Edge.trailing)
                        Text("Top").tag(Edge.top)
                        Text("Bottom").tag(Edge.bottom)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Background color
                HStack {
                    Text("Background Color:").ctBody().frame(width: 150, alignment: .leading)
                    ColorPicker("", selection: $customBackgroundColor)
                }
                
                // Corner radius
                HStack {
                    Text("Corner Radius:").ctBody().frame(width: 150, alignment: .leading)
                    Slider(value: $customCornerRadius, in: 0...40)
                    Text("\(Int(customCornerRadius))").ctCaption().frame(width: 40)
                }
                
                // Size
                HStack {
                    Text("Size:").ctBody().frame(width: 150, alignment: .leading)
                    Slider(value: $customSize, in: 100...400)
                    Text("\(Int(customSize))").ctCaption().frame(width: 40)
                }
                
                // Backdrop dismissal
                HStack {
                    Text("Close on Backdrop Tap:").ctBody().frame(width: 150, alignment: .leading)
                    Toggle("", isOn: $closeOnBackdropTap)
                }
            }
            .padding()
            .background(Color.ctSurface)
            .cornerRadius(12)
            
            // Preview button
            Button("Open Interactive Drawer") {
                isInteractiveDrawerPresented = true
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
        .ctDrawer(
            isPresented: $isInteractiveDrawerPresented,
            edge: selectedEdge,
            style: CTDrawerStyle(
                backgroundColor: customBackgroundColor,
                cornerRadius: customCornerRadius,
                backdropOpacity: 0.5
            ),
            size: customSize,
            closeOnBackdropTap: closeOnBackdropTap
        ) {
            DrawerContentExample(
                title: "Interactive Drawer",
                subtitle: "You configured this drawer using the interactive controls",
                showCloseButton: !closeOnBackdropTap,
                onClose: { isInteractiveDrawerPresented = false }
            )
        }
    }
    
    // MARK: - Helper Methods
    
    /// Generate code for the interactive example
    private func generateInteractiveCode() -> String {
        let code = """
        @State private var isDrawerPresented = false
        
        // Your content view
        YourView()
            .ctDrawer(
                isPresented: $isDrawerPresented,
                edge: .\(edgeToString(selectedEdge)),
                style: CTDrawerStyle(
                    backgroundColor: \(colorToString(customBackgroundColor)),
                    cornerRadius: \(Int(customCornerRadius)),
                    backdropOpacity: 0.5
                ),
                size: \(Int(customSize)),
                closeOnBackdropTap: \(closeOnBackdropTap)
            ) {
                // Drawer content
                VStack(alignment: .leading) {
                    Text("Interactive Drawer")
                        .ctHeading3()
                        
                    Text("Custom drawer with your configuration")
                        .ctBody()
                        
                    \(closeOnBackdropTap ? "// Tap outside to close" : "Button(\"Close\") {\n    isDrawerPresented = false\n}")
                }
                .padding()
            }
        
        Button("Open Drawer") {
            isDrawerPresented = true
        }
        """
        
        return code
    }
    
    /// Convert an edge to its string representation
    private func edgeToString(_ edge: Edge) -> String {
        switch edge {
        case .leading: return "leading"
        case .trailing: return "trailing"
        case .top: return "top"
        case .bottom: return "bottom"
        }
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

/// Button for demonstrating drawer functionality
struct DrawerDemoButton: View {
    let title: String
    @Binding var isPresented: Bool
    
    var body: some View {
        Button(title) {
            isPresented = true
        }
        .ctButton(style: .secondary, fullWidth: true)
    }
}

/// Example content for drawers
struct DrawerContentExample: View {
    let title: String
    var subtitle: String? = nil
    var showCloseButton: Bool = false
    var onClose: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text(title)
                .ctHeading3()
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .ctBody()
            }
            
            Spacer()
            
            if showCloseButton {
                CTButton("Close", style: .primary) {
                    onClose?()
                }
            }
        }
        .padding()
        .frame(width: 280)
    }
}

// MARK: - Preview Provider

struct DrawerExamples_Previews: PreviewProvider {
    static var previews: some View {
        DrawerExamples()
    }
}

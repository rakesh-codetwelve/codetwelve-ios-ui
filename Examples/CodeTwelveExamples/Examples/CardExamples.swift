//
//  CardExamples.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view showcasing various examples of the CTCard component.
///
/// This view demonstrates:
/// - Basic usage of cards
/// - Predefined card styles
/// - Custom styling options
/// - Header and footer sections
/// - Interactive card builder
struct CardExamples: View {
    // MARK: - Properties
    
    // Card style properties
    @State private var selectedStyle: CTCardStyle = .elevated
    @State private var padding: CGFloat = 16
    @State private var cornerRadius: CGFloat = 8
    @State private var borderWidth: CGFloat = 0
    @State private var borderColor: Color = .gray
    @State private var backgroundColor: Color = .white
    @State private var shadowRadius: CGFloat = 4
    @State private var showHeader: Bool = false
    @State private var showFooter: Bool = false
    
    // Code toggle properties
    @State private var showBasicCode: Bool = false
    @State private var showStylesCode: Bool = false
    @State private var showCustomCode: Bool = false
    @State private var showHeaderFooterCode: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                basicUsageSection
                
                cardStylesSection
                
                customStylingSection
                
                headerFooterSection
                
                interactiveSection
            }
            .padding()
        }
        .navigationTitle("Card")
        .background(Color.ctBackground.edgesIgnoringSafeArea(.all))
    }
    
    // MARK: - Sections
    
    /// Basic card usage examples
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Basic Usage")
                .font(.title)
                .fontWeight(.bold)
            
            Text("A card component that works as a container for content with a consistent card-like appearance.")
                .padding(.bottom, CTSpacing.s)
            
            // Regular card
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Basic Card")
                        .font(.headline)
                    
                    CTCard {
                        cardContent()
                    }
                    
                    codeExample("""
                    CTCard {
                        // Your content goes here
                        Text("Hello, World!")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    """, isShowing: $showBasicCode)
                }
            }
            
            // Interactive card
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Interactive Card")
                        .font(.headline)
                    
                    CTCard(isInteractive: true, action: {
                        // Action would go here
                    }) {
                        HStack {
                            Text("Tap me!")
                                .padding()
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .padding()
                        }
                        .background(Color.ctPrimary.opacity(0.1))
                        .foregroundColor(.ctPrimary)
                        .cornerRadius(8)
                    }
                    
                    codeExample("""
                    CTCard(isInteractive: true, action: {
                        // Your action here
                        print("Card tapped!")
                    }) {
                        HStack {
                            Text("Tap me!")
                                .padding()
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .padding()
                        }
                        .background(Color.ctPrimary.opacity(0.1))
                        .foregroundColor(.ctPrimary)
                        .cornerRadius(8)
                    }
                    """, isShowing: $showBasicCode)
                }
            }
        }
    }
    
    /// Card styles examples
    private var cardStylesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Card Styles")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTCard comes with predefined styles for common use cases.")
                .padding(.bottom, CTSpacing.s)
            
            // Flat style card
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Flat Style")
                        .font(.headline)
                    
                    CTCard(style: .flat) {
                        cardContent()
                    }
                    
                    codeExample("""
                    CTCard(style: .flat) {
                        // Card content
                    }
                    """)
                }
            }
            
            // Outlined style card
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Outlined Style")
                        .font(.headline)
                    
                    CTCard(style: .outlined) {
                        cardContent()
                    }
                    
                    codeExample("""
                    CTCard(style: .outlined) {
                        // Card content
                    }
                    """)
                }
            }
            
            // Elevated style card
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Elevated Style")
                        .font(.headline)
                    
                    CTCard(style: .elevated) {
                        cardContent()
                    }
                    
                    codeExample("""
                    CTCard(style: .elevated) {
                        // Card content
                    }
                    """)
                }
            }
            
            // Filled style card
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Filled Style")
                        .font(.headline)
                    
                    CTCard(style: .filled) {
                        cardContent()
                    }
                    
                    codeExample("""
                    CTCard(style: .filled) {
                        // Card content
                    }
                    """)
                }
            }
        }
    }
    
    /// Custom card styling examples
    private var customStylingSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Custom Styling")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTCard can be customized with various style properties.")
                .padding(.bottom, CTSpacing.s)
            
            // Custom style
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Custom Style")
                        .font(.headline)
                    
                    CTCard(style: CTCardStyle.custom(backgroundColor: Color.blue.opacity(0.1), borderColor: Color.blue), cornerRadius: cornerRadius, borderWidth: borderWidth) {
                        cardContent()
                    }
                    
                    codeExample("""
                    CTCard(
                        style: CTCardStyle.custom(
                            backgroundColor: Color.blue.opacity(0.1), 
                            borderColor: Color.blue
                        ),
                        cornerRadius: \(Int(cornerRadius)),
                        borderWidth: \(Int(borderWidth))
                    ) {
                        // Card content
                    }
                    """, isShowing: $showCustomCode)
                }
            }
            
            // Custom shadow
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Custom Shadow")
                        .font(.headline)
                    
                    CTCard(style: .elevated, shadowRadius: 8) {
                        cardContent()
                    } header: {
                        EmptyView()
                    } footer: {
                        EmptyView()
                    }
                    
                    codeExample("""
                    CTCard(
                        style: .elevated,
                        shadowRadius: 8
                    ) {
                        // Card content
                    }
                    """, isShowing: $showCustomCode)
                }
            }
        }
    }
    
    /// Card with header and footer examples
    private var headerFooterSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Header & Footer")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTCard supports optional header and footer sections.")
                .padding(.bottom, CTSpacing.s)
            
            // Card with header
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Card with Header")
                        .font(.headline)
                    
                    CTCard {
                        cardContent()
                    } header: {
                        HStack {
                            Text("Card Header")
                                .font(.headline)
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "ellipsis")
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                    }
                    
                    codeExample("""
                    CTCard {
                        // Card content
                    } header: {
                        HStack {
                            Text("Card Header")
                                .font(.headline)
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "ellipsis")
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                    }
                    """, isShowing: $showHeaderFooterCode)
                }
            }
            
            // Card with both header and footer
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Card with Header & Footer")
                        .font(.headline)
                    
                    CTCard {
                        cardContent()
                    } header: {
                        Text("Card Header")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                    } footer: {
                        Text("Card Footer")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .background(Color.gray.opacity(0.1))
                    }
                    
                    codeExample("""
                    CTCard {
                        // Card content
                    } header: {
                        Text("Card Header")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                    } footer: {
                        Text("Card Footer")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .background(Color.gray.opacity(0.1))
                    }
                    """, isShowing: $showHeaderFooterCode)
                }
            }
        }
    }
    
    /// Interactive card builder
    private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Interactive Example")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Configure a card and see how it changes.")
                .padding(.bottom, CTSpacing.s)
            
            // Controls
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.m) {
                    // Style selection
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Card Style:")
                            .font(.headline)
                        
                        Picker("Style", selection: $selectedStyle) {
                            Text("Elevated").tag(CTCardStyle.elevated)
                            Text("Flat").tag(CTCardStyle.flat)
                            Text("Outlined").tag(CTCardStyle.outlined)
                            Text("Filled").tag(CTCardStyle.filled)
                            Text("Custom").tag(CTCardStyle.custom(backgroundColor: Color.blue.opacity(0.1), borderColor: Color.blue))
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Optional sections
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Toggle("Show Header", isOn: $showHeader)
                            .font(.headline)
                        
                        Toggle("Show Footer", isOn: $showFooter)
                            .font(.headline)
                    }
                    
                    // Custom properties
                    if case .custom = selectedStyle {
                        VStack(alignment: .leading, spacing: CTSpacing.m) {
                            // Padding control
                            VStack(alignment: .leading, spacing: CTSpacing.xs) {
                                Text("Padding: \(Int(padding))")
                                    .font(.headline)
                                
                                Slider(value: $padding, in: 0...32, step: 4)
                            }
                            
                            // Corner radius control
                            VStack(alignment: .leading, spacing: CTSpacing.xs) {
                                Text("Corner Radius: \(Int(cornerRadius))")
                                    .font(.headline)
                                
                                Slider(value: $cornerRadius, in: 0...24, step: 2)
                            }
                            
                            // Border controls
                            VStack(alignment: .leading, spacing: CTSpacing.xs) {
                                Text("Border Width: \(Int(borderWidth))")
                                    .font(.headline)
                                
                                Slider(value: $borderWidth, in: 0...5, step: 1)
                            }
                            
                            if borderWidth > 0 {
                                ColorPicker("Border Color:", selection: $borderColor)
                                    .font(.headline)
                            }
                            
                            // Background control
                            ColorPicker("Background Color:", selection: $backgroundColor)
                                .font(.headline)
                            
                            // Shadow control
                            VStack(alignment: .leading, spacing: CTSpacing.xs) {
                                Text("Shadow Radius: \(Int(shadowRadius))")
                                    .font(.headline)
                                
                                Slider(value: $shadowRadius, in: 0...20, step: 2)
                            }
                        }
                    }
                }
            }
            
            // Preview
            CTCard {
                VStack {
                    Text("Preview")
                        .font(.headline)
                        .padding(.top)
                    
                    let cardView: AnyView = {
                        if case .custom = selectedStyle {
                            if showHeader && showFooter {
                                return AnyView(
                                    CTCard(
                                        style: CTCardStyle.custom(backgroundColor: backgroundColor, borderColor: borderColor),
                                        cornerRadius: cornerRadius,
                                        borderWidth: borderWidth,
                                        shadowRadius: shadowRadius
                                    ) {
                                        cardContent()
                                    } header: {
                                        cardHeader()
                                    } footer: {
                                        cardFooter()
                                    }
                                )
                            } else if showHeader {
                                return AnyView(
                                    CTCard(
                                        style: CTCardStyle.custom(backgroundColor: backgroundColor, borderColor: borderColor),
                                        cornerRadius: cornerRadius,
                                        borderWidth: borderWidth,
                                        shadowRadius: shadowRadius
                                    ) {
                                        cardContent()
                                    } header: {
                                        cardHeader()
                                    } footer: {
                                        EmptyView()
                                    }
                                )
                            } else if showFooter {
                                return AnyView(
                                    CTCard(
                                        style: CTCardStyle.custom(backgroundColor: backgroundColor, borderColor: borderColor),
                                        cornerRadius: cornerRadius,
                                        borderWidth: borderWidth,
                                        shadowRadius: shadowRadius
                                    ) {
                                        cardContent()
                                    } header: {
                                        EmptyView()
                                    } footer: {
                                        cardFooter()
                                    }
                                )
                            } else {
                                return AnyView(
                                    CTCard(
                                        style: CTCardStyle.custom(backgroundColor: backgroundColor, borderColor: borderColor),
                                        cornerRadius: cornerRadius,
                                        borderWidth: borderWidth,
                                        shadowRadius: shadowRadius
                                    ) {
                                        cardContent()
                                    } header: {
                                        EmptyView()
                                    } footer: {
                                        EmptyView()
                                    }
                                )
                            }
                        } else {
                            if showHeader && showFooter {
                                return AnyView(
                                    CTCard(style: selectedStyle) {
                                        cardContent()
                                    } header: {
                                        cardHeader()
                                    } footer: {
                                        cardFooter()
                                    }
                                )
                            } else if showHeader {
                                return AnyView(
                                    CTCard(style: selectedStyle) {
                                        cardContent()
                                    } header: {
                                        cardHeader()
                                    } footer: {
                                        EmptyView()
                                    }
                                )
                            } else if showFooter {
                                return AnyView(
                                    CTCard(style: selectedStyle) {
                                        cardContent()
                                    } header: {
                                        EmptyView()
                                    } footer: {
                                        cardFooter()
                                    }
                                )
                            } else {
                                return AnyView(
                                    CTCard(style: selectedStyle) {
                                        cardContent()
                                    } header: {
                                        EmptyView()
                                    } footer: {
                                        EmptyView()
                                    }
                                )
                            }
                        }
                    }()
                    
                    cardView
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    codeExample(generateCode(), isShowing: .constant(true))
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// Creates a standard card content
    /// - Returns: A view with standard card content
    private func cardContent() -> some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Card Content")
                .font(.headline)
            
            Text("This is an example of card content with some text that demonstrates the card component.")
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                
                Image(systemName: "star")
                    .foregroundColor(.gray)
                
                Image(systemName: "star")
                    .foregroundColor(.gray)
                
                Spacer()
            }
        }
        .padding()
    }
    
    /// Creates a standard card header
    /// - Returns: A view with standard card header
    private func cardHeader() -> some View {
        HStack {
            Text("Card Header")
                .font(.headline)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "ellipsis")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
    
    /// Creates a standard card footer
    /// - Returns: A view with standard card footer
    private func cardFooter() -> some View {
        HStack {
            Spacer()
            
            Button("Cancel", action: {})
                .buttonStyle(.bordered)
            
            Button("Save", action: {})
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
    
    /// Creates a formatted code example view
    /// - Parameter code: The code string to display
    /// - Returns: A formatted code view
    private func codeExample(_ code: String, isShowing: Binding<Bool> = .constant(true)) -> some View {
        VStack(alignment: .leading) {
            Text("Code Example:")
                .font(.subheadline)
                .padding(.top, CTSpacing.xs)
            
            ScrollView(.horizontal, showsIndicators: false) {
                Text(code)
                    .font(.system(.footnote, design: .monospaced))
                    .padding(CTSpacing.s)
            }
            .background(Color.black.opacity(0.03))
            .cornerRadius(8)
        }
        .opacity(isShowing.wrappedValue ? 1 : 0)
    }
    
    /// Generates code based on the current interactive settings
    /// - Returns: A code string reflecting current settings
    private func generateCode() -> String {
        var code = ""
        
        // Start of the CTCard
        if case .custom = selectedStyle {
            code += "CTCard(\n"
            code += "    style: CTCardStyle.custom(\n"
            code += "        backgroundColor: \(colorToString(backgroundColor)),\n"
            code += "        borderColor: \(colorToString(borderColor))\n"
            code += "    ),\n"
            
            // Corner radius
            if cornerRadius != 8 {
                code += "    cornerRadius: \(Int(cornerRadius)),\n"
            }
            
            // Border width
            if borderWidth > 0 {
                code += "    borderWidth: \(Int(borderWidth)),\n"
            }
            
            // Shadow radius
            if shadowRadius != 4 {
                code += "    shadowRadius: \(Int(shadowRadius)),\n"
            }
        } else {
            code += "CTCard(style: .\(styleToString(selectedStyle))"
        }
        
        // Add header and footer sections
        if showHeader && showFooter {
            code += ") {\n"
            code += "    // Content\n"
            code += "} header: {\n"
            code += "    // Header\n"
            code += "} footer: {\n"
            code += "    // Footer\n"
            code += "}"
        } else if showHeader {
            code += ") {\n"
            code += "    // Content\n"
            code += "} header: {\n"
            code += "    // Header\n"
            code += "} footer: {\n"
            code += "    EmptyView()\n"
            code += "}"
        } else if showFooter {
            code += ") {\n"
            code += "    // Content\n"
            code += "} header: {\n"
            code += "    EmptyView()\n"
            code += "} footer: {\n"
            code += "    // Footer\n"
            code += "}"
        } else {
            code += ") {\n"
            code += "    // Content\n"
            code += "} header: {\n"
            code += "    EmptyView()\n"
            code += "} footer: {\n"
            code += "    EmptyView()\n"
            code += "}"
        }
        
        return code
    }
    
    /// Converts a style to its string representation
    /// - Parameter style: The card style
    /// - Returns: String representation of the style
    private func styleToString(_ style: CTCardStyle) -> String {
        switch style {
        case .elevated:
            return "elevated"
        case .flat:
            return "flat"
        case .outlined:
            return "outlined"
        case .filled:
            return "filled"
        case .custom:
            return "custom"
        }
    }
    
    /// Converts a color to its string representation
    /// - Parameter color: The color to convert
    /// - Returns: String representation of the color
    private func colorToString(_ color: Color) -> String {
        "Color(/* custom color */)"
    }
}

struct CardExamples_Previews: PreviewProvider {
    static var previews: some View {
        CardExamples()
    }
}
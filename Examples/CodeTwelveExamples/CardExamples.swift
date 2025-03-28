//
//  CardExamples.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view that showcases CTCard component examples
///
/// This view demonstrates different aspects of the CTCard component:
/// - Basic card usage
/// - Card styles (default, bordered, elevated)
/// - Custom styling options
/// - Header and footer sections
/// - Interactive card builder
struct CardExamples: View {
    // MARK: - State Properties
    
    @State private var padding: CGFloat = CTSpacing.m
    @State private var cornerRadius: CGFloat = 8
    @State private var borderWidth: CGFloat = 1
    @State private var borderColor: Color = .gray
    @State private var backgroundColor: Color = Color.ctBackground
    @State private var shadowRadius: CGFloat = 4
    @State private var showHeader: Bool = false
    @State private var showFooter: Bool = false
    @State private var selectedStyle: CTCardStyle = .default
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                // Basic usage section
                basicUsageSection
                
                // Card styles section
                cardStylesSection
                
                // Custom styling section
                customStylingSection
                
                // Header and footer section
                headerFooterSection
                
                // Interactive section
                interactiveSection
            }
            .padding()
        }
        .navigationTitle("Card")
        .background(Color.ctBackground.edgesIgnoringSafeArea(.all))
    }
    
    // MARK: - Private Views
    
    /// Basic card usage examples
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Basic Usage")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTCard provides a container for content with consistent styling.")
                .padding(.bottom, CTSpacing.s)
            
            // Basic card
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Basic Card")
                        .font(.headline)
                    
                    CTCard {
                        VStack(alignment: .leading, spacing: CTSpacing.m) {
                            Text("Card Title")
                                .font(.headline)
                            
                            Text("This is a basic card with default styling. Cards are used to group related content and actions.")
                            
                            Button("Card Action") {}
                                .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    }
                    
                    codeExample("""
                    CTCard {
                        VStack(alignment: .leading, spacing: CTSpacing.m) {
                            Text("Card Title")
                                .font(.headline)
                            
                            Text("Card content goes here...")
                            
                            Button("Card Action") {}
                                .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    }
                    """)
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
            
            // Default style card
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Default Style")
                        .font(.headline)
                    
                    CTCard(style: .default) {
                        cardContent()
                    }
                    
                    codeExample("""
                    CTCard(style: .default) {
                        // Card content
                    }
                    
                    // Or simply:
                    CTCard {
                        // Card content
                    }
                    """)
                }
            }
            
            // Bordered style card
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Bordered Style")
                        .font(.headline)
                    
                    CTCard(style: .bordered) {
                        cardContent()
                    }
                    
                    codeExample("""
                    CTCard(style: .bordered) {
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
            
            // Background color
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Custom Background")
                        .font(.headline)
                    
                    CTCard(backgroundColor: Color.ctPrimary.opacity(0.1)) {
                        cardContent()
                    }
                    
                    codeExample("""
                    CTCard(backgroundColor: Color.ctPrimary.opacity(0.1)) {
                        // Card content
                    }
                    """)
                }
            }
            
            // Border customization
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Custom Border")
                        .font(.headline)
                    
                    CTCard(
                        borderWidth: 2,
                        borderColor: .ctPrimary
                    ) {
                        cardContent()
                    }
                    
                    codeExample("""
                    CTCard(
                        borderWidth: 2,
                        borderColor: .ctPrimary
                    ) {
                        // Card content
                    }
                    """)
                }
            }
            
            // Shadow customization
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Custom Shadow")
                        .font(.headline)
                    
                    CTCard(
                        shadowRadius: 8,
                        shadowColor: .ctPrimary.opacity(0.3),
                        shadowOffset: CGSize(width: 2, height: 4)
                    ) {
                        cardContent()
                    }
                    
                    codeExample("""
                    CTCard(
                        shadowRadius: 8,
                        shadowColor: .ctPrimary.opacity(0.3),
                        shadowOffset: CGSize(width: 2, height: 4)
                    ) {
                        // Card content
                    }
                    """)
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
                    """)
                }
            }
            
            // Card with footer
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Card with Footer")
                        .font(.headline)
                    
                    CTCard {
                        cardContent()
                    } footer: {
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
                    
                    codeExample("""
                    CTCard {
                        // Card content
                    } footer: {
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
                    """)
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
                    """)
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
                        
                        Picker("Card Style", selection: $selectedStyle) {
                            Text("Default").tag(CTCardStyle.default)
                            Text("Bordered").tag(CTCardStyle.bordered)
                            Text("Elevated").tag(CTCardStyle.elevated)
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
                    
                    // Custom properties (only if not using predefined style)
                    if selectedStyle == .default {
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
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Preview")
                        .font(.headline)
                    
                    Group {
                        if selectedStyle != .default {
                            if showHeader && showFooter {
                                CTCard(style: selectedStyle) {
                                    cardContent()
                                } header: {
                                    cardHeader()
                                } footer: {
                                    cardFooter()
                                }
                            } else if showHeader {
                                CTCard(style: selectedStyle) {
                                    cardContent()
                                } header: {
                                    cardHeader()
                                }
                            } else if showFooter {
                                CTCard(style: selectedStyle) {
                                    cardContent()
                                } footer: {
                                    cardFooter()
                                }
                            } else {
                                CTCard(style: selectedStyle) {
                                    cardContent()
                                }
                            }
                        } else {
                            if showHeader && showFooter {
                                CTCard(
                                    padding: padding,
                                    cornerRadius: cornerRadius,
                                    borderWidth: borderWidth,
                                    borderColor: borderColor,
                                    backgroundColor: backgroundColor,
                                    shadowRadius: shadowRadius
                                ) {
                                    cardContent()
                                } header: {
                                    cardHeader()
                                } footer: {
                                    cardFooter()
                                }
                            } else if showHeader {
                                CTCard(
                                    padding: padding,
                                    cornerRadius: cornerRadius,
                                    borderWidth: borderWidth,
                                    borderColor: borderColor,
                                    backgroundColor: backgroundColor,
                                    shadowRadius: shadowRadius
                                ) {
                                    cardContent()
                                } header: {
                                    cardHeader()
                                }
                            } else if showFooter {
                                CTCard(
                                    padding: padding,
                                    cornerRadius: cornerRadius,
                                    borderWidth: borderWidth,
                                    borderColor: borderColor,
                                    backgroundColor: backgroundColor,
                                    shadowRadius: shadowRadius
                                ) {
                                    cardContent()
                                } footer: {
                                    cardFooter()
                                }
                            } else {
                                CTCard(
                                    padding: padding,
                                    cornerRadius: cornerRadius,
                                    borderWidth: borderWidth,
                                    borderColor: borderColor,
                                    backgroundColor: backgroundColor,
                                    shadowRadius: shadowRadius
                                ) {
                                    cardContent()
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    codeExample(generateCode())
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
    private func codeExample(_ code: String) -> some View {
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
    }
    
    /// Generates code based on the current interactive settings
    /// - Returns: A code string reflecting current settings
    private func generateCode() -> String {
        var code = ""
        
        // Start of the CTCard
        if selectedStyle != .default {
            code += "CTCard(style: .\(selectedStyle))"
        } else {
            code += "CTCard(\n"
            
            // Padding
            if padding != CTSpacing.m {
                code += "    padding: \(Int(padding)),\n"
            }
            
            // Corner radius
            if cornerRadius != 8 {
                code += "    cornerRadius: \(Int(cornerRadius)),\n"
            }
            
            // Border
            if borderWidth > 0 {
                code += "    borderWidth: \(Int(borderWidth)),\n"
                if borderColor != .gray {
                    code += "    borderColor: .ctPrimary,\n"
                }
            }
            
            // Background
            if backgroundColor != Color.ctBackground {
                code += "    backgroundColor: Color.ctPrimary.opacity(0.1),\n"
            }
            
            // Shadow
            if shadowRadius > 0 {
                code += "    shadowRadius: \(Int(shadowRadius)),\n"
            }
            
            // End of parameters
            code += ")"
        }
        
        // Content section
        if showHeader && showFooter {
            code += " {\n"
            code += "    // Card content\n"
            code += "} header: {\n"
            code += "    // Header content\n"
            code += "} footer: {\n"
            code += "    // Footer content\n"
            code += "}"
        } else if showHeader {
            code += " {\n"
            code += "    // Card content\n"
            code += "} header: {\n"
            code += "    // Header content\n"
            code += "}"
        } else if showFooter {
            code += " {\n"
            code += "    // Card content\n"
            code += "} footer: {\n"
            code += "    // Footer content\n"
            code += "}"
        } else {
            code += " {\n"
            code += "    // Card content\n"
            code += "}"
        }
        
        return code
    }
}

struct CardExamples_Previews: PreviewProvider {
    static var previews: some View {
        CardExamples()
    }
}
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
/// - Basic card with content
/// - Cards with headers and footers
/// - Interactive cards
/// - Different card styles
/// - Custom styling options
/// - Interactive card builder
struct CardExamples: View {
    // MARK: - State Properties
    
    @State private var style: CTCardStyle = .elevated
    @State private var cornerRadius: CGFloat = 8
    @State private var borderWidth: CGFloat = 0
    @State private var hasShadow: Bool = true
    @State private var isInteractive: Bool = false
    @State private var tapCount: Int = 0
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                // Basic usage section
                basicUsageSection
                
                // Headers and footers section
                headersAndFootersSection
                
                // Interactive cards section
                interactiveCardsSection
                
                // Card styles section
                cardStylesSection
                
                // Custom styling section
                customStylingSection
                
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
            
            Text("CTCard provides a container for content with a consistent card-like appearance.")
                .padding(.bottom, CTSpacing.s)
            
            // Basic card
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Basic Card")
                        .font(.headline)
                    
                    CTCard {
                        Text("This is a basic card with just content.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, CTSpacing.s)
                    }
                    
                    codeExample("""
                    CTCard {
                        Text("This is a basic card with just content.")
                    }
                    """)
                }
            }
            
            // Card with custom content padding
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Custom Content Padding")
                        .font(.headline)
                    
                    CTCard(contentPadding: CTSpacing.all(CTSpacing.l)) {
                        Text("This card has larger content padding.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    codeExample("""
                    CTCard(contentPadding: CTSpacing.all(CTSpacing.l)) {
                        Text("This card has larger content padding.")
                    }
                    """)
                }
            }
        }
    }
    
    /// Examples of cards with headers and footers
    private var headersAndFootersSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Headers & Footers")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Cards can have optional header and footer sections.")
                .padding(.bottom, CTSpacing.s)
            
            // Card with header
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Card with Header")
                        .font(.headline)
                    
                    CTCard {
                        Text("This is the card content area.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, CTSpacing.s)
                    } header: {
                        Text("Card Header")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    codeExample("""
                    CTCard {
                        Text("This is the card content area.")
                    } header: {
                        Text("Card Header")
                            .font(.headline)
                    }
                    """)
                }
            }
            
            // Card with header and footer
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Card with Header and Footer")
                        .font(.headline)
                    
                    CTCard {
                        Text("This is the card content area.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, CTSpacing.s)
                    } header: {
                        Text("Card Header")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } footer: {
                        HStack {
                            Spacer()
                            Text("Card Footer")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    codeExample("""
                    CTCard {
                        Text("This is the card content area.")
                    } header: {
                        Text("Card Header")
                            .font(.headline)
                    } footer: {
                        Text("Card Footer")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    """)
                }
            }
            
            // Card with custom header
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Custom Header")
                        .font(.headline)
                    
                    CTCard {
                        Text("This is the card content area.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, CTSpacing.s)
                    } header: {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            
                            Text("Featured Card")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("New")
                                .font(.caption)
                                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                .background(Color.ctPrimary)
                                .foregroundColor(.white)
                                .cornerRadius(4)
                        }
                    }
                    
                    codeExample("""
                    CTCard {
                        Text("This is the card content area.")
                    } header: {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            
                            Text("Featured Card")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("New")
                                .font(.caption)
                                .padding(...)
                                .background(Color.ctPrimary)
                                .foregroundColor(.white)
                                .cornerRadius(4)
                        }
                    }
                    """)
                }
            }
        }
    }
    
    /// Examples of interactive cards
    private var interactiveCardsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Interactive Cards")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Cards can be made interactive (tappable) for navigation or actions.")
                .padding(.bottom, CTSpacing.s)
            
            // Interactive card
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Interactive Card")
                        .font(.headline)
                    
                    CTCard(isInteractive: true, action: {
                        // This would navigate or perform an action
                        print("Card tapped")
                    }) {
                        HStack {
                            Text("Tap this card")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, CTSpacing.s)
                    }
                    
                    codeExample("""
                    CTCard(isInteractive: true, action: {
                        // Handle tap
                    }) {
                        HStack {
                            Text("Tap this card")
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                    }
                    """)
                }
            }
            
            // Interactive card with state
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Interactive Card with State")
                        .font(.headline)
                    
                    CTCard(isInteractive: true, action: {
                        tapCount += 1
                    }) {
                        HStack {
                            Text("Tap count: \(tapCount)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Tap to increment")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                        .padding(.vertical, CTSpacing.s)
                    }
                    
                    codeExample("""
                    @State private var tapCount: Int = 0
                    
                    CTCard(isInteractive: true, action: {
                        tapCount += 1
                    }) {
                        Text("Tap count: \\(tapCount)")
                    }
                    """)
                }
            }
        }
    }
    
    /// Examples of different card styles
    private var cardStylesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Card Styles")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTCard comes with several predefined styles.")
                .padding(.bottom, CTSpacing.s)
            
            // Elevated card
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Elevated Style")
                        .font(.headline)
                    
                    CTCard(style: .elevated) {
                        Text("This is an elevated card with a shadow.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, CTSpacing.s)
                    }
                    
                    codeExample("""
                    CTCard(style: .elevated) {
                        Text("This is an elevated card with a shadow.")
                    }
                    """)
                }
            }
            
            // Flat card
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Flat Style")
                        .font(.headline)
                    
                    CTCard(style: .flat, borderWidth: 1) {
                        Text("This is a flat card with a border.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, CTSpacing.s)
                    }
                    
                    codeExample("""
                    CTCard(style: .flat, borderWidth: 1) {
                        Text("This is a flat card with a border.")
                    }
                    """)
                }
            }
            
            // Outlined card
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Outlined Style")
                        .font(.headline)
                    
                    CTCard(style: .outlined, borderWidth: 1) {
                        Text("This is an outlined card.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, CTSpacing.s)
                    }
                    
                    codeExample("""
                    CTCard(style: .outlined, borderWidth: 1) {
                        Text("This is an outlined card.")
                    }
                    """)
                }
            }
            
            // Filled card
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Filled Style")
                        .font(.headline)
                    
                    CTCard(style: .filled) {
                        Text("This is a filled card.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, CTSpacing.s)
                    }
                    
                    codeExample("""
                    CTCard(style: .filled) {
                        Text("This is a filled card.")
                    }
                    """)
                }
            }
            
            // Custom card
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Custom Style")
                        .font(.headline)
                    
                    CTCard(style: .custom(backgroundColor: Color.ctPrimary.opacity(0.1), borderColor: Color.ctPrimary), borderWidth: 1) {
                        Text("This is a custom styled card.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, CTSpacing.s)
                    }
                    
                    codeExample("""
                    CTCard(
                        style: .custom(
                            backgroundColor: Color.ctPrimary.opacity(0.1),
                            borderColor: Color.ctPrimary
                        ),
                        borderWidth: 1
                    ) {
                        Text("This is a custom styled card.")
                    }
                    """)
                }
            }
        }
    }
    
    /// Examples of custom styling options
    private var customStylingSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Custom Styling")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Cards can be customized with various styling parameters.")
                .padding(.bottom, CTSpacing.s)
            
            // Corner radius
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Corner Radius")
                        .font(.headline)
                    
                    HStack {
                        CTCard(cornerRadius: 0) {
                            Text("0px")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, CTSpacing.s)
                        }
                        
                        CTCard(cornerRadius: 8) {
                            Text("8px")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, CTSpacing.s)
                        }
                        
                        CTCard(cornerRadius: 16) {
                            Text("16px")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, CTSpacing.s)
                        }
                        
                        CTCard(cornerRadius: 24) {
                            Text("24px")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, CTSpacing.s)
                        }
                    }
                    
                    codeExample("""
                    CTCard(cornerRadius: 16) {
                        Text("16px")
                    }
                    """)
                }
            }
            
            // Border width
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Border Width")
                        .font(.headline)
                    
                    HStack {
                        CTCard(style: .outlined, borderWidth: 1) {
                            Text("1px")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, CTSpacing.s)
                        }
                        
                        CTCard(style: .outlined, borderWidth: 2) {
                            Text("2px")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, CTSpacing.s)
                        }
                        
                        CTCard(style: .outlined, borderWidth: 3) {
                            Text("3px")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, CTSpacing.s)
                        }
                    }
                    
                    codeExample("""
                    CTCard(style: .outlined, borderWidth: 2) {
                        Text("2px")
                    }
                    """)
                }
            }
            
            // Shadow options
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Shadow Options")
                        .font(.headline)
                    
                    HStack {
                        CTCard(hasShadow: false) {
                            Text("No Shadow")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, CTSpacing.s)
                        }
                        
                        CTCard(shadowRadius: 2, shadowOpacity: 0.1) {
                            Text("Subtle")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, CTSpacing.s)
                        }
                        
                        CTCard(shadowRadius: 8, shadowOpacity: 0.2) {
                            Text("Prominent")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, CTSpacing.s)
                        }
                    }
                    .padding(.bottom, 8) // Extra padding for shadow
                    
                    codeExample("""
                    // No shadow
                    CTCard(hasShadow: false) {
                        Text("No Shadow")
                    }
                    
                    // Custom shadow
                    CTCard(shadowRadius: 8, shadowOpacity: 0.2) {
                        Text("Prominent")
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
                    // Style control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Style:")
                            .font(.headline)
                        
                        Picker("Style", selection: $style) {
                            Text("Elevated").tag(CTCardStyle.elevated)
                            Text("Flat").tag(CTCardStyle.flat)
                            Text("Outlined").tag(CTCardStyle.outlined)
                            Text("Filled").tag(CTCardStyle.filled)
                            Text("Custom").tag(CTCardStyle.custom(backgroundColor: Color.ctPrimary.opacity(0.1), borderColor: Color.ctPrimary))
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Corner radius control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Corner Radius: \(Int(cornerRadius))")
                            .font(.headline)
                        
                        Slider(value: $cornerRadius, in: 0...24, step: 4)
                    }
                    
                    // Border width control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        if style == .flat || style == .outlined || (style == .custom(backgroundColor: Color.ctPrimary.opacity(0.1), borderColor: Color.ctPrimary)) {
                            Text("Border Width: \(Int(borderWidth))")
                                .font(.headline)
                            
                            Slider(value: $borderWidth, in: 0...3, step: 1)
                        }
                    }
                    
                    // Shadow control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Toggle("Shadow", isOn: $hasShadow)
                            .font(.headline)
                    }
                    
                    // Interactive control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Toggle("Interactive", isOn: $isInteractive)
                            .font(.headline)
                    }
                }
            }
            
            // Preview
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Preview")
                        .font(.headline)
                    
                    CTCard(
                        style: style,
                        cornerRadius: cornerRadius,
                        borderWidth: borderWidth,
                        hasShadow: hasShadow,
                        isInteractive: isInteractive,
                        action: {
                            // Interactive action
                            if isInteractive {
                                tapCount += 1
                            }
                        }
                    ) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Sample Card")
                                    .font(.headline)
                                
                                if isInteractive {
                                    Text("Tap count: \(tapCount)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            if isInteractive {
                                Image(systemName: "hand.tap")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, CTSpacing.s)
                    } header: {
                        HStack {
                            Text("Card Header")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Spacer()
                        }
                    }
                    .padding(.bottom, hasShadow ? 10 : 0) // Extra space for shadow
                    
                    codeExample(generateCode())
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
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
        var code = "CTCard(\n"
        
        // Style
        switch style {
        case .elevated:
            code += "    style: .elevated,\n"
        case .flat:
            code += "    style: .flat,\n"
        case .outlined:
            code += "    style: .outlined,\n"
        case .filled:
            code += "    style: .filled,\n"
        case .custom:
            code += "    style: .custom(\n        backgroundColor: Color.ctPrimary.opacity(0.1),\n        borderColor: Color.ctPrimary\n    ),\n"
        }
        
        // Corner radius
        if cornerRadius != 8 {
            code += "    cornerRadius: \(cornerRadius),\n"
        }
        
        // Border width
        if borderWidth > 0 {
            code += "    borderWidth: \(borderWidth),\n"
        }
        
        // Shadow
        if !hasShadow {
            code += "    hasShadow: false,\n"
        }
        
        // Interactive
        if isInteractive {
            code += "    isInteractive: true,\n"
            code += "    action: {\n        // Handle tap\n    },\n"
        }
        
        code += ") {\n    Text(\"Card Content\")\n} header: {\n    Text(\"Card Header\")\n}"
        
        return code
    }
}

struct CardExamples_Previews: PreviewProvider {
    static var previews: some View {
        CardExamples()
    }
}
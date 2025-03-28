//
//  DividerExamples.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view that showcases the various styles and configurations of the CTDivider component.
///
/// This example view demonstrates:
/// - Horizontal and vertical dividers
/// - Customization options (color, thickness, length, opacity)
/// - Common usage patterns for dividers
struct DividerExamples: View {
    // MARK: - State Properties
    
    /// Color for the interactive divider
    @State private var dividerColor: DividerColor = .border
    
    /// Thickness for the interactive divider
    @State private var thickness: CGFloat = 1
    
    /// Length for the interactive divider
    @State private var useFixedLength = false
    
    /// Fixed length value for the interactive divider
    @State private var fixedLength: CGFloat = 200
    
    /// Opacity for the interactive divider
    @State private var opacity: Double = 1.0
    
    /// Orientation for the interactive divider
    @State private var orientation: CTDivider.Orientation = .horizontal
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.xl) {
                // Basic usage section
                basicUsageSection
                
                CTDivider()
                
                // Orientation section
                orientationSection
                
                CTDivider()
                
                // Customization section
                customizationSection
                
                CTDivider()
                
                // Common patterns section
                commonPatternsSection
                
                CTDivider()
                
                // Interactive example section
                interactiveSection
            }
            .padding(CTSpacing.m)
        }
        .navigationTitle("Divider")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - Basic Usage Section
    
    /// Section demonstrating basic divider usage
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Section header
            Text("Basic Usage")
                .ctHeading2()
                .padding(.bottom, CTSpacing.xs)
            
            Text("Dividers help organize and separate content to improve visual hierarchy and readability.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.s)
            
            // Default divider example
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Default Divider")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                CTDivider()
                
                Text("The default divider is a thin horizontal line with the theme's border color.")
                    .ctBodySmall()
                    .foregroundColor(.ctTextSecondary)
            }
            
            // Code example
            codeExample("""
            // Simple horizontal divider
            CTDivider()
            """)
        }
    }
    
    // MARK: - Orientation Section
    
    /// Section demonstrating divider orientations
    private var orientationSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Section header
            Text("Orientation")
                .ctHeading2()
                .padding(.bottom, CTSpacing.xs)
            
            Text("Dividers can be oriented horizontally or vertically depending on your layout needs.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.s)
            
            // Horizontal divider example
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Horizontal Divider")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                CTDivider(orientation: .horizontal)
                
                Text("Horizontal dividers separate content vertically and typically span the full width of their container.")
                    .ctBodySmall()
                    .foregroundColor(.ctTextSecondary)
            }
            .padding(.bottom, CTSpacing.m)
            
            // Vertical divider example
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Vertical Divider")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                HStack(spacing: CTSpacing.l) {
                    Text("Left Content")
                        .ctBody()
                    
                    CTDivider(orientation: .vertical, length: 40)
                    
                    Text("Right Content")
                        .ctBody()
                }
                .frame(height: 50)
                
                Text("Vertical dividers separate content horizontally and typically need a specified height.")
                    .ctBodySmall()
                    .foregroundColor(.ctTextSecondary)
            }
            
            // Code example
            codeExample("""
            // Horizontal divider (default)
            CTDivider(orientation: .horizontal)
            
            // Vertical divider
            CTDivider(orientation: .vertical, length: 40)
            """)
        }
    }
    
    // MARK: - Customization Section
    
    /// Section demonstrating divider customization options
    private var customizationSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Section header
            Text("Customization")
                .ctHeading2()
                .padding(.bottom, CTSpacing.xs)
            
            Text("Dividers can be customized with different colors, thicknesses, lengths, and opacities.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.s)
            
            // Color customization
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Color")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                VStack(spacing: CTSpacing.s) {
                    CTDivider(color: .ctPrimary)
                    CTDivider(color: .ctSecondary)
                    CTDivider(color: .ctDestructive)
                    CTDivider(color: .ctSuccess)
                }
            }
            .padding(.bottom, CTSpacing.m)
            
            // Thickness customization
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Thickness")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                VStack(spacing: CTSpacing.s) {
                    CTDivider(thickness: 1)
                    Text("1pt (Default)")
                        .ctCaption()
                        .foregroundColor(.ctTextSecondary)
                    
                    CTDivider(thickness: 2)
                    Text("2pt")
                        .ctCaption()
                        .foregroundColor(.ctTextSecondary)
                    
                    CTDivider(thickness: 4)
                    Text("4pt")
                        .ctCaption()
                        .foregroundColor(.ctTextSecondary)
                    
                    CTDivider(thickness: 8)
                    Text("8pt")
                        .ctCaption()
                        .foregroundColor(.ctTextSecondary)
                }
            }
            .padding(.bottom, CTSpacing.m)
            
            // Length customization
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Length")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                VStack(spacing: CTSpacing.m) {
                    CTDivider()
                    Text("Full width (Default)")
                        .ctCaption()
                        .foregroundColor(.ctTextSecondary)
                    
                    HStack {
                        Spacer()
                        CTDivider(length: 200)
                        Spacer()
                    }
                    Text("Fixed length (200pt)")
                        .ctCaption()
                        .foregroundColor(.ctTextSecondary)
                }
            }
            .padding(.bottom, CTSpacing.m)
            
            // Opacity customization
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Opacity")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                VStack(spacing: CTSpacing.m) {
                    CTDivider(thickness: 4, opacity: 1.0)
                    Text("100% opacity")
                        .ctCaption()
                        .foregroundColor(.ctTextSecondary)
                    
                    CTDivider(thickness: 4, opacity: 0.75)
                    Text("75% opacity")
                        .ctCaption()
                        .foregroundColor(.ctTextSecondary)
                    
                    CTDivider(thickness: 4, opacity: 0.5)
                    Text("50% opacity")
                        .ctCaption()
                        .foregroundColor(.ctTextSecondary)
                    
                    CTDivider(thickness: 4, opacity: 0.25)
                    Text("25% opacity")
                        .ctCaption()
                        .foregroundColor(.ctTextSecondary)
                }
            }
            
            // Code example
            codeExample("""
            // Color customization
            CTDivider(color: .ctPrimary)
            
            // Thickness customization
            CTDivider(thickness: 4)
            
            // Length customization
            CTDivider(length: 200)
            
            // Opacity customization
            CTDivider(opacity: 0.5)
            
            // Combined customization
            CTDivider(
                color: .ctPrimary,
                thickness: 2,
                length: 150,
                opacity: 0.8
            )
            """)
        }
    }
    
    // MARK: - Common Patterns Section
    
    /// Section demonstrating common divider usage patterns
    private var commonPatternsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Section header
            Text("Common Patterns")
                .ctHeading2()
                .padding(.bottom, CTSpacing.xs)
            
            Text("Common ways to use dividers in your interfaces.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.s)
            
            // Section divider pattern
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Section Divider")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                VStack(alignment: .leading, spacing: CTSpacing.m) {
                    Text("Personal Information")
                        .ctHeading3()
                    
                    Text("Name: John Doe\nEmail: john@example.com\nPhone: (123) 456-7890")
                        .ctBody()
                    
                    CTDivider()
                    
                    Text("Shipping Address")
                        .ctHeading3()
                    
                    Text("123 Main Street\nAnytown, CA 12345\nUnited States")
                        .ctBody()
                }
            }
            .padding(.bottom, CTSpacing.m)
            
            // List divider pattern
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("List Divider")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                VStack(alignment: .leading) {
                    ForEach(0..<3) { index in
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.ctPrimary)
                            
                            Text("List Item \(index + 1)")
                                .ctBody()
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.ctTextSecondary)
                        }
                        .padding(.vertical, CTSpacing.xs)
                        
                        if index < 2 {
                            CTDivider()
                        }
                    }
                }
            }
            .padding(.bottom, CTSpacing.m)
            
            // Content grouping pattern
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Content Grouping")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                HStack(spacing: CTSpacing.m) {
                    VStack(alignment: .leading) {
                        Text("Category A")
                            .ctSubtitle()
                        
                        Text("Item 1\nItem 2\nItem 3")
                            .ctBody()
                    }
                    
                    CTDivider(orientation: .vertical, length: 100)
                    
                    VStack(alignment: .leading) {
                        Text("Category B")
                            .ctSubtitle()
                        
                        Text("Item 4\nItem 5\nItem 6")
                            .ctBody()
                    }
                }
            }
            .padding(.bottom, CTSpacing.m)
            
            // Decorative divider pattern
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Decorative Divider")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                VStack {
                    Text("SECTION TITLE")
                        .ctSubtitle()
                        .tracking(2)
                    
                    HStack {
                        CTDivider(color: .ctPrimary, thickness: 2, length: 40)
                        
                        Image(systemName: "star.fill")
                            .foregroundColor(.ctPrimary)
                        
                        CTDivider(color: .ctPrimary, thickness: 2, length: 40)
                    }
                    
                    Text("Section content goes here...")
                        .ctBodySmall()
                        .foregroundColor(.ctTextSecondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    // MARK: - Interactive Section
    
    /// Section with interactive divider customization
    private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Section header
            Text("Interactive Example")
                .ctHeading2()
                .padding(.bottom, CTSpacing.xs)
            
            Text("Customize a divider to see how different properties affect its appearance.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.m)
            
            // Divider preview
            ZStack {
                Color.ctBackground
                    .cornerRadius(CTSpacing.s)
                    .frame(height: 200)
                
                if orientation == .horizontal {
                    CTDivider(
                        orientation: orientation,
                        color: colorForSelection(dividerColor),
                        thickness: thickness,
                        length: useFixedLength ? fixedLength : nil,
                        opacity: opacity
                    )
                } else {
                    CTDivider(
                        orientation: orientation,
                        color: colorForSelection(dividerColor),
                        thickness: thickness,
                        length: 100,
                        opacity: opacity
                    )
                }
            }
            .padding(.bottom, CTSpacing.m)
            
            // Customization controls
            Group {
                // Orientation
                VStack(alignment: .leading, spacing: CTSpacing.xxs) {
                    Text("Orientation")
                        .ctSubtitle()
                    
                    Picker("Orientation", selection: $orientation) {
                        Text("Horizontal").tag(CTDivider.Orientation.horizontal)
                        Text("Vertical").tag(CTDivider.Orientation.vertical)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.bottom, CTSpacing.s)
                
                // Color
                VStack(alignment: .leading, spacing: CTSpacing.xxs) {
                    Text("Color")
                        .ctSubtitle()
                    
                    Picker("Color", selection: $dividerColor) {
                        Text("Border").tag(DividerColor.border)
                        Text("Primary").tag(DividerColor.primary)
                        Text("Secondary").tag(DividerColor.secondary)
                        Text("Destructive").tag(DividerColor.destructive)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.bottom, CTSpacing.s)
                
                // Thickness
                VStack(alignment: .leading, spacing: CTSpacing.xxs) {
                    Text("Thickness: \(Int(thickness))pt")
                        .ctSubtitle()
                    
                    Slider(value: $thickness, in: 1...10, step: 1)
                }
                .padding(.bottom, CTSpacing.s)
                
                // Length (only applicable to horizontal orientation)
                if orientation == .horizontal {
                    VStack(alignment: .leading, spacing: CTSpacing.xxs) {
                        Toggle("Fixed Length", isOn: $useFixedLength)
                            .ctSubtitle()
                        
                        if useFixedLength {
                            HStack {
                                Text("Length: \(Int(fixedLength))pt")
                                    .ctCaption()
                                
                                Slider(value: $fixedLength, in: 50...300, step: 10)
                            }
                        }
                    }
                    .padding(.bottom, CTSpacing.s)
                }
                
                // Opacity
                VStack(alignment: .leading, spacing: CTSpacing.xxs) {
                    Text("Opacity: \(Int(opacity * 100))%")
                        .ctSubtitle()
                    
                    Slider(value: $opacity, in: 0.1...1.0)
                }
            }
            
            // Generated code
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Generated Code:")
                    .ctSubtitle()
                    .padding(.top, CTSpacing.m)
                
                let code = generateCode()
                
                Text(code)
                    .ctCode()
                    .padding(CTSpacing.s)
                    .background(Color.ctBackground)
                    .cornerRadius(CTSpacing.xs)
            }
        }
    }
    
    // MARK: - Helper Views and Methods
    
    /// Helper function to create a code example view
    /// - Parameter code: The code to display
    /// - Returns: A view displaying the code
    private func codeExample(_ code: String) -> some View {
        VStack(alignment: .leading) {
            Text("Example Code:")
                .ctCaption()
                .foregroundColor(.ctTextSecondary)
                .padding(.top, CTSpacing.s)
            
            Text(code)
                .ctCode()
                .padding(CTSpacing.s)
                .background(Color.ctBackground)
                .cornerRadius(CTSpacing.xs)
        }
    }
    
    /// Helper method to get the color for a selected divider color
    /// - Parameter selectedColor: The selected divider color
    /// - Returns: The corresponding SwiftUI Color
    private func colorForSelection(_ selectedColor: DividerColor) -> Color {
        switch selectedColor {
        case .border:
            return .ctBorder
        case .primary:
            return .ctPrimary
        case .secondary:
            return .ctSecondary
        case .destructive:
            return .ctDestructive
        }
    }
    
    /// Helper method to generate code for the interactive example
    /// - Returns: Swift code as string
    private func generateCode() -> String {
        var code = "CTDivider(\n"
        
        code += "    orientation: .\(orientation == .horizontal ? "horizontal" : "vertical")"
        
        if dividerColor != .border {
            code += ",\n    color: .\(dividerColor.rawValue)"
        }
        
        if thickness != 1 {
            code += ",\n    thickness: \(Int(thickness))"
        }
        
        if orientation == .horizontal && useFixedLength {
            code += ",\n    length: \(Int(fixedLength))"
        } else if orientation == .vertical {
            code += ",\n    length: 100"
        }
        
        if opacity != 1.0 {
            code += ",\n    opacity: \(String(format: "%.2f", opacity))"
        }
        
        code += "\n)"
        
        return code
    }
}

// MARK: - Supporting Types

/// Enum representing divider color options for the interactive example
enum DividerColor: String {
    case border = "ctBorder"
    case primary = "ctPrimary"
    case secondary = "ctSecondary"
    case destructive = "ctDestructive"
}

// MARK: - Previews

struct DividerExamples_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DividerExamples()
        }
    }
}
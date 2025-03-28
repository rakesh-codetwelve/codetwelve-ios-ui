//
//  StackExamples.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

/// Wrapper enum to make HorizontalAlignment hashable for use in pickers
enum HorizontalAlignmentOption: String, Hashable {
    case leading, center, trailing
    
    var alignment: HorizontalAlignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }
}

/// Wrapper enum to make VerticalAlignment hashable for use in pickers
enum VerticalAlignmentOption: String, Hashable {
    case top, center, bottom
    
    var alignment: VerticalAlignment {
        switch self {
        case .top: return .top
        case .center: return .center
        case .bottom: return .bottom
        }
    }
}

/// A view that showcases CTStack component examples
///
/// This view demonstrates different aspects of the CTStack component:
/// - Vertical and horizontal stack orientations
/// - Custom spacing options
/// - Different alignment options
/// - Dividers between items
/// - View extension methods
/// - Interactive stack builder
struct StackExamples: View {
    // MARK: - State Properties
    
    @State private var orientation: CTStackOrientation = .vertical
    @State private var spacing: CGFloat = CTSpacing.m
    @State private var horizontalAlignmentOption: HorizontalAlignmentOption = .center
    @State private var verticalAlignmentOption: VerticalAlignmentOption = .center
    @State private var showDividers: Bool = false
    @State private var dividerColor: Color = .gray
    @State private var dividerThickness: CGFloat = 1
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                // Basic usage section
                basicUsageSection
                
                // Orientation section
                orientationSection
                
                // Spacing section
                spacingSection
                
                // Alignment section
                alignmentSection
                
                // Dividers section
                dividersSection
                
                // View extensions section
                extensionsSection
                
                // Interactive section
                interactiveSection
            }
            .padding()
        }
        .navigationTitle("Stack")
        .background(Color.ctBackground.edgesIgnoringSafeArea(.all))
    }
    
    // MARK: - Private Views
    
    /// Basic stack usage examples
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Basic Usage")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTStack provides a flexible way to arrange views in vertical or horizontal layouts.")
                .padding(.bottom, CTSpacing.s)
            
            // Basic stack
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Basic Stack")
                        .font(.headline)
                    
                    CTStack(vertical: CTSpacing.m) {
                        stackItem(1, color: .blue)
                        stackItem(2, color: .green)
                        stackItem(3, color: .purple)
                    }
                    
                    codeExample("""
                    CTStack {
                        Text("Item 1")
                        Text("Item 2")
                        Text("Item 3")
                    }
                    """)
                }
            }
        }
    }
    
    /// Orientation examples
    private var orientationSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Orientation")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Stacks can be arranged vertically or horizontally.")
                .padding(.bottom, CTSpacing.s)
            
            // Vertical stack
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Vertical Stack")
                        .font(.headline)
                    
                    CTStack(orientation: .vertical, spacing: CTSpacing.m) {
                        stackItem(1, color: .blue)
                        stackItem(2, color: .green)
                        stackItem(3, color: .purple)
                    }
                    
                    codeExample("""
                    CTStack(orientation: .vertical, spacing: CTSpacing.m) {
                        Text("Item 1")
                        Text("Item 2")
                        Text("Item 3")
                    }
                    
                    // Or using the convenience initializer:
                    CTStack(vertical: CTSpacing.m) {
                        // stack items
                    }
                    """)
                }
            }
            
            // Horizontal stack
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Horizontal Stack")
                        .font(.headline)
                    
                    CTStack(orientation: .horizontal, spacing: CTSpacing.m) {
                        stackItem(1, color: .blue)
                        stackItem(2, color: .green)
                        stackItem(3, color: .purple)
                    }
                    
                    codeExample("""
                    CTStack(orientation: .horizontal, spacing: CTSpacing.m) {
                        Text("Item 1")
                        Text("Item 2")
                        Text("Item 3")
                    }
                    
                    // Or using the convenience initializer:
                    CTStack(horizontal: CTSpacing.m) {
                        // stack items
                    }
                    """)
                }
            }
        }
    }
    
    /// Spacing examples
    private var spacingSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Spacing")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Control the spacing between items in the stack.")
                .padding(.bottom, CTSpacing.s)
            
            // Spacing options
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Spacing Options")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: CTSpacing.m) {
                        Text("No Spacing")
                            .font(.subheadline)
                        
                        CTStack(spacing: 0) {
                            stackItem(1, color: .blue)
                            stackItem(2, color: .green)
                            stackItem(3, color: .purple)
                        }
                        
                        Text("Small Spacing (8pt)")
                            .font(.subheadline)
                        
                        CTStack(spacing: CTSpacing.s) {
                            stackItem(1, color: .blue)
                            stackItem(2, color: .green)
                            stackItem(3, color: .purple)
                        }
                        
                        Text("Large Spacing (24pt)")
                            .font(.subheadline)
                        
                        CTStack(spacing: CTSpacing.l) {
                            stackItem(1, color: .blue)
                            stackItem(2, color: .green)
                            stackItem(3, color: .purple)
                        }
                    }
                    
                    codeExample("""
                    // No spacing
                    CTStack(spacing: 0) {
                        // stack items
                    }
                    
                    // Small spacing
                    CTStack(spacing: CTSpacing.s) {
                        // stack items
                    }
                    
                    // Large spacing
                    CTStack(spacing: CTSpacing.l) {
                        // stack items
                    }
                    """)
                }
            }
        }
    }
    
    /// Alignment examples
    private var alignmentSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Alignment")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Control the alignment of items within the stack.")
                .padding(.bottom, CTSpacing.s)
            
            // Horizontal alignment in vertical stack
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Horizontal Alignment in Vertical Stack")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: CTSpacing.m) {
                        Text("Leading Alignment")
                            .font(.subheadline)
                        
                        CTStack(vertical: CTSpacing.m, alignment: .leading) {
                            stackItem(1, color: .blue, width: 100)
                            stackItem(2, color: .green, width: 150)
                            stackItem(3, color: .purple, width: 200)
                        }
                        
                        Text("Center Alignment")
                            .font(.subheadline)
                        
                        CTStack(vertical: CTSpacing.m, alignment: .center) {
                            stackItem(1, color: .blue, width: 100)
                            stackItem(2, color: .green, width: 150)
                            stackItem(3, color: .purple, width: 200)
                        }
                        
                        Text("Trailing Alignment")
                            .font(.subheadline)
                        
                        CTStack(vertical: CTSpacing.m, alignment: .trailing) {
                            stackItem(1, color: .blue, width: 100)
                            stackItem(2, color: .green, width: 150)
                            stackItem(3, color: .purple, width: 200)
                        }
                    }
                    
                    codeExample("""
                    CTStack(vertical: CTSpacing.m, alignment: .leading) {
                        // Items with different widths
                    }
                    
                    CTStack(vertical: CTSpacing.m, alignment: .center) {
                        // Items with different widths
                    }
                    
                    CTStack(vertical: CTSpacing.m, alignment: .trailing) {
                        // Items with different widths
                    }
                    """)
                }
            }
            
            // Vertical alignment in horizontal stack
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Vertical Alignment in Horizontal Stack")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: CTSpacing.m) {
                        Text("Top Alignment")
                            .font(.subheadline)
                        
                        CTStack(horizontal: CTSpacing.m, alignment: .top) {
                            stackItem(1, color: .blue, height: 40)
                            stackItem(2, color: .green, height: 60)
                            stackItem(3, color: .purple, height: 80)
                        }
                        
                        Text("Center Alignment")
                            .font(.subheadline)
                        
                        CTStack(horizontal: CTSpacing.m, alignment: .center) {
                            stackItem(1, color: .blue, height: 40)
                            stackItem(2, color: .green, height: 60)
                            stackItem(3, color: .purple, height: 80)
                        }
                        
                        Text("Bottom Alignment")
                            .font(.subheadline)
                        
                        CTStack(horizontal: CTSpacing.m, alignment: .bottom) {
                            stackItem(1, color: .blue, height: 40)
                            stackItem(2, color: .green, height: 60)
                            stackItem(3, color: .purple, height: 80)
                        }
                    }
                    
                    codeExample("""
                    CTStack(horizontal: CTSpacing.m, alignment: .top) {
                        // Items with different heights
                    }
                    
                    CTStack(horizontal: CTSpacing.m, alignment: .center) {
                        // Items with different heights
                    }
                    
                    CTStack(horizontal: CTSpacing.m, alignment: .bottom) {
                        // Items with different heights
                    }
                    """)
                }
            }
        }
    }
    
    /// Dividers examples
    private var dividersSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Dividers")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Add dividers between stack items for visual separation.")
                .padding(.bottom, CTSpacing.s)
            
            // Vertical stack with dividers
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Vertical Stack with Dividers")
                        .font(.headline)
                    
                    CTStack(vertical: CTSpacing.m, showDividers: true) {
                        stackItem(1, color: .blue)
                        stackItem(2, color: .green)
                        stackItem(3, color: .purple)
                    }
                    
                    codeExample("""
                    CTStack(showDividers: true) {
                        Text("Item 1")
                        Text("Item 2")
                        Text("Item 3")
                    }
                    """)
                }
            }
            
            // Horizontal stack with dividers
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Horizontal Stack with Dividers")
                        .font(.headline)
                    
                    CTStack(orientation: .horizontal, showDividers: true) {
                        stackItem(1, color: .blue)
                        stackItem(2, color: .green)
                        stackItem(3, color: .purple)
                    }
                    
                    codeExample("""
                    CTStack(
                        orientation: .horizontal,
                        showDividers: true
                    ) {
                        Text("Item 1")
                        Text("Item 2")
                        Text("Item 3")
                    }
                    """)
                }
            }
            
            // Custom dividers
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Custom Dividers")
                        .font(.headline)
                    
                    CTStack(
                        spacing: CTSpacing.m,
                        showDividers: true,
                        dividerColor: .ctPrimary,
                        dividerThickness: 2
                    ) {
                        stackItem(1, color: .blue)
                        stackItem(2, color: .green)
                        stackItem(3, color: .purple)
                    }
                    
                    codeExample("""
                    CTStack(
                        spacing: CTSpacing.m,
                        showDividers: true,
                        dividerColor: .ctPrimary,
                        dividerThickness: 2
                    ) {
                        Text("Item 1")
                        Text("Item 2")
                        Text("Item 3")
                    }
                    """)
                }
            }
        }
    }
    
    /// View extension examples
    private var extensionsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("View Extensions")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTStack provides view extensions for easier stack creation.")
                .padding(.bottom, CTSpacing.s)
            
            // VStack extension
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("VStack Extension")
                        .font(.headline)
                    
                    Text("Use the ctVStack modifier to create a vertical stack.")
                        .padding(.bottom, CTSpacing.xs)
                    
                    HStack {
                        stackItem(1, color: .blue)
                        CTStack(vertical: CTSpacing.s) {
                            stackItem(2, color: .green)
                            stackItem(3, color: .purple)
                        }
                    }
                    
                    codeExample("""
                    Text("Item 1")
                    CTStack(vertical: CTSpacing.s) {
                        Text("Item 2")
                        Text("Item 3")
                    }
                    """)
                }
            }
            
            // HStack extension
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("HStack Extension")
                        .font(.headline)
                    
                    Text("Use the ctHStack modifier to create a horizontal stack.")
                        .padding(.bottom, CTSpacing.xs)
                    
                    stackItem(1, color: .blue)
                    CTStack(horizontal: CTSpacing.s) {
                        stackItem(2, color: .green)
                        stackItem(3, color: .purple)
                    }
                    
                    codeExample("""
                    Text("Item 1")
                    CTStack(horizontal: CTSpacing.s) {
                        Text("Item 2")
                        Text("Item 3")
                    }
                    """)
                }
            }
        }
    }
    
    /// Interactive stack builder
    private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Interactive Example")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Configure a stack and see how it changes.")
                .padding(.bottom, CTSpacing.s)
            
            // Controls
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.m) {
                    // Orientation control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Orientation:")
                            .font(.headline)
                        
                        Picker("Orientation", selection: $orientation) {
                            Text("Vertical").tag(CTStackOrientation.vertical)
                            Text("Horizontal").tag(CTStackOrientation.horizontal)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Spacing control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Spacing: \(Int(spacing))")
                            .font(.headline)
                        
                        Slider(value: $spacing, in: 0...32, step: 4)
                    }
                    
                    // Alignment control
                    if orientation == .vertical {
                        VStack(alignment: .leading, spacing: CTSpacing.xs) {
                            Text("Horizontal Alignment:")
                                .font(.headline)
                            
                            Picker("Horizontal Alignment", selection: $horizontalAlignmentOption) {
                                Text("Leading").tag(HorizontalAlignmentOption.leading)
                                Text("Center").tag(HorizontalAlignmentOption.center)
                                Text("Trailing").tag(HorizontalAlignmentOption.trailing)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    } else {
                        VStack(alignment: .leading, spacing: CTSpacing.xs) {
                            Text("Vertical Alignment:")
                                .font(.headline)
                            
                            Picker("Vertical Alignment", selection: $verticalAlignmentOption) {
                                Text("Top").tag(VerticalAlignmentOption.top)
                                Text("Center").tag(VerticalAlignmentOption.center)
                                Text("Bottom").tag(VerticalAlignmentOption.bottom)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    
                    // Divider controls
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Toggle("Show Dividers", isOn: $showDividers)
                            .font(.headline)
                        
                        if showDividers {
                            ColorPicker("Divider Color:", selection: $dividerColor)
                                .font(.subheadline)
                            
                            Text("Divider Thickness: \(Int(dividerThickness))")
                                .font(.subheadline)
                            
                            Slider(value: $dividerThickness, in: 1...5, step: 1)
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
                        if orientation == .vertical {
                            CTStack(
                                orientation: orientation,
                                spacing: spacing,
                                alignment: Alignment(horizontal: horizontalAlignmentOption.alignment, vertical: .center),
                                showDividers: showDividers,
                                dividerColor: dividerColor,
                                dividerThickness: dividerThickness
                            ) {
                                previewItem(1, width: 100, height: 50)
                                previewItem(2, width: 150, height: 50)
                                previewItem(3, width: 200, height: 50)
                            }
                        } else {
                            CTStack(
                                orientation: orientation,
                                spacing: spacing,
                                alignment: Alignment(horizontal: .center, vertical: verticalAlignmentOption.alignment),
                                showDividers: showDividers,
                                dividerColor: dividerColor,
                                dividerThickness: dividerThickness
                            ) {
                                previewItem(1, width: 80, height: 40)
                                previewItem(2, width: 80, height: 60)
                                previewItem(3, width: 80, height: 80)
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
    
    /// Creates a stack item with specified properties
    /// - Parameters:
    ///   - number: The item number
    ///   - color: The background color
    ///   - width: Optional custom width
    ///   - height: Optional custom height
    /// - Returns: A standard stack item view
    private func stackItem(_ number: Int, color: Color, width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        Text("Item \(number)")
            .padding(10)
            .frame(width: width, height: height)
            .frame(maxWidth: width == nil ? .infinity : nil)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(6)
    }
    
    /// Gets a string representation of a Color
    /// - Parameter color: The color to convert
    /// - Returns: A string representation of the color
    private func colorName(for color: Color) -> String {
        // This is a simple implementation - you might want to expand this
        if color == .gray { return "gray" }
        if color == .blue { return "blue" }
        if color == .red { return "red" }
        if color == .green { return "green" }
        if color == .yellow { return "yellow" }
        if color == .orange { return "orange" }
        if color == .purple { return "purple" }
        if color == .pink { return "pink" }
        return "gray" // Default
    }
    
    /// Creates a preview item for the interactive builder
    /// - Parameters:
    ///   - number: The item number
    ///   - width: The width of the item
    ///   - height: The height of the item
    /// - Returns: A preview item view
    private func previewItem(_ number: Int, width: CGFloat, height: CGFloat) -> some View {
        Text("Item \(number)")
            .padding(10)
            .frame(width: width, height: height)
            .background(Color.ctPrimary.opacity(0.2))
            .foregroundColor(Color.ctPrimary)
            .cornerRadius(6)
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
        var code = "CTStack(\n"
        
        if orientation == .horizontal {
            code += "    orientation: .horizontal,\n"
        }
        
        code += "    spacing: \(Int(spacing)),\n"
        
        if orientation == .vertical && horizontalAlignmentOption != .center {
            code += "    alignment: .\(horizontalAlignmentOption.rawValue),\n"
        } else if orientation == .horizontal && verticalAlignmentOption != .center {
            code += "    alignment: .\(verticalAlignmentOption.rawValue),\n"
        }
        
        if showDividers {
            code += "    showDividers: true,\n"
        }
        
        if dividerColor != .gray {
            code += "    dividerColor: .\(colorName(for: dividerColor)),\n"
        }
        
        if dividerThickness != 1 {
            code += "    dividerThickness: \(Int(dividerThickness)),\n"
        }
        
        code += ") {\n"
        code += "    Text(\"Item 1\")\n"
        code += "    Text(\"Item 2\")\n"
        code += "    Text(\"Item 3\")\n"
        code += "}"
        
        return code
    }
}

struct StackExamples_Previews: PreviewProvider {
    static var previews: some View {
        StackExamples()
    }
}
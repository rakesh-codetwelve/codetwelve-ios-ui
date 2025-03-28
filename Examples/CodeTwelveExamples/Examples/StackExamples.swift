//
//  StackExamples.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view that showcases CTStack component examples
///
/// This view demonstrates different aspects of the CTStack component:
/// - Vertical stacks
/// - Horizontal stacks
/// - Customized stacks with different spacing and alignment
/// - Stacks with dividers
/// - Interactive stack examples
struct StackExamples: View {
    // MARK: - State Properties
    
    @State private var orientation: CTStack<AnyView>.Orientation = .vertical
    @State private var spacing: CGFloat = CTSpacing.m
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
                
                // Customization section
                customizationSection
                
                // Dividers section
                dividersSection
                
                // Interactive section
                interactiveSection
            }
            .padding()
        }
        .navigationTitle("Stack")
        .background(Color.ctBackground.edgesIgnoringSafeArea(.all))
    }
    
    // MARK: - Private Views
    
    /// Basic usage examples of CTStack
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Basic Usage")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTStack is a customizable stack component that enhances SwiftUI's VStack and HStack with additional features.")
                .padding(.bottom, CTSpacing.s)
            
            // Default vertical stack
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Default Vertical Stack")
                        .font(.headline)
                    
                    CTStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.ctPrimary)
                            .frame(height: 44)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.ctSecondary)
                            .frame(height: 44)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.ctSuccess)
                            .frame(height: 44)
                    }
                    .padding()
                    .background(Color.ctBackground)
                    .cornerRadius(8)
                    
                    codeExample("""
                    CTStack {
                        // First item
                        // Second item
                        // Third item
                    }
                    """)
                }
            }
            
            // Default horizontal stack
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Default Horizontal Stack")
                        .font(.headline)
                    
                    CTStack(orientation: .horizontal) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.ctPrimary)
                            .frame(width: 80, height: 44)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.ctSecondary)
                            .frame(width: 80, height: 44)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.ctSuccess)
                            .frame(width: 80, height: 44)
                    }
                    .padding()
                    .background(Color.ctBackground)
                    .cornerRadius(8)
                    
                    codeExample("""
                    CTStack(orientation: .horizontal) {
                        // First item
                        // Second item
                        // Third item
                    }
                    """)
                }
            }
        }
    }
    
    /// Examples of different stack orientations
    private var orientationSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Orientation")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTStack supports both vertical and horizontal orientations with dedicated initializers.")
                .padding(.bottom, CTSpacing.s)
            
            // Vertical stack
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Vertical Stack with Alignment")
                        .font(.headline)
                    
                    CTStack(vertical: CTSpacing.m, alignment: .leading) {
                        Text("Leading")
                            .padding()
                            .frame(width: 120)
                            .background(Color.ctPrimary)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        
                        Text("Alignment")
                            .padding()
                            .frame(width: 180)
                            .background(Color.ctSecondary)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        
                        Text("Example")
                            .padding()
                            .frame(width: 150)
                            .background(Color.ctSuccess)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.ctBackground)
                    .cornerRadius(8)
                    
                    codeExample("""
                    CTStack(vertical: CTSpacing.m, alignment: .leading) {
                        Text("Leading")
                        Text("Alignment")
                        Text("Example")
                    }
                    """)
                }
            }
            
            // Horizontal stack
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Horizontal Stack with Alignment")
                        .font(.headline)
                    
                    CTStack(horizontal: CTSpacing.m, alignment: .top) {
                        Text("Top")
                            .padding()
                            .frame(height: 50)
                            .background(Color.ctPrimary)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        
                        Text("Alignment\nExample\nWith\nMultiple\nLines")
                            .padding()
                            .background(Color.ctSecondary)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        
                        Text("Top")
                            .padding()
                            .frame(height: 50)
                            .background(Color.ctSuccess)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.ctBackground)
                    .cornerRadius(8)
                    
                    codeExample("""
                    CTStack(horizontal: CTSpacing.m, alignment: .top) {
                        Text("Top")
                        Text("Alignment\\nExample\\nWith\\nMultiple\\nLines")
                        Text("Top")
                    }
                    """)
                }
            }
        }
    }
    
    /// Examples of stack customization options
    private var customizationSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Customization")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTStack offers various customization options, including spacing and alignment.")
                .padding(.bottom, CTSpacing.s)
            
            // Custom spacing
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Custom Spacing")
                        .font(.headline)
                    
                    CTStack(spacing: CTSpacing.l) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.ctPrimary)
                            .frame(height: 44)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.ctSecondary)
                            .frame(height: 44)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.ctSuccess)
                            .frame(height: 44)
                    }
                    .padding()
                    .background(Color.ctBackground)
                    .cornerRadius(8)
                    
                    codeExample("""
                    CTStack(spacing: CTSpacing.l) {
                        // Items with large spacing between them
                    }
                    """)
                }
            }
            
            // View extensions
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Using View Extensions")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: CTSpacing.s) {
                        Text("With ctVStack:")
                        
                        VStack {
                            Text("First item")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.ctPrimary)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            
                            Text("Second item")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.ctSecondary)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .ctVStack(spacing: CTSpacing.m)
                        
                        Text("With ctHStack:")
                        
                        HStack {
                            Text("First")
                                .padding()
                                .background(Color.ctPrimary)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            
                            Text("Second")
                                .padding()
                                .background(Color.ctSecondary)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .ctHStack(spacing: CTSpacing.m)
                    }
                    .padding()
                    .background(Color.ctBackground)
                    .cornerRadius(8)
                    
                    codeExample("""
                    // Using view extensions
                    VStack {
                        // Content
                    }
                    .ctVStack(spacing: CTSpacing.m)
                    
                    HStack {
                        // Content
                    }
                    .ctHStack(spacing: CTSpacing.m)
                    """)
                }
            }
        }
    }
    
    /// Examples of stacks with dividers
    private var dividersSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Dividers")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTStack can automatically add dividers between items.")
                .padding(.bottom, CTSpacing.s)
            
            // Vertical dividers
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Vertical Stack with Dividers")
                        .font(.headline)
                    
                    CTStack(showDividers: true) {
                        Text("First Item")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.ctSurface)
                            .cornerRadius(8)
                        
                        Text("Second Item")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.ctSurface)
                            .cornerRadius(8)
                        
                        Text("Third Item")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.ctSurface)
                            .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.ctBackground)
                    .cornerRadius(8)
                    
                    codeExample("""
                    CTStack(showDividers: true) {
                        Text("First Item")
                        Text("Second Item")
                        Text("Third Item")
                    }
                    """)
                }
            }
            
            // Horizontal dividers
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Horizontal Stack with Custom Dividers")
                        .font(.headline)
                    
                    CTStack(
                        orientation: .horizontal,
                        spacing: CTSpacing.s,
                        showDividers: true,
                        dividerColor: .ctPrimary,
                        dividerThickness: 2
                    ) {
                        Text("First")
                            .padding()
                            .background(Color.ctSurface)
                            .cornerRadius(8)
                        
                        Text("Second")
                            .padding()
                            .background(Color.ctSurface)
                            .cornerRadius(8)
                        
                        Text("Third")
                            .padding()
                            .background(Color.ctSurface)
                            .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.ctBackground)
                    .cornerRadius(8)
                    
                    codeExample("""
                    CTStack(
                        orientation: .horizontal,
                        spacing: CTSpacing.s,
                        showDividers: true,
                        dividerColor: .ctPrimary,
                        dividerThickness: 2
                    ) {
                        Text("First")
                        Text("Second")
                        Text("Third")
                    }
                    """)
                }
            }
        }
    }
    
    /// Interactive stack examples
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
                            Text("Vertical").tag(CTStack<AnyView>.Orientation.vertical)
                            Text("Horizontal").tag(CTStack<AnyView>.Orientation.horizontal)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Spacing control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Spacing: \(Int(spacing))")
                            .font(.headline)
                        
                        Slider(value: $spacing, in: 0...50, step: 4)
                    }
                    
                    // Dividers control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Toggle("Show Dividers", isOn: $showDividers)
                            .font(.headline)
                        
                        if showDividers {
                            HStack {
                                Text("Divider Color:")
                                
                                ColorPicker("", selection: $dividerColor)
                                    .labelsHidden()
                            }
                            
                            VStack(alignment: .leading, spacing: CTSpacing.xs) {
                                Text("Divider Thickness: \(Int(dividerThickness))")
                                
                                Slider(value: $dividerThickness, in: 1...10, step: 1)
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
                        if orientation == .vertical {
                            CTStack(
                                orientation: orientation,
                                spacing: spacing,
                                showDividers: showDividers,
                                dividerColor: dividerColor,
                                dividerThickness: dividerThickness
                            ) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.ctPrimary)
                                    .frame(height: 44)
                                    .overlay(Text("Item 1").foregroundColor(.white))
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.ctSecondary)
                                    .frame(height: 44)
                                    .overlay(Text("Item 2").foregroundColor(.white))
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.ctSuccess)
                                    .frame(height: 44)
                                    .overlay(Text("Item 3").foregroundColor(.white))
                            }
                        } else {
                            CTStack(
                                orientation: orientation,
                                spacing: spacing,
                                showDividers: showDividers,
                                dividerColor: dividerColor,
                                dividerThickness: dividerThickness
                            ) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.ctPrimary)
                                    .frame(width: 80, height: 44)
                                    .overlay(Text("Item 1").foregroundColor(.white))
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.ctSecondary)
                                    .frame(width: 80, height: 44)
                                    .overlay(Text("Item 2").foregroundColor(.white))
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.ctSuccess)
                                    .frame(width: 80, height: 44)
                                    .overlay(Text("Item 3").foregroundColor(.white))
                            }
                        }
                    }
                    .padding()
                    .background(Color.ctBackground)
                    .cornerRadius(8)
                    
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
        var code = "CTStack(\n"
        
        if orientation == .horizontal {
            code += "    orientation: .horizontal,\n"
        }
        
        code += "    spacing: \(spacing != CTSpacing.m ? String(format: "%.1f", spacing) : "CTSpacing.m"),\n"
        
        if showDividers {
            code += "    showDividers: true,\n"
            
            if dividerColor != .gray {
                code += "    dividerColor: Color(...),\n"
            }
            
            if dividerThickness != 1 {
                code += "    dividerThickness: \(dividerThickness),\n"
            }
        }
        
        code += ") {\n    // Content items\n}"
        
        return code
    }
}

struct StackExamples_Previews: PreviewProvider {
    static var previews: some View {
        StackExamples()
    }
}
//
//  ContainerExamples.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view that showcases CTContainer component examples
///
/// This view demonstrates different aspects of the CTContainer component:
/// - Basic container usage
/// - Padding options
/// - Background and border customization
/// - Elevation effects with shadows
/// - Container factory methods
/// - Interactive container builder
struct ContainerExamples: View {
    // MARK: - State Properties
    
    @State private var padding: CGFloat = CTSpacing.m
    @State private var cornerRadius: CGFloat = 8
    @State private var backgroundColor: Color = .white
    @State private var hasBorder: Bool = false
    @State private var borderWidth: CGFloat = 1
    @State private var borderColor: Color = .gray
    @State private var hasShadow: Bool = false
    @State private var shadowOpacity: Double = 0.1
    @State private var shadowRadius: CGFloat = 4
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                // Basic usage section
                basicUsageSection
                
                // Padding section
                paddingSection
                
                // Background and border section
                backgroundAndBorderSection
                
                // Elevation section
                elevationSection
                
                // Factory methods section
                factoryMethodsSection
                
                // Interactive section
                interactiveSection
            }
            .padding()
        }
        .navigationTitle("Container")
        .background(Color.ctBackground.edgesIgnoringSafeArea(.all))
    }
    
    // MARK: - Private Views
    
    /// Basic usage examples of CTContainer
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Basic Usage")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTContainer provides a consistent way to wrap content with appropriate spacing and styling.")
                .padding(.bottom, CTSpacing.s)
            
            // Simple container
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Simple Container")
                        .font(.headline)
                    
                    CTContainer {
                        Text("This is a basic container with default padding.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .background(Color.ctBackground)
                    .cornerRadius(8)
                    
                    codeExample("""
                    CTContainer {
                        Text("This is a basic container with default padding.")
                    }
                    """)
                }
            }
            
            // Container with custom styling
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Custom Styled Container")
                        .font(.headline)
                    
                    CTContainer(
                        padding: CTSpacing.all(CTSpacing.l),
                        backgroundColor: Color.ctPrimary.opacity(0.1),
                        cornerRadius: 12
                    ) {
                        Text("This container has custom padding, background color, and corner radius.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    codeExample("""
                    CTContainer(
                        padding: CTSpacing.all(CTSpacing.l),
                        backgroundColor: Color.ctPrimary.opacity(0.1),
                        cornerRadius: 12
                    ) {
                        Text("This container has custom styling.")
                    }
                    """)
                }
            }
        }
    }
    
    /// Examples of different padding options
    private var paddingSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Padding Options")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTContainer supports various padding configurations for different use cases.")
                .padding(.bottom, CTSpacing.s)
            
            // Uniform padding
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Uniform Padding")
                        .font(.headline)
                    
                    HStack {
                        CTContainer(padding: CTSpacing.s) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.ctPrimary)
                                .frame(width: 60, height: 60)
                        }
                        .background(Color.ctPrimary.opacity(0.1))
                        .cornerRadius(4)
                        
                        CTContainer(padding: CTSpacing.m) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.ctSecondary)
                                .frame(width: 60, height: 60)
                        }
                        .background(Color.ctSecondary.opacity(0.1))
                        .cornerRadius(4)
                        
                        CTContainer(padding: CTSpacing.l) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.ctSuccess)
                                .frame(width: 60, height: 60)
                        }
                        .background(Color.ctSuccess.opacity(0.1))
                        .cornerRadius(4)
                    }
                    
                    codeExample("""
                    // Small padding
                    CTContainer(padding: CTSpacing.s) {
                        // Content
                    }
                    
                    // Medium padding
                    CTContainer(padding: CTSpacing.m) {
                        // Content
                    }
                    
                    // Large padding
                    CTContainer(padding: CTSpacing.l) {
                        // Content
                    }
                    """)
                }
            }
            
            // Custom edge insets
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Custom Edge Insets")
                        .font(.headline)
                    
                    CTContainer(
                        padding: CTSpacing.insets(
                            top: CTSpacing.l,
                            leading: CTSpacing.s,
                            bottom: CTSpacing.s,
                            trailing: CTSpacing.l
                        ),
                        backgroundColor: Color.ctBackground
                    ) {
                        Text("This container has different padding values for each edge.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .cornerRadius(8)
                    
                    codeExample("""
                    CTContainer(
                        padding: CTSpacing.insets(
                            top: CTSpacing.l,
                            leading: CTSpacing.s,
                            bottom: CTSpacing.s,
                            trailing: CTSpacing.l
                        )
                    ) {
                        // Content
                    }
                    """)
                }
            }
            
            // Horizontal and vertical padding
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Horizontal & Vertical Padding")
                        .font(.headline)
                    
                    CTContainer(
                        padding: CTSpacing.symmetrical(
                            horizontal: CTSpacing.l,
                            vertical: CTSpacing.s
                        ),
                        backgroundColor: Color.ctBackground
                    ) {
                        Text("This container has symmetrical horizontal and vertical padding.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .cornerRadius(8)
                    
                    codeExample("""
                    CTContainer(
                        padding: CTSpacing.symmetrical(
                            horizontal: CTSpacing.l,
                            vertical: CTSpacing.s
                        )
                    ) {
                        // Content
                    }
                    """)
                }
            }
        }
    }
    
    /// Examples of background and border customization
    private var backgroundAndBorderSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Background & Border")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Containers can have custom backgrounds and borders.")
                .padding(.bottom, CTSpacing.s)
            
            // Background color
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Background Colors")
                        .font(.headline)
                    
                    HStack {
                        CTContainer(
                            padding: CTSpacing.m,
                            backgroundColor: Color.ctPrimary
                        ) {
                            Text("Primary")
                                .foregroundColor(.white)
                        }
                        .cornerRadius(8)
                        
                        CTContainer(
                            padding: CTSpacing.m,
                            backgroundColor: Color.ctSecondary
                        ) {
                            Text("Secondary")
                                .foregroundColor(.white)
                        }
                        .cornerRadius(8)
                        
                        CTContainer(
                            padding: CTSpacing.m,
                            backgroundColor: Color.ctSuccess
                        ) {
                            Text("Success")
                                .foregroundColor(.white)
                        }
                        .cornerRadius(8)
                    }
                    
                    codeExample("""
                    CTContainer(
                        padding: CTSpacing.m,
                        backgroundColor: Color.ctPrimary
                    ) {
                        Text("Primary")
                            .foregroundColor(.white)
                    }
                    .cornerRadius(8)
                    """)
                }
            }
            
            // Borders
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Borders")
                        .font(.headline)
                    
                    HStack {
                        CTContainer(
                            padding: CTSpacing.m,
                            backgroundColor: .clear,
                            cornerRadius: 8,
                            borderWidth: 1,
                            borderColor: Color.ctPrimary
                        ) {
                            Text("Thin Border")
                                .foregroundColor(Color.ctPrimary)
                        }
                        
                        CTContainer(
                            padding: CTSpacing.m,
                            backgroundColor: .clear,
                            cornerRadius: 8,
                            borderWidth: 2,
                            borderColor: Color.ctSecondary
                        ) {
                            Text("Medium Border")
                                .foregroundColor(Color.ctSecondary)
                        }
                        
                        CTContainer(
                            padding: CTSpacing.m,
                            backgroundColor: .clear,
                            cornerRadius: 8,
                            borderWidth: 3,
                            borderColor: Color.ctSuccess
                        ) {
                            Text("Thick Border")
                                .foregroundColor(Color.ctSuccess)
                        }
                    }
                    
                    codeExample("""
                    CTContainer(
                        padding: CTSpacing.m,
                        backgroundColor: .clear,
                        cornerRadius: 8,
                        borderWidth: 2,
                        borderColor: Color.ctSecondary
                    ) {
                        Text("Medium Border")
                    }
                    """)
                }
            }
            
            // Corner radius
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Corner Radius")
                        .font(.headline)
                    
                    HStack {
                        CTContainer(
                            padding: CTSpacing.m,
                            backgroundColor: Color.ctBackground,
                            cornerRadius: 0
                        ) {
                            Text("0")
                        }
                        
                        CTContainer(
                            padding: CTSpacing.m,
                            backgroundColor: Color.ctBackground,
                            cornerRadius: 8
                        ) {
                            Text("8")
                        }
                        
                        CTContainer(
                            padding: CTSpacing.m,
                            backgroundColor: Color.ctBackground,
                            cornerRadius: 16
                        ) {
                            Text("16")
                        }
                        
                        CTContainer(
                            padding: CTSpacing.m,
                            backgroundColor: Color.ctBackground,
                            cornerRadius: 24
                        ) {
                            Text("24")
                        }
                    }
                    
                    codeExample("""
                    CTContainer(
                        padding: CTSpacing.m,
                        backgroundColor: Color.ctBackground,
                        cornerRadius: 16
                    ) {
                        Text("16")
                    }
                    """)
                }
            }
        }
    }
    
    /// Examples of elevation with shadows
    private var elevationSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Elevation")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Add elevation to containers using shadows.")
                .padding(.bottom, CTSpacing.s)
            
            // Shadow examples
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Shadow Elevation")
                        .font(.headline)
                    
                    HStack {
                        CTContainer(
                            padding: CTSpacing.m,
                            backgroundColor: Color.ctSurface,
                            cornerRadius: 8,
                            shadowEnabled: true,
                            shadowRadius: 2,
                            shadowOpacity: 0.1
                        ) {
                            Text("Low")
                                .frame(width: 80, height: 40)
                        }
                        
                        CTContainer(
                            padding: CTSpacing.m,
                            backgroundColor: Color.ctSurface,
                            cornerRadius: 8,
                            shadowEnabled: true,
                            shadowRadius: 5,
                            shadowOpacity: 0.15
                        ) {
                            Text("Medium")
                                .frame(width: 80, height: 40)
                        }
                        
                        CTContainer(
                            padding: CTSpacing.m,
                            backgroundColor: Color.ctSurface,
                            cornerRadius: 8,
                            shadowEnabled: true,
                            shadowRadius: 10,
                            shadowOpacity: 0.2
                        ) {
                            Text("High")
                                .frame(width: 80, height: 40)
                        }
                    }
                    .padding(.bottom, 10) // Extra space for shadows
                    
                    codeExample("""
                    CTContainer(
                        padding: CTSpacing.m,
                        backgroundColor: Color.ctSurface,
                        cornerRadius: 8,
                        shadowEnabled: true,
                        shadowRadius: 5,
                        shadowOpacity: 0.15
                    ) {
                        Text("Medium")
                    }
                    """)
                }
            }
        }
    }
    
    /// Examples of factory methods
    private var factoryMethodsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Factory Methods")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTContainer provides convenient factory methods for common use cases.")
                .padding(.bottom, CTSpacing.s)
            
            // Padding container
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Padding Container")
                        .font(.headline)
                    
                    CTContainer.padding(CTSpacing.all(CTSpacing.m)) {
                        Text("This container only adds padding without background or border.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.ctBackground)
                            .cornerRadius(8)
                    }
                    
                    codeExample("""
                    CTContainer.padding(CTSpacing.all(CTSpacing.m)) {
                        // Content
                    }
                    """)
                }
            }
            
            // Surface container
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Surface Container")
                        .font(.headline)
                    
                    CTContainer.surface(cornerRadius: 8, shadowStrength: 0.1) {
                        Text("This container is styled as a surface with a subtle shadow.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    codeExample("""
                    CTContainer.surface(
                        cornerRadius: 8, 
                        shadowStrength: 0.1
                    ) {
                        // Content
                    }
                    """)
                }
            }
            
            // Primary container
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Primary Container")
                        .font(.headline)
                    
                    CTContainer.primary(cornerRadius: 8) {
                        Text("This container has a primary background color.")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    codeExample("""
                    CTContainer.primary(cornerRadius: 8) {
                        // Content
                    }
                    """)
                }
            }
            
            // Bordered container
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Bordered Container")
                        .font(.headline)
                    
                    CTContainer.bordered(
                        borderWidth: 2,
                        borderColor: Color.ctPrimary,
                        cornerRadius: 8
                    ) {
                        Text("This container has a custom border.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    codeExample("""
                    CTContainer.bordered(
                        borderWidth: 2,
                        borderColor: Color.ctPrimary,
                        cornerRadius: 8
                    ) {
                        // Content
                    }
                    """)
                }
            }
        }
    }
    
    /// Interactive container builder
    private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Interactive Example")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Configure a container and see how it changes.")
                .padding(.bottom, CTSpacing.s)
            
            // Controls
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.m) {
                    // Padding control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Padding: \(Int(padding))")
                            .font(.headline)
                        
                        Slider(value: $padding, in: 0...48, step: 8)
                    }
                    
                    // Corner radius control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Corner Radius: \(Int(cornerRadius))")
                            .font(.headline)
                        
                        Slider(value: $cornerRadius, in: 0...24, step: 4)
                    }
                    
                    // Background color control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        HStack {
                            Text("Background Color:")
                                .font(.headline)
                            
                            ColorPicker("", selection: $backgroundColor)
                                .labelsHidden()
                        }
                    }
                    
                    // Border controls
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Toggle("Show Border", isOn: $hasBorder)
                            .font(.headline)
                        
                        if hasBorder {
                            VStack(alignment: .leading, spacing: CTSpacing.xs) {
                                Text("Border Width: \(Int(borderWidth))")
                                
                                Slider(value: $borderWidth, in: 1...5, step: 1)
                                
                                HStack {
                                    Text("Border Color:")
                                    
                                    ColorPicker("", selection: $borderColor)
                                        .labelsHidden()
                                }
                            }
                        }
                    }
                    
                    // Shadow controls
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Toggle("Enable Shadow", isOn: $hasShadow)
                            .font(.headline)
                        
                        if hasShadow {
                            VStack(alignment: .leading, spacing: CTSpacing.xs) {
                                Text("Shadow Opacity: \(shadowOpacity, specifier: "%.2f")")
                                
                                Slider(value: $shadowOpacity, in: 0.05...0.3, step: 0.05)
                                
                                Text("Shadow Radius: \(Int(shadowRadius))")
                                
                                Slider(value: $shadowRadius, in: 1...15, step: 1)
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
                    
                    CTContainer(
                        padding: EdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding),
                        backgroundColor: backgroundColor,
                        cornerRadius: cornerRadius,
                        borderWidth: hasBorder ? borderWidth : 0,
                        borderColor: hasBorder ? borderColor : nil,
                        shadowEnabled: hasShadow,
                        shadowRadius: shadowRadius,
                        shadowOpacity: shadowOpacity
                    ) {
                        Text("Container Content")
                            .frame(maxWidth: .infinity, alignment: .center)
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
        var code = "CTContainer(\n"
        
        // Padding
        if padding != CTSpacing.m {
            code += "    padding: EdgeInsets(top: \(padding), leading: \(padding), bottom: \(padding), trailing: \(padding)),\n"
        }
        
        // Background color
        if backgroundColor != .white {
            code += "    backgroundColor: Color(...),\n"
        }
        
        // Corner radius
        if cornerRadius != 8 {
            code += "    cornerRadius: \(cornerRadius),\n"
        }
        
        // Border
        if hasBorder {
            code += "    borderWidth: \(borderWidth),\n"
            code += "    borderColor: Color(...),\n"
        }
        
        // Shadow
        if hasShadow {
            code += "    shadowEnabled: true,\n"
            code += "    shadowRadius: \(shadowRadius),\n"
            code += "    shadowOpacity: \(String(format: "%.2f", shadowOpacity)),\n"
        }
        
        code += ") {\n    Text(\"Container Content\")\n}"
        
        return code
    }
}

struct ContainerExamples_Previews: PreviewProvider {
    static var previews: some View {
        ContainerExamples()
    }
}
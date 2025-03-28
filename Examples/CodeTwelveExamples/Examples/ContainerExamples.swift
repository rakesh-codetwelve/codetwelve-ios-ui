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
/// - Basic container usage with various padding options
/// - Different background, border, and corner radius styling
/// - Shadow effects and customization
/// - Static container styles (surface, primary, bordered)
/// - View extension methods
/// - Interactive container builder
struct ContainerExamples: View {
    // MARK: - State Properties
    
    @State private var padding: CGFloat = CTSpacing.m
    @State private var cornerRadius: CGFloat = 8
    @State private var borderWidth: CGFloat = 0
    @State private var useBackground: Bool = true
    @State private var useBorder: Bool = false
    @State private var useShadow: Bool = false
    @State private var shadowRadius: CGFloat = 4
    @State private var shadowOpacity: Double = 0.1
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                // Basic usage section
                basicUsageSection
                
                // Styling section
                stylingSection
                
                // Shadow section
                shadowSection
                
                // Container styles section
                containerStylesSection
                
                // Extension methods section
                extensionMethodsSection
                
                // Interactive section
                interactiveSection
            }
            .padding()
        }
        .navigationTitle("Container")
        .background(Color.ctBackground.edgesIgnoringSafeArea(.all))
    }
    
    // MARK: - Private Views
    
    /// Basic container usage examples
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Basic Usage")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTContainer provides a flexible way to wrap content with consistent spacing and styling.")
                .padding(.bottom, CTSpacing.s)
            
            // Basic container
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Basic Container")
                        .font(.headline)
                    
                    CTContainer {
                        Text("This is a basic container with default medium padding.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    codeExample("""
                    CTContainer {
                        Text("This is a basic container with default medium padding.")
                    }
                    """)
                }
            }
            
            // Custom padding
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Custom Padding")
                        .font(.headline)
                    
                    CTContainer(padding: CTSpacing.l) {
                        Text("This container has large padding (24pt).")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    codeExample("""
                    CTContainer(padding: CTSpacing.l) {
                        Text("This container has large padding (24pt).")
                    }
                    """)
                }
            }
            
            // Uneven padding
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Uneven Padding")
                        .font(.headline)
                    
                    CTContainer(
                        padding: EdgeInsets(
                            top: CTSpacing.l,
                            leading: CTSpacing.s,
                            bottom: CTSpacing.l,
                            trailing: CTSpacing.s
                        )
                    ) {
                        Text("This container has different padding on each side (top: 24pt, leading: 8pt, bottom: 24pt, trailing: 8pt).")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    codeExample("""
                    CTContainer(
                        padding: EdgeInsets(
                            top: CTSpacing.l,
                            leading: CTSpacing.s,
                            bottom: CTSpacing.l,
                            trailing: CTSpacing.s
                        )
                    ) {
                        Text("This container has different padding on each side.")
                    }
                    """)
                }
            }
        }
    }
    
    /// Container styling examples
    private var stylingSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Styling")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Containers can be styled with background colors, borders, and corner radius.")
                .padding(.bottom, CTSpacing.s)
            
            // Background color
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Background Color")
                        .font(.headline)
                    
                    CTContainer(backgroundColor: Color.ctPrimary.opacity(0.1)) {
                        Text("This container has a custom background color.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    codeExample("""
                    CTContainer(backgroundColor: Color.ctPrimary.opacity(0.1)) {
                        Text("This container has a custom background color.")
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
                            backgroundColor: Color.ctPrimary.opacity(0.1),
                            cornerRadius: 0
                        ) {
                            Text("0")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        CTContainer(
                            backgroundColor: Color.ctPrimary.opacity(0.1),
                            cornerRadius: 8
                        ) {
                            Text("8")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        CTContainer(
                            backgroundColor: Color.ctPrimary.opacity(0.1),
                            cornerRadius: 16
                        ) {
                            Text("16")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        CTContainer(
                            backgroundColor: Color.ctPrimary.opacity(0.1),
                            cornerRadius: 24
                        ) {
                            Text("24")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    
                    codeExample("""
                    CTContainer(
                        backgroundColor: Color.ctPrimary.opacity(0.1),
                        cornerRadius: 16
                    ) {
                        Text("16")
                    }
                    """)
                }
            }
            
            // Border
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Border")
                        .font(.headline)
                    
                    HStack {
                        CTContainer(
                            backgroundColor: Color.clear,
                            borderWidth: 1,
                            borderColor: Color.ctPrimary
                        ) {
                            Text("1px")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        CTContainer(
                            backgroundColor: Color.clear,
                            borderWidth: 2,
                            borderColor: Color.ctPrimary
                        ) {
                            Text("2px")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        CTContainer(
                            backgroundColor: Color.clear,
                            borderWidth: 3,
                            borderColor: Color.ctPrimary
                        ) {
                            Text("3px")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    
                    codeExample("""
                    CTContainer(
                        backgroundColor: Color.clear,
                        borderWidth: 2,
                        borderColor: Color.ctPrimary
                    ) {
                        Text("2px")
                    }
                    """)
                }
            }
        }
    }
    
    /// Shadow examples
    private var shadowSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Shadow Effects")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Containers can have customizable shadow effects.")
                .padding(.bottom, CTSpacing.s)
            
            // Shadow containers
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Shadow Options")
                        .font(.headline)
                    
                    HStack {
                        CTContainer(
                            shadowEnabled: true,
                            shadowRadius: 2,
                            shadowOpacity: 0.1
                        ) {
                            Text("Subtle")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        }
                        
                        CTContainer(
                            shadowEnabled: true,
                            shadowRadius: 8,
                            shadowOpacity: 0.2
                        ) {
                            Text("Medium")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        }
                        
                        CTContainer(
                            shadowEnabled: true,
                            shadowRadius: 16,
                            shadowOpacity: 0.3
                        ) {
                            Text("Strong")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        }
                    }
                    .padding(.bottom, 16) // Space for shadow
                    
                    codeExample("""
                    CTContainer(
                        shadowEnabled: true,
                        shadowRadius: 8,
                        shadowOpacity: 0.2
                    ) {
                        Text("Medium")
                    }
                    """)
                }
            }
            
            // Shadow offset
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Shadow Offset")
                        .font(.headline)
                    
                    HStack {
                        CTContainer(
                            shadowEnabled: true,
                            shadowRadius: 4,
                            shadowOpacity: 0.2,
                            shadowOffset: CGSize(width: 0, height: 4)
                        ) {
                            Text("Bottom")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        }
                        
                        CTContainer(
                            shadowEnabled: true,
                            shadowRadius: 4,
                            shadowOpacity: 0.2,
                            shadowOffset: CGSize(width: -4, height: 0)
                        ) {
                            Text("Left")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        }
                        
                        CTContainer(
                            shadowEnabled: true,
                            shadowRadius: 4,
                            shadowOpacity: 0.2,
                            shadowOffset: CGSize(width: 4, height: 4)
                        ) {
                            Text("Bottom-Right")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        }
                    }
                    .padding(.bottom, 16) // Space for shadow
                    
                    codeExample("""
                    CTContainer(
                        shadowEnabled: true,
                        shadowRadius: 4,
                        shadowOpacity: 0.2,
                        shadowOffset: CGSize(width: 4, height: 4)
                    ) {
                        Text("Bottom-Right")
                    }
                    """)
                }
            }
        }
    }
    
    /// Container styles examples
    private var containerStylesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Container Styles")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTContainer provides convenience initializers for common container styles.")
                .padding(.bottom, CTSpacing.s)
            
            // Padding container
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Padding Container")
                        .font(.headline)
                    
                    CTContainer.padding(CTSpacing.all(CTSpacing.m)) {
                        Text("This container adds padding without any styling.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .border(Color.gray.opacity(0.3))
                    }
                    
                    codeExample("""
                    CTContainer.padding(CTSpacing.all(CTSpacing.m)) {
                        Text("This container adds padding without any styling.")
                    }
                    """)
                }
            }
            
            // Surface container
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Surface Container")
                        .font(.headline)
                    
                    CTContainer.surface(
                        padding: CTSpacing.all(CTSpacing.m),
                        cornerRadius: 12,
                        shadowStrength: 0.15
                    ) {
                        Text("This container is styled as a surface with shadow.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.bottom, 8) // Extra space for shadow
                    
                    codeExample("""
                    CTContainer.surface(
                        padding: CTSpacing.all(CTSpacing.m),
                        cornerRadius: 12,
                        shadowStrength: 0.15
                    ) {
                        Text("This container is styled as a surface with shadow.")
                    }
                    """)
                }
            }
            
            // Primary container
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Primary Container")
                        .font(.headline)
                    
                    CTContainer.primary(
                        padding: CTSpacing.all(CTSpacing.m),
                        cornerRadius: 8
                    ) {
                        Text("This container uses the primary color as background.")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    codeExample("""
                    CTContainer.primary(
                        padding: CTSpacing.all(CTSpacing.m),
                        cornerRadius: 8
                    ) {
                        Text("This container uses the primary color as background.")
                            .foregroundColor(.white)
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
                        padding: CTSpacing.all(CTSpacing.m),
                        borderWidth: 2,
                        borderColor: Color.ctPrimary,
                        cornerRadius: 8
                    ) {
                        Text("This container has a border with custom styling.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    codeExample("""
                    CTContainer.bordered(
                        padding: CTSpacing.all(CTSpacing.m),
                        borderWidth: 2,
                        borderColor: Color.ctPrimary,
                        cornerRadius: 8
                    ) {
                        Text("This container has a border with custom styling.")
                    }
                    """)
                }
            }
        }
    }
    
    /// Extension methods examples
    private var extensionMethodsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("View Extensions")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTContainer provides view extensions for easy container wrapping.")
                .padding(.bottom, CTSpacing.s)
            
            // Container padding
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Container Padding")
                        .font(.headline)
                    
                    Text("This text uses the ctContainerPadding modifier.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .ctContainerPadding(CTSpacing.m)
                        .border(Color.gray.opacity(0.3))
                    
                    codeExample("""
                    Text("This text uses the ctContainerPadding modifier.")
                        .ctContainerPadding(CTSpacing.m)
                    """)
                }
            }
            
            // Surface extension
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Surface Extension")
                        .font(.headline)
                    
                    Text("This text uses the ctSurface modifier.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .ctSurface(padding: CTSpacing.all(CTSpacing.m), cornerRadius: 12)
                        .padding(.bottom, 8) // Extra space for shadow
                    
                    codeExample("""
                    Text("This text uses the ctSurface modifier.")
                        .ctSurface(
                            padding: CTSpacing.all(CTSpacing.m),
                            cornerRadius: 12
                        )
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
                        
                        Slider(value: $padding, in: 0...32, step: 4)
                    }
                    
                    // Corner radius control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Corner Radius: \(Int(cornerRadius))")
                            .font(.headline)
                        
                        Slider(value: $cornerRadius, in: 0...24, step: 4)
                    }
                    
                    // Background control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Toggle("Background", isOn: $useBackground)
                            .font(.headline)
                    }
                    
                    // Border control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Toggle("Border", isOn: $useBorder)
                            .font(.headline)
                        
                        if useBorder {
                            Text("Border Width: \(Int(borderWidth))")
                                .font(.subheadline)
                            
                            Slider(value: $borderWidth, in: 1...5, step: 1)
                        }
                    }
                    
                    // Shadow control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Toggle("Shadow", isOn: $useShadow)
                            .font(.headline)
                        
                        if useShadow {
                            Text("Shadow Radius: \(Int(shadowRadius))")
                                .font(.subheadline)
                            
                            Slider(value: $shadowRadius, in: 1...16, step: 1)
                            
                            Text("Shadow Opacity: \(String(format: "%.1f", shadowOpacity))")
                                .font(.subheadline)
                            
                            Slider(value: $shadowOpacity, in: 0.05...0.3, step: 0.05)
                        }
                    }
                }
            }
            
            // Preview
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Preview")
                        .font(.headline)
                    
                    VStack {
                        CTContainer(
                            padding: EdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding),
                            backgroundColor: useBackground ? Color.ctPrimary.opacity(0.1) : .clear,
                            cornerRadius: cornerRadius,
                            borderWidth: useBorder ? borderWidth : 0,
                            borderColor: useBorder ? Color.ctPrimary : nil,
                            shadowEnabled: useShadow,
                            shadowRadius: shadowRadius,
                            shadowOpacity: shadowOpacity
                        ) {
                            Text("Custom Container")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        }
                    }
                    .padding(.bottom, useShadow ? 16 : 0) // Extra space for shadow
                    
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
            code += "    padding: EdgeInsets(top: \(Int(padding)), leading: \(Int(padding)), bottom: \(Int(padding)), trailing: \(Int(padding))),\n"
        }
        
        // Background
        if useBackground {
            code += "    backgroundColor: Color.ctPrimary.opacity(0.1),\n"
        }
        
        // Corner radius
        if cornerRadius != 8 {
            code += "    cornerRadius: \(Int(cornerRadius)),\n"
        }
        
        // Border
        if useBorder {
            code += "    borderWidth: \(Int(borderWidth)),\n"
            code += "    borderColor: Color.ctPrimary,\n"
        }
        
        // Shadow
        if useShadow {
            code += "    shadowEnabled: true,\n"
            if shadowRadius != 4 {
                code += "    shadowRadius: \(Int(shadowRadius)),\n"
            }
            if shadowOpacity != 0.1 {
                code += "    shadowOpacity: \(String(format: "%.2f", shadowOpacity)),\n"
            }
        }
        
        code += ") {\n"
        code += "    Text(\"Custom Container\")\n"
        code += "        .frame(maxWidth: .infinity)\n"
        code += "        .padding()\n"
        code += "}"
        
        return code
    }
}

struct ContainerExamples_Previews: PreviewProvider {
    static var previews: some View {
        ContainerExamples()
    }
}
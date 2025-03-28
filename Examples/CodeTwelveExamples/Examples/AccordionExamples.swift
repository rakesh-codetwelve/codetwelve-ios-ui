//
//  AccordionExamples.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view that showcases CTAccordion component examples
///
/// This view demonstrates different aspects of the CTAccordion component:
/// - Basic accordion usage
/// - Different styles and customization options
/// - Multiple item accordions
/// - Interactive accordion examples
struct AccordionExamples: View {
    // MARK: - State Properties
    
    @State private var singleAccordionExpanded = false
    @State private var multiAccordionIndices: Set<Int> = [0]
    @State private var accordionStyle: CTAccordionStyle = .default
    @State private var animationDuration: Double = 0.3
    @State private var showDividers: Bool = true
    @State private var dividerColor: Color = .gray
    @State private var dividerThickness: CGFloat = 1
    @State private var showChevron: Bool = true
    @State private var customContentPadding: EdgeInsets = EdgeInsets(top: CTSpacing.m, leading: CTSpacing.m, bottom: CTSpacing.m, trailing: CTSpacing.m)
    @State private var cornerRadius: CGFloat = 8
    @State private var isExpanded1: Bool = false
    @State private var isExpanded2: Bool = false
    @State private var isExpanded3: Bool = false
    @State private var animatedAccordion = false
    @State private var interactiveExpanded = true
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                // Basic usage section
                basicUsageSection
                
                // Style options section
                styleOptionsSection
                
                // Multiple items section
                multipleItemsSection
                
                // Customization section
                customizationSection
                
                // Interactive section
                interactiveSection
            }
            .padding()
        }
        .navigationTitle("Accordion")
        .background(Color.ctBackground.edgesIgnoringSafeArea(.all))
    }
    
    // MARK: - Private Views
    
    /// Basic accordion usage examples
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Basic Usage")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTAccordion provides expandable and collapsible content sections.")
                .padding(.bottom, CTSpacing.s)
            
            // Basic single accordion
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Basic Accordion")
                        .font(.headline)
                    
                    CTAccordion(
                        label: "Click to expand",
                        style: .default,
                        initiallyExpanded: singleAccordionExpanded,
                        animated: true
                    ) {
                        VStack(alignment: .leading, spacing: CTSpacing.s) {
                            Text("This is the expanded content of the accordion. It can contain any SwiftUI view.")
                            
                            Text("The content is only visible when the accordion is expanded.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                    
                    codeExample("""
                    @State private var isExpanded = false
                    
                    CTAccordion(
                        label: "Click to expand",
                        style: .default,
                        initiallyExpanded: isExpanded,
                        animated: true
                    ) {
                        // Accordion content goes here
                        Text("Expanded content")
                            .padding()
                    }
                    """)
                }
            }
        }
    }
    
    /// Accordion style options examples
    private var styleOptionsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Style Options")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTAccordion supports different visual styles.")
                .padding(.bottom, CTSpacing.s)
            
            // Default style
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Default Style")
                        .font(.headline)
                    
                    CTAccordion(
                        label: "Default Style Accordion",
                        style: .default,
                        initiallyExpanded: true
                    ) {
                        Text("This accordion uses the default style which has minimal styling.")
                            .padding()
                    }
                    
                    codeExample("""
                    CTAccordion(
                        label: "Default Style Accordion",
                        style: .default,
                        initiallyExpanded: true
                    ) {
                        Text("This accordion uses the default style.")
                            .padding()
                    }
                    """)
                }
            }
            
            // Bordered style
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Bordered Style")
                        .font(.headline)
                    
                    CTAccordion(
                        label: "Bordered Style Accordion",
                        style: .bordered,
                        initiallyExpanded: true
                    ) {
                        Text("This accordion uses the bordered style which adds a border around the entire component.")
                            .padding()
                    }
                    
                    codeExample("""
                    CTAccordion(
                        label: "Bordered Style Accordion",
                        style: .bordered,
                        initiallyExpanded: true
                    ) {
                        Text("This accordion uses the bordered style.")
                            .padding()
                    }
                    """)
                }
            }
            
            // Filled style
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Filled Style")
                        .font(.headline)
                    
                    CTAccordion(
                        label: "Filled Style Accordion",
                        style: .filled,
                        initiallyExpanded: true
                    ) {
                        Text("This accordion uses the filled style which adds a background color.")
                            .padding()
                    }
                    
                    codeExample("""
                    CTAccordion(
                        label: "Filled Style Accordion",
                        style: .filled,
                        initiallyExpanded: true
                    ) {
                        Text("This accordion uses the filled style.")
                            .padding()
                    }
                    """)
                }
            }
        }
    }
    
    /// Multiple items accordion examples
    private var multipleItemsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Multiple Items")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTAccordion can be used to create multi-section expandable content.")
                .padding(.bottom, CTSpacing.s)
            
            // Multiple accordions
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Multiple Accordions")
                        .font(.headline)
                    
                    CTAccordionGroup {
                        ForEach(0..<3) { index in
                            CTAccordion(
                                label: "Section \(index + 1)",
                                style: .default,
                                initiallyExpanded: multiAccordionIndices.contains(index),
                                groupID: "\(index)"
                            ) {
                                Text("This is the content for section \(index + 1). Each section can be expanded or collapsed independently.")
                                    .padding()
                            }
                        }
                    }
                    
                    codeExample("""
                    CTAccordionGroup {
                        ForEach(0..<3) { index in
                            CTAccordion(
                                label: "Section \\(index + 1)",
                                style: .default,
                                initiallyExpanded: false,
                                groupID: "\\(index)"
                            ) {
                                Text("Content for section \\(index + 1)")
                                    .padding()
                            }
                        }
                    }
                    """)
                }
            }
            
            // Single selection accordion
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Single Selection Accordion")
                        .font(.headline)
                    
                    VStack {
                        Text("Only one section can be expanded at a time:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, CTSpacing.xs)
                        
                        CTAccordionGroup(initialExpandedID: "0") {
                            ForEach(0..<3) { index in
                                CTAccordion(
                                    label: "Section \(index + 1)",
                                    style: .default,
                                    allowMultipleExpanded: false,
                                    groupID: "\(index)"
                                ) {
                                    Text("Content for section \(index + 1). When you open a different section, this one will automatically close.")
                                        .padding()
                                }
                            }
                        }
                    }
                    
                    codeExample("""
                    CTAccordionGroup(initialExpandedID: "0") {
                        ForEach(0..<3) { index in
                            CTAccordion(
                                label: "Section \\(index + 1)",
                                style: .default,
                                allowMultipleExpanded: false,
                                groupID: "\\(index)"
                            ) {
                                Text("Content for section \\(index + 1)")
                                    .padding()
                            }
                        }
                    }
                    """)
                }
            }
        }
    }
    
    /// Accordion customization examples
    private var customizationSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Customization")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTAccordion can be customized with various options.")
                .padding(.bottom, CTSpacing.s)
            
            // Show/hide chevron
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Chevron Visibility")
                        .font(.headline)
                    
                    HStack(spacing: CTSpacing.l) {
                        VStack(alignment: .leading, spacing: CTSpacing.s) {
                            Text("With Chevron")
                                .font(.subheadline)
                            
                            CTAccordion(
                                label: "With Chevron",
                                style: .default,
                                initiallyExpanded: true,
                                showChevron: true
                            ) {
                                Text("Accordion content")
                                    .padding()
                            }
                            .frame(width: 150)
                        }
                        
                        VStack(alignment: .leading, spacing: CTSpacing.s) {
                            Text("Without Chevron")
                                .font(.subheadline)
                            
                            CTAccordion(
                                label: "No Chevron",
                                style: .default,
                                initiallyExpanded: true,
                                showChevron: false
                            ) {
                                Text("Accordion content")
                                    .padding()
                            }
                            .frame(width: 150)
                        }
                    }
                    
                    codeExample("""
                    // With chevron
                    CTAccordion(
                        label: "With Chevron",
                        style: .default,
                        initiallyExpanded: true,
                        showChevron: true
                    ) {
                        Text("Accordion content")
                            .padding()
                    }
                    
                    // Without chevron
                    CTAccordion(
                        label: "No Chevron",
                        style: .default,
                        initiallyExpanded: true,
                        showChevron: false
                    ) {
                        Text("Accordion content")
                            .padding()
                    }
                    """)
                }
            }
            
            // Custom content padding
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Custom Content Padding")
                        .font(.headline)
                    
                    CTAccordion(
                        label: "Custom Padding",
                        style: .default,
                        initiallyExpanded: true,
                        contentPadding: EdgeInsets(top: CTSpacing.l, leading: CTSpacing.l, bottom: CTSpacing.l, trailing: CTSpacing.l)
                    ) {
                        Text("This accordion has custom content padding.")
                    }
                    
                    codeExample("""
                    CTAccordion(
                        label: "Custom Padding",
                        style: .default,
                        initiallyExpanded: true,
                        contentPadding: EdgeInsets(
                            top: CTSpacing.l,
                            leading: CTSpacing.l,
                            bottom: CTSpacing.l,
                            trailing: CTSpacing.l
                        )
                    ) {
                        Text("This accordion has custom content padding.")
                    }
                    """)
                }
            }
            
            // Animation customization
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Animation Customization")
                        .font(.headline)
                    
                    VStack(spacing: CTSpacing.m) {
                        Button("Toggle Accordion") {
                            animatedAccordion.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                        
                        CTAccordion(
                            label: "Custom Animation",
                            style: .default,
                            initiallyExpanded: animatedAccordion,
                            animated: true
                        ) {
                            Text("This accordion uses the standard animation.")
                                .padding()
                        }
                    }
                    
                    codeExample("""
                    Button("Toggle Accordion") {
                        isExpanded.toggle()
                    }
                    
                    CTAccordion(
                        label: "Custom Animation",
                        style: .default,
                        initiallyExpanded: isExpanded,
                        animated: true
                    ) {
                        Text("This accordion uses the standard animation.")
                            .padding()
                    }
                    """)
                }
            }
        }
    }
    
    /// Interactive accordion builder
    private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Interactive Example")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Configure an accordion and see how it changes.")
                .padding(.bottom, CTSpacing.s)
            
            // Controls
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.m) {
                    // Style selection
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Accordion Style:")
                            .font(.headline)
                        
//                        Picker("Style", selection: $accordionStyle) {
//                            Text("Default").tag(CTAccordionStyle.default)
//                            Text("Bordered").tag(CTAccordionStyle.bordered)
//                            Text("Filled").tag(CTAccordionStyle.filled)
//                            Text("Subtle").tag(CTAccordionStyle.subtle)
//                        }
//                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Show/hide chevron
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Show Chevron:")
                            .font(.headline)
                        
                        Toggle("", isOn: $showChevron)
                    }
                    
                    // Content padding
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Content Padding:")
                            .font(.headline)
                        
                        Slider(value: $customContentPadding.top, in: 0...32, step: 4)
                        Text("Padding: \(Int(customContentPadding.top))pt")
                            .font(.caption)
                    }
                }
            }
            
            // Preview
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Preview")
                        .font(.headline)
                    
                    CTAccordion(
                        label: "Interactive Accordion",
                        style: accordionStyle,
                        initiallyExpanded: interactiveExpanded,
                        animated: true,
                        showChevron: showChevron,
                        contentPadding: customContentPadding
                    ) {
                        VStack(alignment: .leading, spacing: CTSpacing.m) {
                            Text("This is a preview of your configured accordion.")
                                .font(.body)
                            
                            Text("Try adjusting the controls above to see how they affect the accordion's appearance and behavior.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    codeExample("""
                    CTAccordion(
                        label: "Interactive Accordion",
                        style: \(String(describing: accordionStyle)),
                        initiallyExpanded: true,
                        animated: true,
                        showChevron: \(showChevron),
                        contentPadding: EdgeInsets(all: \(Int(customContentPadding.top)))
                    ) {
                        // Accordion content
                    }
                    """)
                }
            }
        }
    }
    
    /// Helper method to display code examples
    private func codeExample(_ code: String) -> some View {
        VStack(alignment: .leading) {
            Text("Example Code:")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, CTSpacing.s)
            
            Text(code)
                .font(.system(.caption, design: .monospaced))
                .padding(CTSpacing.s)
                .background(Color.ctBackground)
                .cornerRadius(CTSpacing.xs)
        }
    }
}

struct AccordionExamples_Previews: PreviewProvider {
    static var previews: some View {
        AccordionExamples()
    }
}

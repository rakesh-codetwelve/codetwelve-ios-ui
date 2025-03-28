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
/// - Basic accordion with expandable content
/// - Different accordion styles
/// - Accordions with custom headers
/// - Accordion groups with coordinated expansion
/// - Accordions with complex content
/// - Interactive accordion builder
struct AccordionExamples: View {
    // MARK: - State Properties
    
    @State private var selectedStyle: CTAccordionStyle = .default
    @State private var initiallyExpanded: Bool = false
    @State private var animated: Bool = true
    @State private var showChevron: Bool = true
    @State private var customHeaderText: String = "Custom Header"
    @State private var customContentText: String = "This is custom content for the accordion."
    
    // For accordion group
    @StateObject private var accordionController = AccordionGroupController()
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                // Basic usage section
                basicUsageSection
                
                // Styles section
                stylesSection
                
                // Custom headers section
                customHeadersSection
                
                // Accordion group section
                accordionGroupSection
                
                // Complex content section
                complexContentSection
                
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
            
            Text("CTAccordion provides an expandable/collapsible container for content.")
                .padding(.bottom, CTSpacing.s)
            
            // Basic accordion
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Basic Accordion")
                        .font(.headline)
                    
                    CTAccordion(label: "Click to expand") {
                        Text("This is the expanded content of the accordion.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.ctBackground)
                            .cornerRadius(8)
                    }
                    
                    codeExample("""
                    CTAccordion(label: "Click to expand") {
                        Text("This is the expanded content of the accordion.")
                    }
                    """)
                }
            }
            
            // Accordion initially expanded
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Initially Expanded")
                        .font(.headline)
                    
                    CTAccordion(
                        label: "Already expanded",
                        initiallyExpanded: true
                    ) {
                        Text("This accordion starts in the expanded state.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.ctBackground)
                            .cornerRadius(8)
                    }
                    
                    codeExample("""
                    CTAccordion(
                        label: "Already expanded",
                        initiallyExpanded: true
                    ) {
                        Text("This accordion starts in the expanded state.")
                    }
                    """)
                }
            }
            
            // Accordion without animation
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Without Animation")
                        .font(.headline)
                    
                    CTAccordion(
                        label: "No animation",
                        animated: false
                    ) {
                        Text("This accordion expands and collapses without animation.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.ctBackground)
                            .cornerRadius(8)
                    }
                    
                    codeExample("""
                    CTAccordion(
                        label: "No animation",
                        animated: false
                    ) {
                        Text("This accordion expands and collapses without animation.")
                    }
                    """)
                }
            }
        }
    }
    
    /// Examples of different accordion styles
    private var stylesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Accordion Styles")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTAccordion offers several built-in styles.")
                .padding(.bottom, CTSpacing.s)
            
            // Default style
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Default Style")
                        .font(.headline)
                    
                    CTAccordion(
                        label: "Default style",
                        style: .default
                    ) {
                        Text("Content for default style accordion.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.ctBackground)
                            .cornerRadius(8)
                    }
                    
                    codeExample("""
                    CTAccordion(
                        label: "Default style",
                        style: .default
                    ) {
                        Text("Content for default style accordion.")
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
                        label: "Bordered style",
                        style: .bordered
                    ) {
                        Text("Content for bordered style accordion.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.ctBackground)
                            .cornerRadius(8)
                    }
                    
                    codeExample("""
                    CTAccordion(
                        label: "Bordered style",
                        style: .bordered
                    ) {
                        Text("Content for bordered style accordion.")
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
                        label: "Filled style",
                        style: .filled
                    ) {
                        Text("Content for filled style accordion.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.ctBackground)
                            .cornerRadius(8)
                    }
                    
                    codeExample("""
                    CTAccordion(
                        label: "Filled style",
                        style: .filled
                    ) {
                        Text("Content for filled style accordion.")
                    }
                    """)
                }
            }
            
            // Subtle style
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Subtle Style")
                        .font(.headline)
                    
                    CTAccordion(
                        label: "Subtle style",
                        style: .subtle
                    ) {
                        Text("Content for subtle style accordion.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.ctBackground)
                            .cornerRadius(8)
                    }
                    
                    codeExample("""
                    CTAccordion(
                        label: "Subtle style",
                        style: .subtle
                    ) {
                        Text("Content for subtle style accordion.")
                    }
                    """)
                }
            }
            
            // Custom style
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Custom Style")
                        .font(.headline)
                    
                    CTAccordion(
                        label: "Custom style",
                        style: .custom(
                            headerColor: .purple,
                            chevronColor: .orange,
                            headerBackgroundColor: .yellow.opacity(0.2),
                            contentBackgroundColor: .green.opacity(0.1),
                            headerPadding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16),
                            contentPadding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
                            cornerRadius: 12,
                            font: .title3.bold()
                        )
                    ) {
                        Text("Content for custom style accordion.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.ctBackground)
                            .cornerRadius(8)
                    }
                    
                    codeExample("""
                    CTAccordion(
                        label: "Custom style",
                        style: .custom(
                            headerColor: .purple,
                            chevronColor: .orange,
                            headerBackgroundColor: .yellow.opacity(0.2),
                            contentBackgroundColor: .green.opacity(0.1),
                            headerPadding: EdgeInsets(...),
                            contentPadding: EdgeInsets(...),
                            cornerRadius: 12,
                            font: .title3.bold()
                        )
                    ) {
                        Text("Content for custom style accordion.")
                    }
                    """)
                }
            }
        }
    }
    
    /// Examples of accordions with custom headers
    private var customHeadersSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Custom Headers")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Accordions can have custom header content.")
                .padding(.bottom, CTSpacing.s)
            
            // Accordion with custom header
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Custom Header")
                        .font(.headline)
                    
                    CTAccordion(
                        style: .bordered,
                        headerContent: {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                
                                Text("Featured Section")
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Text("Tap to expand")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    ) {
                        Text("This accordion has a custom header with an icon and additional text.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.ctBackground)
                            .cornerRadius(8)
                    }
                    
                    codeExample("""
                    CTAccordion(
                        style: .bordered,
                        headerContent: {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                
                                Text("Featured Section")
                                
                                Spacer()
                                
                                Text("Tap to expand")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    ) {
                        Text("This accordion has a custom header...")
                    }
                    """)
                }
            }
            
            // Accordion with badge in header
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Header with Badge")
                        .font(.headline)
                    
                    CTAccordion(
                        style: .default,
                        headerContent: {
                            HStack {
                                Text("Notifications")
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Text("3")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8))
                                    .background(Color.ctPrimary)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    ) {
                        VStack(alignment: .leading, spacing: CTSpacing.s) {
                            Text("You have 3 unread notifications:")
                                .font(.headline)
                            
                            Text("• New message from Alex")
                            Text("• Your order has shipped")
                            Text("• Payment received")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.ctBackground)
                        .cornerRadius(8)
                    }
                    
                    codeExample("""
                    CTAccordion(
                        style: .default,
                        headerContent: {
                            HStack {
                                Text("Notifications")
                                
                                Spacer()
                                
                                Text("3")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(...)
                                    .background(Color.ctPrimary)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    ) {
                        // Notification content
                    }
                    """)
                }
            }
            
            // Accordion with toggle in header
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Interactive Header")
                        .font(.headline)
                    
                    // Using a state variable for the toggle
                    @State var isEnabled = false
                    
                    CTAccordion(
                        style: .bordered,
                        headerContent: {
                            HStack {
                                Text("Advanced Settings")
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Toggle("", isOn: $isEnabled)
                                    .labelsHidden()
                            }
                        }
                    ) {
                        if isEnabled {
                            VStack(alignment: .leading, spacing: CTSpacing.s) {
                                Text("Advanced settings are enabled!")
                                    .font(.headline)
                                
                                Slider(value: .constant(0.5))
                                    .padding(.vertical, CTSpacing.xs)
                                
                                HStack {
                                    Text("Developer Mode")
                                    Spacer()
                                    Toggle("", isOn: .constant(false))
                                        .labelsHidden()
                                }
                                
                                HStack {
                                    Text("Experimental Features")
                                    Spacer()
                                    Toggle("", isOn: .constant(false))
                                        .labelsHidden()
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.ctBackground)
                            .cornerRadius(8)
                        } else {
                            Text("Enable advanced settings to view options")
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.ctBackground)
                                .cornerRadius(8)
                        }
                    }
                    
                    codeExample("""
                    @State var isEnabled = false
                    
                    CTAccordion(
                        style: .bordered,
                        headerContent: {
                            HStack {
                                Text("Advanced Settings")
                                
                                Spacer()
                                
                                Toggle("", isOn: $isEnabled)
                                    .labelsHidden()
                            }
                        }
                    ) {
                        if isEnabled {
                            // Advanced settings content
                        } else {
                            Text("Enable advanced settings to view options")
                        }
                    }
                    """)
                }
            }
        }
    }
    
    /// Example of accordion groups with coordinated expansion
    private var accordionGroupSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Accordion Groups")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Use CTAccordionGroup to coordinate expansion between multiple accordions.")
                .padding(.bottom, CTSpacing.s)
            
            // Accordion group
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Accordion Group (only one can be expanded)")
                        .font(.headline)
                    
                    CTAccordionGroup {
                        CTAccordion(
                            label: "Section 1",
                            style: .bordered,
                            allowMultipleExpanded: false,
                            groupID: "section1"
                        ) {
                            Text("Content for Section 1")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.ctBackground)
                                .cornerRadius(8)
                        }
                        
                        CTAccordion(
                            label: "Section 2",
                            style: .bordered,
                            allowMultipleExpanded: false,
                            groupID: "section2"
                        ) {
                            Text("Content for Section 2")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.ctBackground)
                                .cornerRadius(8)
                        }
                        
                        CTAccordion(
                            label: "Section 3",
                            style: .bordered,
                            allowMultipleExpanded: false,
                            groupID: "section3"
                        ) {
                            Text("Content for Section 3")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.ctBackground)
                                .cornerRadius(8)
                        }
                    }
                    
                    codeExample("""
                    CTAccordionGroup {
                        CTAccordion(
                            label: "Section 1",
                            style: .bordered,
                            allowMultipleExpanded: false,
                            groupID: "section1"
                        ) {
                            Text("Content for Section 1")
                        }
                        
                        CTAccordion(
                            label: "Section 2",
                            style: .bordered,
                            allowMultipleExpanded: false,
                            groupID: "section2"
                        ) {
                            Text("Content for Section 2")
                        }
                        
                        CTAccordion(
                            label: "Section 3",
                            style: .bordered,
                            allowMultipleExpanded: false,
                            groupID: "section3"
                        ) {
                            Text("Content for Section 3")
                        }
                    }
                    """)
                }
            }
            
            // Accordion group with controller
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Accordion Group with Controller")
                        .font(.headline)
                    
                    VStack(spacing: CTSpacing.s) {
                        HStack {
                            Button("Open Section 1") {
                                accordionController.setExpandedAccordion(id: "controlled1")
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Open Section 2") {
                                accordionController.setExpandedAccordion(id: "controlled2")
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Collapse All") {
                                accordionController.collapseAll()
                            }
                            .buttonStyle(.bordered)
                        }
                        
                        CTAccordionGroup(initialExpandedID: nil) {
                            CTAccordion(
                                label: "Section 1",
                                style: .bordered,
                                allowMultipleExpanded: false,
                                groupID: "controlled1"
                            ) {
                                Text("Content for Section 1")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(Color.ctBackground)
                                    .cornerRadius(8)
                            }
                            
                            CTAccordion(
                                label: "Section 2",
                                style: .bordered,
                                allowMultipleExpanded: false,
                                groupID: "controlled2"
                            ) {
                                Text("Content for Section 2")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(Color.ctBackground)
                                    .cornerRadius(8)
                            }
                        }
                        .environmentObject(accordionController)
                    }
                    
                    codeExample("""
                    // Create a controller
                    @StateObject private var accordionController = AccordionGroupController()
                    
                    // Button controls
                    Button("Open Section 1") {
                        accordionController.setExpandedAccordion(id: "controlled1")
                    }
                    
                    Button("Collapse All") {
                        accordionController.collapseAll()
                    }
                    
                    // Accordion group
                    CTAccordionGroup {
                        CTAccordion(
                            label: "Section 1",
                            allowMultipleExpanded: false,
                            groupID: "controlled1"
                        ) {
                            // Content
                        }
                        
                        // More accordions...
                    }
                    .environmentObject(accordionController)
                    """)
                }
            }
        }
    }
    
    /// Examples of accordions with complex content
    private var complexContentSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Complex Content")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Accordions can contain complex, interactive content.")
                .padding(.bottom, CTSpacing.s)
            
            // Form in accordion
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Form in Accordion")
                        .font(.headline)
                    
                    @State var name = ""
                    @State var email = ""
                    @State var isSubscribed = false
                    
                    CTAccordion(
                        label: "Contact Information",
                        style: .bordered,
                        initiallyExpanded: true
                    ) {
                        VStack(alignment: .leading, spacing: CTSpacing.m) {
                            VStack(alignment: .leading, spacing: CTSpacing.xs) {
                                Text("Name")
                                    .font(.subheadline)
                                
                                TextField("Enter your name", text: $name)
                                    .textFieldStyle(.roundedBorder)
                            }
                            
                            VStack(alignment: .leading, spacing: CTSpacing.xs) {
                                Text("Email")
                                    .font(.subheadline)
                                
                                TextField("Enter your email", text: $email)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.emailAddress)
                            }
                            
                            Toggle("Subscribe to newsletter", isOn: $isSubscribed)
                            
                            Button("Submit") {
                                // Handle form submission
                            }
                            .buttonStyle(.borderedProminent)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding()
                        .background(Color.ctBackground)
                        .cornerRadius(8)
                    }
                    
                    codeExample("""
                    @State var name = ""
                    @State var email = ""
                    @State var isSubscribed = false
                    
                    CTAccordion(
                        label: "Contact Information",
                        style: .bordered,
                        initiallyExpanded: true
                    ) {
                        VStack(alignment: .leading, spacing: CTSpacing.m) {
                            // Form fields
                            TextField("Enter your name", text: $name)
                                .textFieldStyle(.roundedBorder)
                                
                            TextField("Enter your email", text: $email)
                                .textFieldStyle(.roundedBorder)
                                
                            Toggle("Subscribe to newsletter", isOn: $isSubscribed)
                            
                            Button("Submit") {
                                // Handle form submission
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    """)
                }
            }
            
            // Chart in accordion
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Chart in Accordion")
                        .font(.headline)
                    
                    CTAccordion(
                        label: "Sales Data",
                        style: .bordered
                    ) {
                        VStack(spacing: CTSpacing.m) {
                            // Simple bar chart using SwiftUI
                            HStack(alignment: .bottom, spacing: CTSpacing.s) {
                                ForEach(salesData.indices, id: \.self) { index in
                                    VStack {
                                        Rectangle()
                                            .fill(Color.ctPrimary)
                                            .frame(width: 30, height: CGFloat(salesData[index]) * 2)
                                        
                                        Text(months[index])
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .frame(height: 200)
                            .padding()
                            
                            Text("Monthly Sales (Q1)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.ctBackground)
                        .cornerRadius(8)
                    }
                    
                    codeExample("""
                    CTAccordion(
                        label: "Sales Data",
                        style: .bordered
                    ) {
                        // Chart content
                        HStack(alignment: .bottom, spacing: CTSpacing.s) {
                            ForEach(salesData.indices, id: \\.self) { index in
                                VStack {
                                    Rectangle()
                                        .fill(Color.ctPrimary)
                                        .frame(width: 30, height: CGFloat(salesData[index]) * 2)
                                    
                                    Text(months[index])
                                        .font(.caption)
                                }
                            }
                        }
                        
                        Text("Monthly Sales (Q1)")
                            .font(.subheadline)
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
                    // Style control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Style:")
                            .font(.headline)
                        
                        Picker("Style", selection: $selectedStyle) {
                            Text("Default").tag(CTAccordionStyle.default)
                            Text("Bordered").tag(CTAccordionStyle.bordered)
                            Text("Filled").tag(CTAccordionStyle.filled)
                            Text("Subtle").tag(CTAccordionStyle.subtle)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Initial state control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Toggle("Initially Expanded", isOn: $initiallyExpanded)
                            .font(.headline)
                    }
                    
                    // Animation control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Toggle("Animated", isOn: $animated)
                            .font(.headline)
                    }
                    
                    // Chevron control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Toggle("Show Chevron", isOn: $showChevron)
                            .font(.headline)
                    }
                    
                    // Custom header text control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Header Text:")
                            .font(.headline)
                        
                        TextField("Enter header text", text: $customHeaderText)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    // Custom content text control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Content Text:")
                            .font(.headline)
                        
                        TextField("Enter content text", text: $customContentText)
                            .textFieldStyle(.roundedBorder)
                    }
                }
            }
            
            // Preview
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Preview")
                        .font(.headline)
                    
                    CTAccordion(
                        label: customHeaderText,
                        style: selectedStyle,
                        initiallyExpanded: initiallyExpanded,
                        animated: animated,
                        showChevron: showChevron
                    ) {
                        Text(customContentText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.ctBackground)
                            .cornerRadius(8)
                    }
                    
                    codeExample(generateCode())
                }
            }
        }
    }
    
    // MARK: - Helper Properties
    
    /// Sample sales data for chart
    private let salesData = [45, 63, 72]
    
    /// Sample month labels for chart
    private let months = ["Jan", "Feb", "Mar"]
    
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
        var code = "CTAccordion(\n"
        
        code += "    label: \"\(customHeaderText)\",\n"
        
        switch selectedStyle {
        case .default:
            code += "    style: .default,\n"
        case .bordered:
            code += "    style: .bordered,\n"
        case .filled:
            code += "    style: .filled,\n"
        case .subtle:
            code += "    style: .subtle,\n"
        default:
            // Handle custom style
            code += "    style: .default,\n"
        }
        
        if initiallyExpanded {
            code += "    initiallyExpanded: true,\n"
        }
        
        if !animated {
            code += "    animated: false,\n"
        }
        
        if !showChevron {
            code += "    showChevron: false,\n"
        }
        
        code += ") {\n    Text(\"\(customContentText)\")\n}"
        
        return code
    }
}

struct AccordionExamples_Previews: PreviewProvider {
    static var previews: some View {
        AccordionExamples()
    }
}
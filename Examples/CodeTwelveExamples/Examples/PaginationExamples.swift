//
//  PaginationExamples.swift
//  CodeTwelveExamples
//
//  Created on 28/03/25.
//

import SwiftUI
import CodetwelveUI

/// Examples demonstrating the usage of the CTPagination component
struct PaginationExamples: View {
    // MARK: - State Properties
    
    /// Current page in each example
    @State private var currentPage1 = 5
    @State private var currentPage2 = 5
    @State private var currentPage3 = 5
    @State private var currentPage4 = 5
    @State private var currentPage5 = 5
    @State private var currentPageCustom = 5
    
    /// Toggle for showing code examples
    @State private var showBasicCode = false
    @State private var showStylesCode = false
    @State private var showSizesCode = false
    @State private var showRangeCode = false
    @State private var showEdgeButtonsCode = false
    
    /// Interactive example options
    @State private var interactiveTotalPages = 20
    @State private var interactivePageRange = 2
    @State private var interactiveCurrentPage = 5
    @State private var interactiveShowEdgeButtons = true
    @State private var selectedStyle: CTPagination.PaginationStyle = .primary
    @State private var selectedSize: CTPagination.PaginationSize = .medium
    @State private var showInteractiveCode = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                basicUsageSection
                stylesSection
                sizesSection
                pageRangeSection
                edgeButtonsSection
                interactiveSection
            }
            .padding()
        }
        .navigationTitle("Pagination")
    }
    
    // MARK: - Basic Usage Section
    
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Basic Usage", showCode: $showBasicCode)
            
            Text("Pagination enables navigation through multiple pages of content.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            PaginationContainer {
                CTPagination(
                    currentPage: $currentPage1,
                    totalPages: 10
                )
            }
            
            if showBasicCode {
                CodePreview(code: """
                @State private var currentPage = 1
                
                CTPagination(
                    currentPage: $currentPage,
                    totalPages: 10
                )
                """)
            }
        }
    }
    
    // MARK: - Styles Section
    
    private var stylesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Pagination Styles", showCode: $showStylesCode)
            
            Text("Pagination comes in different styles to match your app's design.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            VStack(spacing: CTSpacing.l) {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Primary Style").ctBody().fontWeight(.medium)
                    
                    PaginationContainer {
                        CTPagination(
                            currentPage: $currentPage2,
                            totalPages: 10,
                            style: .primary
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Secondary Style").ctBody().fontWeight(.medium)
                    
                    PaginationContainer {
                        CTPagination(
                            currentPage: $currentPage3,
                            totalPages: 10,
                            style: .secondary
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Minimal Style").ctBody().fontWeight(.medium)
                    
                    PaginationContainer {
                        CTPagination(
                            currentPage: $currentPage4,
                            totalPages: 10,
                            style: .minimal
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Custom Style").ctBody().fontWeight(.medium)
                    
                    PaginationContainer {
                        CTPagination(
                            currentPage: $currentPage5,
                            totalPages: 10,
                            style: .custom(Color.green)
                        )
                    }
                }
            }
            
            if showStylesCode {
                CodePreview(code: """
                // Primary Style
                CTPagination(
                    currentPage: $currentPage,
                    totalPages: 10,
                    style: .primary
                )
                
                // Secondary Style
                CTPagination(
                    currentPage: $currentPage,
                    totalPages: 10,
                    style: .secondary
                )
                
                // Minimal Style
                CTPagination(
                    currentPage: $currentPage,
                    totalPages: 10,
                    style: .minimal
                )
                
                // Custom Style
                CTPagination(
                    currentPage: $currentPage,
                    totalPages: 10,
                    style: .custom(Color.green)
                )
                """)
            }
        }
    }
    
    // MARK: - Sizes Section
    
    private var sizesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Pagination Sizes", showCode: $showSizesCode)
            
            Text("Pagination is available in different sizes.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            VStack(spacing: CTSpacing.l) {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Small Size").ctBody().fontWeight(.medium)
                    
                    PaginationContainer {
                        CTPagination(
                            currentPage: $currentPage1,
                            totalPages: 10,
                            size: .small
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Medium Size").ctBody().fontWeight(.medium)
                    
                    PaginationContainer {
                        CTPagination(
                            currentPage: $currentPage2,
                            totalPages: 10,
                            size: .medium
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Large Size").ctBody().fontWeight(.medium)
                    
                    PaginationContainer {
                        CTPagination(
                            currentPage: $currentPage3,
                            totalPages: 10,
                            size: .large
                        )
                    }
                }
            }
            
            if showSizesCode {
                CodePreview(code: """
                // Small Size
                CTPagination(
                    currentPage: $currentPage,
                    totalPages: 10,
                    size: .small
                )
                
                // Medium Size
                CTPagination(
                    currentPage: $currentPage,
                    totalPages: 10,
                    size: .medium
                )
                
                // Large Size
                CTPagination(
                    currentPage: $currentPage,
                    totalPages: 10,
                    size: .large
                )
                """)
            }
        }
    }
    
    // MARK: - Page Range Section
    
    private var pageRangeSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Page Range Configuration", showCode: $showRangeCode)
            
            Text("You can control how many page numbers appear around the current page.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            VStack(spacing: CTSpacing.l) {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Default Range (2)").ctBody().fontWeight(.medium)
                    
                    PaginationContainer {
                        CTPagination(
                            currentPage: $currentPage1,
                            totalPages: 20,
                            pageRange: 2
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Small Range (1)").ctBody().fontWeight(.medium)
                    
                    PaginationContainer {
                        CTPagination(
                            currentPage: $currentPage2,
                            totalPages: 20,
                            pageRange: 1
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Large Range (3)").ctBody().fontWeight(.medium)
                    
                    PaginationContainer {
                        CTPagination(
                            currentPage: $currentPage3,
                            totalPages: 20,
                            pageRange: 3
                        )
                    }
                }
            }
            
            if showRangeCode {
                CodePreview(code: """
                // Default Range (2)
                CTPagination(
                    currentPage: $currentPage,
                    totalPages: 20,
                    pageRange: 2
                )
                
                // Small Range (1)
                CTPagination(
                    currentPage: $currentPage,
                    totalPages: 20,
                    pageRange: 1
                )
                
                // Large Range (3)
                CTPagination(
                    currentPage: $currentPage,
                    totalPages: 20,
                    pageRange: 3
                )
                """)
            }
        }
    }
    
    // MARK: - Edge Buttons Section
    
    private var edgeButtonsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Edge Buttons", showCode: $showEdgeButtonsCode)
            
            Text("You can show or hide 'First' and 'Last' buttons.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            VStack(spacing: CTSpacing.l) {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("With Edge Buttons").ctBody().fontWeight(.medium)
                    
                    PaginationContainer {
                        CTPagination(
                            currentPage: $currentPage4,
                            totalPages: 20,
                            showEdgeButtons: true
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Without Edge Buttons").ctBody().fontWeight(.medium)
                    
                    PaginationContainer {
                        CTPagination(
                            currentPage: $currentPage5,
                            totalPages: 20,
                            showEdgeButtons: false
                        )
                    }
                }
            }
            
            if showEdgeButtonsCode {
                CodePreview(code: """
                // With Edge Buttons
                CTPagination(
                    currentPage: $currentPage,
                    totalPages: 20,
                    showEdgeButtons: true
                )
                
                // Without Edge Buttons
                CTPagination(
                    currentPage: $currentPage,
                    totalPages: 20,
                    showEdgeButtons: false
                )
                """)
            }
        }
    }
    
    // MARK: - Interactive Section
    
    private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Interactive Example")
                .ctHeading3()
                .padding(.bottom, CTSpacing.s)
            
            Text("Configure your pagination by adjusting the options below.")
                .ctBody()
                .padding(.bottom, CTSpacing.m)
            
            // Configuration options
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                // Style picker
                HStack {
                    Text("Style:").ctBody().frame(width: 120, alignment: .leading)
                    Picker("Style", selection: $selectedStyle) {
                        Text("Primary").tag(CTPagination.PaginationStyle.primary)
                        Text("Secondary").tag(CTPagination.PaginationStyle.secondary)
                        Text("Minimal").tag(CTPagination.PaginationStyle.minimal)
                        Text("Custom").tag(CTPagination.PaginationStyle.custom(Color.green))
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Size picker
                HStack {
                    Text("Size:").ctBody().frame(width: 120, alignment: .leading)
                    Picker("Size", selection: $selectedSize) {
                        Text("Small").tag(CTPagination.PaginationSize.small)
                        Text("Medium").tag(CTPagination.PaginationSize.medium)
                        Text("Large").tag(CTPagination.PaginationSize.large)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Total pages slider
                HStack {
                    Text("Total Pages:").ctBody().frame(width: 120, alignment: .leading)
                    Slider(value: $interactiveTotalPages.double, in: 5...50, step: 1)
                    Text("\(interactiveTotalPages)").ctCaption().frame(width: 30)
                }
                
                // Page range slider
                HStack {
                    Text("Page Range:").ctBody().frame(width: 120, alignment: .leading)
                    Slider(value: $interactivePageRange.double, in: 0...5, step: 1)
                    Text("\(interactivePageRange)").ctCaption().frame(width: 30)
                }
                
                // Current page slider
                HStack {
                    Text("Current Page:").ctBody().frame(width: 120, alignment: .leading)
                    Slider(value: $interactiveCurrentPage.double, in: 1...Double(interactiveTotalPages), step: 1)
                    Text("\(interactiveCurrentPage)").ctCaption().frame(width: 30)
                }
                
                // Edge buttons toggle
                HStack {
                    Text("Edge Buttons:").ctBody().frame(width: 120, alignment: .leading)
                    Toggle("", isOn: $interactiveShowEdgeButtons)
                }
            }
            .padding()
            .background(Color.ctSurface)
            .cornerRadius(12)
            
            // Preview
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Preview").ctBody().fontWeight(.medium)
                
                PaginationContainer {
                    CTPagination(
                        currentPage: $interactiveCurrentPage,
                        totalPages: interactiveTotalPages,
                        style: selectedStyle,
                        size: selectedSize,
                        pageRange: interactivePageRange,
                        showEdgeButtons: interactiveShowEdgeButtons
                    )
                }
                
                Button(action: {
                    showInteractiveCode.toggle()
                }) {
                    Text(showInteractiveCode ? "Hide Code" : "Show Code")
                }
                .padding(.vertical, CTSpacing.s)
                
                if showInteractiveCode {
                    CodePreview(code: generateInteractiveCode())
                }
            }
            .padding(.top, CTSpacing.m)
        }
    }
    
    // MARK: - Helper Methods
    
    /// Generate code for the interactive example
    private func generateInteractiveCode() -> String {
        var code = """
        @State private var currentPage = \(interactiveCurrentPage)
        
        CTPagination(
            currentPage: $currentPage,
            totalPages: \(interactiveTotalPages),
        """
        
        // Add style if not default
        if selectedStyle != .primary {
            code += "\n    style: .\(styleToString(selectedStyle)),"
        }
        
        // Add size if not default
        if selectedSize != .medium {
            code += "\n    size: .\(sizeToString(selectedSize)),"
        }
        
        // Add page range if not default
        if interactivePageRange != 2 {
            code += "\n    pageRange: \(interactivePageRange),"
        }
        
        // Add edge buttons if not default
        if !interactiveShowEdgeButtons {
            code += "\n    showEdgeButtons: false,"
        }
        
        // Close the function call
        code += "\n)"
        
        return code
    }
    
    /// Convert style to string representation
    private func styleToString(_ style: CTPagination.PaginationStyle) -> String {
        switch style {
        case .primary: return "primary"
        case .secondary: return "secondary"
        case .minimal: return "minimal"
        case .custom: return "custom(Color.green)"
        }
    }
    
    /// Convert size to string representation
    private func sizeToString(_ size: CTPagination.PaginationSize) -> String {
        switch size {
        case .small: return "small"
        case .medium: return "medium"
        case .large: return "large"
        }
    }
}

// MARK: - Helper Views

/// A container view for pagination examples
struct PaginationContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
        .padding()
        .background(Color.ctBackground)
        .cornerRadius(12)
        .shadow(color: Color.ctShadow.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Binding Extensions

extension Binding where Value == Int {
    var double: Binding<Double> {
        Binding<Double>(
            get: { Double(self.wrappedValue) },
            set: { self.wrappedValue = Int($0) }
        )
    }
}

// MARK: - Preview Provider

struct PaginationExamples_Previews: PreviewProvider {
    static var previews: some View {
        PaginationExamples()
    }
}

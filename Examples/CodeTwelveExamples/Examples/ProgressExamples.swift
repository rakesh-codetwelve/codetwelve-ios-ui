//
//  ProgressExamples.swift
//  CodeTwelveExamples
//
//  Created on 28/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view that demonstrates different ways to use the CTProgress component.
struct ProgressExamples: View {
    // MARK: - State Properties
    
    /// Progress value (0.0 to 1.0)
    @State private var progressValue: Double = 0.3
    
    /// Selected style for the custom progress
    @State private var selectedStyle: CTProgressStyle = .linear
    
    /// Selected size for the custom progress
    @State private var selectedSize: CTProgressSize = .medium
    
    /// Custom label for the progress indicator
    @State private var progressLabel = "Loading..."
    
    /// Whether to show percentage
    @State private var showPercentage = false
    
    /// Selected label position
    @State private var selectedLabelPosition: CTProgressLabelPosition = .bottom
    
    /// Whether the progress is indeterminate
    @State private var isIndeterminate = false
    
    /// State for showing code examples
    @State private var showBasicCode = false
    @State private var showStylesCode = false
    @State private var showCustomCode = false
    
    /// Timer for the animated progress example
    @State private var timer: Timer? = nil
    @State private var animatedProgress: Double = 0.0
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                basicUsageSection
                progressStylesSection
                progressStatesSection
                customProgressSection
                progressUsageSection
            }
            .padding(.vertical, CTSpacing.l)
            .padding(.horizontal, CTSpacing.m)
        }
        .navigationTitle("Progress")
        .onAppear {
            startAnimatedProgress()
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
    }
    
    // MARK: - Sections
    
    /// Basic usage examples of progress indicators
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Basic Usage").ctHeading2()
                
                Text("Progress indicators show the completion status of an operation or task.")
                    .ctBody()
                    .padding(.bottom, CTSpacing.s)
                
                // Linear progress examples
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Linear Progress:").ctBodyBold()
                    
                    CTProgress(value: 0.3)
                        .padding(.bottom, CTSpacing.xs)
                    
                    CTProgress(value: 0.5, label: "Loading...")
                        .padding(.bottom, CTSpacing.xs)
                    
                    CTProgress(value: 0.7, showPercentage: true)
                }
                .padding(.bottom, CTSpacing.m)
                
                // Circular progress examples
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Circular Progress:").ctBodyBold()
                    
                    HStack(spacing: CTSpacing.l) {
                        CTProgress(value: 0.3, style: .circular)
                        CTProgress(value: 0.5, style: .circular, label: "Loading...")
                        CTProgress(value: 0.7, style: .circular, showPercentage: true, labelPosition: .center)
                    }
                }
                
                ToggleCodeButton(isExpanded: $showBasicCode)
                    .padding(Edge.Set.top, CTSpacing.s)
                
                if showBasicCode {
                    codeExample("""
                    // Basic linear progress
                    CTProgress(value: 0.3)
                    
                    // Linear progress with label
                    CTProgress(value: 0.5, label: "Loading...")
                    
                    // Linear progress with percentage
                    CTProgress(value: 0.7, showPercentage: true)
                    
                    // Basic circular progress
                    CTProgress(value: 0.3, style: .circular)
                    
                    // Circular progress with centered percentage
                    CTProgress(
                        value: 0.7,
                        style: .circular,
                        showPercentage: true,
                        labelPosition: .center
                    )
                    """)
                }
            }
        }
        .padding(CTSpacing.m)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    /// Examples of different progress styles and sizes
    private var progressStylesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Progress Styles").ctHeading2()
                
                Text("Progress indicators come in different styles and sizes to fit your layout needs.")
                    .ctBody()
                    .padding(.bottom, CTSpacing.s)
                
                // Sizes
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Sizes:").ctBodyBold()
                    
                    CTProgress(value: 0.5, size: .small, label: "Small")
                        .padding(.bottom, CTSpacing.xs)
                    
                    CTProgress(value: 0.5, size: .medium, label: "Medium")
                        .padding(.bottom, CTSpacing.xs)
                    
                    CTProgress(value: 0.5, size: .large, label: "Large")
                }
                .padding(.bottom, CTSpacing.m)
                
                // Colors
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Colors:").ctBodyBold()
                    
                    CTProgress(value: 0.5, size: .medium, color: .ctPrimary, label: "Primary")
                        .padding(.bottom, CTSpacing.xs)
                    
                    CTProgress(value: 0.5, size: .medium, color: .ctSuccess, label: "Success")
                        .padding(.bottom, CTSpacing.xs)
                    
                    CTProgress(value: 0.5, size: .medium, color: .ctDestructive, label: "Destructive")
                        .padding(.bottom, CTSpacing.xs)
                    
                    CTProgress(value: 0.5, size: .medium, color: .ctWarning, label: "Warning")
                }
                
                ToggleCodeButton(isExpanded: $showStylesCode)
                    .padding(Edge.Set.top, CTSpacing.s)
                
                if showStylesCode {
                    codeExample("""
                    // Small progress
                    CTProgress(value: 0.5, size: .small, label: "Small")
                    
                    // Medium progress
                    CTProgress(value: 0.5, size: .medium, label: "Medium")
                    
                    // Large progress
                    CTProgress(value: 0.5, size: .large, label: "Large")
                    
                    // Custom color progress
                    CTProgress(value: 0.5, size: .medium, color: .ctSuccess, label: "Success")
                    """)
                }
            }
        }
        .padding(CTSpacing.m)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    /// Examples of different progress states
    private var progressStatesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Progress States").ctHeading2()
                
                Text("Progress indicators can show determinate progress with a specific value or indeterminate progress for unknown completion times.")
                    .ctBody()
                    .padding(.bottom, CTSpacing.s)
                
                // Indeterminate progress
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Indeterminate Progress:").ctBodyBold()
                    
                    CTProgress(
                        label: "Loading...",
                        isIndeterminate: true
                    )
                    .padding(.bottom, CTSpacing.s)
                    
                    CTProgress(
                        style: .circular,
                        label: "Processing...",
                        isIndeterminate: true
                    )
                }
                .padding(.bottom, CTSpacing.m)
                
                // Animated progress
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Animated Progress:").ctBodyBold()
                    
                    CTProgress(
                        value: animatedProgress,
                        label: "Uploading...",
                        showPercentage: true
                    )
                }
            }
        }
        .padding(CTSpacing.m)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    /// Custom progress configuration section
    private var customProgressSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Custom Progress").ctHeading2()
            
            Text("You can customize various aspects of progress indicators including the value, style, size, label, and more.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            // Progress value slider
            VStack(alignment: .leading, spacing: CTSpacing.xs) {
                Text("Value: \(Int(progressValue * 100))%").ctBodyBold()
                Slider(value: $progressValue)
                    .disabled(isIndeterminate)
            }
            
            // Style picker
            VStack(alignment: .leading, spacing: CTSpacing.xs) {
                Text("Style:").ctBodyBold()
                Picker("Style", selection: $selectedStyle) {
                    Text("Linear").tag(CTProgressStyle.linear)
                    Text("Circular").tag(CTProgressStyle.circular)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            // Size picker
            VStack(alignment: .leading, spacing: CTSpacing.xs) {
                Text("Size:").ctBodyBold()
                Picker("Size", selection: $selectedSize) {
                    Text("Small").tag(CTProgressSize.small)
                    Text("Medium").tag(CTProgressSize.medium)
                    Text("Large").tag(CTProgressSize.large)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            // Label input
            VStack(alignment: .leading, spacing: CTSpacing.xs) {
                Text("Label:").ctBodyBold()
                TextField("Progress label", text: $progressLabel)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // Label position picker (only enabled for circular style)
            VStack(alignment: .leading, spacing: CTSpacing.xs) {
                Text("Label Position:").ctBodyBold()
                Picker("Label Position", selection: $selectedLabelPosition) {
                    Text("Top").tag(CTProgressLabelPosition.top)
                    Text("Bottom").tag(CTProgressLabelPosition.bottom)
                    if selectedStyle == .circular {
                        Text("Center").tag(CTProgressLabelPosition.center)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .disabled(progressLabel.isEmpty && !showPercentage)
            }
            
            // Options
            VStack(alignment: .leading, spacing: CTSpacing.xs) {
                Toggle("Show Percentage", isOn: $showPercentage)
                Toggle("Indeterminate", isOn: $isIndeterminate)
            }
            
            // Preview
            Text("Preview:").ctBodyBold()
                .padding(.top, CTSpacing.s)
            
            CTProgress(
                value: progressValue,
                style: selectedStyle,
                size: selectedSize,
                label: progressLabel.isEmpty ? nil : progressLabel,
                showPercentage: showPercentage,
                labelPosition: selectedLabelPosition,
                isIndeterminate: isIndeterminate
            )
            
            ToggleCodeButton(isExpanded: $showCustomCode)
                .padding(Edge.Set.top, CTSpacing.s)
            
            if showCustomCode {
                codeExample("""
                CTProgress(
                    value: \(String(format: "%.2f", progressValue)),
                    style: .\(styleString(selectedStyle)),
                    size: .\(sizeString(selectedSize)),
                    \(progressLabel.isEmpty ? "" : "label: \"\(progressLabel)\",")
                    showPercentage: \(showPercentage),
                    labelPosition: .\(labelPositionString(selectedLabelPosition)),
                    isIndeterminate: \(isIndeterminate)
                )
                """)
            }
        }
        .padding(CTSpacing.m)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    /// Usage examples of progress indicators
    private var progressUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Usage Examples").ctHeading2()
            
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("File Upload:").ctBodyBold()
                
                HStack(spacing: CTSpacing.m) {
                    Image(systemName: "doc.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.ctPrimary)
                    
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("document.pdf")
                            .ctBody()
                        
                        CTProgress(value: 0.65, size: .small)
                        
                        Text("65% • 2.4 MB of 3.7 MB")
                            .ctCaption()
                            .foregroundColor(.ctTextSecondary)
                    }
                }
                .padding()
                .background(Color.ctSurface)
                .cornerRadius(8)
            }
            .padding(.bottom, CTSpacing.m)
            
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Task Completion:").ctBodyBold()
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    HStack {
                        Text("Project Setup")
                            .ctBody()
                        
                        Spacer()
                        
                        Text("Complete")
                            .ctCaption()
                            .foregroundColor(.ctSuccess)
                    }
                    
                    CTProgress(value: 1.0, size: .small, color: .ctSuccess)
                    
                    HStack {
                        Text("Design System")
                            .ctBody()
                        
                        Spacer()
                        
                        Text("75%")
                            .ctCaption()
                            .foregroundColor(.ctPrimary)
                    }
                    
                    CTProgress(value: 0.75, size: .small)
                    
                    HStack {
                        Text("Development")
                            .ctBody()
                        
                        Spacer()
                        
                        Text("25%")
                            .ctCaption()
                            .foregroundColor(.ctPrimary)
                    }
                    
                    CTProgress(value: 0.25, size: .small)
                }
                .padding()
                .background(Color.ctSurface)
                .cornerRadius(8)
            }
        }
        .padding(CTSpacing.m)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Helper Methods
    
    /// Returns a code example view with the provided code string
    /// - Parameter code: The code to display
    /// - Returns: A styled code example view
    private func codeExample(_ code: String) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(code)
                .ctCode()
                .padding(CTSpacing.m)
                .background(Color.black.opacity(0.05))
                .cornerRadius(CTSpacing.s)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    /// Converts a CTProgressStyle to its string representation
    /// - Parameter style: The progress style
    /// - Returns: String representation of the style
    private func styleString(_ style: CTProgressStyle) -> String {
        switch style {
        case .linear:
            return "linear"
        case .circular:
            return "circular"
        }
    }
    
    /// Converts a CTProgressSize to its string representation
    /// - Parameter size: The progress size
    /// - Returns: String representation of the size
    private func sizeString(_ size: CTProgressSize) -> String {
        switch size {
        case .small:
            return "small"
        case .medium:
            return "medium"
        case .large:
            return "large"
        default:
            return "medium"
        }
    }
    
    /// Converts a CTProgressLabelPosition to its string representation
    /// - Parameter position: The label position
    /// - Returns: String representation of the position
    private func labelPositionString(_ position: CTProgressLabelPosition) -> String {
        switch position {
        case .top:
            return "top"
        case .bottom:
            return "bottom"
        case .center:
            return "center"
        }
    }
    
    /// Starts the animated progress example
    private func startAnimatedProgress() {
        // Reset progress
        animatedProgress = 0.0
        
        // Set up timer to update progress
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            withAnimation {
                if animatedProgress < 1.0 {
                    animatedProgress += 0.005
                } else {
                    // Reset when complete
                    animatedProgress = 0.0
                }
            }
        }
    }
}

// MARK: - Supporting Views

/// A button that toggles the visibility of code examples
struct ToggleCodeButton: View {
    @Binding var isExpanded: Bool
    
    var body: some View {
        Button(action: {
            withAnimation {
                isExpanded.toggle()
            }
        }) {
            HStack {
                Text(isExpanded ? "Hide Code" : "Show Code")
                    .ctBodySmall()
                    .foregroundColor(.ctPrimary)
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 12))
                    .foregroundColor(.ctPrimary)
            }
            .padding(.vertical, CTSpacing.xs)
            .padding(.horizontal, CTSpacing.s)
            .background(Color.ctPrimary.opacity(0.1))
            .cornerRadius(CTSpacing.xs)
        }
    }
}

// MARK: - Previews

struct ProgressExamples_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProgressExamples()
        }
    }
}

//
//  SkeletonLoaderExamples.swift
//  CodeTwelveExamples
//
//  Created on 28/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view that demonstrates different ways to use the CTSkeletonLoader component.
struct SkeletonLoaderExamples: View {
    // MARK: - State Properties
    
    /// Selected skeleton shape for the custom skeleton
    @State private var selectedShape: CTSkeletonShape = .rectangle
    
    /// Selected animation type for the custom skeleton
    @State private var selectedAnimation: CTSkeletonAnimation = .pulse
    
    /// Width of the custom skeleton
    @State private var skeletonWidth: CGFloat = 200
    
    /// Height of the custom skeleton
    @State private var skeletonHeight: CGFloat = 20
    
    /// Corner radius of the custom skeleton
    @State private var cornerRadius: CGFloat = 8
    
    /// Number of text lines for text skeleton
    @State private var textLines: Double = 3
    
    /// Width of last line for text skeleton (as percentage)
    @State private var lastLineWidth: Double = 0.6
    
    /// Whether to show loading state for the examples
    @State private var isLoading = true
    
    /// Sample data for the content that would replace the skeleton when loaded
    @State private var sampleData: [SampleItem]? = nil
    
    /// State for showing code examples
    @State private var showBasicCode = false
    @State private var showCustomCode = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: CTSpacing.l) {
                basicUsageSection
                animationTypesSection
                customSkeletonSection
                commonPatternsSection
                usageExampleSection
            }
            .padding()
        }
        .navigationTitle("Skeleton Loader")
        .onAppear {
            // Simulate loading data
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                loadSampleData()
            }
        }
    }
    
    // MARK: - Sections
    
    /// Basic usage examples of skeleton loaders
    private var basicUsageSection: some View {
        CTCard {
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                Text("Basic Usage").ctHeading2()
                
                Text("Skeleton loaders provide visual placeholders during content loading to improve perceived performance.")
                    .ctBody()
                    .padding(.bottom, CTSpacing.s)
                
                // Toggle to show/hide skeletons
                Toggle("Show Loading State", isOn: $isLoading)
                    .padding(.bottom, CTSpacing.m)
                
                // Basic shapes
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Basic Shapes:").ctBodyBold()
                    
                    HStack(spacing: CTSpacing.m) {
                        VStack(spacing: CTSpacing.xs) {
                            Text("Rectangle").ctCaption()
                            CTSkeletonLoader(shape: .rectangle)
                                .frame(width: 150, height: 20)
                        }
                        
                        VStack(spacing: CTSpacing.xs) {
                            Text("Circle").ctCaption()
                            CTSkeletonLoader(shape: .circle)
                                .frame(width: 50, height: 50)
                        }
                        
                        VStack(spacing: CTSpacing.xs) {
                            Text("Capsule").ctCaption()
                            CTSkeletonLoader(shape: .capsule)
                                .frame(width: 100, height: 30)
                        }
                    }
                }
                .padding(.bottom, CTSpacing.m)
                
                // Text skeleton
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Text Skeleton:").ctBodyBold()
                    
                    CTSkeletonLoader(shape: .text(lines: 3, lastLineWidth: 0.7))
                        .frame(width: 300)
                }
                
                ToggleCodeButton(isExpanded: $showBasicCode)
                    .padding(.top, CTSpacing.s)
                
                if showBasicCode {
                    codeExample("""
                    // Rectangle skeleton
                    CTSkeletonLoader(shape: .rectangle)
                        .frame(width: 150, height: 20)
                    
                    // Circle skeleton
                    CTSkeletonLoader(shape: .circle)
                        .frame(width: 50, height: 50)
                    
                    // Capsule skeleton
                    CTSkeletonLoader(shape: .capsule)
                        .frame(width: 100, height: 30)
                    
                    // Text skeleton with multiple lines
                    CTSkeletonLoader(shape: .text(lines: 3, lastLineWidth: 0.7))
                        .frame(width: 300)
                    """)
                }
            }
        }
    }
    
    /// Examples of different skeleton animation types
    private var animationTypesSection: some View {
        CTCard {
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                Text("Animation Types").ctHeading2()
                
                Text("Skeleton loaders support different animation types to indicate loading state.")
                    .ctBody()
                    .padding(.bottom, CTSpacing.s)
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Pulse Animation:").ctBodyBold()
                    CTSkeletonLoader(
                        shape: .rectangle,
                        animation: .pulse
                    )
                    .frame(width: 300, height: 50)
                }
                .padding(.bottom, CTSpacing.m)
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Shimmer Animation:").ctBodyBold()
                    CTSkeletonLoader(
                        shape: .rectangle,
                        animation: .shimmer
                    )
                    .frame(width: 300, height: 50)
                }
                .padding(.bottom, CTSpacing.m)
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("No Animation:").ctBodyBold()
                    CTSkeletonLoader(
                        shape: .rectangle,
                        animation: .none
                    )
                    .frame(width: 300, height: 50)
                }
            }
        }
    }
    
    /// Custom skeleton configuration section
    private var customSkeletonSection: some View {
        CTCard {
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                Text("Custom Skeleton").ctHeading2()
                
                Text("You can customize various aspects of skeleton loaders including the shape, size, animation type, and appearance.")
                    .ctBody()
                    .padding(.bottom, CTSpacing.s)
                
                // Shape picker
                VStack(alignment: .leading, spacing: CTSpacing.xs) {
                    Text("Shape:").ctBodyBold()
                    Picker("Shape", selection: $selectedShape) {
                        Text("Rectangle").tag(CTSkeletonShape.rectangle)
                        Text("Square").tag(CTSkeletonShape.square)
                        Text("Circle").tag(CTSkeletonShape.circle)
                        Text("Capsule").tag(CTSkeletonShape.capsule)
                        Text("Text").tag(CTSkeletonShape.text(lines: Int(textLines), lastLineWidth: lastLineWidth))
                    }
                    .onChange(of: selectedShape) { newValue in
                        if case .text = newValue {
                            // Create a new text shape with current parameters
                            selectedShape = .text(lines: Int(textLines), lastLineWidth: lastLineWidth)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Animation type picker
                VStack(alignment: .leading, spacing: CTSpacing.xs) {
                    Text("Animation:").ctBodyBold()
                    Picker("Animation", selection: $selectedAnimation) {
                        Text("Pulse").tag(CTSkeletonAnimation.pulse)
                        Text("Shimmer").tag(CTSkeletonAnimation.shimmer)
                        Text("None").tag(CTSkeletonAnimation.none)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Text skeleton options (only shown for text shape)
                switch selectedShape {
                case .text:
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Text Lines: \(Int(textLines))").ctBodyBold()
                        Slider(value: $textLines, in: 1...8, step: 1)
                            .onChange(of: textLines) { newValue in
                                selectedShape = .text(lines: Int(newValue), lastLineWidth: lastLineWidth)
                            }
                        
                        Text("Last Line Width: \(Int(lastLineWidth * 100))%").ctBodyBold()
                        Slider(value: $lastLineWidth, in: 0.1...1.0, step: 0.05)
                            .onChange(of: lastLineWidth) { newValue in
                                selectedShape = .text(lines: Int(textLines), lastLineWidth: newValue)
                            }
                    }
                default:
                    // Size options (only shown for non-text shapes)
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Width: \(Int(skeletonWidth))").ctBodyBold()
                        Slider(value: $skeletonWidth, in: 50...300, step: 10)
                        
                        Text("Height: \(Int(skeletonHeight))").ctBodyBold()
                        Slider(value: $skeletonHeight, in: 10...150, step: 10)
                    }
                }
                
                // Corner radius (only applicable to rectangle/square)
                switch selectedShape {
                case .rectangle, .square:
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Corner Radius: \(Int(cornerRadius))").ctBodyBold()
                        Slider(value: $cornerRadius, in: 0...20, step: 1)
                    }
                default:
                    EmptyView()
                }
                
                // Preview
                Text("Preview:").ctBodyBold()
                    .padding(.top, CTSpacing.s)
                
                customSkeletonPreview
                
                ToggleCodeButton(isExpanded: $showCustomCode)
                    .padding(.top, CTSpacing.s)
                
                if showCustomCode {
                    codeExample(generateCustomCode())
                }
            }
        }
    }
    
    /// Common skeleton loader patterns
    private var commonPatternsSection: some View {
        CTCard {
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                Text("Common Patterns").ctHeading2()
                
                Text("Skeleton loaders are commonly used in various UI patterns to represent loading content.")
                    .ctBody()
                    .padding(.bottom, CTSpacing.s)
                
                // Profile card skeleton
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Profile Card:").ctBodyBold()
                    
                    HStack(spacing: CTSpacing.m) {
                        CTSkeletonLoader(shape: .circle)
                            .frame(width: 64, height: 64)
                        
                        VStack(alignment: .leading, spacing: CTSpacing.s) {
                            CTSkeletonLoader(shape: .rectangle)
                                .frame(width: 150, height: 20)
                            
                            CTSkeletonLoader(shape: .rectangle)
                                .frame(width: 100, height: 16)
                        }
                    }
                    .padding()
                    .background(Color.ctSurface)
                    .cornerRadius(CTSpacing.m)
                }
                .padding(.bottom, CTSpacing.m)
                
                // List skeleton
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("List Items:").ctBodyBold()
                    
                    VStack(spacing: CTSpacing.m) {
                        ForEach(0..<3) { _ in
                            HStack(spacing: CTSpacing.m) {
                                CTSkeletonLoader(shape: .square)
                                    .frame(width: 40, height: 40)
                                
                                VStack(alignment: .leading, spacing: CTSpacing.xs) {
                                    CTSkeletonLoader(shape: .rectangle)
                                        .frame(width: 120, height: 16)
                                    
                                    CTSkeletonLoader(shape: .rectangle)
                                        .frame(width: 80, height: 12)
                                }
                                
                                Spacer()
                                
                                CTSkeletonLoader(shape: .capsule)
                                    .frame(width: 60, height: 24)
                            }
                        }
                    }
                    .padding()
                    .background(Color.ctSurface)
                    .cornerRadius(CTSpacing.m)
                }
            }
        }
    }
    
    /// Example of usage with actual content loading
    private var usageExampleSection: some View {
        CTCard {
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                Text("Usage Example").ctHeading2()
                
                Text("This example demonstrates how to use skeleton loaders while loading actual content.")
                    .ctBody()
                    .padding(.bottom, CTSpacing.s)
                
                if isLoading || sampleData == nil {
                    // Skeleton UI
                    VStack(spacing: CTSpacing.m) {
                        // Header skeleton
                        HStack {
                            CTSkeletonLoader(shape: .rectangle)
                                .frame(width: 150, height: 24)
                            
                            Spacer()
                            
                            CTSkeletonLoader(shape: .capsule)
                                .frame(width: 80, height: 30)
                        }
                        
                        // List items skeletons
                        ForEach(0..<5) { _ in
                            HStack(spacing: CTSpacing.m) {
                                CTSkeletonLoader(shape: .square)
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(CTSpacing.xs)
                                
                                VStack(alignment: .leading, spacing: CTSpacing.xs) {
                                    CTSkeletonLoader(shape: .rectangle)
                                        .frame(width: 180, height: 16)
                                    
                                    CTSkeletonLoader(shape: .rectangle)
                                        .frame(width: 120, height: 12)
                                }
                                
                                Spacer()
                                
                                CTSkeletonLoader(shape: .rectangle)
                                    .frame(width: 40, height: 20)
                            }
                            .padding()
                            .background(Color.ctSurface)
                            .cornerRadius(CTSpacing.s)
                        }
                    }
                } else {
                    // Actual content
                    VStack(spacing: CTSpacing.m) {
                        // Header
                        HStack {
                            Text("Sample List").ctHeading2()
                            
                            Spacer()
                            
                            CTButton("Refresh", style: .primary) {
                                isLoading = true
                                sampleData = nil
                                loadSampleData()
                            }
                        }
                        
                        // List items
                        if let items = sampleData {
                            ForEach(items) { item in
                                HStack(spacing: CTSpacing.m) {
                                    CTAvatar(initials: item.initials)
                                        .frame(width: 50, height: 50)
                                    
                                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                                        Text(item.title).ctBodyBold()
                                        Text(item.subtitle).ctCaption()
                                    }
                                    
                                    Spacer()
                                    
                                    Text(item.value).ctBody()
                                }
                                .padding()
                                .background(Color.ctSurface)
                                .cornerRadius(CTSpacing.s)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Supporting Views
    
    /// Preview of the custom skeleton based on the selected parameters
    private var customSkeletonPreview: some View {
        switch selectedShape {
        case .text(let lines, let lastLineWidth):
            return AnyView(
                CTSkeletonLoader(
                    shape: .text(lines: lines, lastLineWidth: lastLineWidth),
                    animation: selectedAnimation,
                    size: CGSize(width: skeletonWidth, height: CGFloat(lines) * 16 + CGFloat(lines - 1) * 8),
                    cornerRadius: cornerRadius
                )
                .frame(width: skeletonWidth)
            )
        default:
            let size = selectedShape == .square ? CGSize(width: skeletonWidth, height: skeletonWidth) : CGSize(width: skeletonWidth, height: skeletonHeight)
            
            return AnyView(
                CTSkeletonLoader(
                    shape: selectedShape,
                    animation: selectedAnimation,
                    size: size,
                    cornerRadius: cornerRadius
                )
            )
        }
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
    
    /// Generates the code for the custom skeleton
    /// - Returns: Generated code as a string
    private func generateCustomCode() -> String {
        var code = "CTSkeletonLoader(\n"
        
        // Shape
        switch selectedShape {
        case .rectangle:
            code += "    shape: .rectangle,\n"
        case .square:
            code += "    shape: .square,\n"
        case .circle:
            code += "    shape: .circle,\n"
        case .capsule:
            code += "    shape: .capsule,\n"
        case .text(let lines, let lastLineWidth):
            code += "    shape: .text(lines: \(lines), lastLineWidth: \(String(format: "%.2f", lastLineWidth))),\n"
        }
        
        // Animation
        switch selectedAnimation {
        case .pulse:
            code += "    animation: .pulse,\n"
        case .shimmer:
            code += "    animation: .shimmer,\n"
        case .none:
            code += "    animation: .none,\n"
        }
        
        // Size
        switch selectedShape {
        case .text(let lines, _):
            code += "    size: CGSize(width: \(Int(skeletonWidth)), height: \(lines * 16 + (lines - 1) * 8)),\n"
        case .square:
            code += "    size: CGSize(width: \(Int(skeletonWidth)), height: \(Int(skeletonWidth))),\n"
        default:
            code += "    size: CGSize(width: \(Int(skeletonWidth)), height: \(Int(skeletonHeight))),\n"
        }
        
        // Corner radius (only for rectangle/square)
        switch selectedShape {
        case .rectangle, .square:
            code += "    cornerRadius: \(Int(cornerRadius))\n"
        default:
            code = code.trimmingCharacters(in: CharacterSet(charactersIn: ",\n")) + "\n"
        }
        
        code += ")"
        
        return code
    }
    
    /// Loads sample data for the usage example
    private func loadSampleData() {
        let items = [
            SampleItem(
                title: "Wireless Headphones",
                subtitle: "Premium sound quality",
                initials: "WH",
                value: "$199"
            ),
            SampleItem(
                title: "Smart Watch",
                subtitle: "Fitness tracking & notifications",
                initials: "SW",
                value: "$249"
            ),
            SampleItem(
                title: "Laptop Stand",
                subtitle: "Ergonomic design",
                initials: "LS",
                value: "$59"
            ),
            SampleItem(
                title: "Wireless Charger",
                subtitle: "Fast charging technology",
                initials: "WC",
                value: "$39"
            ),
            SampleItem(
                title: "Bluetooth Speaker",
                subtitle: "Waterproof & portable",
                initials: "BS",
                value: "$89"
            )
        ]
        
        sampleData = items
        isLoading = false
    }
}

// MARK: - Supporting Types

/// Sample item for the usage example
struct SampleItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let initials: String
    let value: String
}

// MARK: - Previews

struct SkeletonLoaderExamples_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SkeletonLoaderExamples()
        }
    }
}

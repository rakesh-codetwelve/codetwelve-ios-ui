//
//  TabBarExamples.swift
//  CodeTwelveExamples
//
//  Created on 28/03/25.
//

import SwiftUI
import CodetwelveUI

/// Examples demonstrating the usage of the CTTabBar component
struct TabBarExamples: View {
    // MARK: - State Properties
    
    /// Current selected tab in each example
    @State private var selectedTab1 = 0
    @State private var selectedTab2 = 0
    @State private var selectedTab3 = 0
    @State private var selectedTab4 = 0
    @State private var selectedCustomTab = 0
    @State private var selectedInteractiveTab = 0
    
    /// Toggle for showing code examples
    @State private var showBasicCode = false
    @State private var showStylesCode = false
    @State private var showLabelsCode = false
    @State private var showAlignmentCode = false
    @State private var showBackgroundCode = false
    
    /// Interactive example options
    @State private var showLabels = true
    @State private var selectedStyle: CTTabBarStyle = .default
    @State private var selectedAlignment: CTTabBarAlignment = .spaceEvenly
    @State private var selectedBackground: CTTabBarBackgroundStyle = .standard
    @State private var badge1 = 0
    @State private var badge2 = 0
    @State private var badge3 = 0
    @State private var badge4 = 0
    
    // MARK: - Sample Data
    
    /// Sample tab items for demonstration
    private let sampleTabs = [
        CTTabItem(label: "Home", icon: "house"),
        CTTabItem(label: "Search", icon: "magnifyingglass"),
        CTTabItem(label: "Favorites", icon: "heart"),
        CTTabItem(label: "Profile", icon: "person")
    ]
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                basicUsageSection
                stylesSection
                labelsSection
                alignmentSection
                backgroundStylesSection
                interactiveSection
            }
            .padding(CTSpacing.m)
        }
        .navigationTitle("Tab Bar")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - Basic Usage Section
    
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Basic Usage", showCode: $showBasicCode)
            
            Text("A tab bar provides navigation between different sections of an app.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, CTSpacing.s)
            
            TabBarDemoContainer {
                CTTabBar(
                    selectedTab: $selectedTab1,
                    tabs: sampleTabs
                )
            }
            
            if showBasicCode {
                CodePreview("""
                @State private var selectedTab = 0

                CTTabBar(
                    selectedTab: $selectedTab,
                    tabs: [
                        CTTabItem(label: "Home", icon: "house"),
                        CTTabItem(label: "Search", icon: "magnifyingglass"),
                        CTTabItem(label: "Favorites", icon: "heart"),
                        CTTabItem(label: "Profile", icon: "person")
                    ]
                )
                """)
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    // MARK: - Styles Section
    
    private var stylesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Tab Bar Styles", showCode: $showStylesCode)
            
            Text("Tab bars come in different styles to match your app's design language.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            VStack(spacing: CTSpacing.l) {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Default Style").ctBody().fontWeight(.medium)
                    
                    TabBarDemoContainer {
                        CTTabBar(
                            selectedTab: $selectedTab1,
                            tabs: sampleTabs,
                            style: .default
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Filled Style").ctBody().fontWeight(.medium)
                    
                    TabBarDemoContainer {
                        CTTabBar(
                            selectedTab: $selectedTab2,
                            tabs: sampleTabs,
                            style: .filled
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Indicator Style").ctBody().fontWeight(.medium)
                    
                    TabBarDemoContainer {
                        CTTabBar(
                            selectedTab: $selectedTab3,
                            tabs: sampleTabs,
                            style: .indicator
                        )
                    }
                }
            }
            
            if showStylesCode {
              CodePreview("""
                // Default Style
                CTTabBar(
                    selectedTab: $selectedTab,
                    tabs: tabs,
                    style: .default
                )
                
                // Filled Style
                CTTabBar(
                    selectedTab: $selectedTab,
                    tabs: tabs,
                    style: .filled
                )
                
                // Indicator Style
                CTTabBar(
                    selectedTab: $selectedTab,
                    tabs: tabs,
                    style: .indicator
                )
                """)
            }
        }
    }
    
    // MARK: - Labels Section
    
    private var labelsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Tab Labels", showCode: $showLabelsCode)
            
            Text("Tab bars can be displayed with or without labels.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            VStack(spacing: CTSpacing.l) {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("With Labels").ctBody().fontWeight(.medium)
                    
                    TabBarDemoContainer {
                        CTTabBar(
                            selectedTab: $selectedTab1,
                            tabs: sampleTabs,
                            showLabels: true
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Without Labels").ctBody().fontWeight(.medium)
                    
                    TabBarDemoContainer {
                        CTTabBar(
                            selectedTab: $selectedTab2,
                            tabs: sampleTabs,
                            showLabels: false
                        )
                    }
                }
            }
            
            if showLabelsCode {
              CodePreview("""
                // With Labels
                CTTabBar(
                    selectedTab: $selectedTab,
                    tabs: tabs,
                    showLabels: true
                )
                
                // Without Labels
                CTTabBar(
                    selectedTab: $selectedTab,
                    tabs: tabs,
                    showLabels: false
                )
                """)
            }
        }
    }
    
    // MARK: - Alignment Section
    
    private var alignmentSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Tab Alignment", showCode: $showAlignmentCode)
            
            Text("Tab bars can have different alignment configurations.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            VStack(spacing: CTSpacing.l) {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Space Evenly").ctBody().fontWeight(.medium)
                    
                    TabBarDemoContainer {
                        CTTabBar(
                            selectedTab: $selectedTab1,
                            tabs: sampleTabs,
                            alignment: .spaceEvenly
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Distributed").ctBody().fontWeight(.medium)
                    
                    TabBarDemoContainer {
                        CTTabBar(
                            selectedTab: $selectedTab2,
                            tabs: sampleTabs,
                            alignment: .distributed
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Leading").ctBody().fontWeight(.medium)
                    
                    TabBarDemoContainer {
                        CTTabBar(
                            selectedTab: $selectedTab3,
                            tabs: sampleTabs,
                            alignment: .leading
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Trailing").ctBody().fontWeight(.medium)
                    
                    TabBarDemoContainer {
                        CTTabBar(
                            selectedTab: $selectedTab4,
                            tabs: sampleTabs,
                            alignment: .trailing
                        )
                    }
                }
            }
            
            if showAlignmentCode {
              CodePreview("""
                // Space Evenly
                CTTabBar(
                    selectedTab: $selectedTab,
                    tabs: tabs,
                    alignment: .spaceEvenly
                )
                
                // Distributed
                CTTabBar(
                    selectedTab: $selectedTab,
                    tabs: tabs,
                    alignment: .distributed
                )
                
                // Leading
                CTTabBar(
                    selectedTab: $selectedTab,
                    tabs: tabs,
                    alignment: .leading
                )
                
                // Trailing
                CTTabBar(
                    selectedTab: $selectedTab,
                    tabs: tabs,
                    alignment: .trailing
                )
                """)
            }
        }
    }
    
    // MARK: - Background Styles Section
    
    private var backgroundStylesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Background Styles", showCode: $showBackgroundCode)
            
            Text("Tab bars can have different background styles.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            VStack(spacing: CTSpacing.l) {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Standard").ctBody().fontWeight(.medium)
                    
                    TabBarDemoContainer {
                        CTTabBar(
                            selectedTab: $selectedTab1,
                            tabs: sampleTabs,
                            backgroundStyle: .standard
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Solid Color").ctBody().fontWeight(.medium)
                    
                    TabBarDemoContainer {
                        CTTabBar(
                            selectedTab: $selectedTab2,
                            tabs: sampleTabs,
                            backgroundStyle: .solid(Color.ctPrimary.opacity(0.1))
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Blur").ctBody().fontWeight(.medium)
                    
                    TabBarDemoContainer {
                        CTTabBar(
                            selectedTab: $selectedTab3,
                            tabs: sampleTabs,
                            backgroundStyle: .blur
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Invisible").ctBody().fontWeight(.medium)
                    
                    TabBarDemoContainer {
                        CTTabBar(
                            selectedTab: $selectedTab4,
                            tabs: sampleTabs,
                            backgroundStyle: .invisible
                        )
                    }
                }
            }
            
            if showBackgroundCode {
              CodePreview("""
                // Standard
                CTTabBar(
                    selectedTab: $selectedTab,
                    tabs: tabs,
                    backgroundStyle: .standard
                )
                
                // Solid Color
                CTTabBar(
                    selectedTab: $selectedTab,
                    tabs: tabs,
                    backgroundStyle: .solid(Color.ctPrimary.opacity(0.1))
                )
                
                // Blur
                CTTabBar(
                    selectedTab: $selectedTab,
                    tabs: tabs,
                    backgroundStyle: .blur
                )
                
                // Invisible
                CTTabBar(
                    selectedTab: $selectedTab,
                    tabs: tabs,
                    backgroundStyle: .invisible
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
            
            Text("Configure your tab bar by adjusting the options below.")
                .ctBody()
                .padding(.bottom, CTSpacing.m)
            
            // Configuration options
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                // Style picker
                HStack {
                    Text("Style:").ctBody().frame(width: 100, alignment: .leading)
                    Picker("Style", selection: $selectedStyle) {
                        Text("Default").tag(CTTabBarStyle.default)
                        Text("Filled").tag(CTTabBarStyle.filled)
                        Text("Indicator").tag(CTTabBarStyle.indicator)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Labels toggle
                HStack {
                    Text("Labels:").ctBody().frame(width: 100, alignment: .leading)
                    Toggle("", isOn: $showLabels)
                }
                
                // Alignment picker
                HStack {
                    Text("Alignment:").ctBody().frame(width: 100, alignment: .leading)
                    Picker("Alignment", selection: $selectedAlignment) {
                        Text("Space Evenly").tag(CTTabBarAlignment.spaceEvenly)
                        Text("Distributed").tag(CTTabBarAlignment.distributed)
                        Text("Leading").tag(CTTabBarAlignment.leading)
                        Text("Trailing").tag(CTTabBarAlignment.trailing)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Background style picker
                HStack {
                    Text("Background:").ctBody().frame(width: 100, alignment: .leading)
                    Picker("Background", selection: $selectedBackground) {
                        Text("Standard").tag(CTTabBarBackgroundStyle.standard)
                        Text("Solid").tag(CTTabBarBackgroundStyle.solid(Color.ctPrimary.opacity(0.1)))
                        Text("Blur").tag(CTTabBarBackgroundStyle.blur)
                        Text("Invisible").tag(CTTabBarBackgroundStyle.invisible)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Badge configuration
                Text("Badge Configuration:").ctBody().padding(.top, CTSpacing.m)
                HStack {
                    VStack {
                        Text("Home").ctCaption()
                        Stepper("\(badge1)", value: $badge1, in: 0...99)
                    }
                    
                    VStack {
                        Text("Search").ctCaption()
                        Stepper("\(badge2)", value: $badge2, in: 0...99)
                    }
                    
                    VStack {
                        Text("Favorites").ctCaption()
                        Stepper("\(badge3)", value: $badge3, in: 0...99)
                    }
                    
                    VStack {
                        Text("Profile").ctCaption()
                        Stepper("\(badge4)", value: $badge4, in: 0...99)
                    }
                }
            }
            .padding()
            .background(Color.ctSurface)
            .cornerRadius(12)
            
            // Preview
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Preview").ctBody().fontWeight(.medium)
                
                TabBarDemoContainer {
                    CTTabBar(
                        selectedTab: $selectedInteractiveTab,
                        tabs: [
                            CTTabItem(label: "Home", icon: "house", badgeCount: badge1),
                            CTTabItem(label: "Search", icon: "magnifyingglass", badgeCount: badge2),
                            CTTabItem(label: "Favorites", icon: "heart", badgeCount: badge3),
                            CTTabItem(label: "Profile", icon: "person", badgeCount: badge4)
                        ],
                        style: selectedStyle,
                        showLabels: showLabels,
                        alignment: selectedAlignment,
                        backgroundStyle: selectedBackground
                    )
                }
                
              CodePreview(generateInteractiveCode())
            }
            .padding(.top, CTSpacing.m)
        }
    }
    
    // MARK: - Helper Methods
    
    /// Generate code for the interactive example based on current settings
    private func generateInteractiveCode() -> String {
        var code = """
        CTTabBar(
            selectedTab: $selectedTab,
            tabs: [
                CTTabItem(label: "Home", icon: "house"\(badge1 > 0 ? ", badgeCount: \(badge1)" : "")),
                CTTabItem(label: "Search", icon: "magnifyingglass"\(badge2 > 0 ? ", badgeCount: \(badge2)" : "")),
                CTTabItem(label: "Favorites", icon: "heart"\(badge3 > 0 ? ", badgeCount: \(badge3)" : "")),
                CTTabItem(label: "Profile", icon: "person"\(badge4 > 0 ? ", badgeCount: \(badge4)" : ""))
            ],
        """
        
        // Add style if not default
        if selectedStyle != .default {
            code += "\n    style: .\(styleToString(selectedStyle)),"
        }
        
        // Add showLabels if false
        if !showLabels {
            code += "\n    showLabels: false,"
        }
        
        // Add alignment if not spaceEvenly
        if selectedAlignment != .spaceEvenly {
            code += "\n    alignment: .\(alignmentToString(selectedAlignment)),"
        }
        
        // Add background style if not standard
        if selectedBackground != .standard {
            code += "\n    backgroundStyle: .\(backgroundToString(selectedBackground)),"
        }
        
        // Close the function call
        code += "\n)"
        
        return code
    }
    
    /// Convert style to string representation
    private func styleToString(_ style: CTTabBarStyle) -> String {
        switch style {
        case .default: return "default"
        case .filled: return "filled"
        case .indicator: return "indicator"
        }
    }
    
    /// Convert alignment to string representation
    private func alignmentToString(_ alignment: CTTabBarAlignment) -> String {
        switch alignment {
        case .spaceEvenly: return "spaceEvenly"
        case .distributed: return "distributed"
        case .leading: return "leading"
        case .trailing: return "trailing"
        }
    }
    
    /// Convert background style to string representation
    private func backgroundToString(_ background: CTTabBarBackgroundStyle) -> String {
        switch background {
        case .standard: return "standard"
        case .solid: return "solid(Color.ctPrimary.opacity(0.1))"
        case .blur: return "blur"
        case .invisible: return "invisible"
        }
    }
}

// MARK: - Helper Views

/// A container view to demo tab bars with the right height and styling
struct TabBarDemoContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(Color.ctSecondary.opacity(0.05))
                .frame(maxWidth: .infinity)
                .frame(height: 250)
                .cornerRadius(12)
            
            content
                .frame(maxWidth: .infinity)
        }
    }
}

/// A header for each section with optional code toggle
struct SectionHeader: View {
    let title: String
    @Binding var showCode: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .ctHeading3()
            
            Spacer()
            
            Button(action: {
                showCode.toggle()
            }) {
                Image(systemName: "chevron.right")
                    .rotationEffect(.degrees(showCode ? 90 : 0))
                    .imageScale(.small)
                Text(showCode ? "Hide Code" : "Show Code")
                    .ctCaption()
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, CTSpacing.s)
            .padding(.vertical, CTSpacing.xxs)
            .background(Color.ctSecondary.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

// MARK: - Preview Provider

struct TabBarExamples_Previews: PreviewProvider {
    static var previews: some View {
        TabBarExamples()
    }
}

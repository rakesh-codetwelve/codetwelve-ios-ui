//
//  ThemeExplorer.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view for exploring and switching between different themes in the application.
///
/// This view demonstrates the theming capabilities of the CodeTwelveUI library by
/// showing previews of various UI components with different themes applied.
struct ThemeExplorer: View {
    // MARK: - State Properties
    
    /// The currently selected theme
    @State private var selectedTheme: ThemeOption = .default
    
    // MARK: - Private Properties
    
    /// The available theme options
    private let themes: [ThemeOption] = [
        .default,
        .dark,
        .light,
        .custom(name: "Blue", color: .blue),
        .custom(name: "Green", color: .green),
        .custom(name: "Purple", color: .purple)
    ]
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // Theme selector
            themePicker
                .padding()
                .background(Color.ctSurface)
            
            // Theme preview
            ScrollView {
                VStack(spacing: CTSpacing.m) {
                    // Preview sections
                    themeInfoCard
                    basicComponentsPreview
                    layoutComponentsPreview
                    formComponentsPreview
                    feedbackComponentsPreview
                }
                .padding()
            }
        }
        .navigationTitle("Theme Explorer")
        .onChange(of: selectedTheme) { newTheme in
            applyTheme(newTheme)
        }
        .onAppear {
            // Initialize with the current theme
            selectedTheme = .default
        }
    }
    
    // MARK: - Private Views
    
    /// Theme picker control
    private var themePicker: some View {
        Picker("Theme", selection: $selectedTheme) {
            ForEach(themes, id: \.id) { theme in
                Text(theme.name).tag(theme)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    /// Theme information card
    private var themeInfoCard: some View {
        CTCard {
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Current Theme: \(selectedTheme.name)")
                    .ctHeading2()
                    .foregroundColor(Color.ctText)
                
                Text("This explorer shows how components adapt to different themes. Select a theme from the picker above to see how the components change.")
                    .ctBody()
                    .foregroundColor(Color.ctTextSecondary)
            }
        }
    }
    
    /// Basic components preview
    private var basicComponentsPreview: some View {
        CTCard {
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                Text("Basic Components")
                    .ctHeading3()
                    .foregroundColor(Color.ctText)
                
                HStack(spacing: CTSpacing.m) {
                    CTButton("Primary") {}
                    CTButton("Secondary", style: .secondary) {}
                    CTButton("Outline", style: .outline) {}
                }
                
                CTDivider()
                
                Text("This is a text component with the current theme applied.")
                    .ctBody()
                    .foregroundColor(Color.ctText)
            }
        }
    }
    
    /// Layout components preview
    private var layoutComponentsPreview: some View {
        CTCard {
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                Text("Layout Components")
                    .ctHeading3()
                    .foregroundColor(Color.ctText)
                
                CTAccordion(
                    initiallyExpanded: true,
                    headerContent: {
                        Text("Expandable Content")
                            .ctBody()
                    }, content: {
                        Text("This accordion content shows how nested components inherit the current theme.")
                            .ctBodySmall()
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.ctBackground)
                            .cornerRadius(8)
                    })
            }
        }
    }
    
    /// Form components preview
    private var formComponentsPreview: some View {
        CTCard {
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                Text("Form Components")
                    .ctHeading3()
                    .foregroundColor(Color.ctText)
                
                HStack(spacing: CTSpacing.m) {
                    CTToggle(
                        "Toggle",
                        isOn: .constant(true)
                    )
                    CTCheckbox("Checkbox", isChecked: .constant(true))
                }
                
                HStack(spacing: CTSpacing.m) {
                    Slider(value: .constant(0.5))
                        .frame(maxWidth: .infinity)
                    
                    CTTextField(
                        "Custom Field", 
                        placeholder: "Type something",
                        text: .constant("")
                    )
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    /// Feedback components preview
    private var feedbackComponentsPreview: some View {
        CTCard {
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                Text("Feedback Components")
                    .ctHeading3()
                    .foregroundColor(Color.ctText)
                
                CTAlert(
                    title: "Information Alert",
                    message: "This is an example of an alert component with the current theme.",
                    severity: .info
                )
                
                CTProgress(
                    value: 0.7,
                    style: .linear,
                    showPercentage: true
                )
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Apply the selected theme to the application
    /// - Parameter theme: The theme option to apply
    private func applyTheme(_ theme: ThemeOption) {
        selectedTheme = theme
        
        switch theme.type {
        case .default:
            CTThemeManager.shared.setTheme(CTDefaultTheme())
        case .dark:
            CTThemeManager.shared.setTheme(CTDarkTheme())
        case .light:
            CTThemeManager.shared.setTheme(CTLightTheme())
        case let .custom(name, color):
            let themeBuilder = CTThemeBuilder()
                .withPrimaryColor(color)
                .withName(name)
            
            CTThemeManager.shared.setTheme(themeBuilder.build())
        }
    }
}

// MARK: - Supporting Types

/// Represents a theme option in the explorer
struct ThemeOption: Identifiable, Equatable, Hashable {
    /// Unique identifier for the theme option
    let id = UUID()
    
    /// The display name of the theme
    let name: String
    
    /// The theme type
    let type: ThemeType
    
    /// Optional color for custom themes
    let color: Color?
    
    /// Default theme option
    static let `default` = ThemeOption(name: "Default", type: .default, color: nil)
    
    /// Dark theme option
    static let dark = ThemeOption(name: "Dark", type: .dark, color: nil)
    
    /// Light theme option
    static let light = ThemeOption(name: "Light", type: .light, color: nil)
    
    /// Create a custom theme option
    /// - Parameters:
    ///   - name: The display name of the theme
    ///   - color: The primary color for the theme
    static func custom(name: String, color: Color) -> ThemeOption {
        ThemeOption(name: name, type: .custom(name: name, color: color), color: color)
    }
    
    /// Equatable implementation
    static func == (lhs: ThemeOption, rhs: ThemeOption) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Hashable implementation
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/// Represents the type of theme
enum ThemeType {
    case `default`
    case dark
    case light
    case custom(name: String, color: Color)
}

// MARK: - Previews

#Preview {
    NavigationView {
        ThemeExplorer()
    }
}
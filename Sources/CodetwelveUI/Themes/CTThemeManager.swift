//
//  CTThemeManager.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI
import Combine

/// Manager for handling theme switching and storage
///
/// `CTThemeManager` provides a centralized way to manage themes in a CodeTwelve UI application.
/// It maintains the current theme, facilitates theme switching, and publishes theme changes
/// so that views can update accordingly.
///
/// # Example
///
/// ```swift
/// // Set a specific theme
/// CTThemeManager.shared.setTheme(CTDarkTheme())
///
/// // Set a theme by name
/// CTThemeManager.shared.setTheme(named: "dark")
///
/// // Access the current theme
/// let currentTheme = CTThemeManager.shared.currentTheme
/// ```
public class CTThemeManager: ObservableObject {
    /// Shared instance of the theme manager (singleton)
    public static let shared = CTThemeManager()
    
    /// The currently active theme
    @Published public private(set) var currentTheme: CTTheme
    
    /// Dictionary of registered themes by name
    private var themes: [String: CTTheme] = [:]
    
    /// Private initializer to enforce singleton usage
    private init() {
        // Initialize with a default theme (will be replaced once actual themes are registered)
        self.currentTheme = DefaultPlaceholderTheme()
    }
    
    /// Register a theme with the manager
    /// - Parameter theme: The theme to register
    public func registerTheme(_ theme: CTTheme) {
        themes[theme.name] = theme
        
        // If this is the first theme registered, set it as current
        if themes.count == 1 {
            setTheme(theme)
        }
    }
    
    /// Register multiple themes with the manager
    /// - Parameter themes: The themes to register
    public func registerThemes(_ themes: [CTTheme]) {
        themes.forEach { registerTheme($0) }
    }
    
    /// Set the active theme
    /// - Parameter theme: The theme to set as active
    public func setTheme(_ theme: CTTheme) {
        // Register the theme if it's not already registered
        if themes[theme.name] == nil {
            registerTheme(theme)
        }
        
        self.currentTheme = theme
    }
    
    /// Set theme by name
    /// - Parameter name: The name of the theme to set
    /// - Returns: `true` if the theme was found and set, `false` otherwise
    @discardableResult
    public func setTheme(named name: String) -> Bool {
        guard let theme = themes[name] else {
            print("Theme with name '\(name)' not found")
            return false
        }
        
        setTheme(theme)
        return true
    }
    
    /// Get a registered theme by name
    /// - Parameter name: The name of the theme to get
    /// - Returns: The theme with the specified name, or `nil` if not found
    public func theme(named name: String) -> CTTheme? {
        return themes[name]
    }
    
    /// Get all registered themes
    /// - Returns: An array of all registered themes
    public func allThemes() -> [CTTheme] {
        return Array(themes.values)
    }
    
    /// Get all theme names
    /// - Returns: An array of all registered theme names
    public func allThemeNames() -> [String] {
        return Array(themes.keys)
    }
}

// MARK: - Default Placeholder Theme

/// A minimal placeholder theme used as initial value
/// Not intended for actual use in applications
private struct DefaultPlaceholderTheme: CTTheme {
    // MARK: - Theme Identification
    var name: String = "Default Placeholder"
    
    // MARK: - Colors
    var primary: Color = .accentColor
    var secondary: Color = .gray
    var background: Color = Color(.systemBackground)
    var surface: Color = Color(.secondarySystemBackground)
    var text: Color = Color(.label)
    var textSecondary: Color = Color(.secondaryLabel)
    var textOnAccent: Color = .white
    var destructive: Color = .red
    var success: Color = .green
    var warning: Color = .yellow
    var info: Color = .blue
    
    // MARK: - Borders
    var border: Color = Color(.separator)
    var borderWidth: CGFloat = 1
    var borderRadius: CGFloat = 8
    
    // MARK: - Shadows
    var shadowColor: Color = .black
    var shadowOpacity: Double = 0.1
    var shadowRadius: CGFloat = 4
    var shadowOffset: CGSize = CGSize(width: 0, height: 2)
    
    // MARK: - Button Styling
    func buttonBackgroundColor(for style: CTButtonStyle) -> Color {
        switch style {
        case .primary:
            return primary
        case .secondary:
            return secondary
        case .destructive:
            return destructive
        case .outline, .ghost, .link:
            return .clear
        }
    }
    
    func buttonForegroundColor(for style: CTButtonStyle) -> Color {
        switch style {
        case .primary, .secondary, .destructive:
            return textOnAccent
        case .outline:
            return primary
        case .ghost:
            return text
        case .link:
            return primary
        }
    }
    
    func buttonBorderColor(for style: CTButtonStyle) -> Color {
        switch style {
        case .outline:
            return primary
        case .link, .ghost, .primary, .secondary, .destructive:
            return .clear
        }
    }
}

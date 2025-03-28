//
//  View+Theme.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

// MARK: - Theme Environment Key

/// Environment key for storing the current theme
private struct CTThemeKey: EnvironmentKey {
    /// The default value is the current theme from CTThemeManager
    static let defaultValue: CTTheme = CTThemeManager.shared.currentTheme
}

/// Extension to add theme to the environment values
public extension EnvironmentValues {
    /// The current theme from the environment
    var ctTheme: CTTheme {
        get { self[CTThemeKey.self] }
        set { self[CTThemeKey.self] = newValue }
    }
}

// MARK: - View Extensions for Theming

public extension View {
    /// Apply a CodeTwelve theme to this view and its subviews
    ///
    /// This modifier sets the provided theme in the environment, making it
    /// available to all child views. CodeTwelve components will automatically
    /// use this theme for styling.
    ///
    /// # Example
    ///
    /// ```swift
    /// VStack {
    ///     CTButton("Primary", style: .primary) {}
    ///     CTButton("Secondary", style: .secondary) {}
    /// }
    /// .ctTheme(CTDarkTheme())
    /// ```
    ///
    /// - Parameter theme: The theme to apply
    /// - Returns: A view with the theme applied to the environment
    func ctTheme(_ theme: CTTheme) -> some View {
        self.environment(\.ctTheme, theme)
    }
    
    /// Apply a theme by name to this view and its subviews
    ///
    /// This modifier sets the theme with the specified name in the environment,
    /// if it exists in the theme manager. If the theme doesn't exist, the current
    /// theme will be used instead.
    ///
    /// # Example
    ///
    /// ```swift
    /// VStack {
    ///     CTButton("Primary", style: .primary) {}
    ///     CTButton("Secondary", style: .secondary) {}
    /// }
    /// .ctThemeNamed("dark")
    /// ```
    ///
    /// - Parameter name: The name of the theme to apply
    /// - Returns: A view with the theme applied to the environment
    func ctThemeNamed(_ name: String) -> some View {
        if let theme = CTThemeManager.shared.theme(named: name) {
            return self.environment(\.ctTheme, theme)
        }
        return self.environment(\.ctTheme, CTThemeManager.shared.currentTheme)
    }
    
    /// Get the current theme from the environment
    ///
    /// This function extracts the current theme from the environment, allowing
    /// components to access theme properties for styling.
    ///
    /// # Example
    ///
    /// ```swift
    /// struct CustomComponent: View {
    ///     @Environment(\.ctTheme) private var theme
    ///
    ///     var body: some View {
    ///         Text("Themed Text")
    ///             .foregroundColor(theme.primary)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter perform: A closure that takes the current theme and returns a view
    /// - Returns: The view returned by the closure
    func withTheme<Content: View>(@ViewBuilder perform: @escaping (CTTheme) -> Content) -> some View {
        return WithThemeView(content: perform)
    }
}

// MARK: - Internal Helper Views

/// Helper view to extract the theme from the environment and pass it to a closure
private struct WithThemeView<Content: View>: View {
    @Environment(\.ctTheme) private var theme
    let content: (CTTheme) -> Content
    
    var body: some View {
        content(theme)
    }
}

/// A view modifier that updates when the CTThemeManager's current theme changes
public struct CTThemeObservingModifier: ViewModifier {
    @ObservedObject private var themeManager = CTThemeManager.shared
    
    public func body(content: Content) -> some View {
        content.ctTheme(themeManager.currentTheme)
    }
}

public extension View {
    /// Make this view observe theme changes from the CTThemeManager
    ///
    /// This modifier causes the view to be updated whenever the current theme
    /// in CTThemeManager changes.
    ///
    /// # Example
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         VStack {
    ///             // View content that uses theme properties
    ///         }
    ///         .ctObserveThemeChanges()
    ///     }
    /// }
    /// ```
    ///
    /// - Returns: A view that updates when the theme changes
    func ctObserveThemeChanges() -> some View {
        self.modifier(CTThemeObservingModifier())
    }
}
//
//  CTLightTheme.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A light theme for CodeTwelve UI
///
/// This theme provides a bright, clean appearance optimized for standard light mode.
/// It follows iOS light mode conventions while incorporating CodeTwelve's brand identity.
///
/// # Example
///
/// ```swift
/// // Apply the light theme to a view hierarchy
/// ContentView()
///     .ctTheme(CTLightTheme())
///
/// // Or set it as the global theme
/// CTThemeManager.shared.setTheme(CTLightTheme())
/// ```
public struct CTLightTheme: CTTheme {
    // MARK: - Properties
    
    /// The name of the theme
    public var name: String = "light"
    
    // MARK: - Colors
    
    /// The primary brand color
    public var primary: Color = Color(hex: "#007AFF")
    
    /// The secondary brand color
    public var secondary: Color = Color(hex: "#5856D6")
    
    /// The light background color for the app
    public var background: Color = Color(hex: "#F2F2F7")
    
    /// The surface color for cards and elements in light mode
    public var surface: Color = Color.white
    
    /// The primary text color in light mode
    public var text: Color = Color(hex: "#000000")
    
    /// The secondary text color for less emphasis in light mode
    public var textSecondary: Color = Color(hex: "#6C6C70")
    
    /// Text color for use on accent/colored backgrounds
    public var textOnAccent: Color = Color.white
    
    /// The color for destructive actions in light mode
    public var destructive: Color = Color(hex: "#FF3B30")
    
    /// The color for success states and actions in light mode
    public var success: Color = Color(hex: "#34C759")
    
    /// The color for warning states and actions in light mode
    public var warning: Color = Color(hex: "#FF9500")
    
    /// The color for informational states and actions in light mode
    public var info: Color = Color(hex: "#5AC8FA")
    
    // MARK: - Borders
    
    /// The standard border color in light mode
    public var border: Color = Color(hex: "#D1D1D6")
    
    /// The standard border width
    public var borderWidth: CGFloat = 1
    
    /// The standard border radius
    public var borderRadius: CGFloat = 8
    
    // MARK: - Shadows
    
    /// The color for shadows in light mode
    public var shadowColor: Color = Color.black
    
    /// The opacity for shadows in light mode
    public var shadowOpacity: Double = 0.1
    
    /// The radius for shadows
    public var shadowRadius: CGFloat = 4
    
    /// The offset for shadows
    public var shadowOffset: CGSize = CGSize(width: 0, height: 2)
    
    // MARK: - Initializer
    
    /// Initialize a light theme with standard values
    public init() {}
    
    // MARK: - Methods
    
    /// Returns the appropriate background color for a button with the specified style
    /// - Parameter style: The button style
    /// - Returns: The background color for the button
    public func buttonBackgroundColor(for style: CTButtonStyle) -> Color {
        switch style {
        case .primary:
            return primary
        case .secondary:
            return secondary
        case .destructive:
            return destructive
        case .outline, .ghost, .link:
            return Color.clear
        }
    }
    
    /// Returns the appropriate foreground color for a button with the specified style
    /// - Parameter style: The button style
    /// - Returns: The foreground color for the button
    public func buttonForegroundColor(for style: CTButtonStyle) -> Color {
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
    
    /// Returns the appropriate border color for a button with the specified style
    /// - Parameter style: The button style
    /// - Returns: The border color for the button
    public func buttonBorderColor(for style: CTButtonStyle) -> Color {
        switch style {
        case .outline:
            return primary
        case .ghost, .link, .primary, .secondary, .destructive:
            return Color.clear
        }
    }
}

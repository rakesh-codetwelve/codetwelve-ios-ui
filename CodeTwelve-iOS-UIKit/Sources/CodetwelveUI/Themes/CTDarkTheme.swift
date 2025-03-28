//
//  CTDarkTheme.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A dark theme for CodeTwelve UI
///
/// This theme provides a dark appearance optimized for low-light environments
/// and devices with OLED screens. It follows iOS dark mode conventions while
/// adding CodeTwelve's brand identity.
///
/// # Example
///
/// ```swift
/// // Apply the dark theme to a view hierarchy
/// ContentView()
///     .ctTheme(CTDarkTheme())
///
/// // Or set it as the global theme
/// CTThemeManager.shared.setTheme(CTDarkTheme())
/// ```
public struct CTDarkTheme: CTTheme {
    // MARK: - Properties
    
    /// The name of the theme
    public var name: String = "dark"
    
    // MARK: - Colors
    
    /// The primary brand color, slightly adjusted for dark mode
    public var primary: Color = Color(hex: "#0A84FF")
    
    /// The secondary brand color, slightly adjusted for dark mode
    public var secondary: Color = Color(hex: "#5E5CE6")
    
    /// The dark background color for the app
    public var background: Color = Color(hex: "#1C1C1E")
    
    /// The surface color for cards and elements in dark mode
    public var surface: Color = Color(hex: "#2C2C2E")
    
    /// The primary text color in dark mode
    public var text: Color = Color(hex: "#FFFFFF")
    
    /// The secondary text color for less emphasis in dark mode
    public var textSecondary: Color = Color(hex: "#8E8E93")
    
    /// Text color for use on accent/colored backgrounds
    public var textOnAccent: Color = Color.white
    
    /// The color for destructive actions in dark mode
    public var destructive: Color = Color(hex: "#FF453A")
    
    /// The color for success states and actions in dark mode
    public var success: Color = Color(hex: "#30D158")
    
    /// The color for warning states and actions in dark mode
    public var warning: Color = Color(hex: "#FF9F0A")
    
    /// The color for informational states and actions in dark mode
    public var info: Color = Color(hex: "#64D2FF")
    
    // MARK: - Borders
    
    /// The standard border color in dark mode
    public var border: Color = Color(hex: "#38383A")
    
    /// The standard border width
    public var borderWidth: CGFloat = 1
    
    /// The standard border radius
    public var borderRadius: CGFloat = 8
    
    // MARK: - Shadows
    
    /// The color for shadows in dark mode
    public var shadowColor: Color = Color.black
    
    /// The opacity for shadows in dark mode
    public var shadowOpacity: Double = 0.3
    
    /// The radius for shadows
    public var shadowRadius: CGFloat = 5
    
    /// The offset for shadows
    public var shadowOffset: CGSize = CGSize(width: 0, height: 3)
    
    // MARK: - Initializer
    
    /// Initialize a dark theme with standard values
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

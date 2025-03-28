//
//  CTTheme.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// Protocol defining the required properties for a CodeTwelve theme
///
/// `CTTheme` is the foundation of the CodeTwelve theming system. It defines all the 
/// properties that a theme must implement to provide consistent styling across the application.
/// This includes colors, typography, spacing, and other visual properties.
///
/// # Example
///
/// ```swift
/// struct MyCustomTheme: CTTheme {
///     // Implement all required properties
///     var name: String = "Custom"
///     var primary: Color = Color.blue
///     // ... other properties
/// }
///
/// // Apply the custom theme
/// ContentView()
///     .ctTheme(MyCustomTheme())
/// ```
public protocol CTTheme {
    // MARK: - Theme Identification
    
    /// The name of the theme
    var name: String { get }
    
    // MARK: - Colors
    
    /// The primary brand color
    var primary: Color { get }
    
    /// The secondary brand color
    var secondary: Color { get }
    
    /// The main background color for the app
    var background: Color { get }
    
    /// The surface color for cards and elevated elements
    var surface: Color { get }
    
    /// The primary text color
    var text: Color { get }
    
    /// The secondary text color for less emphasis
    var textSecondary: Color { get }
    
    /// Text color for use on accent/colored backgrounds
    var textOnAccent: Color { get }
    
    /// The color for destructive actions
    var destructive: Color { get }
    
    /// The color for success states and actions
    var success: Color { get }
    
    /// The color for warning states and actions
    var warning: Color { get }
    
    /// The color for informational states and actions
    var info: Color { get }
    
    // MARK: - Borders
    
    /// The default border color
    var border: Color { get }
    
    /// The default border width
    var borderWidth: CGFloat { get }
    
    /// The default corner radius for elements
    var borderRadius: CGFloat { get }
    
    // MARK: - Shadows
    
    /// The shadow color
    var shadowColor: Color { get }
    
    /// The shadow opacity
    var shadowOpacity: Double { get }
    
    /// The shadow radius (blur)
    var shadowRadius: CGFloat { get }
    
    /// The shadow offset
    var shadowOffset: CGSize { get }
    
    // MARK: - Component Specific Styling
    
    /// Returns the background color for a button with the specified style
    /// - Parameter style: The button style
    /// - Returns: The background color for the button
    func buttonBackgroundColor(for style: CTButtonStyle) -> Color
    
    /// Returns the foreground color for a button with the specified style
    /// - Parameter style: The button style
    /// - Returns: The foreground color for the button
    func buttonForegroundColor(for style: CTButtonStyle) -> Color
    
    /// Returns the border color for a button with the specified style
    /// - Parameter style: The button style
    /// - Returns: The border color for the button
    func buttonBorderColor(for style: CTButtonStyle) -> Color
}

/// The available button styles in the CodeTwelve UI system
public enum ButtonStyle {
    case primary
    case secondary
    case destructive
    case outline
    case ghost
    case link
}

// MARK: - Default Theme Extension

public extension CTTheme {
    /// Default implementation for button background color
    func buttonBackgroundColor(for style: ButtonStyle) -> Color {
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
    
    /// Default implementation for button foreground color
    func buttonForegroundColor(for style: ButtonStyle) -> Color {
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
    
    /// Default implementation for button border color
    func buttonBorderColor(for style: ButtonStyle) -> Color {
        switch style {
        case .outline:
            return primary
        case .link, .ghost, .primary, .secondary, .destructive:
            return Color.clear
        }
    }
}
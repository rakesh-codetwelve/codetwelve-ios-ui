//
//  CTThemeBuilder.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A builder for creating custom CodeTwelve UI themes
///
/// The theme builder provides a fluent interface for creating custom themes
/// without needing to implement the entire `CTTheme` protocol. It starts with
/// a base theme and allows you to override specific properties.
///
/// # Example
///
/// ```swift
/// // Create a custom theme based on the default theme
/// let customTheme = CTThemeBuilder(base: CTDefaultTheme())
///     .withName("My Custom Theme")
///     .withPrimaryColor(Color.blue)
///     .withSecondaryColor(Color.purple)
///     .withBorderRadius(12)
///     .build()
///
/// // Apply the custom theme
/// CTThemeManager.shared.setTheme(customTheme)
/// ```
public class CTThemeBuilder {
    // MARK: - Private Properties
    
    private var theme: CustomTheme
    
    // MARK: - Initializers
    
    /// Initialize a theme builder with a base theme
    /// - Parameter base: The base theme to start with
    public init(base: CTTheme = CTDefaultTheme()) {
        self.theme = CustomTheme(base: base)
    }
    
    // MARK: - Builder Methods
    
    /// Set the name of the theme
    /// - Parameter name: The name for the theme
    /// - Returns: The builder for chaining
    public func withName(_ name: String) -> CTThemeBuilder {
        theme.name = name
        return self
    }
    
    /// Set the primary color of the theme
    /// - Parameter color: The primary color
    /// - Returns: The builder for chaining
    public func withPrimaryColor(_ color: Color) -> CTThemeBuilder {
        theme.primary = color
        return self
    }
    
    /// Set the secondary color of the theme
    /// - Parameter color: The secondary color
    /// - Returns: The builder for chaining
    public func withSecondaryColor(_ color: Color) -> CTThemeBuilder {
        theme.secondary = color
        return self
    }
    
    /// Set the background color of the theme
    /// - Parameter color: The background color
    /// - Returns: The builder for chaining
    public func withBackgroundColor(_ color: Color) -> CTThemeBuilder {
        theme.background = color
        return self
    }
    
    /// Set the surface color of the theme
    /// - Parameter color: The surface color
    /// - Returns: The builder for chaining
    public func withSurfaceColor(_ color: Color) -> CTThemeBuilder {
        theme.surface = color
        return self
    }
    
    /// Set the text color of the theme
    /// - Parameter color: The text color
    /// - Returns: The builder for chaining
    public func withTextColor(_ color: Color) -> CTThemeBuilder {
        theme.text = color
        return self
    }
    
    /// Set the secondary text color of the theme
    /// - Parameter color: The secondary text color
    /// - Returns: The builder for chaining
    public func withTextSecondaryColor(_ color: Color) -> CTThemeBuilder {
        theme.textSecondary = color
        return self
    }
    
    /// Set the text on accent color of the theme
    /// - Parameter color: The text on accent color
    /// - Returns: The builder for chaining
    public func withTextOnAccentColor(_ color: Color) -> CTThemeBuilder {
        theme.textOnAccent = color
        return self
    }
    
    /// Set the destructive color of the theme
    /// - Parameter color: The destructive color
    /// - Returns: The builder for chaining
    public func withDestructiveColor(_ color: Color) -> CTThemeBuilder {
        theme.destructive = color
        return self
    }
    
    /// Set the success color of the theme
    /// - Parameter color: The success color
    /// - Returns: The builder for chaining
    public func withSuccessColor(_ color: Color) -> CTThemeBuilder {
        theme.success = color
        return self
    }
    
    /// Set the warning color of the theme
    /// - Parameter color: The warning color
    /// - Returns: The builder for chaining
    public func withWarningColor(_ color: Color) -> CTThemeBuilder {
        theme.warning = color
        return self
    }
    
    /// Set the info color of the theme
    /// - Parameter color: The info color
    /// - Returns: The builder for chaining
    public func withInfoColor(_ color: Color) -> CTThemeBuilder {
        theme.info = color
        return self
    }
    
    /// Set the border color of the theme
    /// - Parameter color: The border color
    /// - Returns: The builder for chaining
    public func withBorderColor(_ color: Color) -> CTThemeBuilder {
        theme.border = color
        return self
    }
    
    /// Set the border width of the theme
    /// - Parameter width: The border width
    /// - Returns: The builder for chaining
    public func withBorderWidth(_ width: CGFloat) -> CTThemeBuilder {
        theme.borderWidth = width
        return self
    }
    
    /// Set the border radius of the theme
    /// - Parameter radius: The border radius
    /// - Returns: The builder for chaining
    public func withBorderRadius(_ radius: CGFloat) -> CTThemeBuilder {
        theme.borderRadius = radius
        return self
    }
    
    /// Set the shadow color of the theme
    /// - Parameter color: The shadow color
    /// - Returns: The builder for chaining
    public func withShadowColor(_ color: Color) -> CTThemeBuilder {
        theme.shadowColor = color
        return self
    }
    
    /// Set the shadow opacity of the theme
    /// - Parameter opacity: The shadow opacity
    /// - Returns: The builder for chaining
    public func withShadowOpacity(_ opacity: Double) -> CTThemeBuilder {
        theme.shadowOpacity = opacity
        return self
    }
    
    /// Set the shadow radius of the theme
    /// - Parameter radius: The shadow radius
    /// - Returns: The builder for chaining
    public func withShadowRadius(_ radius: CGFloat) -> CTThemeBuilder {
        theme.shadowRadius = radius
        return self
    }
    
    /// Set the shadow offset of the theme
    /// - Parameter offset: The shadow offset
    /// - Returns: The builder for chaining
    public func withShadowOffset(_ offset: CGSize) -> CTThemeBuilder {
        theme.shadowOffset = offset
        return self
    }
    
    /// Build the theme with the configured properties
    /// - Returns: A CTTheme instance with the configured properties
    public func build() -> CTTheme {
        return theme
    }
    
    // MARK: - Theme Implementation
    
    /// A custom theme implementation that wraps an existing theme
    private class CustomTheme: CTTheme {
        // Theme properties
        var name: String
        var primary: Color
        var secondary: Color
        var background: Color
        var surface: Color
        var text: Color
        var textSecondary: Color
        var textOnAccent: Color
        var destructive: Color
        var success: Color
        var warning: Color
        var info: Color
        var border: Color
        var borderWidth: CGFloat
        var borderRadius: CGFloat
        var shadowColor: Color
        var shadowOpacity: Double
        var shadowRadius: CGFloat
        var shadowOffset: CGSize
        
        // Base theme for button style methods
        private let baseTheme: CTTheme
        
        /// Initialize with a base theme
        /// - Parameter base: The base theme to start with
        init(base: CTTheme) {
            self.baseTheme = base
            self.name = base.name + "-custom"
            self.primary = base.primary
            self.secondary = base.secondary
            self.background = base.background
            self.surface = base.surface
            self.text = base.text
            self.textSecondary = base.textSecondary
            self.textOnAccent = base.textOnAccent
            self.destructive = base.destructive
            self.success = base.success
            self.warning = base.warning
            self.info = base.info
            self.border = base.border
            self.borderWidth = base.borderWidth
            self.borderRadius = base.borderRadius
            self.shadowColor = base.shadowColor
            self.shadowOpacity = base.shadowOpacity
            self.shadowRadius = base.shadowRadius
            self.shadowOffset = base.shadowOffset
        }
        
        /// Returns the appropriate background color for a button with the specified style
        /// - Parameter style: The button style
        /// - Returns: The background color for the button
        func buttonBackgroundColor(for style: CTButtonStyle) -> Color {
            return baseTheme.buttonBackgroundColor(for: style)
        }
        
        /// Returns the appropriate foreground color for a button with the specified style
        /// - Parameter style: The button style
        /// - Returns: The foreground color for the button
        func buttonForegroundColor(for style: CTButtonStyle) -> Color {
            return baseTheme.buttonForegroundColor(for: style)
        }
        
        /// Returns the appropriate border color for a button with the specified style
        /// - Parameter style: The button style
        /// - Returns: The border color for the button
        func buttonBorderColor(for style: CTButtonStyle) -> Color {
            return baseTheme.buttonBorderColor(for: style)
        }
    }
}

/// Extension with convenience methods for creating themes based on color palettes
public extension CTThemeBuilder {
    /// Create a theme using a primary color palette
    /// - Parameters:
    ///   - base: The base theme to start with
    ///   - primaryColor: The main primary color
    ///   - generatePalette: Whether to generate a full color palette from the primary color
    /// - Returns: A new theme with colors derived from the primary color
    static func fromPrimaryColor(
        base: CTTheme = CTDefaultTheme(),
        primaryColor: Color,
        generatePalette: Bool = true
    ) -> CTTheme {
        let builder = CTThemeBuilder(base: base)
            .withPrimaryColor(primaryColor)
            .withName("Custom-\(base.name)")
            
        if generatePalette {
            // For a real implementation, we would generate a complementary color
            // Here we're using a simplified approach
            let secondaryColor = primaryColor
            return builder
                .withSecondaryColor(secondaryColor)
                .withBorderColor(primaryColor.opacity(0.3))
                .build()
        } else {
            return builder.build()
        }
    }
    
    /// Create a theme with light and dark variants
    /// - Parameters:
    ///   - name: The name for the theme
    ///   - lightPrimary: The primary color for light mode
    ///   - darkPrimary: The primary color for dark mode
    /// - Returns: A CTTheme that adapts based on the color scheme
    static func adaptiveTheme(
        name: String,
        lightPrimary: Color,
        darkPrimary: Color
    ) -> CTTheme {
        // This is a simplified implementation
        // In a real app, we would create a true adaptive theme that responds to color scheme changes
        let isInDarkMode = UITraitCollection.current.userInterfaceStyle == .dark
        let baseTheme: CTTheme = isInDarkMode ? CTDarkTheme() : CTLightTheme()
        let primaryColor = isInDarkMode ? darkPrimary : lightPrimary
        
        return CTThemeBuilder(base: baseTheme)
            .withName(name)
            .withPrimaryColor(primaryColor)
            .build()
    }
}

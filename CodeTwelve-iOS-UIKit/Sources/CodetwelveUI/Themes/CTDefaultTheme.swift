//
//  CTDefaultTheme.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// The default theme for CodeTwelve UI
///
/// This theme provides a balanced appearance that works well in both light and dark mode environments.
/// It uses iOS standard color patterns with CodeTwelve's branding colors.
///
/// # Example
///
/// ```swift
/// // Apply the default theme to a view hierarchy
/// ContentView()
///     .ctTheme(CTDefaultTheme())
///
/// // Or set it as the global theme
/// CTThemeManager.shared.setTheme(CTDefaultTheme())
/// ```

// First, let's define the required enums
public enum CTColorStyle {
    case primary
    case secondary
    case background
    case foreground
    case accent
}

public enum CTFontStyle {
    case heading
    case body
    case caption
}

public struct CTDefaultTheme: CTTheme {
    // MARK: - Theme Identification
    public var name: String = "Default"
    
    // MARK: - Colors
    public var primary: Color = .blue
    public var secondary: Color = .gray
    public var background: Color = Color(uiColor: .systemBackground)
    public var surface: Color = Color(uiColor: .secondarySystemBackground)
    public var text: Color = .primary
    public var textSecondary: Color = .secondary
    public var textOnAccent: Color = .white
    public var destructive: Color = .red
    public var success: Color = .green
    public var warning: Color = .yellow
    public var info: Color = .blue
    
    // MARK: - Borders
    public var border: Color = .gray.opacity(0.2)
    public var borderWidth: CGFloat = 1
    public var borderRadius: CGFloat = 8
    
    // MARK: - Shadows
    public var shadowColor: Color = .black
    public var shadowOpacity: Double = 0.1
    public var shadowRadius: CGFloat = 10
    public var shadowOffset: CGSize = CGSize(width: 0, height: 4)
    
    // MARK: - Initialization
    public init() {}
    
    // MARK: - Button Styling
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
    
    public func buttonBorderColor(for style: CTButtonStyle) -> Color {
        switch style {
        case .outline:
            return primary
        case .link, .ghost, .primary, .secondary, .destructive:
            return Color.clear
        }
    }
    
    // MARK: - Colors
    
    /// The primary brand color
    public var primaryColor: Color = .accentColor
    
    /// The secondary brand color
    public var secondaryColor: Color = .gray
    
    /// The background color
    public var backgroundColor: Color = Color(uiColor: .systemBackground)
    
    /// The foreground color
    public var foregroundColor: Color = .primary
    
    /// The accent color
    public var accentColor: Color = .blue
    
    // MARK: - Typography
    
    /// The heading font
    public var headingFont: Font = .system(.title, design: .default).weight(.bold)
    
    /// The body font
    public var bodyFont: Font = .system(.body)
    
    /// The caption font
    public var captionFont: Font = .system(.caption)
    
    // MARK: - Spacing
    
    /// The spacing
    public var spacing: CGFloat = 8
    
    /// The padding for small elements
    public var paddingSmall: CGFloat = 8
    
    /// The padding for medium elements
    public var paddingMedium: CGFloat = 16
    
    /// The padding for large elements
    public var paddingLarge: CGFloat = 24
    
    // MARK: - Animation
    
    /// The animation duration
    public var animationDuration: Double = 0.3
    
    // MARK: - Methods
    
    /// Returns the color for the specified style
    /// - Parameter style: The color style
    /// - Returns: The color for the specified style
    public func color(for style: CTColorStyle) -> Color {
        switch style {
        case .primary:
            return primaryColor
        case .secondary:
            return secondaryColor
        case .background:
            return backgroundColor
        case .foreground:
            return foregroundColor
        case .accent:
            return accentColor
        }
    }
    
    /// Returns the font for the specified style
    /// - Parameter style: The font style
    /// - Returns: The font for the specified style
    public func font(for style: CTFontStyle) -> Font {
        switch style {
        case .heading:
            return headingFont
        case .body:
            return bodyFont
        case .caption:
            return captionFont
        }
    }
}

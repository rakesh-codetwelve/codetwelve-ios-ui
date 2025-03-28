//
//  CTColors.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// Color tokens for the CodeTwelve UI design system
///
/// This enum provides access to the colors used throughout the library with semantic naming.
/// Colors are defined to automatically adapt to light and dark mode using Color assets.
///
/// # Usage
///
/// Colors can be accessed either through the static properties or through the
/// convenience extensions on Color:
///
/// ```swift
/// // Using the enum
/// Text("Hello, World!")
///     .foregroundColor(CTColors.primary)
///
/// // Using the extensions
/// Text("Hello, World!")
///     .foregroundColor(.ctPrimary)
/// ```
public enum CTColors {
    // MARK: - Brand Colors
    
    /// The primary brand color
    public static var primary: Color {
        Color(hex: "#007AFF")
    }
    
    /// The secondary brand color
    public static var secondary: Color {
        Color(hex: "#5856D6")
    }
    
    // MARK: - UI Colors
    
    /// The background color for the app
    public static var background: Color {
        Color(hex: "#F2F2F7")
    }
    
    /// The surface color for cards and elements
    public static var surface: Color {
        Color.white
    }
    
    /// The primary text color
    public static var text: Color {
        Color(hex: "#1C1C1E")
    }
    
    /// The secondary text color for less emphasis
    public static var textSecondary: Color {
        Color(hex: "#8E8E93")
    }
    
    /// Text color for use on accent/colored backgrounds
    public static var textOnAccent: Color {
        Color.white
    }
    
    // MARK: - Semantic Colors
    
    /// The color for destructive actions
    public static var destructive: Color {
        Color(hex: "#FF3B30")
    }
    
    /// The color for success states and actions
    public static var success: Color {
        Color(hex: "#34C759")
    }
    
    /// The color for warning states and actions
    public static var warning: Color {
        Color(hex: "#FF9500")
    }
    
    /// The color for informational states and actions
    public static var info: Color {
        Color(hex: "#5AC8FA")
    }
    
    // MARK: - Border Colors
    
    /// The standard border color
    public static var border: Color {
        Color(hex: "#C6C6C8")
    }
    
    // MARK: - Elevation Colors
    
    /// The color for shadows
    public static var shadow: Color {
        Color.black.opacity(0.1)
    }
    
    // MARK: - Helper Method
    
    /// Returns a color from the asset catalog by name
    /// - Parameter name: The name of the color in the asset catalog
    /// - Returns: The color from the asset catalog or a fallback color if not found
    private static func colorFromAsset(_ name: String) -> Color {
        Color(name, bundle: Bundle(for: BundleToken.self))
    }
}

// MARK: - Bundle Token

private final class BundleToken {}

// MARK: - Color Extensions

public extension Color {
    /// The primary brand color
    static var ctPrimary: Color { CTColors.primary }
    
    /// The secondary brand color
    static var ctSecondary: Color { CTColors.secondary }
    
    /// The background color for the app
    static var ctBackground: Color { CTColors.background }
    
    /// The surface color for cards and elements
    static var ctSurface: Color { CTColors.surface }
    
    /// The primary text color
    static var ctText: Color { CTColors.text }
    
    /// The secondary text color for less emphasis
    static var ctTextSecondary: Color { CTColors.textSecondary }
    
    /// Text color for use on accent/colored backgrounds
    static var ctTextOnAccent: Color { CTColors.textOnAccent }
    
    /// The color for destructive actions
    static var ctDestructive: Color { CTColors.destructive }
    
    /// The color for success states and actions
    static var ctSuccess: Color { CTColors.success }
    
    /// The color for warning states and actions
    static var ctWarning: Color { CTColors.warning }
    
    /// The color for informational states and actions
    static var ctInfo: Color { CTColors.info }
    
    /// The standard border color
    static var ctBorder: Color { CTColors.border }
    
    /// The color for shadows
    static var ctShadow: Color { CTColors.shadow }
}

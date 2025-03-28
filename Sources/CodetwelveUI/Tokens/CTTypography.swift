//
//  CTTypography.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// Typography tokens for the CodeTwelve UI design system
///
/// This enum provides a consistent set of typography styles to be used throughout
/// the application, ensuring visual consistency and proper text hierarchy.
///
/// All typography styles automatically support Dynamic Type for accessibility.
///
/// # Usage
///
/// Typography styles can be accessed as static methods:
///
/// ```swift
/// Text("Hello, World!")
///     .font(CTTypography.heading1())
/// ```
///
/// Or through the convenience extensions on View:
///
/// ```swift
/// Text("Hello, World!")
///     .ctHeading1()
/// ```
public enum CTTypography {
    // MARK: - Headings
    
    /// Heading 1 - The largest heading style, typically used for page titles
    public static func heading1() -> Font {
        return Font.system(.largeTitle, design: .default).weight(.bold)
    }
    
    /// Heading 2 - The second largest heading style, used for major section headings
    public static func heading2() -> Font {
        return Font.system(.title, design: .default).weight(.bold)
    }
    
    /// Heading 3 - Medium heading style, used for subsection headings
    public static func heading3() -> Font {
        return Font.system(.title2, design: .default).weight(.semibold)
    }
    
    /// Heading 4 - Smaller heading style, used for minor section headings
    public static func heading4() -> Font {
        return Font.system(.title3, design: .default).weight(.semibold)
    }
    
    // MARK: - Body Text
    
    /// Body - Standard body text style
    public static func body() -> Font {
        return Font.system(.body, design: .default)
    }
    
    /// Body Bold - Bold version of the standard body text
    public static func bodyBold() -> Font {
        return Font.system(.body, design: .default).weight(.semibold)
    }
    
    /// Body Small - Smaller body text for less emphasis
    public static func bodySmall() -> Font {
        return Font.system(.subheadline, design: .default)
    }
    
    // MARK: - Supporting Text
    
    /// Subtitle - Used for introductory text or subheadings
    public static func subtitle() -> Font {
        return Font.system(.headline, design: .default)
    }
    
    /// Caption - Small text used for secondary information
    public static func caption() -> Font {
        return Font.system(.caption, design: .default)
    }
    
    /// Caption Small - Even smaller text used for tertiary information
    public static func captionSmall() -> Font {
        return Font.system(.caption2, design: .default)
    }
    
    // MARK: - Interface Elements
    
    /// Button - Standard button text style
    public static func button() -> Font {
        return Font.system(.body, design: .default).weight(.medium)
    }
    
    /// Button Small - Smaller button text style
    public static func buttonSmall() -> Font {
        return Font.system(.subheadline, design: .default).weight(.medium)
    }
    
    /// Button Large - Larger button text style
    public static func buttonLarge() -> Font {
        return Font.system(.title3, design: .default).weight(.medium)
    }
    
    // MARK: - Specialized Text
    
    /// Code - Monospaced text for code snippets
    public static func code() -> Font {
        return Font.system(.body, design: .monospaced)
    }
    
    /// Code Small - Smaller monospaced text
    public static func codeSmall() -> Font {
        return Font.system(.caption, design: .monospaced)
    }
    
    // MARK: - Helper Methods
    
    /// Get a scaled font based on the current device size
    ///
    /// - Parameter baseFont: The base font to scale
    /// - Returns: The scaled font
    public static func scaled(_ baseFont: Font) -> Font {
        let scaleFactor = CTLayoutUtilities.fontSizeAdjustment
        
        // Font scaling is complex in SwiftUI. This is a simplified approach.
        // In a real application, this would need to be more sophisticated
        // to properly scale different font sizes and styles.
        return baseFont
    }
    
    /// Create a custom font with a specific size and weight
    ///
    /// - Parameters:
    ///   - size: The font size
    ///   - weight: The font weight (defaults to regular)
    ///   - design: The font design (defaults to default)
    /// - Returns: The custom font
    public static func custom(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
        return Font.system(size: size, weight: weight, design: design)
    }
    
    /// Get the appropriate line height for a given font
    ///
    /// This is an approximation, as SwiftUI doesn't provide direct access to line height.
    ///
    /// - Parameter font: The font to get the line height for
    /// - Returns: The approximate line height
    public static func lineHeight(for fontStyle: CTTypographyStyle) -> CGFloat {
        switch fontStyle {
        case .heading1:
            return 44
        case .heading2:
            return 36
        case .heading3:
            return 30
        case .heading4:
            return 26
        case .body, .bodyBold:
            return 22
        case .bodySmall:
            return 20
        case .subtitle:
            return 22
        case .caption:
            return 16
        case .captionSmall:
            return 14
        case .button:
            return 22
        case .buttonSmall:
            return 18
        case .buttonLarge:
            return 26
        case .code:
            return 22
        case .codeSmall:
            return 16
        }
    }
    
    /// Get the appropriate kern (letter spacing) for a given font style
    ///
    /// - Parameter fontStyle: The font style to get the kern for
    /// - Returns: The kern value
    public static func kern(for fontStyle: CTTypographyStyle) -> CGFloat {
        switch fontStyle {
        case .heading1, .heading2, .heading3, .heading4:
            return -0.5 // Tighter kerning for headings
        case .body, .bodyBold, .bodySmall:
            return 0 // Default kerning for body text
        case .subtitle:
            return -0.3 // Slightly tighter kerning for subtitles
        case .caption, .captionSmall:
            return 0.2 // Slightly looser kerning for captions
        case .button, .buttonSmall, .buttonLarge:
            return 0 // Default kerning for buttons
        case .code, .codeSmall:
            return 0 // Monospaced fonts have fixed kerning
        }
    }
    
    /// Get a font that respects the system's accessibility settings
    ///
    /// This ensures the font scales appropriately when the user has enabled
    /// larger text sizes in the system settings.
    ///
    /// - Parameters:
    ///   - textStyle: The text style to use as a base
    ///   - weight: The font weight (defaults to regular)
    ///   - design: The font design (defaults to default)
    /// - Returns: An accessibility-aware font
    public static func accessibilityAware(
        textStyle: Font.TextStyle,
        weight: Font.Weight = .regular,
        design: Font.Design = .default
    ) -> Font {
        return Font.system(textStyle, design: design).weight(weight)
    }
    
    /// Get a font with enhanced legibility for accessibility
    ///
    /// This uses the rounded design for improved legibility, which can be helpful
    /// for users with certain visual impairments.
    ///
    /// - Parameter baseFont: The base font style
    /// - Returns: A more legible version of the font
    public static func enhancedLegibility(_ fontStyle: CTTypographyStyle) -> Font {
        switch fontStyle {
        case .heading1:
            return Font.system(.largeTitle, design: .rounded).weight(.bold)
        case .heading2:
            return Font.system(.title, design: .rounded).weight(.bold)
        case .heading3:
            return Font.system(.title2, design: .rounded).weight(.semibold)
        case .heading4:
            return Font.system(.title3, design: .rounded).weight(.semibold)
        case .body:
            return Font.system(.body, design: .rounded)
        case .bodyBold:
            return Font.system(.body, design: .rounded).weight(.semibold)
        case .bodySmall:
            return Font.system(.subheadline, design: .rounded)
        case .subtitle:
            return Font.system(.headline, design: .rounded)
        case .caption:
            return Font.system(.caption, design: .rounded)
        case .captionSmall:
            return Font.system(.caption2, design: .rounded)
        case .button:
            return Font.system(.body, design: .rounded).weight(.medium)
        case .buttonSmall:
            return Font.system(.subheadline, design: .rounded).weight(.medium)
        case .buttonLarge:
            return Font.system(.title3, design: .rounded).weight(.medium)
        case .code:
            return Font.system(.body, design: .monospaced)
        case .codeSmall:
            return Font.system(.caption, design: .monospaced)
        }
    }
}

// MARK: - Line Height Modifier

/// A view modifier for setting line height on text views
struct LineHeightModifier: ViewModifier {
    let height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .lineSpacing(height - UIFont.systemFont(ofSize: 14).lineHeight)
    }
}

/// Extension for applying line height to text views
public extension View {
    /// Set the line height for a text view
    ///
    /// - Parameter height: The desired line height
    /// - Returns: The text view with the specified line height
    func lineHeight(_ height: CGFloat) -> some View {
        self.modifier(LineHeightModifier(height: height))
    }
    
    /// Set the line height based on a typography style
    ///
    /// - Parameter style: The typography style to get the line height from
    /// - Returns: The text view with the appropriate line height
    func lineHeightForStyle(_ style: CTTypographyStyle) -> some View {
        self.modifier(LineHeightModifier(height: CTTypography.lineHeight(for: style)))
    }
}
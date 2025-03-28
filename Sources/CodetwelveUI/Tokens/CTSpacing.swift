//
//  CTSpacing.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// Spacing tokens for the CodeTwelve UI design system
///
/// This enum provides a consistent set of spacing values to be used throughout
/// the application, ensuring visual consistency and rhythm in layouts.
///
/// # Usage
///
/// Spacing values can be accessed as static properties:
///
/// ```swift
/// VStack(spacing: CTSpacing.m) {
///     // Content with medium spacing
/// }
/// ```
///
/// Helper methods are available for creating edge insets:
///
/// ```swift
/// .padding(CTSpacing.all(CTSpacing.m))
/// ```
public enum CTSpacing {
    // MARK: - Base Spacing Values
    
    /// Extra extra small spacing (2 points)
    public static let xxs: CGFloat = 2
    
    /// Extra small spacing (4 points)
    public static let xs: CGFloat = 4
    
    /// Small spacing (8 points)
    public static let s: CGFloat = 8
    
    /// Medium spacing (16 points)
    public static let m: CGFloat = 16
    
    /// Large spacing (24 points)
    public static let l: CGFloat = 24
    
    /// Extra large spacing (32 points)
    public static let xl: CGFloat = 32
    
    /// Extra extra large spacing (48 points)
    public static let xxl: CGFloat = 48
    
    /// Extra extra extra large spacing (64 points)
    public static let xxxl: CGFloat = 64
    
    // MARK: - Semantic Spacing Values
    
    /// Spacing between related elements (8 points)
    public static let elementSpacing: CGFloat = s
    
    /// Spacing between groups of elements (16 points)
    public static let groupSpacing: CGFloat = m
    
    /// Spacing between sections (24 points)
    public static let sectionSpacing: CGFloat = l
    
    /// Spacing around a page or screen (16-24 points)
    public static let screenPadding: CGFloat = m
    
    /// Spacing for button padding (horizontal: 16, vertical: 8)
    public static let buttonPadding: EdgeInsets = EdgeInsets(top: s, leading: m, bottom: s, trailing: m)
    
    /// Spacing for card padding (16 points)
    public static let cardPadding: CGFloat = m
    
    /// Spacing for form element padding (horizontal: 12, vertical: 8)
    public static let formPadding: EdgeInsets = EdgeInsets(top: s, leading: 12, bottom: s, trailing: 12)
    
    /// Spacing for form element vertical spacing (16 points)
    public static let formElementSpacing: CGFloat = m
    
    // MARK: - Helper Methods
    
    /// Create edge insets with the same value on all sides
    ///
    /// - Parameter spacing: The spacing value to use on all sides
    /// - Returns: The edge insets with the specified spacing
    public static func all(_ spacing: CGFloat) -> EdgeInsets {
        return EdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
    }
    
    /// Create edge insets with different values for horizontal and vertical spacing
    ///
    /// - Parameters:
    ///   - horizontal: The spacing value to use on the leading and trailing edges
    ///   - vertical: The spacing value to use on the top and bottom edges
    /// - Returns: The edge insets with the specified spacing
    public static func symmetrical(horizontal: CGFloat, vertical: CGFloat) -> EdgeInsets {
        return EdgeInsets(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
    
    /// Create edge insets with values for each side
    ///
    /// - Parameters:
    ///   - top: The spacing value for the top edge (defaults to 0)
    ///   - leading: The spacing value for the leading edge (defaults to 0)
    ///   - bottom: The spacing value for the bottom edge (defaults to 0)
    ///   - trailing: The spacing value for the trailing edge (defaults to 0)
    /// - Returns: The edge insets with the specified spacing
    public static func insets(
        top: CGFloat = 0,
        leading: CGFloat = 0,
        bottom: CGFloat = 0,
        trailing: CGFloat = 0
    ) -> EdgeInsets {
        return EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
    
    /// Create edge insets for horizontal spacing only
    ///
    /// - Parameter spacing: The spacing value to use on the leading and trailing edges
    /// - Returns: The edge insets with the specified horizontal spacing
    public static func horizontal(_ spacing: CGFloat) -> EdgeInsets {
        return EdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing)
    }
    
    /// Create edge insets for vertical spacing only
    ///
    /// - Parameter spacing: The spacing value to use on the top and bottom edges
    /// - Returns: The edge insets with the specified vertical spacing
    public static func vertical(_ spacing: CGFloat) -> EdgeInsets {
        return EdgeInsets(top: spacing, leading: 0, bottom: spacing, trailing: 0)
    }
    
    /// Create padding for a specific edge
    ///
    /// - Parameters:
    ///   - edge: The edge to apply padding to
    ///   - spacing: The spacing value to use
    /// - Returns: The edge insets with padding applied to the specified edge
    public static func padding(for edge: Edge, spacing: CGFloat) -> EdgeInsets {
        switch edge {
        case .top:
            return EdgeInsets(top: spacing, leading: 0, bottom: 0, trailing: 0)
        case .leading:
            return EdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: 0)
        case .bottom:
            return EdgeInsets(top: 0, leading: 0, bottom: spacing, trailing: 0)
        case .trailing:
            return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: spacing)
        }
    }
    
    /// Get a responsive spacing value based on the device size
    ///
    /// - Parameter baseSpacing: The base spacing value to scale
    /// - Returns: The scaled spacing value for the current device
    public static func responsive(_ baseSpacing: CGFloat) -> CGFloat {
        return CTLayoutUtilities.responsiveSize(small: baseSpacing * 0.75, regular: baseSpacing, large: baseSpacing * 1.25)
    }
    
    /// Get the appropriate stack spacing for a device size
    ///
    /// - Returns: The stack spacing value for the current device
    public static var stackSpacing: CGFloat {
        switch CTDeviceUtilities.deviceSize {
        case .small:
            return s
        case .medium:
            return m
        case .large, .extraLarge:
            return l
        }
    }
}

// MARK: - View Extensions for Spacing

/// Extensions for applying CTSpacing to SwiftUI views
public extension View {
    /// Apply standard horizontal padding based on CTSpacing
    ///
    /// - Parameter multiplier: Optional multiplier for the spacing value
    /// - Returns: The view with horizontal padding applied
    func ctHorizontalPadding(_ multiplier: CGFloat = 1) -> some View {
        padding(.horizontal, CTSpacing.m * multiplier)
    }
    
    /// Apply standard vertical padding based on CTSpacing
    ///
    /// - Parameter multiplier: Optional multiplier for the spacing value
    /// - Returns: The view with vertical padding applied
    func ctVerticalPadding(_ multiplier: CGFloat = 1) -> some View {
        padding(.vertical, CTSpacing.m * multiplier)
    }
    
    /// Apply standard padding on all edges based on CTSpacing
    ///
    /// - Parameter multiplier: Optional multiplier for the spacing value
    /// - Returns: The view with padding applied on all edges
    func ctPadding(_ multiplier: CGFloat = 1) -> some View {
        padding(CTSpacing.all(CTSpacing.m * multiplier))
    }
    
    /// Apply card-style padding based on CTSpacing
    ///
    /// - Returns: The view with card-style padding applied
    func ctCardPadding() -> some View {
        padding(CTSpacing.cardPadding)
    }
}
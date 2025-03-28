//
//  CTLayoutUtilities.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// Utilities for layout calculations and positioning
///
/// This class provides helper functions for layout calculations, making it easier
/// to create consistent layouts that adapt to different device sizes.
public enum CTLayoutUtilities {
    // MARK: - Responsive Sizing
    
    /// Calculate a responsive size based on the device size
    ///
    /// This method returns a size that scales appropriately for different device sizes.
    ///
    /// - Parameters:
    ///   - smallSize: The size for small devices
    ///   - regularSize: The size for regular devices
    ///   - largeSize: The size for large devices
    /// - Returns: The appropriate size for the current device
    public static func responsiveSize(
        small smallSize: CGFloat,
        regular regularSize: CGFloat,
        large largeSize: CGFloat = -1
    ) -> CGFloat {
        let deviceSize = CTDeviceUtilities.deviceSize
        let largeValue = largeSize >= 0 ? largeSize : regularSize * 1.25
        
        switch deviceSize {
        case .small:
            return smallSize
        case .medium:
            return regularSize
        case .large:
            return largeValue
        case .extraLarge:
            return largeValue * 1.25
        }
    }
    
    /// Calculate padding that adapts to the device size
    ///
    /// This method returns padding values that scale appropriately for different device sizes.
    ///
    /// - Parameters:
    ///   - small: The padding for small devices
    ///   - regular: The padding for regular devices
    ///   - large: The padding for large devices
    /// - Returns: The appropriate padding for the current device
    public static func responsivePadding(
        small: CGFloat = CTSpacing.s,
        regular: CGFloat = CTSpacing.m,
        large: CGFloat = CTSpacing.l
    ) -> CGFloat {
        return responsiveSize(small: small, regular: regular, large: large)
    }
    
    /// Calculate a horizontal padding value that adapts to the device size
    ///
    /// - Returns: The appropriate horizontal padding for the current device
    public static var horizontalPadding: CGFloat {
        switch CTDeviceUtilities.deviceSize {
        case .small:
            return CTSpacing.m
        case .medium:
            return CTSpacing.l
        case .large, .extraLarge:
            return CTSpacing.xl
        }
    }
    
    /// Calculate a vertical padding value that adapts to the device size
    ///
    /// - Returns: The appropriate vertical padding for the current device
    public static var verticalPadding: CGFloat {
        switch CTDeviceUtilities.deviceSize {
        case .small:
            return CTSpacing.s
        case .medium:
            return CTSpacing.m
        case .large, .extraLarge:
            return CTSpacing.l
        }
    }
    
    // MARK: - Grid Calculations
    
    /// Calculate the number of columns for a grid based on the available width
    ///
    /// This method helps create responsive grids by calculating the appropriate number
    /// of columns based on the available width and minimum item width.
    ///
    /// - Parameters:
    ///   - availableWidth: The available width for the grid
    ///   - minItemWidth: The minimum width for each item in the grid
    ///   - spacing: The spacing between items
    /// - Returns: The appropriate number of columns
    public static func calculateColumns(
        availableWidth: CGFloat,
        minItemWidth: CGFloat,
        spacing: CGFloat = CTSpacing.m
    ) -> Int {
        // Calculate how many items can fit in the available width
        let itemsPerRow = max(1, Int((availableWidth + spacing) / (minItemWidth + spacing)))
        return itemsPerRow
    }
    
    /// Calculate the width for each item in a grid based on the number of columns
    ///
    /// - Parameters:
    ///   - availableWidth: The available width for the grid
    ///   - columns: The number of columns
    ///   - spacing: The spacing between items
    /// - Returns: The width for each item
    public static func calculateItemWidth(
        availableWidth: CGFloat,
        columns: Int,
        spacing: CGFloat = CTSpacing.m
    ) -> CGFloat {
        // Calculate the width for each item
        let totalSpacing = spacing * CGFloat(columns - 1)
        let itemWidth = (availableWidth - totalSpacing) / CGFloat(columns)
        return max(0, itemWidth)
    }
    
    // MARK: - Layout Adaptations
    
    /// Get the appropriate spacing between items based on the device size
    ///
    /// - Returns: The appropriate spacing for the current device
    public static var adaptiveSpacing: CGFloat {
        switch CTDeviceUtilities.deviceSize {
        case .small:
            return CTSpacing.xs
        case .medium:
            return CTSpacing.s
        case .large:
            return CTSpacing.m
        case .extraLarge:
            return CTSpacing.l
        }
    }
    
    /// Get the appropriate corner radius based on the device size
    ///
    /// - Returns: The appropriate corner radius for the current device
    public static var adaptiveCornerRadius: CGFloat {
        switch CTDeviceUtilities.deviceSize {
        case .small:
            return 8
        case .medium:
            return 10
        case .large, .extraLarge:
            return 12
        }
    }
    
    /// Get the appropriate font size adjustment based on the device size
    ///
    /// This can be used to scale fonts on different device sizes.
    ///
    /// - Returns: The font size adjustment factor
    public static var fontSizeAdjustment: CGFloat {
        switch CTDeviceUtilities.deviceSize {
        case .small:
            return 0.9
        case .medium:
            return 1.0
        case .large:
            return 1.1
        case .extraLarge:
            return 1.2
        }
    }
    
    // MARK: - Safe Area Helpers
    
    /// Get the safe area insets for the bottom of the screen
    ///
    /// - Returns: The bottom safe area inset
    public static var bottomSafeAreaInset: CGFloat {
        return CTDeviceUtilities.safeAreaInsets.bottom
    }
    
    /// Get the safe area insets for the top of the screen
    ///
    /// - Returns: The top safe area inset
    public static var topSafeAreaInset: CGFloat {
        return CTDeviceUtilities.safeAreaInsets.top
    }
    
    /// Get the height of the status bar
    ///
    /// - Returns: The height of the status bar
    public static var statusBarHeight: CGFloat {
        return topSafeAreaInset
    }
    
    /// Get the height to use for tab bars
    ///
    /// - Returns: The appropriate height for a tab bar
    public static var tabBarHeight: CGFloat {
        return 49 + bottomSafeAreaInset
    }
    
    /// Get the height to use for navigation bars
    ///
    /// - Returns: The appropriate height for a navigation bar
    public static var navigationBarHeight: CGFloat {
        return 44 + topSafeAreaInset
    }
}

// MARK: - View Extensions for Layout

/// Extensions for applying layout utilities to SwiftUI views
public extension View {
    /// Apply responsive horizontal padding to a view
    ///
    /// - Returns: The view with responsive horizontal padding
    func ctHorizontalPadding() -> some View {
        padding(.horizontal, CTLayoutUtilities.horizontalPadding)
    }
    
    /// Apply responsive vertical padding to a view
    ///
    /// - Returns: The view with responsive vertical padding
    func ctVerticalPadding() -> some View {
        padding(.vertical, CTLayoutUtilities.verticalPadding)
    }
    
    /// Apply responsive padding to a view
    ///
    /// - Returns: The view with responsive padding on all edges
    func ctResponsivePadding() -> some View {
        padding(EdgeInsets(
            top: CTLayoutUtilities.verticalPadding,
            leading: CTLayoutUtilities.horizontalPadding,
            bottom: CTLayoutUtilities.verticalPadding,
            trailing: CTLayoutUtilities.horizontalPadding
        ))
    }
    
    /// Apply adaptive corner radius to a view
    ///
    /// - Returns: The view with an adaptive corner radius
    func ctAdaptiveCornerRadius() -> some View {
        clipShape(RoundedRectangle(cornerRadius: CTLayoutUtilities.adaptiveCornerRadius))
    }
}
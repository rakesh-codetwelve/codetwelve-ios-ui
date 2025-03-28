//
//  CTDivider.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable divider component for visually separating content.
///
/// `CTDivider` provides a consistent divider interface throughout your application
/// with support for different orientations, colors, and thicknesses.
///
/// # Example
///
/// ```swift
/// // Simple horizontal divider
/// CTDivider()
///
/// // Customized vertical divider
/// CTDivider(orientation: .vertical, color: .red, thickness: 2)
/// ```
public struct CTDivider: View {
    // MARK: - Public Properties
    
    /// The orientation of the divider
    public enum Orientation {
        /// Horizontal line (width is flexible, height is fixed)
        case horizontal
        /// Vertical line (height is flexible, width is fixed)
        case vertical
    }
    
    // MARK: - Private Properties
    
    private let orientation: Orientation
    private let color: Color
    private let thickness: CGFloat
    private let length: CGFloat?
    private let opacity: Double
    
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a new divider
    /// - Parameters:
    ///   - orientation: The orientation of the divider (default: .horizontal)
    ///   - color: The color of the divider (default: theme's border color)
    ///   - thickness: The thickness of the divider in points (default: 1)
    ///   - length: The length of the divider in points, nil for flexible (default: nil)
    ///   - opacity: The opacity of the divider (default: 1.0)
    public init(
        orientation: Orientation = .horizontal,
        color: Color? = nil,
        thickness: CGFloat = 1,
        length: CGFloat? = nil,
        opacity: Double = 1.0
    ) {
        self.orientation = orientation
        self.color = color ?? .ctBorder
        self.thickness = thickness
        self.length = length
        self.opacity = opacity
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            if orientation == .horizontal {
                horizontalDivider
            } else {
                verticalDivider
            }
        }
        .accessibilityHidden(true)
    }
    
    // MARK: - Private Views
    
    private var horizontalDivider: some View {
        Rectangle()
            .fill(color)
            .frame(height: thickness)
            .frame(width: length)
            .opacity(opacity)
    }
    
    private var verticalDivider: some View {
        Rectangle()
            .fill(color)
            .frame(width: thickness)
            .frame(height: length)
            .opacity(opacity)
    }
}

// MARK: - Previews

struct CTDivider_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: CTSpacing.m) {
            // Default horizontal divider
            CTDivider()
                .padding(.vertical)
            
            // Custom colored divider
            CTDivider(color: .ctPrimary)
                .padding(.vertical)
            
            // Thicker divider
            CTDivider(thickness: 4)
                .padding(.vertical)
            
            // Fixed length divider
            CTDivider(length: 100)
                .padding(.vertical)
            
            // Semi-transparent divider
            CTDivider(opacity: 0.5)
                .padding(.vertical)
            
            HStack {
                // Vertical divider
                CTDivider(orientation: .vertical, thickness: 2, length: 100)
                    .padding(.horizontal)
                
                Text("Vertical Divider Example")
                    .ctBody()
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Divider Examples")
    }
}
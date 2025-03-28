//
//  CTIcon.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable icon component using SF Symbols.
///
/// `CTIcon` provides a consistent interface for displaying icons throughout your application
/// with support for different sizes, weights, and colors.
///
/// # Example
///
/// ```swift
/// CTIcon("star.fill")
///
/// CTIcon("heart.fill", size: .large, color: .ctDestructive)
/// ```
public struct CTIcon: View {
    // MARK: - Public Properties
    
    /// The SF Symbol name for the icon.
    private let systemName: String
    
    /// The size of the icon.
    private let size: IconSize
    
    /// The color of the icon.
    private let color: Color
    
    /// The weight of the icon.
    private let weight: Font.Weight
    
    /// The rendering mode of the icon.
    private let renderingMode: SymbolRenderingMode
    
    /// The accessibility label for the icon.
    private let accessibilityLabel: String?
    
    /// Whether the icon should be treated as a decorative element (for accessibility).
    private let isDecorative: Bool
    
    // MARK: - Environment Properties
    
    /// The current theme from the environment.
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a new icon component with the specified SF Symbol and styling.
    ///
    /// - Parameters:
    ///   - systemName: The SF Symbol name for the icon.
    ///   - size: The size of the icon (defaults to medium).
    ///   - color: The color of the icon (defaults to the theme's text color).
    ///   - weight: The weight of the icon (defaults to regular).
    ///   - renderingMode: The rendering mode of the icon (defaults to multicolor).
    ///   - accessibilityLabel: The accessibility label for the icon (defaults to nil).
    ///   - isDecorative: Whether the icon should be treated as a decorative element (defaults to false).
    public init(
        _ systemName: String,
        size: IconSize = .medium,
        color: Color? = nil,
        weight: Font.Weight = .regular,
        renderingMode: SymbolRenderingMode = .multicolor,
        accessibilityLabel: String? = nil,
        isDecorative: Bool = false
    ) {
        self.systemName = systemName
        self.size = size
        self.color = color ?? .ctText
        self.weight = weight
        self.renderingMode = renderingMode
        self.accessibilityLabel = accessibilityLabel
        self.isDecorative = isDecorative
    }
    
    // MARK: - Body
    
    public var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size.pointSize, weight: weight))
            .foregroundColor(color)
            .symbolRenderingMode(renderingMode)
            .frame(width: size.frame, height: size.frame)
            .accessibilityLabel(isDecorative ? "" : (accessibilityLabel ?? systemName))
            .accessibilityHidden(isDecorative)
    }
}

// MARK: - Supporting Types

/// The available sizes for the icon.
public enum IconSize {
    /// Extra small icon size, appropriate for indicators.
    case extraSmall
    
    /// Small icon size, appropriate for dense UIs and supporting information.
    case small
    
    /// Medium icon size, appropriate for most standard UI elements.
    case medium
    
    /// Large icon size, appropriate for emphasis and featured elements.
    case large
    
    /// Extra large icon size, appropriate for hero elements and illustrations.
    case extraLarge
    
    /// Custom icon size with a specific point size.
    case custom(CGFloat)
    
    /// The font point size for the icon.
    var pointSize: CGFloat {
        switch self {
        case .extraSmall:
            return 12
        case .small:
            return 16
        case .medium:
            return 24
        case .large:
            return 32
        case .extraLarge:
            return 44
        case .custom(let size):
            return size
        }
    }
    
    /// The frame size for the icon (optional for layout).
    var frame: CGFloat {
        switch self {
        case .extraSmall:
            return 16
        case .small:
            return 20
        case .medium:
            return 28
        case .large:
            return 36
        case .extraLarge:
            return 48
        case .custom(let size):
            return size + 4
        }
    }
}

// MARK: - Previews

struct CTIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: CTSpacing.m) {
            Group {
                HStack(spacing: CTSpacing.m) {
                    CTIcon("star.fill", size: .extraSmall)
                    CTIcon("star.fill", size: .small)
                    CTIcon("star.fill", size: .medium)
                    CTIcon("star.fill", size: .large)
                    CTIcon("star.fill", size: .extraLarge)
                }
                .padding()
                .previewDisplayName("Icon Sizes")
                
                HStack(spacing: CTSpacing.m) {
                    CTIcon("heart.fill", color: .ctPrimary)
                    CTIcon("heart.fill", color: .ctSecondary)
                    CTIcon("heart.fill", color: .ctDestructive)
                    CTIcon("heart.fill", color: .ctSuccess)
                    CTIcon("heart.fill", color: .ctWarning)
                }
                .padding()
                .previewDisplayName("Icon Colors")
                
                HStack(spacing: CTSpacing.m) {
                    CTIcon("cloud.sun.fill", renderingMode: .multicolor)
                    CTIcon("cloud.sun.fill", renderingMode: .hierarchical)
                    CTIcon("cloud.sun.fill", color: .ctPrimary, renderingMode: .palette)
                    CTIcon("cloud.sun.fill", color: .ctSecondary, renderingMode: .monochrome)
                }
                .padding()
                .previewDisplayName("Rendering Modes")
                
                HStack(spacing: CTSpacing.m) {
                    CTIcon("person.fill", weight: .ultraLight)
                    CTIcon("person.fill", weight: .light)
                    CTIcon("person.fill", weight: .regular)
                    CTIcon("person.fill", weight: .medium)
                    CTIcon("person.fill", weight: .semibold)
                    CTIcon("person.fill", weight: .bold)
                    CTIcon("person.fill", weight: .heavy)
                    CTIcon("person.fill", weight: .black)
                }
                .padding()
                .previewDisplayName("Icon Weights")
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
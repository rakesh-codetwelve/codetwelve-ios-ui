//
//  CTContainer.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A container component with customizable padding and background.
///
/// `CTContainer` provides a consistent way to wrap content with appropriate spacing
/// and styling. It supports customization for padding, background, border, and shadow.
///
/// # Example
///
/// ```swift
/// CTContainer {
///     Text("Hello, World!")
/// }
///
/// // With custom styling
/// CTContainer(
///     padding: .m,
///     backgroundColor: .ctSecondary,
///     cornerRadius: 8
/// ) {
///     Text("Styled Container")
/// }
/// ```
public struct CTContainer<Content: View>: View {
    // MARK: - Properties
    
    /// The content view to be contained
    private let content: Content
    
    /// The padding around the content
    private let padding: EdgeInsets
    
    /// The background color of the container
    private let backgroundColor: Color?
    
    /// The corner radius of the container
    private let cornerRadius: CGFloat
    
    /// The border width of the container
    private let borderWidth: CGFloat
    
    /// The border color of the container
    private let borderColor: Color?
    
    /// Whether to show a shadow
    private let shadowEnabled: Bool
    
    /// The shadow radius when enabled
    private let shadowRadius: CGFloat
    
    /// The shadow opacity when enabled
    private let shadowOpacity: Double
    
    /// The shadow offset when enabled
    private let shadowOffset: CGSize
    
    /// The shadow color when enabled
    private let shadowColor: Color?
    
    /// Theme access via environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Creates a container with customizable parameters
    ///
    /// - Parameters:
    ///   - padding: The padding around the content, defaulting to medium padding
    ///   - backgroundColor: Optional background color, uses theme surface color if nil
    ///   - cornerRadius: The corner radius of the container
    ///   - borderWidth: The border width of the container
    ///   - borderColor: Optional border color, uses theme border color if nil
    ///   - shadowEnabled: Whether to show a shadow
    ///   - shadowRadius: The shadow radius when enabled
    ///   - shadowOpacity: The shadow opacity when enabled
    ///   - shadowOffset: The shadow offset when enabled
    ///   - shadowColor: Optional shadow color, uses theme shadow color if nil
    ///   - content: The content view builder
    public init(
        padding: EdgeInsets = EdgeInsets(top: CTSpacing.m, leading: CTSpacing.m, bottom: CTSpacing.m, trailing: CTSpacing.m),
        backgroundColor: Color? = nil,
        cornerRadius: CGFloat = 8,
        borderWidth: CGFloat = 0,
        borderColor: Color? = nil,
        shadowEnabled: Bool = false,
        shadowRadius: CGFloat = 4,
        shadowOpacity: Double = 0.1,
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        shadowColor: Color? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.shadowEnabled = shadowEnabled
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
        self.shadowOffset = shadowOffset
        self.shadowColor = shadowColor
    }
    
    /// Creates a container with uniform padding on all sides
    ///
    /// - Parameters:
    ///   - padding: The padding value to apply on all sides
    ///   - backgroundColor: Optional background color, uses theme surface color if nil
    ///   - cornerRadius: The corner radius of the container
    ///   - borderWidth: The border width of the container
    ///   - borderColor: Optional border color, uses theme border color if nil
    ///   - shadowEnabled: Whether to show a shadow
    ///   - content: The content view builder
    public init(
        padding: CGFloat = CTSpacing.m,
        backgroundColor: Color? = nil,
        cornerRadius: CGFloat = 8,
        borderWidth: CGFloat = 0,
        borderColor: Color? = nil,
        shadowEnabled: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            padding: EdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding),
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            borderWidth: borderWidth,
            borderColor: borderColor,
            shadowEnabled: shadowEnabled,
            content: content
        )
    }
    
    // MARK: - Body
    
    public var body: some View {
        content
            .padding(padding)
            .background(effectiveBackgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(effectiveBorderColor, lineWidth: borderWidth)
            )
            .ctConditional(shadowEnabled) { view in
                view.shadow(
                    color: effectiveShadowColor.opacity(shadowOpacity),
                    radius: shadowRadius,
                    x: shadowOffset.width,
                    y: shadowOffset.height
                )
            }
    }
    
    // MARK: - Private Computed Properties
    
    /// The effective background color, using theme values if not explicitly set
    private var effectiveBackgroundColor: Color {
        backgroundColor ?? theme.surface
    }
    
    /// The effective border color, using theme values if not explicitly set
    private var effectiveBorderColor: Color {
        borderColor ?? theme.border
    }
    
    /// The effective shadow color, using theme values if not explicitly set
    private var effectiveShadowColor: Color {
        shadowColor ?? theme.shadowColor
    }
}

// MARK: - Convenience Initializers

public extension CTContainer {
    /// Creates a container with no background or border, just padding
    ///
    /// - Parameters:
    ///   - padding: The padding around the content
    ///   - content: The content view builder
    static func padding(
        _ padding: EdgeInsets = EdgeInsets(top: CTSpacing.m, leading: CTSpacing.m, bottom: CTSpacing.m, trailing: CTSpacing.m),
        @ViewBuilder content: () -> Content
    ) -> CTContainer {
        CTContainer(
            padding: padding,
            backgroundColor: .clear,
            cornerRadius: 0,
            borderWidth: 0,
            content: content
        )
    }
    
    /// Creates a container styled as a surface with shadow
    ///
    /// - Parameters:
    ///   - padding: The padding around the content
    ///   - cornerRadius: The corner radius of the container
    ///   - shadowStrength: The strength of the shadow (0-1)
    ///   - content: The content view builder
    static func surface(
        padding: EdgeInsets = EdgeInsets(top: CTSpacing.m, leading: CTSpacing.m, bottom: CTSpacing.m, trailing: CTSpacing.m),
        cornerRadius: CGFloat = 8,
        shadowStrength: Double = 0.1,
        @ViewBuilder content: () -> Content
    ) -> CTContainer {
        CTContainer(
            padding: padding,
            cornerRadius: cornerRadius,
            shadowEnabled: true,
            shadowOpacity: shadowStrength,
            content: content
        )
    }
    
    /// Creates a container with a primary background color
    ///
    /// - Parameters:
    ///   - padding: The padding around the content
    ///   - cornerRadius: The corner radius of the container
    ///   - content: The content view builder
    static func primary(
        padding: EdgeInsets = EdgeInsets(top: CTSpacing.m, leading: CTSpacing.m, bottom: CTSpacing.m, trailing: CTSpacing.m),
        cornerRadius: CGFloat = 8,
        @ViewBuilder content: () -> Content
    ) -> CTContainer {
        CTContainer(
            padding: padding,
            backgroundColor: .ctPrimary,
            cornerRadius: cornerRadius,
            content: content
        )
    }
    
    /// Creates a container with a border
    ///
    /// - Parameters:
    ///   - padding: The padding around the content
    ///   - borderWidth: The width of the border
    ///   - borderColor: The color of the border
    ///   - cornerRadius: The corner radius of the container
    ///   - content: The content view builder
    static func bordered(
        padding: EdgeInsets = EdgeInsets(top: CTSpacing.m, leading: CTSpacing.m, bottom: CTSpacing.m, trailing: CTSpacing.m),
        borderWidth: CGFloat = 1,
        borderColor: Color? = nil,
        cornerRadius: CGFloat = 8,
        @ViewBuilder content: () -> Content
    ) -> CTContainer {
        CTContainer(
            padding: padding,
            backgroundColor: .clear,
            cornerRadius: cornerRadius,
            borderWidth: borderWidth,
            borderColor: borderColor,
            content: content
        )
    }
}

// MARK: - View Extensions

public extension View {
    /// Wraps the view in a CTContainer with uniform padding
    ///
    /// - Parameter padding: The padding to apply to all sides
    /// - Returns: A container view with the specified padding
    func ctContainerPadding(_ padding: CGFloat = CTSpacing.m) -> some View {
        CTContainer(padding: padding) {
            self
        }
    }
    
    /// Wraps the view in a CTContainer with custom edge insets
    ///
    /// - Parameter padding: The edge insets to apply
    /// - Returns: A container view with the specified padding
    func ctContainerPadding(_ padding: EdgeInsets) -> some View {
        CTContainer(padding: padding) {
            self
        }
    }
    
    /// Wraps the view in a CTContainer styled as a surface
    ///
    /// - Parameters:
    ///   - padding: The padding to apply
    ///   - cornerRadius: The corner radius
    /// - Returns: A container view styled as a surface
    func ctSurface(
        padding: EdgeInsets = EdgeInsets(top: CTSpacing.m, leading: CTSpacing.m, bottom: CTSpacing.m, trailing: CTSpacing.m),
        cornerRadius: CGFloat = 8
    ) -> some View {
        CTContainer.surface(
            padding: padding,
            cornerRadius: cornerRadius
        ) {
            self
        }
    }
}

// MARK: - Previews

struct CTContainer_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Basic container
            CTContainer {
                Text("Basic Container")
                    .frame(maxWidth: .infinity)
            }
            
            // Styled container
            CTContainer(
                padding: CTSpacing.all(CTSpacing.m),
                backgroundColor: .ctSecondary,
                cornerRadius: 12
            ) {
                Text("Styled Container")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }
            
            // Bordered container
            CTContainer.bordered(
                borderWidth: 2,
                borderColor: .ctPrimary
            ) {
                Text("Bordered Container")
                    .frame(maxWidth: .infinity)
            }
            
            // Surface container
            CTContainer.surface(
                shadowStrength: 0.2
            ) {
                Text("Surface Container")
                    .frame(maxWidth: .infinity)
            }
            
            // Primary container
            CTContainer.primary {
                Text("Primary Container")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }
            
            // Using extension
            Text("Extension Container")
                .frame(maxWidth: .infinity)
                .ctSurface(padding: CTSpacing.all(CTSpacing.l))
        }
        .padding()
    }
}

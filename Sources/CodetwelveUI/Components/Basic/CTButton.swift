//
//  CTButton.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable button component with various styles.
///
/// `CTButton` provides a consistent button interface throughout your application
/// with support for different visual styles, sizes, and states including loading and disabled.
///
/// # Example
///
/// ```swift
/// CTButton("Sign In", style: .primary) {
///     print("Button tapped")
/// }
///
/// // With loading state
/// CTButton("Processing", isLoading: true) {
///     print("This won't be called while loading")
/// }
///
/// // With disabled state
/// CTButton("Submit", isDisabled: true) {
///     print("This won't be called when disabled")
/// }
///
/// // With custom icon
/// CTButton("Continue", icon: "arrow.right") {
///     print("Button with icon tapped")
/// }
/// ```
public struct CTButton: View {
    // MARK: - Public Properties
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Private Properties
    
    private let label: String
    private let icon: String?
    private let iconPosition: IconPosition
    private let style: CTButtonStyle
    private let size: CTButtonSize
    private let isLoading: Bool
    private let isDisabled: Bool
    private let fullWidth: Bool
    private let action: () -> Void
    
    // MARK: - Initializers
    
    /// Initialize a new button with text label
    /// - Parameters:
    ///   - label: The text displayed on the button
    ///   - icon: Optional SF Symbol name for an icon
    ///   - iconPosition: Position of the icon relative to the label (leading or trailing)
    ///   - style: The visual style of the button
    ///   - size: The size of the button
    ///   - isLoading: Whether the button is in a loading state
    ///   - isDisabled: Whether the button is disabled
    ///   - fullWidth: Whether the button should take the full available width
    ///   - action: The action to perform when the button is pressed
    public init(
        _ label: String,
        icon: String? = nil,
        iconPosition: IconPosition = .leading,
        style: CTButtonStyle = .primary,
        size: CTButtonSize = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        fullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.icon = icon
        self.iconPosition = iconPosition
        self.style = style
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.fullWidth = fullWidth
        self.action = action
    }
    
    // MARK: - Body
    
    public var body: some View {
        Button(action: performAction) {
            HStack(spacing: CTSpacing.xs) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style.tintColor(for: theme)))
                        .scaleEffect(0.7)
                } else {
                    if let icon = icon, iconPosition == .leading {
                        Image(systemName: icon)
                            .imageScale(size.iconScale)
                    }
                    
                    Text(label)
                        .font(size.font)
                    
                    if let icon = icon, iconPosition == .trailing {
                        Image(systemName: icon)
                            .imageScale(size.iconScale)
                    }
                }
            }
            .padding(size.padding)
            .frame(height: size.height)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .background(theme.buttonBackgroundColor(for: style))
            .foregroundColor(theme.buttonForegroundColor(for: style))
            .cornerRadius(theme.borderRadius)
            .overlay(
                RoundedRectangle(cornerRadius: theme.borderRadius)
                    .stroke(theme.buttonBorderColor(for: style), lineWidth: style == .outline ? theme.borderWidth : 0)
            )
            .opacity(isDisabled ? 0.6 : 1.0)
            .ctAnimation(CTAnimation.buttonPress, value: isDisabled)
            .ctAnimation(CTAnimation.buttonPress, value: isLoading)
        }
        .disabled(isDisabled || isLoading)
        .ctButtonAccessibility(label: accessibilityLabel)
    }
    
    // MARK: - Private Methods
    
    /// Perform the button action with haptic feedback
    private func performAction() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        action()
    }
    
    /// Get the accessibility label based on button state
    private var accessibilityLabel: String {
        if isLoading {
            return "\(label), Loading"
        } else if isDisabled {
            return "\(label), Disabled"
        } else {
            return label
        }
    }
}

// MARK: - Supporting Types

/// The position of an icon relative to the button label
public enum IconPosition {
    /// Icon appears before the label
    case leading
    /// Icon appears after the label
    case trailing
}

/// Defines the visual style of the button
public enum CTButtonStyle {
    /// Primary action button with strong visual emphasis
    case primary
    /// Secondary action button with medium visual emphasis
    case secondary
    /// Destructive action button typically in red
    case destructive
    /// Button with an outline and transparent background
    case outline
    /// Button with no background or border
    case ghost
    /// Button that looks like a link
    case link
    
    /// Get the appropriate tint color for the current style
    /// - Parameter theme: The current theme
    /// - Returns: The tint color for the progress view
    func tintColor(for theme: CTTheme) -> Color {
        switch self {
        case .primary, .secondary, .destructive:
            return theme.textOnAccent
        case .outline:
            return theme.primary
        case .ghost, .link:
            return theme.text
        }
    }
}

/// Defines the size of the button
public enum CTButtonSize {
    /// Small button size
    case small
    /// Medium button size (default)
    case medium
    /// Large button size
    case large
    
    /// The padding for the button based on its size
    var padding: EdgeInsets {
        switch self {
        case .small:
            return EdgeInsets(top: CTSpacing.xs, leading: CTSpacing.s, bottom: CTSpacing.xs, trailing: CTSpacing.s)
        case .medium:
            return EdgeInsets(top: CTSpacing.s, leading: CTSpacing.m, bottom: CTSpacing.s, trailing: CTSpacing.m)
        case .large:
            return EdgeInsets(top: CTSpacing.m, leading: CTSpacing.l, bottom: CTSpacing.m, trailing: CTSpacing.l)
        }
    }
    
    /// The font for the button based on its size
    var font: Font {
        switch self {
        case .small:
            return CTTypography.buttonSmall()
        case .medium:
            return CTTypography.button()
        case .large:
            return CTTypography.buttonLarge()
        }
    }
    
    /// The height for the button based on its size
    var height: CGFloat {
        switch self {
        case .small:
            return 32
        case .medium:
            return 44
        case .large:
            return 56
        }
    }
    
    /// The icon scale for the button based on its size
    var iconScale: Image.Scale {
        switch self {
        case .small:
            return .small
        case .medium:
            return .medium
        case .large:
            return .large
        }
    }
}

// MARK: - Previews

struct CTButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(spacing: CTSpacing.m) {
                Text("Button Styles").ctHeading2()
                
                CTButton("Primary Button", style: .primary) {}
                CTButton("Secondary Button", style: .secondary) {}
                CTButton("Destructive Button", style: .destructive) {}
                CTButton("Outline Button", style: .outline) {}
                CTButton("Ghost Button", style: .ghost) {}
                CTButton("Link Button", style: .link) {}
            }
            .padding()
            .previewDisplayName("Button Styles")
            
            VStack(spacing: CTSpacing.m) {
                Text("Button Sizes").ctHeading2()
                
                CTButton("Small Button", size: .small) {}
                CTButton("Medium Button", size: .medium) {}
                CTButton("Large Button", size: .large) {}
            }
            .padding()
            .previewDisplayName("Button Sizes")
            
            VStack(spacing: CTSpacing.m) {
                Text("Button States").ctHeading2()
                
                CTButton("Loading Button", isLoading: true) {}
                CTButton("Disabled Button", isDisabled: true) {}
                CTButton("Full Width Button", fullWidth: true) {}
            }
            .padding()
            .previewDisplayName("Button States")
            
            VStack(spacing: CTSpacing.m) {
                Text("Button with Icons").ctHeading2()
                
                CTButton("Leading Icon", icon: "arrow.left") {}
                CTButton("Trailing Icon", icon: "arrow.right", iconPosition: .trailing) {}
                CTButton("Loading with Icon", icon: "arrow.right", isLoading: true) {}
            }
            .padding()
            .previewDisplayName("Button with Icons")
        }
    }
}
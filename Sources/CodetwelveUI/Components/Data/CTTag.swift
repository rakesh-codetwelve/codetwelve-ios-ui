//
//  CTTag.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable tag component for displaying metadata, categories, or labels.
///
/// `CTTag` provides a consistent tag interface throughout your application
/// with support for different visual styles, sizes, and optional icons.
///
/// # Example
///
/// ```swift
/// // Basic tag
/// CTTag("Design")
///
/// // Tag with icon
/// CTTag("Important", icon: "star.fill", style: .accent)
///
/// // Removable tag
/// CTTag("Category", isRemovable: true) {
///     // Handle tag removal
/// }
/// ```
public struct CTTag: View {
    // MARK: - Public Properties
    
    /// The style of the tag
    public enum Style {
        /// Default neutral style
        case `default`
        
        /// Primary accent style
        case primary
        
        /// Secondary accent style
        case secondary
        
        /// Success style (typically green)
        case success
        
        /// Warning style (typically yellow/orange)
        case warning
        
        /// Error or destructive style (typically red)
        case error
        
        /// Custom style with specific colors
        case custom(backgroundColor: Color, foregroundColor: Color)
    }
    
    /// The size of the tag
    public enum Size {
        /// Small tag size
        case small
        
        /// Medium tag size (default)
        case medium
        
        /// Large tag size
        case large
    }
    
    // MARK: - Private Properties
    
    private let text: String
    private let icon: String?
    private let style: Style
    private let size: Size
    private let isRemovable: Bool
    private let onRemove: (() -> Void)?
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a new tag with text and optional configuration
    /// - Parameters:
    ///   - text: The text to display in the tag
    ///   - icon: Optional SF Symbol icon name
    ///   - style: The visual style of the tag (default: .default)
    ///   - size: The size of the tag (default: .medium)
    ///   - isRemovable: Whether the tag can be removed (default: false)
    ///   - onRemove: Action to perform when the tag is removed (optional)
    public init(
        _ text: String,
        icon: String? = nil,
        style: Style = .default,
        size: Size = .medium,
        isRemovable: Bool = false,
        onRemove: (() -> Void)? = nil
    ) {
        self.text = text
        self.icon = icon
        self.style = style
        self.size = size
        self.isRemovable = isRemovable
        self.onRemove = onRemove
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: spacing) {
            // Optional icon
            if let icon = icon {
                Image(systemName: icon)
                    .font(iconFont)
                    .foregroundColor(foregroundColor)
            }
            
            Text(text)
                .font(textFont)
                .foregroundColor(foregroundColor)
            
            // Optional remove button
            if isRemovable {
                Button(action: { onRemove?() }) {
                    Image(systemName: "xmark")
                        .font(removeButtonFont)
                        .foregroundColor(foregroundColor)
                }
                .accessibilityLabel("Remove \(text) tag")
            }
        }
        .padding(padding)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .ctAnimation(CTAnimation.buttonPress, value: isRemovable)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(text)
    }
    
    // MARK: - Private Computed Properties
    
    private var backgroundColor: Color {
        switch style {
        case .default:
            return theme.surface.opacity(0.5)
        case .primary:
            return theme.primary.opacity(0.1)
        case .secondary:
            return theme.secondary.opacity(0.1)
        case .success:
            return theme.success.opacity(0.1)
        case .warning:
            return theme.warning.opacity(0.1)
        case .error:
            return theme.destructive.opacity(0.1)
        case .custom(let backgroundColor, _):
            return backgroundColor.opacity(0.1)
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .default:
            return theme.text
        case .primary:
            return theme.primary
        case .secondary:
            return theme.secondary
        case .success:
            return theme.success
        case .warning:
            return theme.warning
        case .error:
            return theme.destructive
        case .custom(_, let foregroundColor):
            return foregroundColor
        }
    }
    
    private var textFont: Font {
        switch size {
        case .small:
            return CTTypography.captionSmall()
        case .medium:
            return CTTypography.caption()
        case .large:
            return CTTypography.body()
        }
    }
    
    private var iconFont: Font {
        switch size {
        case .small:
            return .system(size: 10)
        case .medium:
            return .system(size: 12)
        case .large:
            return .system(size: 14)
        }
    }
    
    private var removeButtonFont: Font {
        switch size {
        case .small:
            return .system(size: 8)
        case .medium:
            return .system(size: 10)
        case .large:
            return .system(size: 12)
        }
    }
    
    private var spacing: CGFloat {
        switch size {
        case .small:
            return CTSpacing.xs
        case .medium:
            return CTSpacing.s
        case .large:
            return CTSpacing.m
        }
    }
    
    private var padding: EdgeInsets {
        switch size {
        case .small:
            return EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6)
        case .medium:
            return EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        case .large:
            return EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
        }
    }
    
    private var cornerRadius: CGFloat {
        switch size {
        case .small:
            return 4
        case .medium:
            return 6
        case .large:
            return 8
        }
    }
}

// MARK: - Previews

struct CTTag_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: CTSpacing.m) {
            // Tag Styles
            Group {
                Text("Tag Styles").ctHeading2()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        CTTag("Default")
                        CTTag("Primary", style: .primary)
                        CTTag("Secondary", style: .secondary)
                        CTTag("Success", style: .success)
                        CTTag("Warning", style: .warning)
                        CTTag("Error", style: .error)
                    }
                }
            }
            
            // Tag Sizes
            Group {
                Text("Tag Sizes").ctHeading2()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        CTTag("Small", size: .small)
                        CTTag("Medium", size: .medium)
                        CTTag("Large", size: .large)
                    }
                }
            }
            
            // Tag with Icons
            Group {
                Text("Tags with Icons").ctHeading2()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        CTTag("Design", icon: "pencil")
                        CTTag("Important", icon: "star.fill", style: .primary)
                        CTTag("Urgent", icon: "exclamationmark.triangle.fill", style: .error)
                    }
                }
            }
            
            // Removable Tags
            Group {
                Text("Removable Tags").ctHeading2()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        CTTag("Remove Me", isRemovable: true) { print("Tag removed") }
                        CTTag("Alert", icon: "bell.fill", style: .warning, isRemovable: true) { }
                        CTTag("Pinned", icon: "pin.fill", style: .primary, isRemovable: true) { }
                    }
                }
            }
            
            // Custom Tag
            Group {
                Text("Custom Tag").ctHeading2()
                
                CTTag("Custom", 
                      style: .custom(
                        backgroundColor: Color.purple.opacity(0.1),
                        foregroundColor: Color.purple
                      )
                )
            }
        }
        .padding()
    }
}
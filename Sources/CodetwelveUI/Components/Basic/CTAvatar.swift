//
//  CTAvatar.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable avatar component for displaying user profile images.
///
/// `CTAvatar` provides a consistent avatar interface throughout your application
/// with support for different sizes, shapes, and fallback display options when an image is unavailable.
///
/// # Example
///
/// ```swift
/// // With an image
/// CTAvatar(image: Image("profile"))
///
/// // With initials
/// CTAvatar(initials: "JD", backgroundColor: .ctPrimary)
///
/// // With an SF Symbol
/// CTAvatar(icon: "person.fill")
/// ```
public struct CTAvatar: View {
    // MARK: - Public Properties
    
    /// The shape of the avatar.
    public enum Shape {
        /// Circle shape
        case circle
        
        /// Rounded rectangle shape
        case rounded(cornerRadius: CGFloat)
        
        /// Square shape
        case square
    }
    
    /// The size of the avatar.
    public enum Size {
        /// Extra small avatar (24x24)
        case extraSmall
        
        /// Small avatar (32x32)
        case small
        
        /// Medium avatar (48x48)
        case medium
        
        /// Large avatar (64x64)
        case large
        
        /// Extra large avatar (96x96)
        case extraLarge
        
        /// Custom size
        case custom(CGFloat)
        
        /// The dimension in points
        var dimension: CGFloat {
            switch self {
            case .extraSmall:
                return 24
            case .small:
                return 32
            case .medium:
                return 48
            case .large:
                return 64
            case .extraLarge:
                return 96
            case .custom(let size):
                return size
            }
        }
        
        /// The font size for text or icons
        var fontSize: CGFloat {
            switch self {
            case .extraSmall:
                return 12
            case .small:
                return 14
            case .medium:
                return 18
            case .large:
                return 24
            case .extraLarge:
                return 36
            case .custom(let size):
                return size * 0.4
            }
        }
    }
    
    // MARK: - Private Properties
    
    /// The image to display in the avatar
    private let image: Image?
    
    /// The initials to display when no image is available
    private let initials: String?
    
    /// The icon to display when no image or initials are available
    private let icon: String?
    
    /// The size of the avatar
    private let size: Size
    
    /// The shape of the avatar
    private let shape: Shape
    
    /// The background color when displaying initials or an icon
    private let backgroundColor: Color
    
    /// The border width around the avatar
    private let borderWidth: CGFloat
    
    /// The border color around the avatar
    private let borderColor: Color?
    
    /// Whether to include a status indicator
    private let showStatus: Bool
    
    /// The color of the status indicator
    private let statusColor: Color
    
    /// Whether the avatar is interactive (e.g., can be tapped)
    private let isInteractive: Bool
    
    /// Action to perform when the avatar is tapped
    private let action: (() -> Void)?
    
    /// The theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize with an image
    /// - Parameters:
    ///   - image: The image to display
    ///   - size: The size of the avatar
    ///   - shape: The shape of the avatar
    ///   - borderWidth: The width of the border
    ///   - borderColor: The color of the border
    ///   - showStatus: Whether to show a status indicator
    ///   - statusColor: The color of the status indicator
    ///   - isInteractive: Whether the avatar is interactive
    ///   - action: Action to perform when tapped
    public init(
        image: Image,
        size: Size = .medium,
        shape: Shape = .circle,
        borderWidth: CGFloat = 0,
        borderColor: Color? = nil,
        showStatus: Bool = false,
        statusColor: Color = .ctSuccess,
        isInteractive: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.image = image
        self.initials = nil
        self.icon = nil
        self.size = size
        self.shape = shape
        self.backgroundColor = .clear
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.showStatus = showStatus
        self.statusColor = statusColor
        self.isInteractive = isInteractive
        self.action = action
    }
    
    /// Initialize with initials
    /// - Parameters:
    ///   - initials: The initials to display
    ///   - size: The size of the avatar
    ///   - shape: The shape of the avatar
    ///   - backgroundColor: The background color
    ///   - borderWidth: The width of the border
    ///   - borderColor: The color of the border
    ///   - showStatus: Whether to show a status indicator
    ///   - statusColor: The color of the status indicator
    ///   - isInteractive: Whether the avatar is interactive
    ///   - action: Action to perform when tapped
    public init(
        initials: String,
        size: Size = .medium,
        shape: Shape = .circle,
        backgroundColor: Color? = nil,
        borderWidth: CGFloat = 0,
        borderColor: Color? = nil,
        showStatus: Bool = false,
        statusColor: Color = .ctSuccess,
        isInteractive: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.image = nil
        self.initials = initials.prefix(2).uppercased()
        self.icon = nil
        self.size = size
        self.shape = shape
        self.backgroundColor = backgroundColor ?? .ctPrimary
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.showStatus = showStatus
        self.statusColor = statusColor
        self.isInteractive = isInteractive
        self.action = action
    }
    
    /// Initialize with an icon
    /// - Parameters:
    ///   - icon: The SF Symbol name
    ///   - size: The size of the avatar
    ///   - shape: The shape of the avatar
    ///   - backgroundColor: The background color
    ///   - borderWidth: The width of the border
    ///   - borderColor: The color of the border
    ///   - showStatus: Whether to show a status indicator
    ///   - statusColor: The color of the status indicator
    ///   - isInteractive: Whether the avatar is interactive
    ///   - action: Action to perform when tapped
    public init(
        icon: String,
        size: Size = .medium,
        shape: Shape = .circle,
        backgroundColor: Color? = nil,
        borderWidth: CGFloat = 0,
        borderColor: Color? = nil,
        showStatus: Bool = false,
        statusColor: Color = .ctSuccess,
        isInteractive: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.image = nil
        self.initials = nil
        self.icon = icon
        self.size = size
        self.shape = shape
        self.backgroundColor = backgroundColor ?? .ctSecondary
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.showStatus = showStatus
        self.statusColor = statusColor
        self.isInteractive = isInteractive
        self.action = action
    }
    
    // MARK: - Body
    
    public var body: some View {
        Button(action: {
            if isInteractive {
                action?()
            }
        }) {
            ZStack {
                // Container with background
                Group {
                    if let image = image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else {
                        Rectangle()
                            .fill(backgroundColor)
                    }
                }
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(avatarShape)
                .overlay(
                    avatarShape
                        .stroke(
                            borderColor ?? theme.border,
                            lineWidth: borderWidth
                        )
                )
                
                // Initials or icon
                if image == nil {
                    if let initials = initials {
                        Text(initials)
                            .font(.system(size: size.fontSize, weight: .medium))
                            .foregroundColor(.white)
                    } else if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: size.fontSize))
                            .foregroundColor(.white)
                    }
                }
                
                // Status indicator
                if showStatus {
                    Circle()
                        .fill(statusColor)
                        .frame(width: statusIndicatorSize, height: statusIndicatorSize)
                        .overlay(
                            Circle()
                                .stroke(theme.background, lineWidth: 2)
                        )
                        .position(x: size.dimension - statusIndicatorSize/2,
                                  y: size.dimension - statusIndicatorSize/2)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isInteractive)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(isInteractive ? [.isButton, .isImage] : [.isImage])
    }
    
    // MARK: - Private Computed Properties
    
    /// The shape of the avatar
    private var avatarShape: AnyShape {
        switch shape {
        case .circle:
            return AnyShape(Circle())
        case .rounded(let cornerRadius):
            return AnyShape(RoundedRectangle(cornerRadius: cornerRadius))
        case .square:
            return AnyShape(Rectangle())
        }
    }
    
    /// The size of the status indicator
    private var statusIndicatorSize: CGFloat {
        return size.dimension * 0.3
    }
    
    /// The accessibility label for the avatar
    private var accessibilityLabel: String {
        if let initials = initials {
            return "Avatar with initials \(initials)"
        } else if image != nil {
            return "Profile avatar"
        } else {
            return "Avatar icon"
        }
    }
}

// MARK: - Previews

struct CTAvatar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(spacing: CTSpacing.m) {
                Text("Avatar Sizes").ctHeading2()
                
                HStack(spacing: CTSpacing.m) {
                    CTAvatar(initials: "XS", size: .extraSmall)
                    CTAvatar(initials: "SM", size: .small)
                    CTAvatar(initials: "MD", size: .medium)
                    CTAvatar(initials: "LG", size: .large)
                    CTAvatar(initials: "XL", size: .extraLarge)
                }
            }
            .padding()
            .previewDisplayName("Avatar Sizes")
            
            VStack(spacing: CTSpacing.m) {
                Text("Avatar Shapes").ctHeading2()
                
                HStack(spacing: CTSpacing.m) {
                    CTAvatar(initials: "CI", shape: .circle)
                    CTAvatar(initials: "RO", shape: .rounded(cornerRadius: 8))
                    CTAvatar(initials: "SQ", shape: .square)
                }
            }
            .padding()
            .previewDisplayName("Avatar Shapes")
            
            VStack(spacing: CTSpacing.m) {
                Text("Avatar Types").ctHeading2()
                
                HStack(spacing: CTSpacing.m) {
                    // Using SF Symbols as placeholder images
                    CTAvatar(image: Image(systemName: "person.fill"))
                    CTAvatar(initials: "JD")
                    CTAvatar(icon: "person.crop.circle.fill")
                }
            }
            .padding()
            .previewDisplayName("Avatar Types")
            
            VStack(spacing: CTSpacing.m) {
                Text("Avatar Variants").ctHeading2()
                
                HStack(spacing: CTSpacing.m) {
                    CTAvatar(
                        initials: "BD",
                        borderWidth: 2,
                        borderColor: .ctPrimary
                    )
                    
                    CTAvatar(
                        initials: "ST",
                        showStatus: true
                    )
                    
                    CTAvatar(
                        initials: "ON",
                        showStatus: true,
                        statusColor: .ctSuccess
                    )
                    
                    CTAvatar(
                        initials: "OF",
                        showStatus: true,
                        statusColor: .ctSecondary
                    )
                }
            }
            .padding()
            .previewDisplayName("Avatar Variants")
            
            VStack(spacing: CTSpacing.m) {
                Text("Interactive Avatar").ctHeading2()
                
                CTAvatar(
                    initials: "TA",
                    backgroundColor: .ctPrimary,
                    isInteractive: true
                ) {
                    print("Avatar tapped")
                }
            }
            .padding()
            .previewDisplayName("Interactive Avatar")
        }
    }
}
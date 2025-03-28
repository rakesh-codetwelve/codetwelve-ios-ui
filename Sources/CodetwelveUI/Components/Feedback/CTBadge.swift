//
//  CTBadge.swift
//  CodetwelveUI
//
//  Created on 28/03/25.
//

import SwiftUI
import Combine

/// A badge component for displaying short, important information.
///
/// `CTBadge` provides a simple way to display notifications, counts, or status indicators.
/// It supports different sizes, styles, and customization options.
///
/// # Example
///
/// ```swift
/// // Basic badge with a number
/// CTBadge(3)
///
/// // Badge with text
/// CTBadge("New")
///
/// // Badge with custom style
/// CTBadge("Premium", style: .success)
///
/// // Badge with custom appearance
/// CTBadge(5, size: .medium, style: .custom(backgroundColor: .purple, textColor: .white))
/// ```
public struct CTBadge: View {
    // MARK: - Public Properties
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Private Properties
    
    /// The content to display in the badge (can be a number or text)
    private let content: BadgeContent
    
    /// The size of the badge
    private let size: CTBadgeSize
    
    /// The style of the badge
    private let style: CTBadgeStyle
    
    /// Whether to use a circular shape for the badge
    private let isCircular: Bool
    
    /// Whether the badge should be pulsing to attract attention
    private let isPulsing: Bool
    
    /// Custom padding for the badge
    private let padding: EdgeInsets?
    
    /// Animation state for pulsing effect
    @State private var isPulsed: Bool = false
    
    // MARK: - Initializers
    
    /// Initialize a badge with an integer value
    /// - Parameters:
    ///   - value: The integer value to display
    ///   - size: The size of the badge
    ///   - style: The style of the badge
    ///   - isCircular: Whether to use a circular shape
    ///   - isPulsing: Whether the badge should pulse to attract attention
    ///   - padding: Custom padding override (optional)
    public init(
        _ value: Int,
        size: CTBadgeSize = .small,
        style: CTBadgeStyle = .primary,
        isCircular: Bool = true,
        isPulsing: Bool = false,
        padding: EdgeInsets? = nil
    ) {
        self.content = .number(value)
        self.size = size
        self.style = style
        self.isCircular = isCircular
        self.isPulsing = isPulsing
        self.padding = padding
    }
    
    /// Initialize a badge with a text string
    /// - Parameters:
    ///   - text: The text to display
    ///   - size: The size of the badge
    ///   - style: The style of the badge
    ///   - isCircular: Whether to use a circular shape
    ///   - isPulsing: Whether the badge should pulse to attract attention
    ///   - padding: Custom padding override (optional)
    public init(
        _ text: String,
        size: CTBadgeSize = .small,
        style: CTBadgeStyle = .primary,
        isCircular: Bool = false,
        isPulsing: Bool = false,
        padding: EdgeInsets? = nil
    ) {
        self.content = .text(text)
        self.size = size
        self.style = style
        self.isCircular = isCircular
        self.isPulsing = isPulsing
        self.padding = padding
    }
    
    // MARK: - Body
    
    public var body: some View {
        contentView
            .padding(padding ?? size.padding)
            .font(size.font)
            .foregroundColor(style.textColor(for: theme))
            .background(style.backgroundColor(for: theme))
            .clipShape(shape)
            .scaleEffect(isPulsed ? 1.1 : 1.0)
            .ctAnimation(CTAnimation.attention, value: isPulsed)
            .onAppear {
                if isPulsing {
                    startPulsing()
                }
            }
            .ctBadgeAccessibility(label: accessibilityLabel)
    }
    
    // MARK: - Private Views
    
    /// The content view for the badge
    private var contentView: some View {
        Group {
            switch content {
            case .number(let value):
                Text("\(value)")
            case .text(let text):
                Text(text)
            }
        }
    }
    
    /// The shape of the badge
    private var shape: some Shape {
        if isCircular {
            return AnyShape(Circle())
        } else {
            return AnyShape(RoundedRectangle(cornerRadius: theme.borderRadius))
        }
    }
    
    // MARK: - Private Methods
    
    /// Start the pulsing animation if enabled
    private func startPulsing() {
        // Set up repeating pulse animation
        Timer.publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                withAnimation {
                    isPulsed = true
                }
                
                // Reset after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation {
                        isPulsed = false
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    /// Get the accessibility label based on badge content
    private var accessibilityLabel: String {
        switch content {
        case .number(let value):
            return "\(value) notification\(value == 1 ? "" : "s")"
        case .text(let text):
            return text
        }
    }
    
    // MARK: - Private Properties
    
    /// Cancellables storage for animation timers
    @State private var cancellables = Set<AnyCancellable>()
}

// MARK: - Supporting Types

/// The content of a badge
private enum BadgeContent {
    /// A numeric value
    case number(Int)
    
    /// A text string
    case text(String)
}

/// The size of the badge
public enum CTBadgeSize {
    /// Small badge for subtle indicators
    case small
    
    /// Medium badge for standard use
    case medium
    
    /// Large badge for emphasis
    case large
    
    /// The padding for the badge based on its size
    var padding: EdgeInsets {
        switch self {
        case .small:
            return CTSpacing.symmetrical(horizontal: CTSpacing.xs, vertical: CTSpacing.xxs)
        case .medium:
            return CTSpacing.symmetrical(horizontal: CTSpacing.s, vertical: CTSpacing.xs)
        case .large:
            return CTSpacing.symmetrical(horizontal: CTSpacing.m, vertical: CTSpacing.s)
        }
    }
    
    /// The font for the badge based on its size
    var font: Font {
        switch self {
        case .small:
            return CTTypography.captionSmall()
        case .medium:
            return CTTypography.caption()
        case .large:
            return CTTypography.bodySmall()
        }
    }
    
    /// Minimum size for circular badges
    var minSize: CGFloat? {
        switch self {
        case .small:
            return 18
        case .medium:
            return 24
        case .large:
            return 32
        }
    }
}

/// The style of the badge
public enum CTBadgeStyle {
    /// Primary style, using the theme's primary color
    case primary
    
    /// Secondary style, using the theme's secondary color
    case secondary
    
    /// Success style, typically green
    case success
    
    /// Warning style, typically orange or yellow
    case warning
    
    /// Error style, typically red
    case error
    
    /// Info style, typically blue
    case info
    
    /// Custom style with specified colors
    case custom(backgroundColor: Color, textColor: Color)
    
    /// Get the background color for this style
    /// - Parameter theme: The current theme
    /// - Returns: The background color
    func backgroundColor(for theme: CTTheme) -> Color {
        switch self {
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
        case .info:
            return theme.info
        case .custom(let backgroundColor, _):
            return backgroundColor
        }
    }
    
    /// Get the text color for this style
    /// - Parameter theme: The current theme
    /// - Returns: The text color
    func textColor(for theme: CTTheme) -> Color {
        switch self {
        case .primary, .secondary, .success, .warning, .error, .info:
            return theme.textOnAccent
        case .custom(_, let textColor):
            return textColor
        }
    }
}

// MARK: - Accessibility Extension

extension View {
    /// Apply standard accessibility modifiers for a badge
    ///
    /// - Parameter label: The accessibility label
    /// - Returns: The view with accessibility modifiers applied
    func ctBadgeAccessibility(label: String) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityAddTraits(.isStaticText)
    }
}

// MARK: - Shape Helpers

/// A type-erased shape
struct AnyShape: Shape {
    private let _path: (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        _path = shape.path(in:)
    }
    
    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}

// MARK: - Previews

struct CTBadge_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(spacing: CTSpacing.m) {
                Text("Numeric Badges").ctHeading2()
                
                HStack(spacing: CTSpacing.m) {
                    CTBadge(1)
                    CTBadge(12)
                    CTBadge(99)
                    CTBadge(999, size: .medium)
                }
                
                Text("Text Badges").ctHeading2()
                
                HStack(spacing: CTSpacing.m) {
                    CTBadge("New")
                    CTBadge("Premium", size: .medium)
                    CTBadge("Featured", size: .large)
                }
                
                Text("Badge Styles").ctHeading2()
                
                HStack(spacing: CTSpacing.m) {
                    CTBadge("Primary", style: .primary)
                    CTBadge("Secondary", style: .secondary)
                    CTBadge("Success", style: .success)
                    CTBadge("Warning", style: .warning)
                    CTBadge("Error", style: .error)
                    CTBadge("Info", style: .info)
                }
                
                Text("Custom Badge").ctHeading2()
                
                CTBadge("Custom", style: .custom(backgroundColor: .purple, textColor: .white))
                
                Text("Pulsing Badge").ctHeading2()
                
                CTBadge(5, isPulsing: true)
                
                Text("Usage Examples").ctHeading2()
                
                HStack {
                    Text("Inbox")
                    Spacer()
                    CTBadge(12)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "bell")
                        Text("Notifications")
                    }
                }
                .overlay(
                    CTBadge(3, isCircular: true)
                        .offset(x: 10, y: -10),
                    alignment: .topTrailing
                )
            }
            .padding()
            .previewLayout(.sizeThatFits)
            
            // Dark mode preview
            VStack(spacing: CTSpacing.m) {
                Text("Dark Mode Badges").ctHeading2()
                
                HStack(spacing: CTSpacing.m) {
                    CTBadge(1)
                    CTBadge("New")
                    CTBadge("Premium", style: .success)
                    CTBadge("Error", style: .error)
                }
            }
            .padding()
            .background(Color.black)
            .colorScheme(.dark)
            .previewLayout(.sizeThatFits)
        }
    }
} 
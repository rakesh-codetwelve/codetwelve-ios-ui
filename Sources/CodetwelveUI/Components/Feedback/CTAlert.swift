//
//  CTAlert.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable alert component for displaying important messages.
///
/// `CTAlert` provides a consistent alert interface throughout your application
/// with support for different severities (info, success, warning, error), icons,
/// and dismissal capabilities.
///
/// # Example
///
/// ```swift
/// // Basic alert
/// CTAlert(
///     title: "Information",
///     message: "Your profile has been updated.",
///     severity: .info
/// )
///
/// // Alert with custom content
/// CTAlert(severity: .warning) {
///     VStack(alignment: .leading, spacing: CTSpacing.s) {
///         Text("Custom Alert Content").font(.headline)
///         Text("You can add any content here").font(.body)
///     }
/// }
///
/// // Dismissible alert
/// CTAlert(
///     message: "This alert can be dismissed",
///     severity: .success,
///     isDismissible: true,
///     onDismiss: {
///         print("Alert dismissed")
///     }
/// )
/// ```
public struct CTAlert<Content: View>: View {
    // MARK: - Private Properties
    
    /// The title of the alert (optional)
    private let title: String?
    
    /// The message of the alert (optional)
    private let message: String?
    
    /// The severity of the alert
    private let severity: CTAlertSeverity
    
    /// Whether the alert can be dismissed
    private let isDismissible: Bool
    
    /// Action to perform when the alert is dismissed
    private let onDismiss: (() -> Void)?
    
    /// Custom content for the alert
    private let content: Content?
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a new alert with a title and message
    /// - Parameters:
    ///   - title: The title of the alert (optional)
    ///   - message: The message content of the alert
    ///   - severity: The severity of the alert
    ///   - isDismissible: Whether the alert can be dismissed
    ///   - onDismiss: Action to perform when the alert is dismissed
    public init(
        title: String? = nil,
        message: String,
        severity: CTAlertSeverity = .info,
        isDismissible: Bool = false,
        onDismiss: (() -> Void)? = nil
    ) where Content == EmptyView {
        self.title = title
        self.message = message
        self.severity = severity
        self.isDismissible = isDismissible
        self.onDismiss = onDismiss
        self.content = nil
    }
    
    /// Initialize a new alert with custom content
    /// - Parameters:
    ///   - title: The title of the alert (optional)
    ///   - severity: The severity of the alert
    ///   - isDismissible: Whether the alert can be dismissed
    ///   - onDismiss: Action to perform when the alert is dismissed
    ///   - content: Custom content builder for the alert
    public init(
        title: String? = nil,
        severity: CTAlertSeverity = .info,
        isDismissible: Bool = false,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.message = nil
        self.severity = severity
        self.isDismissible = isDismissible
        self.onDismiss = onDismiss
        self.content = content()
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: CTSpacing.s) {
            HStack(alignment: .center, spacing: CTSpacing.s) {
                // Icon
                severity.icon
                    .foregroundColor(iconColor)
                    .imageScale(.large)
                
                // Title (if provided)
                if let title = title {
                    Text(title)
                        .ctButtonSmall()
                        .foregroundColor(textColor)
                }
                
                Spacer()
                
                // Dismiss button (if dismissible)
                if isDismissible {
                    Button(action: {
                        onDismiss?()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(textColor.opacity(0.7))
                            .imageScale(.small)
                            .padding(CTSpacing.xs)
                    }
                    .accessibilityLabel("Dismiss alert")
                }
            }
            
            // Content (either message or custom content)
            if let message = message {
                Text(message)
                    .ctBody()
                    .foregroundColor(textColor)
            } else if let content = content {
                content
            }
        }
        .padding(CTSpacing.m)
        .background(backgroundColor)
        .cornerRadius(theme.borderRadius)
        .overlay(
            RoundedRectangle(cornerRadius: theme.borderRadius)
                .stroke(borderColor, lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(.isStaticText)
    }
    
    // MARK: - Private Properties
    
    /// The background color for the alert
    private var backgroundColor: Color {
        switch severity {
        case .info:
            return theme.info.opacity(0.1)
        case .success:
            return theme.success.opacity(0.1)
        case .warning:
            return theme.warning.opacity(0.1)
        case .error:
            return theme.destructive.opacity(0.1)
        case .custom(_, let backgroundColor, _):
            return backgroundColor
        }
    }
    
    /// The border color for the alert
    private var borderColor: Color {
        switch severity {
        case .info:
            return theme.info.opacity(0.3)
        case .success:
            return theme.success.opacity(0.3)
        case .warning:
            return theme.warning.opacity(0.3)
        case .error:
            return theme.destructive.opacity(0.3)
        case .custom(_, _, let borderColor):
            return borderColor
        }
    }
    
    /// The icon color for the alert
    private var iconColor: Color {
        switch severity {
        case .info:
            return theme.info
        case .success:
            return theme.success
        case .warning:
            return theme.warning
        case .error:
            return theme.destructive
        case .custom(_, let iconColor, _):
            return iconColor
        }
    }
    
    /// The text color for the alert
    private var textColor: Color {
        return theme.text
    }
    
    /// The accessibility label for the alert
    private var accessibilityLabel: String {
        var label = "\(severity.accessibilityLabel) alert"
        
        if let title = title {
            label += ": \(title)"
        }
        
        if let message = message {
            label += title != nil ? ", \(message)" : ": \(message)"
        }
        
        return label
    }
}

// MARK: - Supporting Types

/// The severity of an alert
public enum CTAlertSeverity: Hashable {
    /// Informational alert (typically blue)
    case info
    
    /// Success alert (typically green)
    case success
    
    /// Warning alert (typically orange/yellow)
    case warning
    
    /// Error alert (typically red)
    case error
    
    /// Custom alert with specific icon, background color, and border color
    case custom(icon: Image, iconColor: Color, borderColor: Color)
    
    /// The icon for the alert severity
    var icon: Image {
        switch self {
        case .info:
            return Image(systemName: "info.circle.fill")
        case .success:
            return Image(systemName: "checkmark.circle.fill")
        case .warning:
            return Image(systemName: "exclamationmark.triangle.fill")
        case .error:
            return Image(systemName: "xmark.circle.fill")
        case .custom(let icon, _, _):
            return icon
        }
    }
    
    /// The accessibility label for the alert severity
    var accessibilityLabel: String {
        switch self {
        case .info:
            return "Information"
        case .success:
            return "Success"
        case .warning:
            return "Warning"
        case .error:
            return "Error"
        case .custom:
            return "Custom"
        }
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .info:
            hasher.combine(0)
        case .success:
            hasher.combine(1)
        case .warning:
            hasher.combine(2)
        case .error:
            hasher.combine(3)
        case .custom(_, let iconColor, let borderColor):
            hasher.combine(4)
            hasher.combine(iconColor)
            hasher.combine(borderColor)
        }
    }
    
    public static func == (lhs: CTAlertSeverity, rhs: CTAlertSeverity) -> Bool {
        switch (lhs, rhs) {
        case (.info, .info),
             (.success, .success),
             (.warning, .warning),
             (.error, .error):
            return true
        case (.custom(_, let lhsIconColor, let lhsBorderColor),
              .custom(_, let rhsIconColor, let rhsBorderColor)):
            return lhsIconColor == rhsIconColor && lhsBorderColor == rhsBorderColor
        default:
            return false
        }
    }
}

// MARK: - Previews

struct CTAlert_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: CTSpacing.m) {
                Group {
                    Text("Alert Severities").ctHeading2()
                    
                    CTAlert(
                        title: "Information",
                        message: "This is an informational alert.",
                        severity: .info
                    )
                    
                    CTAlert(
                        title: "Success",
                        message: "This is a success alert.",
                        severity: .success
                    )
                    
                    CTAlert(
                        title: "Warning",
                        message: "This is a warning alert.",
                        severity: .warning
                    )
                    
                    CTAlert(
                        title: "Error",
                        message: "This is an error alert.",
                        severity: .error
                    )
                    
                    CTAlert(
                        title: "Custom",
                        message: "This is a custom alert.",
                        severity: .custom(
                            icon: Image(systemName: "star.fill"),
                            iconColor: .purple,
                            borderColor: .purple.opacity(0.3)
                        )
                    )
                }
                
                Group {
                    Text("Alert Variants").ctHeading2()
                    
                    CTAlert(
                        message: "This is an alert without a title.",
                        severity: .info
                    )
                    
                    CTAlert(
                        title: "Dismissible Alert",
                        message: "This alert can be dismissed.",
                        severity: .success,
                        isDismissible: true
                    )
                    
                    CTAlert(
                        title: "Long Content",
                        message: "This alert has a long message that will wrap to multiple lines. It demonstrates how the alert handles longer content while maintaining readability and proper layout.",
                        severity: .warning
                    )
                    
                    CTAlert(severity: .info) {
                        VStack(alignment: .leading, spacing: CTSpacing.s) {
                            Text("Custom Content").ctBodyBold()
                            Text("This alert uses custom content instead of a simple message.").ctBody()
                            HStack {
                                Image(systemName: "hand.thumbsup.fill")
                                Text("You can add any SwiftUI views here!").ctBody()
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}
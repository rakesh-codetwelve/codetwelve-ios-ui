//
//  CTToast.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI
import Combine

/// A toast notification component for displaying temporary messages.
///
/// `CTToast` provides a consistent toast notification interface throughout your application
/// with support for different types (success, error, warning, info), auto-dismissal,
/// and animation.
///
/// This component is typically used through the `CTToastManager` which handles
/// the display, queueing and dismissal of toasts.
///
/// # Example
///
/// ```swift
/// // Show a success toast
/// CTToastManager.shared.show(
///     message: "Profile updated successfully",
///     type: .success
/// )
///
/// // Show an error toast with longer duration
/// CTToastManager.shared.show(
///     message: "Failed to save changes",
///     type: .error,
///     duration: 5.0
/// )
/// ```
public struct CTToast: View {
    // MARK: - Private Properties
    
    /// The message to display in the toast
    private let message: String
    
    /// The type of toast (success, error, warning, info)
    private let type: CTToastType
    
    /// The duration (in seconds) to display the toast before auto-dismissing
    private let duration: Double
    
    /// Whether to show a close button
    private let hasCloseButton: Bool
    
    /// Whether the toast is currently showing
    @Binding private var isShowing: Bool
    
    /// The action to perform when the toast is dismissed
    private let onDismiss: (() -> Void)?
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    /// Controls the animation for showing and hiding the toast
    @State private var animationAmount: CGFloat = 0
    
    /// Timer for auto-dismissal
    @State private var timer: Timer? = nil
    
    // MARK: - Initializers
    
    /// Initialize a new toast notification
    /// - Parameters:
    ///   - message: The message to display
    ///   - type: The type of toast (success, error, warning, info)
    ///   - duration: The duration to display the toast before auto-dismissing (in seconds)
    ///   - hasCloseButton: Whether to show a close button
    ///   - isShowing: Binding to control whether the toast is showing
    ///   - onDismiss: Action to perform when the toast is dismissed
    public init(
        message: String,
        type: CTToastType = .info,
        duration: Double = 3.0,
        hasCloseButton: Bool = true,
        isShowing: Binding<Bool>,
        onDismiss: (() -> Void)? = nil
    ) {
        self.message = message
        self.type = type
        self.duration = duration
        self.hasCloseButton = hasCloseButton
        self._isShowing = isShowing
        self.onDismiss = onDismiss
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack {
            Spacer()
            
            toastContent
                .padding(.horizontal, CTSpacing.m)
                .padding(.bottom, CTSpacing.l)
        }
        .ignoresSafeArea()
        .opacity(animationAmount)
        .animation(.easeInOut(duration: 0.3), value: animationAmount)
        .onChange(of: isShowing) { newValue in
            if newValue {
                showToast()
            } else {
                hideToast()
            }
        }
        .onAppear {
            if isShowing {
                showToast()
            }
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(type.accessibilityLabel) message: \(message)")
        .accessibilityAddTraits(accessibilityTraits)
    }
    
    // MARK: - Private Views
    
    /// The content of the toast
    private var toastContent: some View {
        HStack(alignment: .center, spacing: CTSpacing.s) {
            // Icon
            type.icon
                .foregroundColor(type.iconColor(for: theme))
            
            // Message
            Text(message)
                .font(CTTypography.body())
                .foregroundColor(textColor)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            // Close button
            if hasCloseButton {
                Button(action: dismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(textColor)
                        .padding(CTSpacing.xs)
                }
                .accessibilityLabel("Dismiss notification")
            }
        }
        .padding(CTSpacing.m)
        .background(backgroundColor)
        .cornerRadius(theme.borderRadius)
        .shadow(
            color: theme.shadowColor.opacity(0.15),
            radius: 10,
            x: 0,
            y: 5
        )
    }
    
    // MARK: - Private Properties
    
    /// The background color for the toast
    private var backgroundColor: Color {
        switch type {
        case .success, .error, .warning, .info:
            return type.backgroundColor(for: theme)
        case .custom(_, let backgroundColor, _):
            return backgroundColor
        }
    }
    
    /// The text color for the toast
    private var textColor: Color {
        switch type {
        case .success, .error, .warning, .info:
            return type.textColor(for: theme)
        case .custom(_, _, let textColor):
            return textColor
        }
    }
    
    // MARK: - Private Methods
    
    /// Show the toast with animation
    private func showToast() {
        // Start animation
        animationAmount = 1.0
        
        // Set up timer for auto-dismissal if duration > 0
        if duration > 0 {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
                dismiss()
            }
        }
        
        // Post accessibility announcement
        CTAccessibilityUtilities.announce(message)
    }
    
    /// Hide the toast with animation
    private func hideToast() {
        // Stop animation
        animationAmount = 0.0
        
        // Invalidate timer
        timer?.invalidate()
        timer = nil
    }
    
    /// Dismiss the toast
    private func dismiss() {
        isShowing = false
        onDismiss?()
    }
    
    private var accessibilityTraits: AccessibilityTraits {
        [.isButton]
    }
}

// MARK: - Supporting Types

/// The type of toast notification
public enum CTToastType: Hashable {
    /// Success toast (typically green)
    case success
    
    /// Error toast (typically red)
    case error
    
    /// Warning toast (typically orange/yellow)
    case warning
    
    /// Information toast (typically blue)
    case info
    
    /// Custom toast with specific icon, background color, and text color
    case custom(icon: Image, backgroundColor: Color, textColor: Color)
    
    /// Get the appropriate icon for the toast type
    var icon: Image {
        switch self {
        case .success:
            return Image(systemName: "checkmark.circle.fill")
        case .error:
            return Image(systemName: "exclamationmark.triangle.fill")
        case .warning:
            return Image(systemName: "exclamationmark.circle.fill")
        case .info:
            return Image(systemName: "info.circle.fill")
        case .custom(let icon, _, _):
            return icon
        }
    }
    
    /// Get the appropriate background color for the toast type
    /// - Parameter theme: The current theme
    /// - Returns: The background color
    func backgroundColor(for theme: CTTheme) -> Color {
        switch self {
        case .success:
            return theme.success.opacity(0.15)
        case .error:
            return theme.destructive.opacity(0.15)
        case .warning:
            return theme.warning.opacity(0.15)
        case .info:
            return theme.info.opacity(0.15)
        case .custom(_, let backgroundColor, _):
            return backgroundColor
        }
    }
    
    /// Get the appropriate icon color for the toast type
    /// - Parameter theme: The current theme
    /// - Returns: The icon color
    func iconColor(for theme: CTTheme) -> Color {
        switch self {
        case .success:
            return theme.success
        case .error:
            return theme.destructive
        case .warning:
            return theme.warning
        case .info:
            return theme.info
        case .custom(_, _, let textColor):
            return textColor
        }
    }
    
    /// Get the appropriate text color for the toast type
    /// - Parameter theme: The current theme
    /// - Returns: The text color
    func textColor(for theme: CTTheme) -> Color {
        switch self {
        case .success, .error, .warning, .info:
            return theme.text
        case .custom(_, _, let textColor):
            return textColor
        }
    }
    
    /// Get the accessibility label for the toast type
    var accessibilityLabel: String {
        switch self {
        case .success:
            return "Success"
        case .error:
            return "Error"
        case .warning:
            return "Warning"
        case .info:
            return "Information"
        case .custom:
            return "Notification"
        }
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .success:
            hasher.combine(0)
        case .error:
            hasher.combine(1)
        case .warning:
            hasher.combine(2)
        case .info:
            hasher.combine(3)
        case .custom:
            hasher.combine(4)
        }
    }
    
    public static func == (lhs: CTToastType, rhs: CTToastType) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success),
             (.error, .error),
             (.warning, .warning),
             (.info, .info),
             (.custom, .custom):
            return true
        default:
            return false
        }
    }
}

// MARK: - Toast Manager

/// Manager for handling toast notification display and queueing
public class CTToastManager: ObservableObject {
    /// Shared instance of the toast manager (singleton)
    public static let shared = CTToastManager()
    
    /// The current toast being displayed
    @Published private(set) var currentToast: ToastData?
    
    /// Queue of pending toasts
    private var queue: [ToastData] = []
    
    /// Whether a toast is currently being shown
    @Published private(set) var isShowingToast: Bool = false
    
    /// Initialize the toast manager
    private init() {}
    
    /// Show a toast notification
    /// - Parameters:
    ///   - message: The message to display
    ///   - type: The type of toast (success, error, warning, info)
    ///   - duration: The duration to display the toast (in seconds)
    ///   - hasCloseButton: Whether to show a close button
    public func show(
        message: String,
        type: CTToastType = .info,
        duration: Double = 3.0,
        hasCloseButton: Bool = true
    ) {
        let toast = ToastData(
            message: message,
            type: type,
            duration: duration,
            hasCloseButton: hasCloseButton
        )
        
        if isShowingToast {
            // If a toast is already showing, add this one to the queue
            queue.append(toast)
        } else {
            // Otherwise, show it immediately
            showToast(toast)
        }
    }
    
    /// Show a success toast notification
    /// - Parameters:
    ///   - message: The message to display
    ///   - duration: The duration to display the toast (in seconds)
    public func showSuccess(message: String, duration: Double = 3.0) {
        show(message: message, type: .success, duration: duration)
    }
    
    /// Show an error toast notification
    /// - Parameters:
    ///   - message: The message to display
    ///   - duration: The duration to display the toast (in seconds)
    public func showError(message: String, duration: Double = 3.0) {
        show(message: message, type: .error, duration: duration)
    }
    
    /// Show a warning toast notification
    /// - Parameters:
    ///   - message: The message to display
    ///   - duration: The duration to display the toast (in seconds)
    public func showWarning(message: String, duration: Double = 3.0) {
        show(message: message, type: .warning, duration: duration)
    }
    
    /// Show an info toast notification
    /// - Parameters:
    ///   - message: The message to display
    ///   - duration: The duration to display the toast (in seconds)
    public func showInfo(message: String, duration: Double = 3.0) {
        show(message: message, type: .info, duration: duration)
    }
    
    /// Clear all pending toasts
    public func clearAll() {
        queue.removeAll()
        dismissCurrentToast()
    }
    
    /// Show a toast
    /// - Parameter toast: The toast data to show
    private func showToast(_ toast: ToastData) {
        currentToast = toast
        isShowingToast = true
    }
    
    /// Dismiss the current toast
    private func dismissCurrentToast() {
        isShowingToast = false
        currentToast = nil
        
        // After a short delay to allow for animation, show the next toast if there is one
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let nextToast = self.queue.first {
                self.queue.removeFirst()
                self.showToast(nextToast)
            }
        }
    }
    
    /// Data for a toast notification
    struct ToastData: Identifiable {
        let id = UUID()
        let message: String
        let type: CTToastType
        let duration: Double
        let hasCloseButton: Bool
    }
}

// MARK: - Toast Container View

/// View that observes the toast manager and displays toasts when needed
public struct CTToastContainer: ViewModifier {
    @ObservedObject private var toastManager = CTToastManager.shared
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            if let toast = toastManager.currentToast {
                CTToast(
                    message: toast.message,
                    type: toast.type,
                    duration: toast.duration,
                    hasCloseButton: toast.hasCloseButton,
                    isShowing: Binding(
                        get: { self.toastManager.isShowingToast },
                        set: { _ in }
                    ),
                    onDismiss: {
                        // This will be called when the toast is dismissed
                        self.toastManager.clearAll()
                    }
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(100) // Make sure toast is above all other content
            }
        }
    }
}

// MARK: - View Extension for Toast

public extension View {
    /// Add toast notifications capability to a view
    ///
    /// This modifier should be applied to the root view of your application
    /// to enable toast notifications throughout the app.
    ///
    /// # Example
    ///
    /// ```swift
    /// @main
    /// struct MyApp: App {
    ///     var body: some Scene {
    ///         WindowGroup {
    ///             ContentView()
    ///                 .ctToastContainer()
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Returns: A view with toast notification capability
    func ctToastContainer() -> some View {
        modifier(CTToastContainer())
    }
}

// MARK: - Previews

struct CTToast_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PreviewToast(type: .success, message: "Profile updated successfully")
                .previewDisplayName("Success Toast")
            
            PreviewToast(type: .error, message: "Failed to save changes")
                .previewDisplayName("Error Toast")
            
            PreviewToast(type: .warning, message: "Your session will expire soon")
                .previewDisplayName("Warning Toast")
            
            PreviewToast(type: .info, message: "Pull to refresh for the latest updates")
                .previewDisplayName("Info Toast")
            
            PreviewToast(
                type: .custom(
                    icon: Image(systemName: "sparkles"),
                    backgroundColor: Color.purple.opacity(0.15),
                    textColor: Color.purple
                ),
                message: "Custom styled notification"
            )
            .previewDisplayName("Custom Toast")
            
            PreviewToast(
                type: .success,
                message: "This is a really long message that will wrap to multiple lines so we can see how the toast handles longer content and whether it remains readable and well-formatted."
            )
            .previewDisplayName("Long Message Toast")
            
            // Usage with manager demo
            ZStack {
                Color.gray.opacity(0.1).ignoresSafeArea()
                
                VStack(spacing: CTSpacing.m) {
                    Text("Toast Manager Demo")
                        .ctHeading2()
                    
                    Button("Show Success Toast") {
                        CTToastManager.shared.showSuccess(message: "Operation completed successfully")
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Show Error Toast") {
                        CTToastManager.shared.showError(message: "Something went wrong")
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Show Warning Toast") {
                        CTToastManager.shared.showWarning(message: "Battery is low")
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Show Info Toast") {
                        CTToastManager.shared.showInfo(message: "New update available")
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Show Multiple Toasts") {
                        CTToastManager.shared.showSuccess(message: "First toast")
                        CTToastManager.shared.showInfo(message: "Second toast")
                        CTToastManager.shared.showWarning(message: "Third toast")
                    }
                    .buttonStyle(.bordered)
                }
            }
            .ctToastContainer()
            .previewDisplayName("Toast Manager Demo")
        }
    }
    
    struct PreviewToast: View {
        let type: CTToastType
        let message: String
        @State private var isShowing = true
        
        var body: some View {
            ZStack {
                Color.gray.opacity(0.1).ignoresSafeArea()
                
                CTToast(
                    message: message,
                    type: type,
                    duration: 0, // No auto-dismiss in preview
                    isShowing: $isShowing
                )
            }
        }
    }
}
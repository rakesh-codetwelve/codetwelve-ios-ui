//
//  CTAlertDialog.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A modal dialog component for presenting alerts with actions.
///
/// `CTAlertDialog` provides a consistent dialog interface for showing important messages
/// and prompting user decisions. It supports customizable content, multiple actions,
/// and can be presented modally over any content.
///
/// # Example
///
/// ```swift
/// // Basic alert dialog
/// @State private var showDialog = false
///
/// Button("Show Dialog") {
///     showDialog = true
/// }
/// .ctAlertDialog(isPresented: $showDialog) {
///     CTAlertDialogContent(
///         title: "Confirm Action",
///         message: "Are you sure you want to proceed?",
///         primaryAction: CTAlertDialogAction(
///             label: "Confirm",
///             style: .primary,
///             action: {
///                 // Handle confirmation
///             }
///         ),
///         secondaryAction: CTAlertDialogAction(
///             label: "Cancel",
///             style: .secondary,
///             action: {
///                 // Handle cancellation
///             }
///         )
///     )
/// }
///
/// // With custom content
/// @State private var showCustomDialog = false
///
/// Button("Show Custom Dialog") {
///     showCustomDialog = true
/// }
/// .ctAlertDialog(isPresented: $showCustomDialog) {
///     CTAlertDialogContent(title: "Custom Dialog") {
///         VStack {
///             Image(systemName: "star.fill")
///                 .resizable()
///                 .frame(width: 100, height: 100)
///                 .foregroundColor(.yellow)
///             
///             Text("This is a custom dialog")
///                 .padding()
///         }
///         .frame(maxWidth: .infinity)
///     } primaryAction: {
///         CTAlertDialogAction(label: "OK")
///     }
/// }
/// ```
public struct CTAlertDialog<DialogContent: View>: ViewModifier {
    // MARK: - Private Properties
    
    /// Binding to control whether the dialog is presented
    @Binding private var isPresented: Bool
    
    /// The content of the dialog
    private let dialogContent: () -> DialogContent
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a new alert dialog
    /// - Parameters:
    ///   - isPresented: Binding to control whether the dialog is presented
    ///   - dialogContent: The content of the dialog
    public init(
        isPresented: Binding<Bool>,
        @ViewBuilder dialogContent: @escaping () -> DialogContent
    ) {
        self._isPresented = isPresented
        self.dialogContent = dialogContent
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        ZStack {
            // Original content
            content
            
            // Alert dialog overlay when presented
            if isPresented {
                GeometryReader { geometry in
                    ZStack {
                        // Semi-transparent background
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .transition(.opacity)
                            .onTapGesture {
                                // Optional: Close when tapping outside
                                // isPresented = false
                            }
                        
                        // Dialog content
                        dialogContent()
                            .background(theme.surface)
                            .cornerRadius(theme.borderRadius)
                            .shadow(
                                color: theme.shadowColor.opacity(theme.shadowOpacity),
                                radius: theme.shadowRadius,
                                x: theme.shadowOffset.width,
                                y: theme.shadowOffset.height
                            )
                            .frame(
                                width: min(geometry.size.width * 0.9, 400),
                                alignment: .center
                            )
                            .transition(.scale.combined(with: .opacity))
                    }
                    .animation(.easeInOut(duration: 0.2), value: isPresented)
                }
                .ignoresSafeArea()
                .accessibilityAddTraits(.isModal)
            }
        }
    }
}

/// Content for an alert dialog
public struct CTAlertDialogContent<CustomContent: View>: View {
    // MARK: - Private Properties
    
    /// The title of the dialog
    private let title: String
    
    /// The message of the dialog (optional)
    private let message: String?
    
    /// The custom content of the dialog (optional)
    private let customContent: CustomContent?
    
    /// The primary action of the dialog
    private let primaryAction: CTAlertDialogAction
    
    /// The secondary action of the dialog (optional)
    private let secondaryAction: CTAlertDialogAction?
    
    /// The destructive action of the dialog (optional)
    private let destructiveAction: CTAlertDialogAction?
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a new alert dialog content with a message
    /// - Parameters:
    ///   - title: The title of the dialog
    ///   - message: The message of the dialog
    ///   - primaryAction: The primary action of the dialog
    ///   - secondaryAction: The secondary action of the dialog (optional)
    ///   - destructiveAction: The destructive action of the dialog (optional)
    public init(
        title: String,
        message: String,
        primaryAction: CTAlertDialogAction,
        secondaryAction: CTAlertDialogAction? = nil,
        destructiveAction: CTAlertDialogAction? = nil
    ) where CustomContent == EmptyView {
        self.title = title
        self.message = message
        self.customContent = nil
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.destructiveAction = destructiveAction
    }
    
    /// Initialize a new alert dialog content with custom content
    /// - Parameters:
    ///   - title: The title of the dialog
    ///   - customContent: The custom content of the dialog
    ///   - primaryAction: The primary action of the dialog
    ///   - secondaryAction: The secondary action of the dialog (optional)
    ///   - destructiveAction: The destructive action of the dialog (optional)
    public init(
        title: String,
        @ViewBuilder customContent: () -> CustomContent,
        @ViewBuilder primaryAction: () -> CTAlertDialogAction,
        secondaryAction: CTAlertDialogAction? = nil,
        destructiveAction: CTAlertDialogAction? = nil
    ) {
        self.title = title
        self.message = nil
        self.customContent = customContent()
        self.primaryAction = primaryAction()
        self.secondaryAction = secondaryAction
        self.destructiveAction = destructiveAction
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .center, spacing: CTSpacing.m) {
            // Dialog header
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                // Title
                Text(title)
                    .ctHeading3()
                    .foregroundColor(theme.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Message or custom content
                if let message = message {
                    Text(message)
                        .ctBody()
                        .foregroundColor(theme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                } else if let customContent = customContent {
                    customContent
                }
            }
            .padding(CTSpacing.m)
            
            // Divider
            CTDivider()
            
            // Dialog actions
            HStack(alignment: .center, spacing: CTSpacing.s) {
                // Handle up to 3 actions (primary, secondary, destructive)
                if let destructiveAction = destructiveAction {
                    destructiveActionButton(destructiveAction)
                }
                
                if let secondaryAction = secondaryAction {
                    secondaryActionButton(secondaryAction)
                }
                
                primaryActionButton(primaryAction)
            }
            .padding(CTSpacing.m)
        }
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
    }
    
    // MARK: - Private Views
    
    /// Create a primary action button
    /// - Parameter action: The action configuration
    /// - Returns: A button view
    private func primaryActionButton(_ action: CTAlertDialogAction) -> some View {
        actionButton(action)
    }
    
    /// Create a secondary action button
    /// - Parameter action: The action configuration
    /// - Returns: A button view
    private func secondaryActionButton(_ action: CTAlertDialogAction) -> some View {
        actionButton(action)
    }
    
    /// Create a destructive action button
    /// - Parameter action: The action configuration
    /// - Returns: A button view
    private func destructiveActionButton(_ action: CTAlertDialogAction) -> some View {
        actionButton(action)
    }
    
    /// Create an action button with appropriate styling
    /// - Parameters:
    ///   - action: The action configuration
    /// - Returns: A button view
    private func actionButton(_ action: CTAlertDialogAction) -> some View {
        Button(action: action.handler) {
            Text(action.label)
                .frame(maxWidth: .infinity)
                .padding(.vertical, CTSpacing.s)
                .padding(.horizontal, CTSpacing.m)
                .background(theme.buttonBackgroundColor(for: action.style))
                .foregroundColor(theme.buttonForegroundColor(for: action.style))
                .cornerRadius(theme.borderRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: theme.borderRadius)
                        .stroke(theme.buttonBorderColor(for: action.style), lineWidth: action.style == .outline ? theme.borderWidth : 0)
                )
        }
        .buttonStyle(CTAlertDialogButtonStyle())
    }
}

/// Configuration for an alert dialog action
public struct CTAlertDialogAction {
    let label: String
    let style: CTButtonStyle
    let handler: () -> Void
    
    public init(
        label: String,
        style: CTButtonStyle = .primary,
        handler: @escaping () -> Void
    ) {
        self.label = label
        self.style = style
        self.handler = handler
    }
}

/// Custom button style for alert dialog actions
struct CTAlertDialogButtonStyle: SwiftUI.ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, CTSpacing.s)
            .padding(.horizontal, CTSpacing.m)
            .background(Color.ctPrimary)
            .foregroundColor(.white)
            .cornerRadius(CTSpacing.xs)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

// MARK: - View Extensions

public extension View {
    /// Apply an alert dialog to a view
    ///
    /// This modifier adds an alert dialog that can be presented over the content
    /// when the binding is true.
    ///
    /// # Example
    ///
    /// ```swift
    /// @State private var showDialog = false
    ///
    /// Button("Show Dialog") {
    ///     showDialog = true
    /// }
    /// .ctAlertDialog(isPresented: $showDialog) {
    ///     CTAlertDialogContent(
    ///         title: "Confirm Action",
    ///         message: "Are you sure you want to proceed?",
    ///         primaryAction: CTAlertDialogAction(label: "Confirm"),
    ///         secondaryAction: CTAlertDialogAction(label: "Cancel")
    ///     )
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: Binding to control whether the dialog is presented
    ///   - content: The content of the dialog
    /// - Returns: The view with the alert dialog modifier applied
    func ctAlertDialog<DialogContent: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> DialogContent
    ) -> some View {
        self.modifier(CTAlertDialog(isPresented: isPresented, dialogContent: content))
    }
}

// MARK: - Previews

struct CTAlertDialog_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer()
    }
    
    struct PreviewContainer: View {
        @State private var showBasicDialog = false
        @State private var showCustomDialog = false
        @State private var showComplexDialog = false
        
        var body: some View {
            ScrollView {
                VStack(spacing: CTSpacing.l) {
                    Text("Alert Dialog Examples").ctHeading2()
                    
                    // Basic Dialog
                    VStack {
                        Text("Basic Dialog").ctHeading3()
                        
                        CTButton("Show Basic Dialog", style: .primary) {
                            showBasicDialog = true
                        }
                    }
                    .padding()
                    .ctAlertDialog(isPresented: $showBasicDialog) {
                        CTAlertDialogContent(
                            title: "Confirm Action",
                            message: "Are you sure you want to proceed with this action? This cannot be undone.",
                            primaryAction: CTAlertDialogAction(
                                label: "Confirm",
                                style: .primary,
                                handler: {
                                    showBasicDialog = false
                                }
                            ),
                            secondaryAction: CTAlertDialogAction(
                                label: "Cancel",
                                style: .secondary,
                                handler: {
                                    showBasicDialog = false
                                }
                            )
                        )
                    }
                    
                    // Custom Content Dialog
                    VStack {
                        Text("Custom Content Dialog").ctHeading3()
                        
                        CTButton("Show Custom Dialog", style: .primary) {
                            showCustomDialog = true
                        }
                    }
                    .padding()
                    .ctAlertDialog(isPresented: $showCustomDialog) {
                        CTAlertDialogContent(
                            title: "Custom Dialog",
                            message: "This is a custom dialog with rich content.",
                            primaryAction: CTAlertDialogAction(
                                label: "Awesome!",
                                style: .primary,
                                handler: {
                                    showCustomDialog = false
                                }
                            )
                        )
                    }
                    
                    // Complex Dialog
                    VStack {
                        Text("Complex Dialog").ctHeading3()
                        
                        CTButton("Show Complex Dialog", style: .primary) {
                            showComplexDialog = true
                        }
                    }
                    .padding()
                    .ctAlertDialog(isPresented: $showComplexDialog) {
                        CTAlertDialogContent(
                            title: "Delete Account",
                            message: "Are you sure you want to delete your account? This action cannot be undone, and you will lose all your data.",
                            primaryAction: CTAlertDialogAction(
                                label: "Keep Account",
                                style: .primary,
                                handler: {
                                    showComplexDialog = false
                                }
                            ),
                            secondaryAction: CTAlertDialogAction(
                                label: "Cancel",
                                style: .secondary,
                                handler: {
                                    showComplexDialog = false
                                }
                            ),
                            destructiveAction: CTAlertDialogAction(
                                label: "Delete Account",
                                style: .destructive,
                                handler: {
                                    showComplexDialog = false
                                }
                            )
                        )
                    }
                }
                .padding()
            }
        }
    }
}
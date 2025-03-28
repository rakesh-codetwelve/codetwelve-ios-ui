//
//  CTSecureField.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A secure text field component for password entry with customizable styling and validation.
///
/// `CTSecureField` provides a consistent password entry field throughout your application
/// with built-in validation, error handling, and support for leading and trailing icons.
///
/// # Example
///
/// ```swift
/// @State private var password = ""
/// @State private var passwordError: String? = nil
///
/// CTSecureField(
///     "Password",
///     placeholder: "Enter your password",
///     text: $password,
///     error: $passwordError,
///     validation: { value in
///         if value.isEmpty {
///             return "Password is required"
///         } else if value.count < 8 {
///             return "Password must be at least 8 characters"
///         }
///         return nil
///     }
/// )
/// ```
public struct CTSecureField: View {
    // MARK: - Public Properties
    
    /// The current text value
    @Binding private var text: String
    
    /// The current error message, if any
    @Binding private var error: String?
    
    // MARK: - Private Properties
    
    private let label: String
    private let placeholder: String
    private let leadingIcon: String?
    private let trailingIcon: String?
    private let trailingAction: (() -> Void)?
    private let style: CTTextFieldStyle
    private let isDisabled: Bool
    private let isRequired: Bool
    private let autocapitalization: TextInputAutocapitalization
    private let autocorrection: Bool
    private let keyboardType: UIKeyboardType
    private let submitLabel: SubmitLabel
    private let validation: ((String) -> String?)?
    private let onSubmit: (() -> Void)?
    private let onEditingChanged: ((Bool) -> Void)?
    private let showPasswordToggle: Bool
    
    @State private var isFocused: Bool = false
    @State private var isEditing: Bool = false
    @State private var isPasswordVisible: Bool = false
    @FocusState private var focusState: Bool
    
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a secure text field component
    /// - Parameters:
    ///   - label: The label text displayed above the field
    ///   - placeholder: The placeholder text displayed when the field is empty
    ///   - text: Binding to the text value
    ///   - error: Binding to the error message, if any
    ///   - leadingIcon: Optional SF Symbol name for a leading icon
    ///   - trailingIcon: Optional SF Symbol name for a trailing icon
    ///   - trailingAction: Optional action to perform when the trailing icon is tapped
    ///   - style: The visual style of the text field
    ///   - isDisabled: Whether the text field is disabled
    ///   - isRequired: Whether the field is required
    ///   - autocapitalization: Text input autocapitalization type
    ///   - autocorrection: Whether autocorrection is enabled
    ///   - keyboardType: The keyboard type to use
    ///   - submitLabel: The label to display on the keyboard's return key
    ///   - showPasswordToggle: Whether to show a button to toggle password visibility
    ///   - validation: Optional validation function that returns an error message or nil
    ///   - onSubmit: Optional action to perform when the return key is pressed
    ///   - onEditingChanged: Optional action to perform when editing begins or ends
    public init(
        _ label: String,
        placeholder: String = "",
        text: Binding<String>,
        error: Binding<String?> = .constant(nil),
        leadingIcon: String? = nil,
        trailingIcon: String? = nil,
        trailingAction: (() -> Void)? = nil,
        style: CTTextFieldStyle = .default,
        isDisabled: Bool = false,
        isRequired: Bool = false,
        autocapitalization: TextInputAutocapitalization = .never,
        autocorrection: Bool = false,
        keyboardType: UIKeyboardType = .default,
        submitLabel: SubmitLabel = .done,
        showPasswordToggle: Bool = true,
        validation: ((String) -> String?)? = nil,
        onSubmit: (() -> Void)? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self._error = error
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.trailingAction = trailingAction
        self.style = style
        self.isDisabled = isDisabled
        self.isRequired = isRequired
        self.autocapitalization = autocapitalization
        self.autocorrection = autocorrection
        self.keyboardType = keyboardType
        self.submitLabel = submitLabel
        self.showPasswordToggle = showPasswordToggle
        self.validation = validation
        self.onSubmit = onSubmit
        self.onEditingChanged = onEditingChanged
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: CTSpacing.xs) {
            // Label
            if !label.isEmpty {
                HStack(spacing: CTSpacing.xxs) {
                    Text(label)
                        .font(CTTypography.caption())
                        .foregroundColor(textColor)
                    
                    if isRequired {
                        Text("*")
                            .font(CTTypography.caption())
                            .foregroundColor(theme.destructive)
                    }
                }
            }
            
            // Input field
            HStack(spacing: CTSpacing.xs) {
                // Leading icon
                if let leadingIcon = leadingIcon {
                    Image(systemName: leadingIcon)
                        .foregroundColor(iconColor)
                        .font(.system(size: 16))
                        .padding(.leading, CTSpacing.s)
                        .accessibilityHidden(true)
                }
                
                // Text field
                Group {
                    if isPasswordVisible {
                        TextField(
                            placeholder,
                            text: $text,
                            onEditingChanged: { isEditing in
                                self.isEditing = isEditing
                                self.onEditingChanged?(isEditing)
                                
                                if !isEditing, let validation = validation {
                                    error = validation(text)
                                }
                            },
                            onCommit: {
                                if let validation = validation {
                                    error = validation(text)
                                }
                                
                                onSubmit?()
                            }
                        )
                        .textInputAutocapitalization(autocapitalization)
                        .autocorrectionDisabled(!autocorrection)
                        .keyboardType(keyboardType)
                        .submitLabel(submitLabel)
                    } else {
                        SecureField(
                            placeholder,
                            text: $text,
                            onCommit: {
                                if let validation = validation {
                                    error = validation(text)
                                }
                                
                                onSubmit?()
                            }
                        )
                        .textInputAutocapitalization(autocapitalization)
                        .autocorrectionDisabled(!autocorrection)
                        .keyboardType(keyboardType)
                        .submitLabel(submitLabel)
                    }
                }
                .focused($focusState)
                .onChange(of: focusState) { newValue in
                    isFocused = newValue
                }
                .foregroundColor(textColor)
                .disabled(isDisabled)
                
                // Password visibility toggle
                if showPasswordToggle {
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(iconColor)
                            .font(.system(size: 16))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(isPasswordVisible ? "Hide password" : "Show password")
                }
                
                // Trailing icon or action
                if let trailingIcon = trailingIcon {
                    Button(action: {
                        trailingAction?()
                    }) {
                        Image(systemName: trailingIcon)
                            .foregroundColor(iconColor)
                            .font(.system(size: 16))
                    }
                    .buttonStyle(.plain)
                    .padding(.trailing, CTSpacing.s)
                    .disabled(trailingAction == nil)
                }
            }
            .padding(CTSpacing.s)
            .background(backgroundColor)
            .cornerRadius(style == .default ? 0 : theme.borderRadius)
            .overlay(
                RoundedRectangle(cornerRadius: style == .default ? 0 : theme.borderRadius)
                    .stroke(borderColor, lineWidth: theme.borderWidth)
            )
            
            // Error message
            if let error = error, !error.isEmpty {
                Text(error)
                    .font(CTTypography.captionSmall())
                    .foregroundColor(theme.destructive)
                    .padding(.top, 2)
                    .transition(.opacity)
            }
        }
        .ctInputAccessibility(label: label, value: text, hint: "Secure text field. \(isPasswordVisible ? "Password is visible" : "Password is hidden")")
        .ctRequiredFieldAccessibility(isRequired: isRequired)
        .animation(.easeInOut, value: error != nil)
    }
    
    // MARK: - Private Properties
    
    private var textColor: Color {
        if isDisabled {
            return theme.textSecondary
        } else {
            return theme.text
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .default, .underlined:
            return Color.clear
        case .filled:
            return isDisabled ? theme.background.opacity(0.5) : theme.background
        case .outlined:
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        if let error = error, !error.isEmpty {
            return theme.destructive
        } else if isFocused {
            return theme.primary
        } else {
            switch style {
            case .default:
                return Color.clear
            case .underlined:
                return isDisabled ? theme.border.opacity(0.5) : theme.border
            case .filled:
                return Color.clear
            case .outlined:
                return isDisabled ? theme.border.opacity(0.5) : theme.border
            }
        }
    }
    
    private var iconColor: Color {
        if isDisabled {
            return theme.textSecondary
        } else if let error = error, !error.isEmpty {
            return theme.destructive
        } else if isFocused {
            return theme.primary
        } else {
            return theme.textSecondary
        }
    }
    
    // MARK: - Public Methods
    
    /// Validates the current input value using the provided validation function
    /// - Returns: True if validation passes (or no validation function), false otherwise
    public func validate() -> Bool {
        guard let validation = validation else {
            return true
        }
        
        error = validation(text)
        return error == nil
    }
    
    /// Clears the current text value
    public func clear() {
        text = ""
        error = nil
    }
}

// MARK: - Preview

struct CTSecureField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: CTSpacing.m) {
            StatefulPreviewWrapper("") { password in
                CTSecureField(
                    "Password",
                    placeholder: "Enter your password",
                    text: password
                )
            }
            
            StatefulPreviewWrapper("password123") { password in
                StatefulPreviewWrapper("Password is too weak") { error in
                    CTSecureField(
                        "Password with Error",
                        placeholder: "Enter your password",
                        text: password,
                        error: error
                    )
                }
            }
            
            StatefulPreviewWrapper("") { password in
                CTSecureField(
                    "Password with Icons",
                    placeholder: "Enter your password",
                    text: password,
                    leadingIcon: "lock",
                    trailingIcon: "xmark.circle.fill",
                    trailingAction: {}
                )
            }
            
            StatefulPreviewWrapper("") { password in
                CTSecureField(
                    "Filled Style",
                    placeholder: "Enter your password",
                    text: password,
                    style: .filled
                )
            }
            
            StatefulPreviewWrapper("") { password in
                CTSecureField(
                    "Outlined Style",
                    placeholder: "Enter your password",
                    text: password,
                    style: .outlined
                )
            }
            
            StatefulPreviewWrapper("") { password in
                CTSecureField(
                    "Underlined Style",
                    placeholder: "Enter your password",
                    text: password,
                    style: .underlined
                )
            }
            
            StatefulPreviewWrapper("password123") { password in
                CTSecureField(
                    "Disabled State",
                    placeholder: "Enter your password",
                    text: password,
                    isDisabled: true
                )
            }
            
            StatefulPreviewWrapper("") { password in
                CTSecureField(
                    "Required Field",
                    placeholder: "Enter your password",
                    text: password,
                    isRequired: true
                )
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
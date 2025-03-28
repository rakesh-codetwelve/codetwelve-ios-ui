//
//  CTTextField.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI
import Combine

/// A customizable text field component with validation and various states.
///
/// `CTTextField` provides a consistent text input interface throughout your application
/// with support for different visual styles, validation, and state handling.
///
/// # Example
///
/// ```swift
/// @State private var text = ""
/// @State private var error: String? = nil
///
/// CTTextField(
///     "Email",
///     placeholder: "Enter your email",
///     text: $text,
///     error: $error,
///     validation: { value in
///         if !value.contains("@") {
///             return "Please enter a valid email"
///         }
///         return nil
///     }
/// )
/// ```
public struct CTTextField: View {
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    private let label: String
    private let placeholder: String
    private let leadingIcon: String?
    private let trailingIcon: String?
    private let trailingAction: (() -> Void)?
    private let style: CTTextFieldStyle
    private let isSecure: Bool
    private let isDisabled: Bool
    private let isRequired: Bool
    private let autocapitalization: TextInputAutocapitalization
    private let autocorrection: Bool
    private let keyboardType: UIKeyboardType
    private let submitLabel: SubmitLabel
    private let validation: ((String) -> String?)?
    private let onSubmit: (() -> Void)?
    private let onEditingChanged: ((Bool) -> Void)?
    
    @Binding private var text: String
    @Binding private var error: String?
    @State private var isFocused: Bool = false
    @State private var isEditing: Bool = false
    @FocusState private var focusState: Bool
    
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Create a new text field with validation
    ///
    /// - Parameters:
    ///   - label: The text field label
    ///   - placeholder: The placeholder text
    ///   - text: Binding to the text value
    ///   - error: Binding to the error message
    ///   - leadingIcon: Optional leading icon (SF Symbol name)
    ///   - trailingIcon: Optional trailing icon (SF Symbol name)
    ///   - trailingAction: Optional action for the trailing icon
    ///   - style: The visual style of the text field
    ///   - isDisabled: Whether the text field is disabled
    ///   - isRequired: Whether the field is required
    ///   - autocapitalization: Text autocapitalization type
    ///   - autocorrection: Whether autocorrection is enabled
    ///   - keyboardType: The keyboard type to use
    ///   - submitLabel: The label for the submit button
    ///   - validation: Optional validation function
    ///   - onSubmit: Optional action to perform on submit
    ///   - onEditingChanged: Optional action to perform when editing changes
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
        autocapitalization: TextInputAutocapitalization = .sentences,
        autocorrection: Bool = true,
        keyboardType: UIKeyboardType = .default,
        submitLabel: SubmitLabel = .done,
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
        self.isSecure = false
        self.isDisabled = isDisabled
        self.isRequired = isRequired
        self.autocapitalization = autocapitalization
        self.autocorrection = autocorrection
        self.keyboardType = keyboardType
        self.submitLabel = submitLabel
        self.validation = validation
        self.onSubmit = onSubmit
        self.onEditingChanged = onEditingChanged
    }
    
    /// Create a new secure text field with validation
    ///
    /// - Parameters:
    ///   - label: The text field label
    ///   - placeholder: The placeholder text
    ///   - text: Binding to the text value
    ///   - error: Binding to the error message
    ///   - leadingIcon: Optional leading icon (SF Symbol name)
    ///   - trailingIcon: Optional trailing icon (SF Symbol name)
    ///   - trailingAction: Optional action for the trailing icon
    ///   - style: The visual style of the text field
    ///   - isDisabled: Whether the text field is disabled
    ///   - isRequired: Whether the field is required
    ///   - submitLabel: The label for the submit button
    ///   - validation: Optional validation function
    ///   - onSubmit: Optional action to perform on submit
    ///   - onEditingChanged: Optional action to perform when editing changes
    public init(
        secure label: String,
        placeholder: String = "",
        text: Binding<String>,
        error: Binding<String?> = .constant(nil),
        leadingIcon: String? = nil,
        trailingIcon: String? = nil,
        trailingAction: (() -> Void)? = nil,
        style: CTTextFieldStyle = .default,
        isDisabled: Bool = false,
        isRequired: Bool = false,
        submitLabel: SubmitLabel = .done,
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
        self.isSecure = true
        self.isDisabled = isDisabled
        self.isRequired = isRequired
        self.autocapitalization = .never
        self.autocorrection = false
        self.keyboardType = .default
        self.submitLabel = submitLabel
        self.validation = validation
        self.onSubmit = onSubmit
        self.onEditingChanged = onEditingChanged
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Label
            if !label.isEmpty {
                HStack(spacing: 4) {
                    Text(label)
                        .font(CTTypography.caption())
                        .foregroundColor(
                            isDisabled ? theme.textSecondary.opacity(0.6) : theme.textSecondary
                        )
                    
                    if isRequired {
                        Text("*")
                            .font(CTTypography.caption())
                            .foregroundColor(theme.destructive)
                    }
                    
                    Spacer()
                }
                .accessibilityHidden(true)
            }
            
            // Text Field Container
            HStack(spacing: CTSpacing.s) {
                // Leading Icon
                if let leadingIcon = leadingIcon {
                    Image(systemName: leadingIcon)
                        .foregroundColor(iconColor)
                        .frame(width: 24, height: 24)
                        .accessibilityHidden(true)
                }
                
                // Text Field
                Group {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                            .textInputAutocapitalization(autocapitalization)
                            .disableAutocorrection(!autocorrection)
                            .keyboardType(keyboardType)
                            .submitLabel(submitLabel)
                            .disabled(isDisabled)
                            .focused($focusState)
                            .onChange(of: focusState) { newValue in
                                isFocused = newValue
                                if !newValue && validation != nil {
                                    validateInput()
                                }
                            }
                            .onChange(of: text) { _ in
                                isEditing = true
                                onEditingChanged?(true)
                                // Clear error when user starts typing
                                if error != nil && !text.isEmpty {
                                    error = nil
                                }
                            }
                    } else {
                        TextField(placeholder, text: $text)
                            .textInputAutocapitalization(autocapitalization)
                            .disableAutocorrection(!autocorrection)
                            .keyboardType(keyboardType)
                            .submitLabel(submitLabel)
                            .disabled(isDisabled)
                            .focused($focusState)
                            .onChange(of: focusState) { newValue in
                                isFocused = newValue
                                if !newValue && validation != nil {
                                    validateInput()
                                }
                            }
                            .onChange(of: text) { _ in
                                isEditing = true
                                onEditingChanged?(true)
                                // Clear error when user starts typing
                                if error != nil && !text.isEmpty {
                                    error = nil
                                }
                            }
                    }
                }
                .foregroundColor(textColor)
                .onSubmit {
                    if validation != nil {
                        validateInput()
                    }
                    onSubmit?()
                }
                
                // Trailing Icon
                if let trailingIcon = trailingIcon {
                    Button(action: {
                        trailingAction?()
                    }) {
                        Image(systemName: trailingIcon)
                            .foregroundColor(iconColor)
                            .frame(width: 24, height: 24)
                    }
                    .disabled(isDisabled)
                    .accessibilityLabel("Clear text")
                }
            }
            .padding(CTSpacing.s)
            .background(backgroundColor)
            .cornerRadius(theme.borderRadius)
            .overlay(
                RoundedRectangle(cornerRadius: theme.borderRadius)
                    .stroke(borderColor, lineWidth: theme.borderWidth)
            )
            .opacity(isDisabled ? 0.6 : 1.0)
            
            // Error Message
            if let errorMessage = error, !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(CTTypography.captionSmall())
                    .foregroundColor(theme.destructive)
                    .padding(.top, 2)
                    .accessibilityLabel("Error: \(errorMessage)")
            }
        }
        .animation(.easeInOut(duration: 0.2), value: error)
        .ctInputAccessibility(
            label: isRequired ? "\(label), required" : label,
            value: text,
            hint: error
        )
        .ctRequiredFieldAccessibility(isRequired: isRequired)
        .accessibilityElement(children: .combine)
    }
    
    // MARK: - Private Methods
    
    /// Validates the input and sets the error message if validation fails
    private func validateInput() {
        if let validationFunction = validation {
            error = validationFunction(text)
        }
    }
    
    /// Returns the appropriate text color based on state
    private var textColor: Color {
        if isDisabled {
            return theme.textSecondary.opacity(0.6)
        } else if error != nil {
            return theme.text
        } else if isFocused {
            return theme.text
        } else {
            return theme.text
        }
    }
    
    /// Returns the appropriate background color based on state and style
    private var backgroundColor: Color {
        switch style {
        case .default:
            return theme.surface
        case .filled:
            return theme.background
        case .outlined:
            return .clear
        case .underlined:
            return .clear
        }
    }
    
    /// Returns the appropriate border color based on state and style
    private var borderColor: Color {
        if error != nil {
            return theme.destructive
        } else if isFocused {
            return theme.primary
        } else {
            switch style {
            case .default, .filled, .outlined:
                return theme.border
            case .underlined:
                return theme.textSecondary
            }
        }
    }
    
    /// Returns the appropriate icon color based on state
    private var iconColor: Color {
        if isDisabled {
            return theme.textSecondary.opacity(0.6)
        } else if error != nil {
            return theme.destructive
        } else if isFocused {
            return theme.primary
        } else {
            return theme.textSecondary
        }
    }
}

// MARK: - Supporting Types

/// The visual style for text fields
public enum CTTextFieldStyle {
    /// Standard style with background and border
    case `default`
    
    /// Filled style with background color
    case filled
    
    /// Outlined style with border and transparent background
    case outlined
    
    /// Underlined style with only a bottom border
    case underlined
}

// MARK: - Extension Methods

extension CTTextField {
    /// Validates the text field and returns whether validation passed
    ///
    /// - Returns: True if validation passed, false otherwise
    public func validate() -> Bool {
        if let validationFunction = validation {
            let errorMessage = validationFunction(text)
            error = errorMessage
            return errorMessage == nil
        }
        return true
    }
    
    /// Clears the text field
    public func clear() {
        text = ""
        error = nil
    }
}

// MARK: - Previews

struct CTTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: CTSpacing.m) {
            Group {
                StatefulPreviewWrapper("") { text in
                    CTTextField("Default Style", text: text)
                }
                
                StatefulPreviewWrapper("") { text in
                    CTTextField("With Placeholder", placeholder: "Enter some text", text: text)
                }
                
                StatefulPreviewWrapper("") { text in
                    CTTextField("With Icons", text: text, leadingIcon: "envelope", trailingIcon: "xmark.circle.fill")
                }
                
                StatefulPreviewWrapper("") { text in
                    StatefulPreviewWrapper(nil as String?) { error in
                        CTTextField(
                            "With Validation",
                            placeholder: "Enter email",
                            text: text,
                            error: error,
                            leadingIcon: "envelope",
                            keyboardType: .emailAddress,
                            validation: { value in
                                return value.isEmpty ? "Email is required" : (!value.contains("@") ? "Invalid email format" : nil)
                            }
                        )
                    }
                }
            }
            
            Group {
                StatefulPreviewWrapper("") { text in
                    CTTextField("Filled Style", text: text, style: .filled)
                }
                
                StatefulPreviewWrapper("") { text in
                    CTTextField("Outlined Style", text: text, style: .outlined)
                }
                
                StatefulPreviewWrapper("") { text in
                    CTTextField("Underlined Style", text: text, style: .underlined)
                }
            }
            
            Group {
                StatefulPreviewWrapper("") { text in
                    CTTextField("Disabled", text: text, isDisabled: true)
                }
                
                StatefulPreviewWrapper("") { text in
                    CTTextField("Required", text: text, isRequired: true)
                }
                
                StatefulPreviewWrapper("") { text in
                    CTTextField(secure: "Password", text: text)
                }
                
                StatefulPreviewWrapper("") { text in
                    CTTextField(
                        secure: "Password with Validation",
                        text: text,
                        leadingIcon: "lock",
                        isRequired: true,
                        validation: { value in
                            return value.isEmpty ? "Password is required" : (value.count < 8 ? "Password must be at least 8 characters" : nil)
                        }
                    )
                }
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

/// A helper view for creating stateful previews
struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    let content: (Binding<Value>) -> Content
    
    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(initialValue: value)
        self.content = content
    }
    
    var body: some View {
        content($value)
    }
}
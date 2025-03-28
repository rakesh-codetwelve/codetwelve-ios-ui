//
//  CTTextArea.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A multi-line text input component with customizable styling and validation.
///
/// `CTTextArea` provides a consistent multi-line text input throughout your application
/// with built-in validation, error handling, and support for placeholder text.
///
/// # Example
///
/// ```swift
/// @State private var description = ""
/// @State private var descriptionError: String? = nil
///
/// CTTextArea(
///     "Description",
///     placeholder: "Describe your experience...",
///     text: $description,
///     error: $descriptionError,
///     validation: { value in
///         if value.isEmpty {
///             return "Description is required"
///         } else if value.count < 10 {
///             return "Description must be at least 10 characters"
///         }
///         return nil
///     }
/// )
/// ```
public struct CTTextArea: View {
    // MARK: - Public Properties
    
    /// The current text value
    @Binding private var text: String
    
    /// The current error message, if any
    @Binding private var error: String?
    
    // MARK: - Private Properties
    
    private let label: String
    private let placeholder: String
    private let style: CTTextAreaStyle
    private let isDisabled: Bool
    private let isRequired: Bool
    private let minHeight: CGFloat
    private let maxHeight: CGFloat?
    private let autocapitalization: TextInputAutocapitalization
    private let autocorrection: Bool
    private let lineLimit: Int?
    private let validation: ((String) -> String?)?
    private let onEditingChanged: ((Bool) -> Void)?
    private let onCommit: (() -> Void)?
    
    @State private var isFocused: Bool = false
    @State private var isEditing: Bool = false
    @State private var textHeight: CGFloat = 100
    @FocusState private var focusState: Bool
    
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a multi-line text area component
    /// - Parameters:
    ///   - label: The label text displayed above the field
    ///   - placeholder: The placeholder text displayed when the field is empty
    ///   - text: Binding to the text value
    ///   - error: Binding to the error message, if any
    ///   - style: The visual style of the text area
    ///   - isDisabled: Whether the text area is disabled
    ///   - isRequired: Whether the field is required
    ///   - minHeight: The minimum height of the text area
    ///   - maxHeight: The maximum height of the text area (nil for unlimited)
    ///   - autocapitalization: Text input autocapitalization type
    ///   - autocorrection: Whether autocorrection is enabled
    ///   - lineLimit: Maximum number of lines to display
    ///   - validation: Optional validation function that returns an error message or nil
    ///   - onEditingChanged: Optional action to perform when editing begins or ends
    ///   - onCommit: Optional action to perform when editing commits
    public init(
        _ label: String,
        placeholder: String = "",
        text: Binding<String>,
        error: Binding<String?> = .constant(nil),
        style: CTTextAreaStyle = .default,
        isDisabled: Bool = false,
        isRequired: Bool = false,
        minHeight: CGFloat = 100,
        maxHeight: CGFloat? = nil,
        autocapitalization: TextInputAutocapitalization = .sentences,
        autocorrection: Bool = true,
        lineLimit: Int? = nil,
        validation: ((String) -> String?)? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self._error = error
        self.style = style
        self.isDisabled = isDisabled
        self.isRequired = isRequired
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.autocapitalization = autocapitalization
        self.autocorrection = autocorrection
        self.lineLimit = lineLimit
        self.validation = validation
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
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
            
            // Text area
            ZStack(alignment: .topLeading) {
                // Text editor
                TextEditor(text: $text)
                    .focused($focusState)
                    .onChange(of: focusState) { newValue in
                        isFocused = newValue
                        if !newValue, let validation = validation {
                            error = validation(text)
                        }
                        onEditingChanged?(newValue)
                    }
                    .frame(minHeight: minHeight, maxHeight: maxHeight)
                    .foregroundColor(textColor)
                    .textInputAutocapitalization(autocapitalization)
                    .autocorrectionDisabled(!autocorrection)
                    .disabled(isDisabled)
                    .scrollContentBackground(.hidden)
                    .background(backgroundColor)
                    
                // Placeholder
                if text.isEmpty {
                    Text(placeholder)
                        .font(CTTypography.body())
                        .foregroundColor(theme.textSecondary.opacity(0.6))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 8)
                        .allowsHitTesting(false)
                }
            }
            .frame(minHeight: minHeight, maxHeight: maxHeight)
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
        .ctInputAccessibility(label: label, value: text, hint: "Multi-line text input")
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
        case .default:
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
                return theme.border
            case .filled:
                return Color.clear
            case .outlined:
                return isDisabled ? theme.border.opacity(0.5) : theme.border
            }
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

/// The visual style of the text area
public enum CTTextAreaStyle {
    /// Default style with border
    case `default`
    
    /// Filled style with background color
    case filled
    
    /// Outlined style with border and transparent background
    case outlined
}

// MARK: - Preview

struct CTTextArea_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: CTSpacing.m) {
            StatefulPreviewWrapper("") { text in
                CTTextArea(
                    "Description",
                    placeholder: "Enter a detailed description...",
                    text: text
                )
            }
            
            StatefulPreviewWrapper("This is a sample text with some content to show how the text area handles multiple lines of text. It should wrap properly and show scrolling behavior once it exceeds the height.") { text in
                StatefulPreviewWrapper("Description is too short") { error in
                    CTTextArea(
                        "Description with Error",
                        placeholder: "Enter a detailed description...",
                        text: text,
                        error: error
                    )
                }
            }
            
            StatefulPreviewWrapper("") { text in
                CTTextArea(
                    "Filled Style",
                    placeholder: "Enter a detailed description...",
                    text: text,
                    style: .filled
                )
            }
            
            StatefulPreviewWrapper("") { text in
                CTTextArea(
                    "Outlined Style",
                    placeholder: "Enter a detailed description...",
                    text: text,
                    style: .outlined
                )
            }
            
            StatefulPreviewWrapper("This text area is disabled and cannot be edited.") { text in
                CTTextArea(
                    "Disabled State",
                    placeholder: "Enter a detailed description...",
                    text: text,
                    isDisabled: true
                )
            }
            
            StatefulPreviewWrapper("") { text in
                CTTextArea(
                    "Required Field",
                    placeholder: "Enter a detailed description...",
                    text: text,
                    isRequired: true
                )
            }
            
            StatefulPreviewWrapper("") { text in
                CTTextArea(
                    "Custom Height",
                    placeholder: "Enter a detailed description...",
                    text: text,
                    minHeight: 150,
                    maxHeight: 300
                )
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
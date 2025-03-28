//
//  CTCheckbox.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable checkbox component with various styles and states.
///
/// `CTCheckbox` provides a consistent checkbox interface throughout your application
/// with support for different visual styles, sizes, and states.
///
/// # Example
///
/// ```swift
/// @State private var isChecked = false
///
/// CTCheckbox(
///     "Accept terms and conditions",
///     isChecked: $isChecked,
///     style: .primary
/// )
/// ```
///
public struct CTCheckbox: View {
    // MARK: - Public Properties
    
    /// The current checked state
    @Binding private var isChecked: Bool
    
    // MARK: - Private Properties
    
    /// The label text displayed next to the checkbox
    private let label: String?
    
    /// The visual style of the checkbox
    private let style: CTCheckboxStyle
    
    /// The size of the checkbox
    private let size: CTCheckboxSize
    
    /// Whether the checkbox is disabled
    private let isDisabled: Bool
    
    /// The alignment of the label relative to the checkbox
    private let labelAlignment: CTCheckboxLabelAlignment
    
    /// The action to perform when the checkbox is toggled
    private let onChange: ((Bool) -> Void)?
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a new checkbox with a text label
    /// - Parameters:
    ///   - label: The text displayed next to the checkbox
    ///   - isChecked: Binding to the checked state
    ///   - style: The visual style of the checkbox
    ///   - size: The size of the checkbox
    ///   - isDisabled: Whether the checkbox is disabled
    ///   - labelAlignment: The alignment of the label relative to the checkbox
    ///   - onChange: The action to perform when the checked state changes
    public init(
        _ label: String? = nil,
        isChecked: Binding<Bool>,
        style: CTCheckboxStyle = .primary,
        size: CTCheckboxSize = .medium,
        isDisabled: Bool = false,
        labelAlignment: CTCheckboxLabelAlignment = .trailing,
        onChange: ((Bool) -> Void)? = nil
    ) {
        self.label = label
        self._isChecked = isChecked
        self.style = style
        self.size = size
        self.isDisabled = isDisabled
        self.labelAlignment = labelAlignment
        self.onChange = onChange
    }
    
    // MARK: - Body
    
    public var body: some View {
        Button(action: toggleCheckbox) {
            HStack(spacing: CTSpacing.s) {
                if labelAlignment == .leading && label != nil {
                    checkboxLabel
                    Spacer()
                    checkboxIcon
                } else {
                    checkboxIcon
                    if label != nil {
                        Spacer()
                        checkboxLabel
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .opacity(isDisabled ? 0.6 : 1.0)
        .disabled(isDisabled)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(isChecked ? "checked" : "unchecked")
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Double tap to \(isChecked ? "uncheck" : "check")")
    }
    
    // MARK: - Private Views
    
    /// The checkbox icon view
    private var checkboxIcon: some View {
        ZStack {
            // Background box
            RoundedRectangle(cornerRadius: 4)
                .stroke(checkboxBorderColor, lineWidth: checkboxBorderWidth)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(checkboxBackgroundColor)
                )
                .frame(width: checkboxSize, height: checkboxSize)
            
            // Checkmark
            if isChecked {
                Image(systemName: "checkmark")
                    .font(.system(size: checkmarkSize))
                    .foregroundColor(checkmarkColor)
            }
        }
    }
    
    /// The checkbox label view
    @ViewBuilder
    private var checkboxLabel: some View {
        if let label = label {
            Text(label)
                .font(size.font)
                .foregroundColor(labelColor)
        }
    }
    
    // MARK: - Private Properties
    
    /// The size of the checkbox
    private var checkboxSize: CGFloat {
        switch size {
        case .small:
            return 16
        case .medium:
            return 20
        case .large:
            return 24
        }
    }
    
    /// The size of the checkmark
    private var checkmarkSize: CGFloat {
        switch size {
        case .small:
            return 10
        case .medium:
            return 14
        case .large:
            return 18
        }
    }
    
    /// The width of the checkbox border
    private var checkboxBorderWidth: CGFloat {
        switch size {
        case .small:
            return 1
        case .medium, .large:
            return 1.5
        }
    }
    
    /// The color of the checkbox border
    private var checkboxBorderColor: Color {
        if isChecked {
            return style.getCheckedBorderColor(for: theme)
        } else {
            return style.getUncheckedBorderColor(for: theme)
        }
    }
    
    /// The background color of the checkbox
    private var checkboxBackgroundColor: Color {
        if isChecked {
            return style.getCheckedBackgroundColor(for: theme)
        } else {
            return style.getUncheckedBackgroundColor(for: theme)
        }
    }
    
    /// The color of the checkmark
    private var checkmarkColor: Color {
        style.getCheckmarkColor(for: theme)
    }
    
    /// The color of the label
    private var labelColor: Color {
        isDisabled ? theme.textSecondary : theme.text
    }
    
    /// The accessibility label for the checkbox
    private var accessibilityLabel: String {
        label ?? "Checkbox"
    }
    
    // MARK: - Private Methods
    
    /// Toggle the checkbox state
    private func toggleCheckbox() {
        let newValue = !isChecked
        isChecked = newValue
        
        // Add haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Call the onChange handler if provided
        onChange?(newValue)
    }
}

// MARK: - Supporting Types

/// The visual style of the checkbox
public enum CTCheckboxStyle {
    /// Primary style, using the primary theme color
    case primary
    
    /// Secondary style, using the secondary theme color
    case secondary
    
    /// Filled style, with a colored background when checked
    case filled
    
    /// Outline style, with a colored border and no background
    case outline
    
    /// Custom style with specific colors
    case custom(
        checkedBackground: Color,
        checkedBorder: Color,
        uncheckedBackground: Color,
        uncheckedBorder: Color,
        checkmark: Color
    )
    
    /// Get the checked background color for a given theme
    func getCheckedBackgroundColor(for theme: CTTheme) -> Color {
        switch self {
        case .primary:
            return theme.primary
        case .secondary:
            return theme.secondary
        case .filled:
            return theme.primary
        case .outline:
            return .clear
        case .custom(let checkedBackground, _, _, _, _):
            return checkedBackground
        }
    }
    
    /// Get the checked border color for a given theme
    func getCheckedBorderColor(for theme: CTTheme) -> Color {
        switch self {
        case .primary:
            return theme.primary
        case .secondary:
            return theme.secondary
        case .filled:
            return theme.primary
        case .outline:
            return theme.primary
        case .custom(_, let checkedBorder, _, _, _):
            return checkedBorder
        }
    }
    
    /// Get the unchecked background color for a given theme
    func getUncheckedBackgroundColor(for theme: CTTheme) -> Color {
        switch self {
        case .primary, .secondary, .filled, .outline:
            return .clear
        case .custom(_, _, let uncheckedBackground, _, _):
            return uncheckedBackground
        }
    }
    
    /// Get the unchecked border color for a given theme
    func getUncheckedBorderColor(for theme: CTTheme) -> Color {
        switch self {
        case .primary, .secondary, .filled, .outline:
            return theme.border
        case .custom(_, _, _, let uncheckedBorder, _):
            return uncheckedBorder
        }
    }
    
    /// Get the checkmark color for a given theme
    func getCheckmarkColor(for theme: CTTheme) -> Color {
        switch self {
        case .primary, .secondary, .filled:
            return theme.textOnAccent
        case .outline:
            return theme.primary
        case .custom(_, _, _, _, let checkmark):
            return checkmark
        }
    }
}

/// The size of the checkbox
public enum CTCheckboxSize {
    /// Small checkbox
    case small
    
    /// Medium checkbox
    case medium
    
    /// Large checkbox
    case large
    
    /// The font for the label based on the checkbox size
    var font: Font {
        switch self {
        case .small:
            return CTTypography.caption()
        case .medium:
            return CTTypography.body()
        case .large:
            return CTTypography.subtitle()
        }
    }
}

/// The alignment of the label relative to the checkbox
public enum CTCheckboxLabelAlignment {
    /// Label comes before the checkbox
    case leading
    
    /// Label comes after the checkbox
    case trailing
}

// MARK: - Previews

struct CTCheckbox_Previews: PreviewProvider {
    struct CheckboxPreview: View {
        @State private var isChecked1 = false
        @State private var isChecked2 = true
        @State private var isChecked3 = false
        @State private var isChecked4 = true
        @State private var isChecked5 = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                Group {
                    Text("Checkbox Styles")
                        .font(CTTypography.heading2())
                        .padding(.bottom, CTSpacing.s)
                    
                    CTCheckbox("Primary Checkbox", isChecked: $isChecked1, style: .primary)
                    CTCheckbox("Secondary Checkbox", isChecked: $isChecked2, style: .secondary)
                    CTCheckbox("Filled Checkbox", isChecked: $isChecked3, style: .filled)
                    CTCheckbox("Outline Checkbox", isChecked: $isChecked4, style: .outline)
                    CTCheckbox("Custom Checkbox", isChecked: $isChecked5, style: .custom(
                        checkedBackground: .purple,
                        checkedBorder: .purple,
                        uncheckedBackground: .clear,
                        uncheckedBorder: .gray,
                        checkmark: .white
                    ))
                }
                
                Divider().padding(.vertical, CTSpacing.m)
                
                Group {
                    Text("Checkbox Sizes")
                        .font(CTTypography.heading2())
                        .padding(.bottom, CTSpacing.s)
                    
                    CTCheckbox("Small Checkbox", isChecked: $isChecked1, size: .small)
                    CTCheckbox("Medium Checkbox", isChecked: $isChecked2)
                    CTCheckbox("Large Checkbox", isChecked: $isChecked3, size: .large)
                }
                
                Divider().padding(.vertical, CTSpacing.m)
                
                Group {
                    Text("Checkbox States")
                        .font(CTTypography.heading2())
                        .padding(.bottom, CTSpacing.s)
                    
                    CTCheckbox("Enabled Unchecked", isChecked: .constant(false))
                    CTCheckbox("Enabled Checked", isChecked: .constant(true))
                    CTCheckbox("Disabled Unchecked", isChecked: .constant(false), isDisabled: true)
                    CTCheckbox("Disabled Checked", isChecked: .constant(true), isDisabled: true)
                }
                
                Divider().padding(.vertical, CTSpacing.m)
                
                Group {
                    Text("Label Alignment")
                        .font(CTTypography.heading2())
                        .padding(.bottom, CTSpacing.s)
                    
                    CTCheckbox("Trailing Label (Default)", isChecked: $isChecked1)
                    CTCheckbox("Leading Label", isChecked: $isChecked2, labelAlignment: .leading)
                    CTCheckbox(isChecked: $isChecked3)
                }
            }
            .padding()
        }
    }
    
    static var previews: some View {
        CheckboxPreview()
    }
}
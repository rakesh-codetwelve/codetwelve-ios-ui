//
//  CTToggle.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable toggle switch component with various styles and states.
///
/// `CTToggle` provides a switch control for toggling between on and off states.
/// It supports different visual styles, sizes, and accessibility features.
///
/// # Example
///
/// ```swift
/// @State private var isEnabled = false
///
/// CTToggle(
///     "Enable notifications",
///     isOn: $isEnabled,
///     style: .primary
/// )
/// ```
///
/// You can create a toggle without a label by passing `nil` as the label parameter:
///
/// ```swift
/// CTToggle(
///     nil,
///     isOn: $isEnabled,
///     style: .primary
/// )
/// ```
public struct CTToggle: View {
    // MARK: - Properties
    
    /// The binding to the toggle's state
    @Binding private var isOn: Bool
    
    /// The label text for the toggle
    private let label: String?
    
    /// The style of the toggle
    private let style: CTToggleStyle
    
    /// The size of the toggle
    private let size: CTToggleSize
    
    /// Whether the toggle is disabled
    private let isDisabled: Bool
    
    /// The position of the label relative to the toggle
    private let labelPosition: CTToggleLabelPosition
    
    /// Optional closure to be called when the toggle changes
    private let onChange: ((Bool) -> Void)?
    
    /// Theme from environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a toggle with a label
    ///
    /// - Parameters:
    ///   - label: The text to display next to the toggle
    ///   - isOn: Binding to the state of the toggle
    ///   - style: The visual style of the toggle
    ///   - size: The size of the toggle
    ///   - isDisabled: Whether the toggle is disabled
    ///   - labelPosition: The position of the label relative to the toggle
    ///   - onChange: Closure to be called when the toggle changes
    public init(
        _ label: String?,
        isOn: Binding<Bool>,
        style: CTToggleStyle = .primary,
        size: CTToggleSize = .medium,
        isDisabled: Bool = false,
        labelPosition: CTToggleLabelPosition = .leading,
        onChange: ((Bool) -> Void)? = nil
    ) {
        self.label = label
        self._isOn = isOn
        self.style = style
        self.size = size
        self.isDisabled = isDisabled
        self.labelPosition = labelPosition
        self.onChange = onChange
    }
    
    // MARK: - Body
    
    public var body: some View {
        let toggleContent = createToggleContent()
            .disabled(isDisabled)
            .opacity(isDisabled ? 0.6 : 1.0)
        
        if let label = label, !label.isEmpty {
            toggleContent
                .ctToggleAccessibility(label: label, isOn: isOn, isDisabled: isDisabled)
        } else {
            toggleContent
                .accessibilityValue(isOn ? "On" : "Off")
                .accessibilityAddTraits(.isButton)
                .accessibilityAddTraits(accessibilityTraits)
        }
    }
    
    // MARK: - Private Methods
    
    /// Creates the toggle content with proper layout based on label position
    @ViewBuilder
    private func createToggleContent() -> some View {
        if let label = label, !label.isEmpty {
            Group {
                if labelPosition == .leading {
                    HStack(spacing: size.contentSpacing) {
                        createLabel()
                        Spacer()
                        createToggle()
                    }
                } else {
                    HStack(spacing: size.contentSpacing) {
                        createToggle()
                        Spacer()
                        createLabel()
                    }
                }
            }
        } else {
            createToggle()
        }
    }
    
    /// Creates the toggle label
    @ViewBuilder
    private func createLabel() -> some View {
        if let label = label, !label.isEmpty {
            Text(label)
                .font(size.font)
                .foregroundColor(labelColor)
        }
    }
    
    /// Creates the toggle control
    private func createToggle() -> some View {
        Toggle("", isOn: Binding(
            get: { isOn },
            set: { newValue in
                isOn = newValue
                onChange?(newValue)
            }
        ))
        .toggleStyle(CTCustomToggleStyle(
            onColor: toggleOnColor,
            offColor: toggleOffColor,
            thumbColor: toggleThumbColor,
            width: size.width,
            height: size.height,
            thumbSize: size.thumbSize
        ))
    }
    
    // MARK: - Computed Properties
    
    /// The color of the toggle when it's on
    private var toggleOnColor: Color {
        switch style {
        case .primary:
            return theme.primary
        case .secondary:
            return theme.secondary
        case .success:
            return theme.success
        case .custom(let colors):
            return colors.onColor
        }
    }
    
    /// The color of the toggle when it's off
    private var toggleOffColor: Color {
        switch style {
        case .primary, .secondary, .success:
            return theme.border.opacity(0.5)
        case .custom(let colors):
            return colors.offColor
        }
    }
    
    /// The color of the toggle thumb
    private var toggleThumbColor: Color {
        switch style {
        case .primary, .secondary, .success:
            return Color.white
        case .custom(let colors):
            return colors.thumbColor
        }
    }
    
    /// The color of the toggle label
    private var labelColor: Color {
        isDisabled ? theme.textSecondary : theme.text
    }
    
    private var accessibilityTraits: AccessibilityTraits {
        var traits: AccessibilityTraits = [.isButton]
        if !isDisabled {
            traits.insert(.isSelected)
        }
        return traits
    }
}

// MARK: - Toggle Style

/// A custom toggle style for CTToggle
struct CTCustomToggleStyle: ToggleStyle {
    let onColor: Color
    let offColor: Color
    let thumbColor: Color
    let width: CGFloat
    let height: CGFloat
    let thumbSize: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: width, height: height)
                    .animation(.spring(response: 0.2, dampingFraction: 0.9), value: configuration.isOn)
                
                // Thumb
                Circle()
                    .fill(thumbColor)
                    .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                    .frame(width: thumbSize, height: thumbSize)
                    .offset(x: configuration.isOn ? (width / 2 - thumbSize / 2 - 1) : (-width / 2 + thumbSize / 2 + 1))
                    .animation(.spring(response: 0.2, dampingFraction: 0.9), value: configuration.isOn)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                configuration.isOn.toggle()
            }
        }
    }
}

// MARK: - Toggle Style Enum

/// The available toggle styles
public enum CTToggleStyle {
    /// Primary accent color
    case primary
    
    /// Secondary accent color
    case secondary
    
    /// Success/positive color
    case success
    
    /// Custom colors
    case custom(colors: CTToggleColorOptions)
}

/// Custom color options for toggle
public struct CTToggleColorOptions {
    /// The color when the toggle is on
    public let onColor: Color
    
    /// The color when the toggle is off
    public let offColor: Color
    
    /// The color of the toggle thumb
    public let thumbColor: Color
    
    /// Initialize custom toggle colors
    /// - Parameters:
    ///   - onColor: The color when the toggle is on
    ///   - offColor: The color when the toggle is off
    ///   - thumbColor: The color of the toggle thumb
    public init(
        onColor: Color,
        offColor: Color,
        thumbColor: Color = .white
    ) {
        self.onColor = onColor
        self.offColor = offColor
        self.thumbColor = thumbColor
    }
}

// MARK: - Toggle Size Enum

/// The available toggle sizes
public enum CTToggleSize {
    /// Small toggle
    case small
    
    /// Medium toggle (default)
    case medium
    
    /// Large toggle
    case large
    
    /// Custom size toggle
    case custom(width: CGFloat, height: CGFloat, thumbSize: CGFloat, font: Font)
    
    /// The width of the toggle
    var width: CGFloat {
        switch self {
        case .small:
            return 44
        case .medium:
            return 50
        case .large:
            return 60
        case .custom(let width, _, _, _):
            return width
        }
    }
    
    /// The height of the toggle
    var height: CGFloat {
        switch self {
        case .small:
            return 24
        case .medium:
            return 30
        case .large:
            return 36
        case .custom(_, let height, _, _):
            return height
        }
    }
    
    /// The size of the toggle thumb
    var thumbSize: CGFloat {
        switch self {
        case .small:
            return 18
        case .medium:
            return 22
        case .large:
            return 26
        case .custom(_, _, let thumbSize, _):
            return thumbSize
        }
    }
    
    /// The spacing between toggle and content
    var contentSpacing: CGFloat {
        switch self {
        case .small:
            return CTSpacing.s
        case .medium:
            return CTSpacing.m
        case .large:
            return CTSpacing.m
        case .custom:
            return CTSpacing.m
        }
    }
    
    /// The font for the label
    var font: Font {
        switch self {
        case .small:
            return CTTypography.bodySmall()
        case .medium:
            return CTTypography.body()
        case .large:
            return CTTypography.subtitle()
        case .custom(_, _, _, let font):
            return font
        }
    }
}

// MARK: - Toggle Label Position Enum

/// The position of the label relative to the toggle
public enum CTToggleLabelPosition {
    /// Label appears before the toggle (left side in LTR layouts)
    case leading
    
    /// Label appears after the toggle (right side in LTR layouts)
    case trailing
}

// MARK: - Accessibility Extension

extension View {
    /// Apply standard accessibility modifiers for a toggle
    /// - Parameters:
    ///   - label: The accessibility label
    ///   - isOn: Whether the toggle is on
    ///   - isDisabled: Whether the toggle is disabled
    /// - Returns: The view with accessibility modifiers applied
    func ctToggleAccessibility(label: String, isOn: Bool, isDisabled: Bool) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityValue(isOn ? "On" : "Off")
            .accessibilityHint(isOn ? "Double tap to turn off" : "Double tap to turn on")
            .accessibilityAddTraits(.isButton)
            .accessibilityAddTraits(!isDisabled ? .isSelected : [])
    }
}

// MARK: - Previews

struct CTToggle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Basic toggle with variations
            Group {
                TogglePreview(title: "Primary Toggle")
                TogglePreview(title: "Secondary Toggle", style: .secondary)
                TogglePreview(title: "Success Toggle", style: .success)
                TogglePreview(title: "Custom Toggle", style: .custom(colors: CTToggleColorOptions(
                    onColor: .pink,
                    offColor: .gray.opacity(0.3),
                    thumbColor: .white
                )))
            }
            
            Divider().padding()
            
            // Size variations
            Group {
                TogglePreview(title: "Small Toggle", size: .small)
                TogglePreview(title: "Medium Toggle", size: .medium)
                TogglePreview(title: "Large Toggle", size: .large)
                TogglePreview(title: "Custom Size Toggle", size: .custom(
                    width: 70,
                    height: 34,
                    thumbSize: 24,
                    font: .title3
                ))
            }
            
            Divider().padding()
            
            // Label position variations
            Group {
                TogglePreview(title: "Label Leading", labelPosition: .leading)
                TogglePreview(title: "Label Trailing", labelPosition: .trailing)
            }
            
            Divider().padding()
            
            // State variations
            Group {
                TogglePreview(title: "Disabled Toggle (Off)", isDisabled: true)
                TogglePreview(title: "Disabled Toggle (On)", isInitiallyOn: true, isDisabled: true)
                CTToggle(nil, isOn: .constant(true), style: .primary)
                    .padding()
                    .previewDisplayName("Toggle without label")
            }
        }
        .padding()
    }
    
    struct TogglePreview: View {
        let title: String
        let style: CTToggleStyle
        let size: CTToggleSize
        let isInitiallyOn: Bool
        let isDisabled: Bool
        let labelPosition: CTToggleLabelPosition
        
        @State private var isOn: Bool
        
        init(
            title: String,
            style: CTToggleStyle = .primary,
            size: CTToggleSize = .medium,
            isInitiallyOn: Bool = false,
            isDisabled: Bool = false,
            labelPosition: CTToggleLabelPosition = .leading
        ) {
            self.title = title
            self.style = style
            self.size = size
            self.isInitiallyOn = isInitiallyOn
            self.isDisabled = isDisabled
            self.labelPosition = labelPosition
            self._isOn = State(initialValue: isInitiallyOn)
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                CTToggle(
                    title,
                    isOn: $isOn,
                    style: style,
                    size: size,
                    isDisabled: isDisabled,
                    labelPosition: labelPosition
                ) { newValue in
                    print("\(title) changed to: \(newValue)")
                }
                .padding(.horizontal)
            }
        }
    }
}
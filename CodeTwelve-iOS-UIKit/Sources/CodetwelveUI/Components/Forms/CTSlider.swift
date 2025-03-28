//
//  CTSlider.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable slider component for inputting numeric values within a range.
///
/// `CTSlider` provides a consistent slider interface throughout your application
/// with support for different visual styles, value labels, and accessibility features.
///
/// # Example
///
/// ```swift
/// @State private var volume: Double = 50
///
/// CTSlider(
///     value: $volume,
///     range: 0...100,
///     style: .primary,
///     label: "Volume"
/// )
/// ```
///
/// With step values and value label:
///
/// ```swift
/// CTSlider(
///     value: $temperature,
///     range: 15...30,
///     step: 0.5,
///     style: .primary,
///     label: "Temperature",
///     valueLabel: { value in "\(Int(value))°C" },
///     showValueLabel: true
/// )
/// ```
public struct CTSlider: View {
    // MARK: - Properties
    
    /// The current value of the slider
    @Binding private var value: Double
    
    /// The range of possible values
    private let range: ClosedRange<Double>
    
    /// The step value to snap to (if provided)
    private let step: Double?
    
    /// The style of the slider
    private let style: CTSliderStyle
    
    /// The size of the slider
    private let size: CTSliderSize
    
    /// The label for the slider
    private let label: String?
    
    /// Whether to show the minimum and maximum value labels
    private let showMinMaxLabels: Bool
    
    /// Function to format the current value for display
    private let valueLabel: ((Double) -> String)?
    
    /// Whether to show the current value label
    private let showValueLabel: Bool
    
    /// Whether the slider is disabled
    private let isDisabled: Bool
    
    /// The action to perform when the value changes
    private let onChange: ((Double) -> Void)?
    
    /// Whether the user is currently dragging the slider
    @State private var isDragging = false
    
    /// Theme from environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a slider with a range of values
    ///
    /// - Parameters:
    ///   - value: Binding to the slider value
    ///   - range: The range of possible values
    ///   - step: Optional step value to snap to
    ///   - style: The visual style of the slider
    ///   - size: The size of the slider
    ///   - label: Optional label for the slider
    ///   - showMinMaxLabels: Whether to show the minimum and maximum value labels
    ///   - valueLabel: Optional function to format the current value for display
    ///   - showValueLabel: Whether to show the current value label
    ///   - isDisabled: Whether the slider is disabled
    ///   - onChange: Optional action to perform when the value changes
    public init(
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double? = nil,
        style: CTSliderStyle = .primary,
        size: CTSliderSize = .medium,
        label: String? = nil,
        showMinMaxLabels: Bool = true,
        valueLabel: ((Double) -> String)? = nil,
        showValueLabel: Bool = false,
        isDisabled: Bool = false,
        onChange: ((Double) -> Void)? = nil
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.style = style
        self.size = size
        self.label = label
        self.showMinMaxLabels = showMinMaxLabels
        self.valueLabel = valueLabel
        self.showValueLabel = showValueLabel
        self.isDisabled = isDisabled
        self.onChange = onChange
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: CTSpacing.s) {
            if showLabel {
                labelView
            }
            
            HStack {
                if showMinValue {
                    Text(String(format: "%.\(step == 1 ? 0 : 1)f", range.lowerBound))
                        .font(size.minMaxFont)
                        .foregroundColor(isDisabled ? theme.textSecondary : theme.text)
                }
                
                Slider(value: $value, in: range, step: step ?? 0)
                    .tint(style.getActiveColor(for: theme))
                    .disabled(isDisabled)
                    .opacity(isDisabled ? 0.5 : 1.0)
                    .accessibilityLabel(accessibilityLabel)
                    .accessibilityValue(accessibilityValue)
                    .accessibilityHint(accessibilityHint)
                    .accessibilityAddTraits(accessibilityTraits)
                
                if showMaxValue {
                    Text(String(format: "%.\(step == 1 ? 0 : 1)f", range.upperBound))
                        .font(size.minMaxFont)
                        .foregroundColor(isDisabled ? theme.textSecondary : theme.text)
                }
            }
        }
    }
    
    // MARK: - Action Methods
    
    /// Updates the slider value based on a drag gesture
    /// - Parameter gesture: The drag gesture
    private func updateValueFromGesture(_ gesture: DragGesture.Value) {
        // Calculate the width of the track
        let width = trackWidth
        guard width > 0 else { return }
        
        // Calculate drag position with bounds checking
        let dragLocation = gesture.location.x
        let position = max(0, min(dragLocation, width))
        
        // Convert position to value
        let percent = position / width
        let newValue = range.lowerBound + (range.upperBound - range.lowerBound) * percent
        
        // Apply step value for better feedback during dragging (final rounding happens on drag end)
        if let step = step {
            value = (round(newValue / step) * step).clamped(to: range)
        } else {
            value = newValue.clamped(to: range)
        }
    }
    
    /// Adjusts the slider value for accessibility
    /// - Parameter direction: The adjustment direction
    private func adjustValueForAccessibility(_ direction: AccessibilityAdjustmentDirection) {
        // Determine the adjustment step
        let adjustmentStep = step ?? (range.upperBound - range.lowerBound) / 10
        
        // Apply the adjustment
        switch direction {
        case .increment:
            value = min(range.upperBound, value + adjustmentStep)
        case .decrement:
            value = max(range.lowerBound, value - adjustmentStep)
        @unknown default:
            break
        }
        
        // Call onChange handler
        onChange?(value)
        
        // Provide haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    // MARK: - Computed Properties
    
    /// The track width (estimated)
    private var trackWidth: CGFloat {
        // This is an estimate, actual width will depend on layout
        UIScreen.main.bounds.width - size.thumbSize - 32  // Accounting for padding
    }
    
    /// The normalized position of the thumb (0-1)
    private var thumbPosition: CGFloat {
        let minValue = range.lowerBound
        let maxValue = range.upperBound
        let rangeSize = maxValue - minValue
        let normalizedValue = (value - minValue) / rangeSize
        return CGFloat(normalizedValue)
    }
    
    /// The color of the track background
    private var trackBackgroundColor: Color {
        switch style {
        case .primary, .custom:
            return theme.border.opacity(0.3)
        case .secondary:
            return theme.secondary.opacity(0.3)
        case .accent(let color):
            return color.opacity(0.3)
        }
    }
    
    /// The color of the filled track
    private var trackFillColor: Color {
        switch style {
        case .primary:
            return theme.primary
        case .secondary:
            return theme.secondary
        case .accent(let color):
            return color
        case .custom(let colors):
            return colors.trackFill
        }
    }
    
    /// The color of the thumb
    private var thumbColor: Color {
        switch style {
        case .primary, .secondary, .accent:
            return .white
        case .custom(let colors):
            return colors.thumb
        }
    }
    
    /// The color of the label
    private var labelColor: Color {
        isDisabled ? theme.textSecondary : theme.text
    }
    
    /// The color of the min/max labels
    private var minMaxLabelColor: Color {
        theme.textSecondary
    }
    
    /// The accessibility label
    private var accessibilityLabel: String {
        label ?? "Slider"
    }
    
    /// The accessibility value text
    private var accessibilityValueText: String {
        if let formatValue = valueLabel {
            return formatValue(value)
        } else {
            return "\(Int(value))"
        }
    }
    
    private var accessibilityTraits: AccessibilityTraits {
        var traits: AccessibilityTraits = [.isButton]
        if !isDisabled {
            traits.insert(.isSelected)
        }
        return traits
    }

    private var accessibilityValue: String {
        if let formatValue = valueLabel {
            return formatValue(value)
        } else {
            let minValue = range.lowerBound
            let maxValue = range.upperBound
            let rangeSize = maxValue - minValue
            let normalizedValue = (value - minValue) / rangeSize
            return "\(Int(normalizedValue * 100))%"
        }
    }

    private var accessibilityHint: String {
        "Adjust value by dragging"
    }

    private var showLabel: Bool {
        label != nil || (showValueLabel && valueLabel != nil)
    }

    private var showMinValue: Bool {
        showMinMaxLabels || !range.isEmpty
    }

    private var showMaxValue: Bool {
        showMinMaxLabels || !range.isEmpty
    }

    private var labelView: some View {
        HStack {
            if let label = label {
                Text(label)
                    .font(size.labelFont)
                    .foregroundColor(labelColor)
            }
            
            Spacer()
            
            if showValueLabel, let formatValue = valueLabel {
                Text(formatValue(value))
                    .font(size.valueFont)
                    .foregroundColor(labelColor)
            }
        }
    }
}

// MARK: - Slider Style Enum

/// The available styles for the slider
public enum CTSliderStyle {
    /// Primary style using the primary theme color
    case primary
    
    /// Secondary style using the secondary theme color
    case secondary
    
    /// Accent style using a custom accent color
    case accent(Color)
    
    /// Custom style with specific colors
    case custom(colors: CTSliderColorOptions)

    func getActiveColor(for theme: CTTheme) -> Color {
        switch self {
        case .primary:
            return theme.primary
        case .secondary:
            return theme.secondary
        case .accent(let color):
            return color
        case .custom(let colors):
            return colors.trackFill
        }
    }
}

/// Custom color options for the slider
public struct CTSliderColorOptions {
    /// The color of the track fill
    public let trackFill: Color
    
    /// The color of the thumb
    public let thumb: Color
    
    /// Initialize custom slider colors
    ///
    /// - Parameters:
    ///   - trackFill: Color of the track fill
    ///   - thumb: Color of the thumb
    public init(trackFill: Color, thumb: Color = .white) {
        self.trackFill = trackFill
        self.thumb = thumb
    }
}

// MARK: - Slider Size Enum

/// The available sizes for the slider
public enum CTSliderSize {
    /// Small slider
    case small
    
    /// Medium slider (default)
    case medium
    
    /// Large slider
    case large
    
    /// The height of the track
    var trackHeight: CGFloat {
        switch self {
        case .small:
            return 2
        case .medium:
            return 4
        case .large:
            return 6
        }
    }
    
    /// The size of the thumb
    var thumbSize: CGFloat {
        switch self {
        case .small:
            return 16
        case .medium:
            return 20
        case .large:
            return 24
        }
    }
    
    /// The font for the label
    var labelFont: Font {
        switch self {
        case .small:
            return CTTypography.caption()
        case .medium:
            return CTTypography.body()
        case .large:
            return CTTypography.subtitle()
        }
    }
    
    /// The font for the value
    var valueFont: Font {
        switch self {
        case .small:
            return CTTypography.caption()
        case .medium:
            return CTTypography.body()
        case .large:
            return CTTypography.bodyBold()
        }
    }
    
    /// The font for min/max labels
    var minMaxFont: Font {
        switch self {
        case .small:
            return CTTypography.captionSmall()
        case .medium:
            return CTTypography.caption()
        case .large:
            return CTTypography.bodySmall()
        }
    }
}

// MARK: - Helper Extension

extension Comparable {
    /// Clamps the value to a closed range
    ///
    /// - Parameter range: The range to clamp to
    /// - Returns: The clamped value
    func clamped(to range: ClosedRange<Self>) -> Self {
        return min(max(self, range.lowerBound), range.upperBound)
    }
}

// MARK: - Previews

struct CTSlider_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Slider Styles")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    SliderPreview(title: "Primary Slider", style: .primary)
                    SliderPreview(title: "Secondary Slider", style: .secondary)
                    SliderPreview(title: "Accent Slider", style: .accent(.purple))
                    SliderPreview(title: "Custom Slider", style: .custom(colors: CTSliderColorOptions(
                        trackFill: .pink,
                        thumb: .white
                    )))
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Slider Sizes")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    SliderPreview(title: "Small Slider", size: .small)
                    SliderPreview(title: "Medium Slider", size: .medium)
                    SliderPreview(title: "Large Slider", size: .large)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Slider Features")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    SliderPreview(title: "With Step Values", step: 10)
                    SliderPreview(title: "With Value Label", showValueLabel: true, valueFormatter: { "\(Int($0)) units" })
                    SliderPreview(title: "Without Min/Max Labels", showMinMaxLabels: false)
                    SliderPreview(title: "Disabled Slider", isDisabled: true)
                }
            }
            .padding()
        }
    }
    
    struct SliderPreview: View {
        let title: String
        let style: CTSliderStyle
        let size: CTSliderSize
        let step: Double?
        let showMinMaxLabels: Bool
        let showValueLabel: Bool
        let valueFormatter: ((Double) -> String)?
        let isDisabled: Bool
        
        @State private var value: Double = 50
        
        init(
            title: String,
            style: CTSliderStyle = .primary,
            size: CTSliderSize = .medium,
            step: Double? = nil,
            showMinMaxLabels: Bool = true,
            showValueLabel: Bool = false,
            valueFormatter: ((Double) -> String)? = nil,
            isDisabled: Bool = false
        ) {
            self.title = title
            self.style = style
            self.size = size
            self.step = step
            self.showMinMaxLabels = showMinMaxLabels
            self.showValueLabel = showValueLabel
            self.valueFormatter = valueFormatter
            self.isDisabled = isDisabled
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.subheadline)
                
                CTSlider(
                    value: $value,
                    range: 0...100,
                    step: step,
                    style: style,
                    size: size,
                    label: "Control",
                    showMinMaxLabels: showMinMaxLabels,
                    valueLabel: valueFormatter,
                    showValueLabel: showValueLabel,
                    isDisabled: isDisabled
                ) { newValue in
                    print("\(title) changed to: \(newValue)")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

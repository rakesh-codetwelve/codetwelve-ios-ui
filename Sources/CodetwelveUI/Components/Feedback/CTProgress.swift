//
//  CTProgress.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable progress indicator component with support for linear and circular styles.
///
/// `CTProgress` provides consistent progress indicators throughout your application
/// with support for different styles, sizes, colors, and optional labels.
///
/// # Example
///
/// ```swift
/// // Linear progress bar (default)
/// CTProgress(value: 0.65)
///
/// // Circular progress indicator
/// CTProgress(value: 0.35, style: .circular)
///
/// // Progress with label and custom color
/// CTProgress(value: 0.75, label: "Loading...", color: .ctSuccess)
///
/// // Indeterminate progress
/// CTProgress(isIndeterminate: true)
/// ```
public struct CTProgress: View {
    // MARK: - Private Properties
    
    /// The current progress value (0.0 to 1.0)
    private let value: Double
    
    /// The style of the progress indicator
    private let style: CTProgressStyle
    
    /// The size of the progress indicator
    private let size: CTProgressSize
    
    /// The color of the progress indicator
    private let color: Color?
    
    /// The track color (background) of the progress indicator
    private let trackColor: Color?
    
    /// The label for the progress indicator (optional)
    private let label: String?
    
    /// Whether to show the percentage value
    private let showPercentage: Bool
    
    /// The position of the label
    private let labelPosition: CTProgressLabelPosition
    
    /// Whether the progress is indeterminate (shows an animation instead of a specific value)
    private let isIndeterminate: Bool
    
    /// Whether the animation should run continuously
    @State private var isAnimating: Bool = false
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a new progress indicator
    /// - Parameters:
    ///   - value: The current progress value (0.0 to 1.0)
    ///   - style: The style of the progress indicator
    ///   - size: The size of the progress indicator
    ///   - color: The color of the progress indicator (defaults to theme's primary color)
    ///   - trackColor: The track color (background) of the progress indicator (defaults to a semi-transparent version of the color)
    ///   - label: The label for the progress indicator (optional)
    ///   - showPercentage: Whether to show the percentage value
    ///   - labelPosition: The position of the label
    ///   - isIndeterminate: Whether the progress is indeterminate (shows an animation instead of a specific value)
    public init(
        value: Double = 0.0,
        style: CTProgressStyle = .linear,
        size: CTProgressSize = .medium,
        color: Color? = nil,
        trackColor: Color? = nil,
        label: String? = nil,
        showPercentage: Bool = false,
        labelPosition: CTProgressLabelPosition = .bottom,
        isIndeterminate: Bool = false
    ) {
        self.value = max(0.0, min(1.0, value)) // Clamp value between 0 and 1
        self.style = style
        self.size = size
        self.color = color
        self.trackColor = trackColor
        self.label = label
        self.showPercentage = showPercentage
        self.labelPosition = labelPosition
        self.isIndeterminate = isIndeterminate
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: CTSpacing.xs) {
            if label != nil && labelPosition == .top {
                labelView
            }
            
            progressIndicator
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(accessibilityLabel)
                .accessibilityValue(accessibilityValue)
                .accessibilityAddTraits(.updatesFrequently)
            
            if label != nil && labelPosition == .bottom {
                labelView
            }
        }
        .onAppear {
            if isIndeterminate {
                withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
        }
    }
    
    // MARK: - Private Views
    
    /// The main progress indicator view
    @ViewBuilder
    private var progressIndicator: some View {
        switch style {
        case .linear:
            linearProgressView
        case .circular:
            circularProgressView
        }
    }
    
    /// Linear progress bar
    private var linearProgressView: some View {
        ZStack(alignment: .leading) {
            // Background track
            Capsule()
                .fill(effectiveTrackColor)
                .frame(height: size.linearHeight)
            
            // Foreground progress
            Capsule()
                .fill(effectiveColor)
                .frame(width: isIndeterminate ? nil : progressWidth, height: size.linearHeight)
                .mask(
                    Rectangle()
                        .offset(x: isIndeterminate ? indeterminateOffset : 0)
                )
                .animation(isIndeterminate ? Animation.linear(duration: 1.5).repeatForever(autoreverses: true) : nil, value: isIndeterminate)
        }
        .frame(height: size.linearHeight)
    }
    
    /// Circular progress indicator
    private var circularProgressView: some View {
        ZStack {
            // Background track
            Circle()
                .stroke(effectiveTrackColor, lineWidth: size.circularLineWidth)
                .frame(width: size.circularDiameter, height: size.circularDiameter)
            
            if isIndeterminate {
                // Indeterminate circular progress
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(effectiveColor, lineWidth: size.circularLineWidth)
                    .frame(width: size.circularDiameter, height: size.circularDiameter)
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false), value: isAnimating)
            } else {
                // Determinate circular progress
                Circle()
                    .trim(from: 0, to: CGFloat(value))
                    .stroke(effectiveColor, lineWidth: size.circularLineWidth)
                    .frame(width: size.circularDiameter, height: size.circularDiameter)
                    .rotationEffect(Angle(degrees: -90))
            }
            
            // Percentage label (only for circular style with showPercentage and not indeterminate)
            if showPercentage && !isIndeterminate && labelPosition == .center {
                Text("\(Int(value * 100))%")
                    .font(size.font)
                    .foregroundColor(theme.text)
            }
        }
        .frame(width: size.circularDiameter, height: size.circularDiameter)
    }
    
    /// Label view
    private var labelView: some View {
        HStack(spacing: CTSpacing.xs) {
            if let label = label {
                Text(label)
                    .font(size.font)
                    .foregroundColor(theme.text)
            }
            
            if showPercentage && !isIndeterminate && labelPosition != .center {
                Text("\(Int(value * 100))%")
                    .font(size.font)
                    .foregroundColor(theme.textSecondary)
            }
        }
    }
    
    // MARK: - Private Properties
    
    /// Calculate the width of the progress bar based on the value
    private var progressWidth: CGFloat {
        if isIndeterminate {
            return UIScreen.main.bounds.width * 0.3 // 30% of screen width for indeterminate state
        } else {
            return UIScreen.main.bounds.width * CGFloat(value)
        }
    }
    
    /// Offset for indeterminate animation
    private var indeterminateOffset: CGFloat {
        isAnimating ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width * 0.3
    }
    
    /// The effective color of the progress indicator
    private var effectiveColor: Color {
        color ?? theme.primary
    }
    
    /// The effective track color of the progress indicator
    private var effectiveTrackColor: Color {
        trackColor ?? effectiveColor.opacity(0.2)
    }
    
    /// The accessibility label for the progress indicator
    private var accessibilityLabel: String {
        if let label = label {
            return label
        } else {
            return isIndeterminate ? "Loading" : "Progress"
        }
    }
    
    /// The accessibility value for the progress indicator
    private var accessibilityValue: String {
        if isIndeterminate {
            return "In progress"
        } else {
            return "\(Int(value * 100)) percent"
        }
    }
}

// MARK: - Supporting Types

/// The style of the progress indicator
public enum CTProgressStyle {
    /// Linear progress bar (horizontal)
    case linear
    
    /// Circular progress indicator
    case circular
}

/// The size of the progress indicator
public enum CTProgressSize {
    /// Small progress indicator
    case small
    
    /// Medium progress indicator (default)
    case medium
    
    /// Large progress indicator
    case large
    
    /// Custom size for the progress indicator
    case custom(linearHeight: CGFloat, circularDiameter: CGFloat, circularLineWidth: CGFloat, font: Font)
    
    /// The height of a linear progress bar
    var linearHeight: CGFloat {
        switch self {
        case .small:
            return 4
        case .medium:
            return 8
        case .large:
            return 12
        case .custom(let linearHeight, _, _, _):
            return linearHeight
        }
    }
    
    /// The diameter of a circular progress indicator
    var circularDiameter: CGFloat {
        switch self {
        case .small:
            return 24
        case .medium:
            return 48
        case .large:
            return 80
        case .custom(_, let circularDiameter, _, _):
            return circularDiameter
        }
    }
    
    /// The line width of a circular progress indicator
    var circularLineWidth: CGFloat {
        switch self {
        case .small:
            return 2
        case .medium:
            return 4
        case .large:
            return 6
        case .custom(_, _, let circularLineWidth, _):
            return circularLineWidth
        }
    }
    
    /// The font for labels and percentages
    var font: Font {
        switch self {
        case .small:
            return CTTypography.captionSmall()
        case .medium:
            return CTTypography.caption()
        case .large:
            return CTTypography.body()
        case .custom(_, _, _, let font):
            return font
        }
    }
}

/// The position of the label relative to the progress indicator
public enum CTProgressLabelPosition {
    /// Label appears above the progress indicator
    case top
    
    /// Label appears below the progress indicator
    case bottom
    
    /// Label appears in the center of the progress indicator (only applicable to circular style)
    case center
}

// MARK: - Previews

struct CTProgress_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(spacing: CTSpacing.m) {
                Text("Linear Progress").ctHeading2()
                
                CTProgress(value: 0.25, label: "25% Complete")
                CTProgress(value: 0.5, label: "50% Complete")
                CTProgress(value: 0.75, label: "75% Complete")
                CTProgress(value: 1.0, label: "100% Complete")
                
                CTProgress(value: 0.6, showPercentage: true)
                
                CTProgress(label: "Loading...", isIndeterminate: true)
            }
            .padding()
            .previewDisplayName("Linear Progress")
            
            VStack(spacing: CTSpacing.m) {
                Text("Circular Progress").ctHeading2()
                
                HStack(spacing: CTSpacing.l) {
                    CTProgress(value: 0.25, style: .circular)
                    CTProgress(value: 0.5, style: .circular)
                    CTProgress(value: 0.75, style: .circular)
                    CTProgress(value: 1.0, style: .circular)
                }
                
                HStack(spacing: CTSpacing.l) {
                    CTProgress(value: 0.6, style: .circular, showPercentage: true, labelPosition: .center)
                    CTProgress(style: .circular, isIndeterminate: true)
                    CTProgress(value: 0.8, style: .circular, label: "Loading", showPercentage: true)
                }
            }
            .padding()
            .previewDisplayName("Circular Progress")
            
            VStack(spacing: CTSpacing.m) {
                Text("Progress Sizes").ctHeading2()
                
                CTProgress(value: 0.5, size: .small, label: "Small")
                CTProgress(value: 0.5, size: .medium, label: "Medium")
                CTProgress(value: 0.5, size: .large, label: "Large")
                
                HStack(spacing: CTSpacing.l) {
                    CTProgress(value: 0.5, style: .circular, size: .small)
                    CTProgress(value: 0.5, style: .circular, size: .medium)
                    CTProgress(value: 0.5, style: .circular, size: .large)
                }
            }
            .padding()
            .previewDisplayName("Progress Sizes")
            
            VStack(spacing: CTSpacing.m) {
                Text("Progress Colors").ctHeading2()
                
                CTProgress(value: 0.5, color: .ctPrimary, label: "Primary")
                CTProgress(value: 0.5, color: .ctSecondary, label: "Secondary")
                CTProgress(value: 0.5, color: .ctSuccess, label: "Success")
                CTProgress(value: 0.5, color: .ctDestructive, label: "Destructive")
                CTProgress(value: 0.5, color: .ctWarning, label: "Warning")
                
                HStack(spacing: CTSpacing.l) {
                    CTProgress(value: 0.5, style: .circular, color: .ctPrimary)
                    CTProgress(value: 0.5, style: .circular, color: .ctSuccess)
                    CTProgress(value: 0.5, style: .circular, color: .ctDestructive)
                }
            }
            .padding()
            .previewDisplayName("Progress Colors")
            
            VStack(spacing: CTSpacing.m) {
                Text("Label Positions").ctHeading2()
                
                CTProgress(value: 0.5, label: "Top Label", labelPosition: .top)
                CTProgress(value: 0.5, label: "Bottom Label", labelPosition: .bottom)
                
                HStack(spacing: CTSpacing.l) {
                    CTProgress(value: 0.5, style: .circular, label: "Top", labelPosition: .top)
                    CTProgress(value: 0.5, style: .circular, showPercentage: true, labelPosition: .center)
                    CTProgress(value: 0.5, style: .circular, label: "Bottom", labelPosition: .bottom)
                }
            }
            .padding()
            .previewDisplayName("Label Positions")
        }
    }
}

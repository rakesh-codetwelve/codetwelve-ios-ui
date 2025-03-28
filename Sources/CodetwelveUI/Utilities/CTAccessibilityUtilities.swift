//
//  CTAccessibilityUtilities.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI
import Combine

/// Utilities for accessibility in CodeTwelve UI
///
/// This enum provides utilities for working with accessibility settings and features
/// in iOS. It helps components adapt their appearance and behavior based on user
/// accessibility preferences.
public enum CTAccessibilityUtilities {
    // MARK: - System Settings Detection
    
    /// Check if high contrast mode is enabled
    ///
    /// High contrast mode increases the contrast of UI elements to make them
    /// more visible for users with visual impairments.
    ///
    /// # Example
    ///
    /// ```swift
    /// if CTAccessibilityUtilities.isHighContrastEnabled {
    ///     // Use high contrast colors
    /// } else {
    ///     // Use standard colors
    /// }
    /// ```
    ///
    /// - Returns: True if high contrast mode is enabled, false otherwise
    public static var isHighContrastEnabled: Bool {
        UIAccessibility.isDarkerSystemColorsEnabled
    }
    
    /// Check if bold text is enabled
    ///
    /// Bold text mode makes text thicker and easier to read for users
    /// with visual impairments.
    ///
    /// # Example
    ///
    /// ```swift
    /// if CTAccessibilityUtilities.isBoldTextEnabled {
    ///     // Use even bolder text or adjust spacing
    /// }
    /// ```
    ///
    /// - Returns: True if bold text is enabled, false otherwise
    public static var isBoldTextEnabled: Bool {
        UIAccessibility.isBoldTextEnabled
    }
    
    /// Check if reduced motion is enabled
    ///
    /// Reduced motion minimizes animations and motion effects for users
    /// who are sensitive to motion or suffer from motion sickness.
    ///
    /// # Example
    ///
    /// ```swift
    /// if CTAccessibilityUtilities.isReducedMotionEnabled {
    ///     // Skip animations or use simpler ones
    /// } else {
    ///     // Use full animations
    /// }
    /// ```
    ///
    /// - Returns: True if reduced motion is enabled, false otherwise
    public static var isReducedMotionEnabled: Bool {
        UIAccessibility.isReduceMotionEnabled
    }
    
    /// Check if reduced transparency is enabled
    ///
    /// Reduced transparency decreases the translucency and blur effects
    /// to improve legibility for users with visual impairments.
    ///
    /// # Example
    ///
    /// ```swift
    /// if CTAccessibilityUtilities.isReducedTransparencyEnabled {
    ///     // Use solid backgrounds instead of transparent ones
    /// } else {
    ///     // Use standard transparency effects
    /// }
    /// ```
    ///
    /// - Returns: True if reduced transparency is enabled, false otherwise
    public static var isReducedTransparencyEnabled: Bool {
        UIAccessibility.isReduceTransparencyEnabled
    }
    
    /// Check if VoiceOver is running
    ///
    /// VoiceOver is a screen reader that allows users with visual impairments
    /// to navigate the UI by having elements read aloud to them.
    ///
    /// # Example
    ///
    /// ```swift
    /// if CTAccessibilityUtilities.isVoiceOverRunning {
    ///     // Provide additional context or adjust UI for VoiceOver
    /// }
    /// ```
    ///
    /// - Returns: True if VoiceOver is running, false otherwise
    public static var isVoiceOverRunning: Bool {
        UIAccessibility.isVoiceOverRunning
    }
    
    /// Check if Switch Control is running
    ///
    /// Switch Control allows users with motor impairments to navigate the UI
    /// using external switches or devices.
    ///
    /// # Example
    ///
    /// ```swift
    /// if CTAccessibilityUtilities.isSwitchControlRunning {
    ///     // Adjust UI for easier switch control navigation
    /// }
    /// ```
    ///
    /// - Returns: True if Switch Control is running, false otherwise
    public static var isSwitchControlRunning: Bool {
        UIAccessibility.isSwitchControlRunning
    }
    
    // MARK: - Adaptive Content
    
    /// Get appropriate text for VoiceOver based on loading state
    ///
    /// This method returns an accessibility label that includes loading state
    /// information when applicable.
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Submit")
    ///     .accessibilityLabel(
    ///         CTAccessibilityUtilities.loadingStateLabel(
    ///             isLoading: isLoading,
    ///             baseLabel: "Submit"
    ///         )
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - isLoading: Whether the component is in loading state
    ///   - baseLabel: The base accessibility label
    /// - Returns: The appropriate accessibility label
    public static func loadingStateLabel(isLoading: Bool, baseLabel: String) -> String {
        isLoading ? "\(baseLabel), Loading" : baseLabel
    }
    
    /// Get the appropriate color for high contrast if needed
    ///
    /// This method returns the high contrast color if high contrast mode is enabled,
    /// otherwise it returns the normal color.
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Hello")
    ///     .foregroundColor(
    ///         CTAccessibilityUtilities.adaptiveColor(
    ///             normalColor: .blue,
    ///             highContrastColor: .white
    ///         )
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - normalColor: The normal color
    ///   - highContrastColor: The high contrast color
    /// - Returns: The appropriate color based on system settings
    public static func adaptiveColor(normalColor: Color, highContrastColor: Color) -> Color {
        isHighContrastEnabled ? highContrastColor : normalColor
    }
    
    /// Get the appropriate font weight based on bold text setting
    ///
    /// This method returns a heavier font weight if bold text is enabled,
    /// otherwise it returns the normal weight.
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Hello")
    ///     .fontWeight(
    ///         CTAccessibilityUtilities.adaptiveFontWeight(
    ///             normalWeight: .regular,
    ///             boldWeight: .semibold
    ///         )
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - normalWeight: The normal font weight
    ///   - boldWeight: The bold font weight
    /// - Returns: The appropriate font weight based on system settings
    public static func adaptiveFontWeight(normalWeight: Font.Weight, boldWeight: Font.Weight) -> Font.Weight {
        isBoldTextEnabled ? boldWeight : normalWeight
    }
    
    /// Get the appropriate text size based on Dynamic Type settings
    ///
    /// This method adjusts text sizes to ensure they remain readable with Dynamic Type.
    ///
    /// # Example
    ///
    /// ```swift
    /// let fontSize = CTAccessibilityUtilities.adaptiveTextSize(baseSize: 16, minSize: 14, maxSize: 24)
    /// ```
    ///
    /// - Parameters:
    ///   - baseSize: The base text size
    ///   - minSize: The minimum text size (optional)
    ///   - maxSize: The maximum text size (optional)
    /// - Returns: The adjusted text size
    public static func adaptiveTextSize(baseSize: CGFloat, minSize: CGFloat? = nil, maxSize: CGFloat? = nil) -> CGFloat {
        let contentSizeCategory = UIApplication.shared.preferredContentSizeCategory
        let scaleFactor = dynamicTypeScaleFactor(for: contentSizeCategory)
        
        var scaledSize = baseSize * scaleFactor
        
        if let minSize = minSize {
            scaledSize = max(scaledSize, minSize)
        }
        
        if let maxSize = maxSize {
            scaledSize = min(scaledSize, maxSize)
        }
        
        return scaledSize
    }
    
    /// Get the dynamic type scale factor for a content size category
    ///
    /// This method returns a scaling factor based on the user's preferred content size.
    ///
    /// - Parameter category: The content size category
    /// - Returns: A scaling factor for text and UI elements
    private static func dynamicTypeScaleFactor(for category: UIContentSizeCategory) -> CGFloat {
        switch category {
        case .accessibilityExtraExtraExtraLarge: return 4.0
        case .accessibilityExtraExtraLarge: return 3.5
        case .accessibilityExtraLarge: return 3.0
        case .accessibilityLarge: return 2.5
        case .accessibilityMedium: return 2.0
        case .extraExtraExtraLarge: return 1.5
        case .extraExtraLarge: return 1.35
        case .extraLarge: return 1.2
        case .large: return 1.1
        case .medium: return 1.0
        case .small: return 0.9
        case .extraSmall: return 0.8
        default: return 1.0
        }
    }
    
    // MARK: - Accessibility Announcements
    
    /// Post an accessibility announcement
    ///
    /// This method announces a message to VoiceOver users. It's useful for notifying
    /// users of important changes that aren't visually apparent.
    ///
    /// # Example
    ///
    /// ```swift
    /// // After successfully saving a form
    /// CTAccessibilityUtilities.announce("Form saved successfully")
    /// ```
    ///
    /// - Parameters:
    ///   - message: The message to announce
    ///   - delay: Optional delay before the announcement (in seconds)
    public static func announce(_ message: String, delay: TimeInterval = 0.1) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIAccessibility.post(notification: .announcement, argument: message)
        }
    }
    
    /// Notify screen readers of a layout change
    ///
    /// This method notifies VoiceOver users of a layout change and optionally
    /// moves the focus to a specific element.
    ///
    /// # Example
    ///
    /// ```swift
    /// // After displaying a new view
    /// CTAccessibilityUtilities.notifyLayoutChange()
    /// ```
    ///
    /// - Parameter element: Optional element to focus after the layout change
    public static func notifyLayoutChange(focusOn element: Any? = nil) {
        UIAccessibility.post(notification: .layoutChanged, argument: element)
    }
    
    /// Notify screen readers of a screen change
    ///
    /// This method notifies VoiceOver users of a major screen change and optionally
    /// moves the focus to a specific element.
    ///
    /// # Example
    ///
    /// ```swift
    /// // After navigating to a new screen
    /// CTAccessibilityUtilities.notifyScreenChange()
    /// ```
    ///
    /// - Parameter element: Optional element to focus after the screen change
    public static func notifyScreenChange(focusOn element: Any? = nil) {
        UIAccessibility.post(notification: .screenChanged, argument: element)
    }
    
    // MARK: - Accessibility Labels and Descriptions
    
    /// Generate an accessibility label for an error state
    ///
    /// This method generates an accessibility label that includes error information.
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Email")
    ///     .accessibilityLabel(
    ///         CTAccessibilityUtilities.errorStateLabel(
    ///             fieldName: "Email",
    ///             errorMessage: emailError
    ///         )
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - fieldName: The name of the field or component
    ///   - errorMessage: The error message, if any
    /// - Returns: An appropriate accessibility label
    public static func errorStateLabel(fieldName: String, errorMessage: String?) -> String {
        if let error = errorMessage, !error.isEmpty {
            return "\(fieldName), Error: \(error)"
        } else {
            return fieldName
        }
    }
    
    /// Generate an accessibility label for a numeric value with unit
    ///
    /// This method generates an accessibility label for a numeric value with its unit.
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("$99.99")
    ///     .accessibilityLabel(
    ///         CTAccessibilityUtilities.numericValueLabel(
    ///             value: 99.99,
    ///             unit: "dollars"
    ///         )
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - value: The numeric value
    ///   - unit: The unit of measurement
    ///   - formatter: Optional number formatter
    /// - Returns: An appropriate accessibility label
    public static func numericValueLabel(value: Double, unit: String, formatter: NumberFormatter? = nil) -> String {
        let valueString: String
        
        if let formatter = formatter {
            valueString = formatter.string(from: NSNumber(value: value)) ?? "\(value)"
        } else {
            valueString = "\(value)"
        }
        
        return "\(valueString) \(unit)"
    }
    
    /// Generate an accessibility label for a progress indicator
    ///
    /// This method generates an accessibility label for a progress indicator.
    ///
    /// # Example
    ///
    /// ```swift
    /// ProgressView(value: progress)
    ///     .accessibilityLabel(
    ///         CTAccessibilityUtilities.progressLabel(
    ///             value: progress,
    ///             total: 1.0,
    ///             label: "Download"
    ///         )
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - value: The current progress value
    ///   - total: The total progress value
    ///   - label: A descriptive label for the progress
    /// - Returns: An appropriate accessibility label
    public static func progressLabel(value: Double, total: Double, label: String) -> String {
        let percentage = Int((value / total) * 100)
        return "\(label) \(percentage)% complete"
    }
    
    /// Subscribe to accessibility setting changes
    ///
    /// This method allows components to react to changes in accessibility settings.
    ///
    /// # Example
    ///
    /// ```swift
    /// .onAppear {
    ///     cancellable = CTAccessibilityUtilities.observeAccessibilityChanges { notification in
    ///         // Update UI based on changes
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter handler: A closure to handle accessibility changes
    /// - Returns: A cancellable subscription
    public static func observeAccessibilityChanges(handler: @escaping (Notification) -> Void) -> AnyCancellable {
        return NotificationCenter.default.publisher(for: UIAccessibility.voiceOverStatusDidChangeNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIAccessibility.boldTextStatusDidChangeNotification))
            .merge(with: NotificationCenter.default.publisher(for: UIAccessibility.darkerSystemColorsStatusDidChangeNotification))
            .merge(with: NotificationCenter.default.publisher(for: UIAccessibility.reduceMotionStatusDidChangeNotification))
            .merge(with: NotificationCenter.default.publisher(for: UIAccessibility.reduceTransparencyStatusDidChangeNotification))
            .merge(with: NotificationCenter.default.publisher(for: UIAccessibility.switchControlStatusDidChangeNotification))
            .sink(receiveValue: handler)
    }
}

// MARK: - View Modifiers

/// A view modifier that adapts a view based on accessibility settings
///
/// This modifier applies different transformations to a view based on
/// various accessibility settings.
public struct CTAccessibilityAdaptiveModifier<Content: View>: ViewModifier {
    // MARK: - Type Aliases
    
    /// The type of view representing the body of this view modifier
    public typealias Body = Never
    
    // MARK: - Properties
    private let content: Content
    private let highContrastTransform: ((Content) -> Content)?
    private let boldTextTransform: ((Content) -> Content)?
    private let reducedMotionTransform: ((Content) -> Content)?
    private let voiceOverTransform: ((Content) -> Content)?
    
    // MARK: - Environment
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.accessibilityEnabled) private var accessibilityEnabled
    
    // MARK: - Initialization
    public init(
        content: Content,
        highContrast: ((Content) -> Content)? = nil,
        boldText: ((Content) -> Content)? = nil,
        reducedMotion: ((Content) -> Content)? = nil,
        voiceOver: ((Content) -> Content)? = nil
    ) {
        self.content = content
        self.highContrastTransform = highContrast
        self.boldTextTransform = boldText
        self.reducedMotionTransform = reducedMotion
        self.voiceOverTransform = voiceOver
    }
    
    // MARK: - ViewModifier Implementation
    public func body(content: Content) -> Never {
        fatalError("This modifier should not be used directly. Use the View extension methods instead.")
    }
}

// MARK: - View Extensions for Accessibility Adapting

public extension View {
    /// Adapt the view based on accessibility settings
    ///
    /// This method applies different transformations to a view based on
    /// various accessibility settings.
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Hello, World!")
    ///     .ctAccessibilityAdapt(
    ///         highContrast: { $0.foregroundColor(.white) },
    ///         boldText: { $0.fontWeight(.bold) },
    ///         reducedMotion: { $0.animation(.none) },
    ///         voiceOver: { $0.accessibilityLabel("Greeting") }
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - highContrast: Transformation to apply when high contrast is enabled
    ///   - boldText: Transformation to apply when bold text is enabled
    ///   - reducedMotion: Transformation to apply when reduced motion is enabled
    ///   - voiceOver: Transformation to apply when VoiceOver is running
    /// - Returns: The adapted view
    func ctAccessibilityAdapt(
        highContrast: ((Self) -> Self)? = nil,
        boldText: ((Self) -> Self)? = nil,
        reducedMotion: ((Self) -> Self)? = nil,
        voiceOver: ((Self) -> Self)? = nil
    ) -> some View {
        return self.modifier(CTAccessibilityAdaptiveModifier(
            content: self,
            highContrast: highContrast,
            boldText: boldText,
            reducedMotion: reducedMotion,
            voiceOver: voiceOver
        ))
    }
    
    /// Apply high contrast settings to a view
    ///
    /// This method adapts a view specifically for high contrast mode.
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Hello, World!")
    ///     .ctHighContrastAdapt { content in
    ///         content
    ///             .foregroundColor(.white)
    ///             .background(Color.black)
    ///     }
    /// ```
    ///
    /// - Parameter transform: Transformation to apply when high contrast is enabled
    /// - Returns: The adapted view
    func ctHighContrastAdapt(_ transform: @escaping (Self) -> Self) -> some View {
        return self.modifier(CTAccessibilityAdaptiveModifier(
            content: self,
            highContrast: transform
        ))
    }
    
    /// Apply bold text settings to a view
    ///
    /// This method adapts a view specifically for bold text mode.
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Hello, World!")
    ///     .ctBoldTextAdapt { content in
    ///         content
    ///             .fontWeight(.heavy)
    ///     }
    /// ```
    ///
    /// - Parameter transform: Transformation to apply when bold text is enabled
    /// - Returns: The adapted view
    func ctBoldTextAdapt(_ transform: @escaping (Self) -> Self) -> some View {
        return self.modifier(CTAccessibilityAdaptiveModifier(
            content: self,
            boldText: transform
        ))
    }
    
    /// Apply reduced motion settings to a view
    ///
    /// This method adapts a view specifically for reduced motion mode.
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Hello, World!")
    ///     .transition(.scale)
    ///     .animation(.easeInOut)
    ///     .ctReducedMotionAdapt { content in
    ///         content
    ///             .transition(.opacity)
    ///             .animation(.none)
    ///     }
    /// ```
    ///
    /// - Parameter transform: Transformation to apply when reduced motion is enabled
    /// - Returns: The adapted view
    func ctReducedMotionAdapt(_ transform: @escaping (Self) -> Self) -> some View {
        return self.modifier(CTAccessibilityAdaptiveModifier(
            content: self,
            reducedMotion: transform
        ))
    }
    
    /// Apply VoiceOver settings to a view
    ///
    /// This method adapts a view specifically for VoiceOver mode.
    ///
    /// # Example
    ///
    /// ```swift
    /// Image("decorative")
    ///     .ctVoiceOverAdapt { content in
    ///         content
    ///             .accessibilityHidden(true)
    ///     }
    /// ```
    ///
    /// - Parameter transform: Transformation to apply when VoiceOver is running
    /// - Returns: The adapted view
    func ctVoiceOverAdapt(_ transform: @escaping (Self) -> Self) -> some View {
        return self.modifier(CTAccessibilityAdaptiveModifier(
            content: self,
            voiceOver: transform
        ))
    }
    
    /// Use alternative text for VoiceOver
    ///
    /// This method provides alternative text for VoiceOver users.
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Hello 👋")
    ///     .ctVoiceOverAlternativeText("Hello, waving hand")
    /// ```
    ///
    /// - Parameter text: The alternative text for VoiceOver
    /// - Returns: The view with VoiceOver-specific text
    func ctVoiceOverAlternativeText(_ text: String) -> some View {
        return self.ctVoiceOverAdapt { content in
            content.accessibilityLabel(text) as! Self
        }
    }
    
    /// Apply increased tap area for accessibility
    ///
    /// This method increases the tappable area of a view to improve accessibility
    /// for users with motor impairments.
    ///
    /// # Example
    ///
    /// ```swift
    /// Button("Tap me") { }
    ///     .ctIncreasedTapArea()
    /// ```
    ///
    /// - Parameter amount: The amount to increase the tap area by (default: 44)
    /// - Returns: The view with an increased tap area
    func ctIncreasedTapArea(by amount: CGFloat = 44) -> some View {
        return self
            .contentShape(Rectangle())
            .frame(minWidth: amount, minHeight: amount)
    }
}

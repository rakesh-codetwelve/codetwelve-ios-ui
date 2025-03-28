//
//  CTAnimations.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// Animation presets for the CodeTwelve UI design system
///
/// This enum provides a set of predefined animations with consistent durations and curves,
/// as well as semantic animation presets for specific UI interactions. These animations
/// are designed to be subtle, meaningful, and respect accessibility settings.
///
/// # Usage
///
/// Animations can be applied to views using the `.ctAnimation()` extension:
///
/// ```swift
/// Button("Tap me") {
///     isExpanded.toggle()
/// }
/// .scaleEffect(isExpanded ? 1.1 : 1.0)
/// .ctAnimation(CTAnimation.buttonPress)
/// ```
///
/// For custom animations, you can use the base duration and curve values:
///
/// ```swift
/// .animation(Animation.easeInOut(duration: CTAnimation.durationMedium), value: someState)
/// ```
public enum CTAnimation {
    // MARK: - Durations
    
    /// Very quick duration for micro-interactions (150ms)
    public static let durationQuick: Double = 0.15
    
    /// Standard duration for most UI animations (300ms)
    public static let durationMedium: Double = 0.3
    
    /// Slow duration for more pronounced animations (500ms)
    public static let durationSlow: Double = 0.5
    
    // MARK: - Base Animations
    
    /// Standard easeInOut animation with medium duration
    public static let easeInOut = Animation.easeInOut(duration: durationMedium)
    
    /// EaseOut animation with medium duration, good for entrances
    public static let easeOut = Animation.easeOut(duration: durationMedium)
    
    /// EaseIn animation with medium duration, good for exits
    public static let easeIn = Animation.easeIn(duration: durationMedium)
    
    /// Spring animation with medium bounciness, good for natural movements
    public static let spring = Animation.spring(response: 0.3, dampingFraction: 0.6)
    
    /// Quick spring animation with less bounciness, good for responsive UI elements
    public static let quickSpring = Animation.spring(response: 0.2, dampingFraction: 0.7)
    
    // MARK: - Semantic Animations
    
    /// Animation for button press interactions
    public static let buttonPress = Animation.easeOut(duration: durationQuick)
    
    /// Animation for elements fading in
    public static let fadeIn = Animation.easeOut(duration: durationMedium)
    
    /// Animation for elements fading out
    public static let fadeOut = Animation.easeIn(duration: durationMedium)
    
    /// Animation for elements sliding in
    public static let slideIn = Animation.spring(response: 0.5, dampingFraction: 0.7)
    
    /// Animation for elements expanding
    public static let expand = Animation.spring(response: 0.4, dampingFraction: 0.6)
    
    /// Animation for elements contracting
    public static let contract = Animation.spring(response: 0.3, dampingFraction: 0.7)
    
    /// Animation for showing toasts or alerts
    public static let popup = Animation.spring(response: 0.35, dampingFraction: 0.65)
    
    /// Animation for dismissing toasts or alerts
    public static let dismiss = Animation.easeIn(duration: durationQuick)
    
    /// Animation for page transitions
    public static let page = Animation.spring(response: 0.5, dampingFraction: 0.8)
    
    /// Animation for attention-grabbing elements
    public static let attention = Animation.spring(response: 0.3, dampingFraction: 0.5)
    
    // MARK: - Accessibility Adjustments
    
    /// Returns a modified animation respecting reduced motion preferences
    /// - Parameter animation: The original animation to modify
    /// - Returns: The animation adjusted for accessibility or nil if animations should be disabled
    public static func respectingReducedMotion(_ animation: Animation) -> Animation? {
        if UIAccessibility.isReduceMotionEnabled {
            // Provide a simplified animation for reduced motion
            return Animation.easeOut(duration: durationQuick)
        }
        return animation
    }
    
    /// Returns a modified duration respecting reduced motion preferences
    /// - Parameter duration: The original duration
    /// - Returns: The adjusted duration for accessibility
    public static func respectingReducedMotion(duration: Double) -> Double {
        if UIAccessibility.isReduceMotionEnabled {
            // Return a quicker duration for reduced motion
            return min(duration, durationQuick)
        }
        return duration
    }
}
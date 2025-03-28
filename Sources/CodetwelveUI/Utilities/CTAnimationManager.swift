//
//  CTAnimationManager.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI
import Combine

/// Manager for controlling animations globally throughout the CodeTwelve UI library
///
/// The animation manager respects system accessibility settings like reduced motion
/// and provides a centralized control point for enabling or disabling animations.
///
/// # Usage
///
/// The manager can be used to check if animations are enabled:
///
/// ```swift
/// if CTAnimationManager.shared.isAnimationEnabled {
///     // Apply animations
/// }
/// ```
///
/// Or to manually control animation state:
///
/// ```swift
/// // Disable animations globally
/// CTAnimationManager.shared.setAnimationsEnabled(false)
/// ```
public class CTAnimationManager: ObservableObject {
    /// Shared instance of the animation manager
    public static let shared = CTAnimationManager()
    
    /// Whether animations are currently enabled globally
    @Published public private(set) var isAnimationEnabled: Bool = true
    
    /// Whether animations should respect reduced motion settings
    @Published public private(set) var respectReducedMotion: Bool = true
    
    /// Initialize the animation manager
    private init() {
        // Check for reduced motion setting
        updateFromAccessibilitySettings()
        
        // Listen for changes to reduce motion setting
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(accessibilitySettingsChanged),
            name: UIAccessibility.reduceMotionStatusDidChangeNotification,
            object: nil
        )
    }
    
    /// Update animation settings based on system accessibility settings
    private func updateFromAccessibilitySettings() {
        if respectReducedMotion && UIAccessibility.isReduceMotionEnabled {
            isAnimationEnabled = false
        }
    }
    
    /// Handle changes to system accessibility settings
    @objc private func accessibilitySettingsChanged() {
        updateFromAccessibilitySettings()
    }
    
    /// Enable or disable animations globally
    /// - Parameter enabled: Whether animations should be enabled
    public func setAnimationsEnabled(_ enabled: Bool) {
        isAnimationEnabled = enabled
    }
    
    /// Set whether to respect the system's reduced motion setting
    /// - Parameter respect: Whether to respect reduced motion
    public func setRespectReducedMotion(_ respect: Bool) {
        respectReducedMotion = respect
        updateFromAccessibilitySettings()
    }
    
    /// Get an animation respecting the current settings
    /// - Parameter animation: The original animation
    /// - Returns: The animation if enabled, or nil if animations are disabled
    public func animation(_ animation: Animation) -> Animation? {
        guard isAnimationEnabled else { return nil }
        
        if respectReducedMotion && UIAccessibility.isReduceMotionEnabled {
            return CTAnimation.respectingReducedMotion(animation)
        }
        
        return animation
    }
    
    /// Get a duration value respecting the current settings
    /// - Parameter duration: The original duration
    /// - Returns: The adjusted duration based on current settings
    public func duration(_ duration: Double) -> Double {
        guard isAnimationEnabled else { return 0 }
        
        if respectReducedMotion && UIAccessibility.isReduceMotionEnabled {
            return CTAnimation.respectingReducedMotion(duration: duration)
        }
        
        return duration
    }
}
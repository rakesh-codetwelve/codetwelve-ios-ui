//
//  View+Animation.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// Extensions for applying CodeTwelve animations to SwiftUI views
public extension View {
    /// Apply a CodeTwelve animation respecting accessibility settings
    ///
    /// This method applies a standard CodeTwelve animation to a view, respecting
    /// the global animation settings and accessibility preferences.
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Animated Text")
    ///     .opacity(isVisible ? 1 : 0)
    ///     .ctAnimation(CTAnimation.fadeIn, value: isVisible)
    /// ```
    ///
    /// - Parameters:
    ///   - animation: The animation to apply
    ///   - value: The value to track for animation changes
    /// - Returns: The view with the animation applied
    func ctAnimation<Value: Equatable>(_ animation: Animation, value: Value) -> some View {
        let finalAnimation = CTAnimationManager.shared.animation(animation)
        return self.animation(finalAnimation, value: value)
    }
    
    /// Apply a CodeTwelve animation with a custom animation block
    ///
    /// This method is useful for more complex animation scenarios where a custom
    /// animation is needed, while still respecting accessibility settings.
    ///
    /// # Example
    ///
    /// ```swift
    /// Button("Animate") {
    ///     withCtAnimation(CTAnimation.expand) {
    ///         self.scale += 0.2
    ///         self.opacity = 1
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - animation: The animation to apply
    ///   - action: The action to perform with animation
    /// - Returns: The view
    func withCtAnimation(_ animation: Animation, _ action: @escaping () -> Void) -> some View {
        return self.onTapGesture {
            if let finalAnimation = CTAnimationManager.shared.animation(animation) {
                withAnimation(finalAnimation) {
                    action()
                }
            } else {
                // If animations are disabled, still perform the action but without animation
                action()
            }
        }
    }
    
    /// Apply a transition with CodeTwelve animation
    ///
    /// This method applies a transition with a CodeTwelve animation, respecting
    /// accessibility settings.
    ///
    /// # Example
    ///
    /// ```swift
    /// if showDetail {
    ///     DetailView()
    ///         .ctTransition(.slide, animation: CTAnimation.slideIn)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - transition: The transition to apply
    ///   - animation: The animation to use with the transition
    /// - Returns: The view with the transition applied
    func ctTransition(_ transition: AnyTransition, animation: Animation) -> some View {
        let finalAnimation = CTAnimationManager.shared.animation(animation)
        return self.transition(transition).animation(finalAnimation)
    }
}

/// Extension for View transitions with default animations
public extension View {
    /// Apply a fade transition with CodeTwelve animation
    ///
    /// - Returns: The view with a fade transition
    func ctFadeTransition() -> some View {
        self.ctTransition(.opacity, animation: CTAnimation.fadeIn)
    }
    
    /// Apply a slide transition with CodeTwelve animation
    ///
    /// - Parameter edge: The edge to slide from
    /// - Returns: The view with a slide transition
    func ctSlideTransition(edge: Edge = .trailing) -> some View {
        self.ctTransition(.move(edge: edge), animation: CTAnimation.slideIn)
    }
    
    /// Apply a scale transition with CodeTwelve animation
    ///
    /// - Returns: The view with a scale transition
    func ctScaleTransition() -> some View {
        self.ctTransition(.scale, animation: CTAnimation.expand)
    }
}
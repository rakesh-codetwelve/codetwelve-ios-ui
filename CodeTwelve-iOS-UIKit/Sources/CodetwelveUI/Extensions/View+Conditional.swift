//
//  View+Conditional.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// Extensions for applying conditional modifiers to SwiftUI views
public extension View {
    /// Apply a modifier conditionally
    ///
    /// This method allows a view modifier to be applied conditionally based on a boolean value.
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Conditional Styling")
    ///     .ctConditional(isHighlighted) { view in
    ///         view.foregroundColor(.ctPrimary)
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - condition: The condition that determines if the modifier should be applied
    ///   - transform: The transform to apply to the view when the condition is true
    /// - Returns: The modified view if the condition is true, otherwise the original view
    @ViewBuilder func ctConditional<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// Apply a modifier based on an optional value
    ///
    /// This method allows a view modifier to be applied based on an optional value.
    /// The transform is only applied if the value is non-nil.
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Optional Styling")
    ///     .ctIfLet(optionalColor) { view, color in
    ///         view.foregroundColor(color)
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - value: The optional value
    ///   - transform: The transform to apply to the view when the value is non-nil
    /// - Returns: The modified view if the value is non-nil, otherwise the original view
    @ViewBuilder func ctIfLet<T, Content: View>(
        _ value: T?,
        transform: (Self, T) -> Content
    ) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
    
    /// Apply different modifiers based on a condition
    ///
    /// This method allows different view modifiers to be applied based on a boolean condition.
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Conditional Styling")
    ///     .ctIfElse(isDarkMode) { view in
    ///         view.foregroundColor(.white)
    ///     } else: { view in
    ///         view.foregroundColor(.black)
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - condition: The condition that determines which transform to apply
    ///   - ifTransform: The transform to apply when the condition is true
    ///   - elseTransform: The transform to apply when the condition is false
    /// - Returns: The view with the appropriate transform applied
    @ViewBuilder func ctIfElse<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if ifTransform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }
    
    /// Apply a modifier only in debug builds
    ///
    /// This method allows a view modifier to be applied only in debug builds.
    /// It's useful for debug-only UI elements or styling.
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Debug Info")
    ///     .ctDebugOnly { view in
    ///         view.border(Color.red)
    ///             .overlay(Text("DEBUG").font(.caption))
    ///     }
    /// ```
    ///
    /// - Parameter transform: The transform to apply in debug builds
    /// - Returns: The modified view in debug builds, otherwise the original view
    @ViewBuilder func ctDebugOnly<Content: View>(
        transform: (Self) -> Content
    ) -> some View {
        #if DEBUG
        transform(self)
        #else
        self
        #endif
    }
    
    /// Apply a different appearance based on UI color scheme (light/dark mode)
    ///
    /// This method allows different appearances to be applied based on light or dark mode.
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Adaptive Text")
    ///     .ctAdaptToColorScheme { view, colorScheme in
    ///         view.foregroundColor(colorScheme == .dark ? .white : .black)
    ///     }
    /// ```
    ///
    /// - Parameter transform: The transform to apply with the current color scheme
    /// - Returns: The view adapted to the current color scheme
    func ctAdaptToColorScheme<Content: View>(
        transform: @escaping (Self, ColorScheme) -> Content
    ) -> some View {
        return self.modifier(ColorSchemeModifier<Self, Content>(transform: transform))
    }
}

/// Modifier for adapting views to the current color scheme
private struct ColorSchemeModifier<InputView: View, OutputView: View>: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    let transform: (InputView, ColorScheme) -> OutputView
    
    func body(content: Content) -> some View {
        if let typedContent = content as? InputView {
            transform(typedContent, colorScheme)
        } else {
            content as! OutputView
        }
    }
}
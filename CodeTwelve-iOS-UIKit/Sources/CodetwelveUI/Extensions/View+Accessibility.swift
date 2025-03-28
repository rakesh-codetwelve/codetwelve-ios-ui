//
//  View+Accessibility.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// Extensions on SwiftUI's View to enhance accessibility support
///
/// These extensions provide convenience methods for applying common accessibility
/// modifiers to views. They help ensure consistent accessibility implementation
/// across all CodeTwelve UI components.
public extension View {
    /// Apply standard accessibility modifiers for a button
    ///
    /// This method applies the appropriate accessibility label, hint, and traits
    /// for a button component.
    ///
    /// # Example
    ///
    /// ```swift
    /// Button("Sign In") {
    ///     // Action
    /// }
    /// .ctButtonAccessibility(label: "Sign In")
    /// ```
    ///
    /// - Parameters:
    ///   - label: The accessibility label (what VoiceOver will read)
    ///   - hint: The accessibility hint providing additional context (optional)
    /// - Returns: The view with accessibility modifiers applied
    func ctButtonAccessibility(label: String, hint: String? = nil) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "Tap to \(label.lowercased())")
            .accessibilityAddTraits(.isButton)
    }
    
    /// Apply standard accessibility modifiers for a toggle
    ///
    /// This method applies the appropriate accessibility label, hint, and value
    /// for a toggle component, based on its current state.
    ///
    /// # Example
    ///
    /// ```swift
    /// Toggle("Dark Mode", isOn: $isDarkMode)
    ///     .ctToggleAccessibility(label: "Dark Mode", isOn: isDarkMode)
    /// ```
    ///
    /// - Parameters:
    ///   - label: The accessibility label (what VoiceOver will read)
    ///   - isOn: Whether the toggle is on
    ///   - hint: Optional custom hint. If nil, a default hint will be used
    /// - Returns: The view with accessibility modifiers applied
    func ctToggleAccessibility(label: String, isOn: Bool, hint: String? = nil) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? (isOn ? "Tap to turn off" : "Tap to turn on"))
            .accessibilityValue(isOn ? "On" : "Off")
            .accessibilityAddTraits(.isButton)
    }
    
    /// Apply standard accessibility modifiers for an input field
    ///
    /// This method applies the appropriate accessibility label, value, and hint
    /// for an input field component.
    ///
    /// # Example
    ///
    /// ```swift
    /// TextField("Email", text: $email)
    ///     .ctInputAccessibility(label: "Email", value: email)
    /// ```
    ///
    /// - Parameters:
    ///   - label: The accessibility label (what VoiceOver will read)
    ///   - value: The current value of the input field
    ///   - hint: Optional custom hint. If nil, a default hint will be used
    /// - Returns: The view with accessibility modifiers applied
    func ctInputAccessibility(label: String, value: String, hint: String? = nil) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityValue(value.isEmpty ? "Empty" : value)
            .accessibilityHint(hint ?? "Double tap to edit")
    }
    
    /// Apply standard accessibility modifiers for an image
    ///
    /// This method applies the appropriate accessibility label and traits
    /// for an image component.
    ///
    /// # Example
    ///
    /// ```swift
    /// Image("profile")
    ///     .ctImageAccessibility(label: "Profile Picture", isDecorative: false)
    /// ```
    ///
    /// - Parameters:
    ///   - label: The accessibility label (what VoiceOver will read)
    ///   - isDecorative: Whether the image is purely decorative (ignored by VoiceOver)
    /// - Returns: The view with accessibility modifiers applied
    func ctImageAccessibility(label: String, isDecorative: Bool = false) -> some View {
        if isDecorative {
            return self.accessibilityHidden(true)
        } else {
            return self
                .accessibilityLabel(label)
                .accessibilityAddTraits(.isImage)
        }
    }
    
    /// Apply standard accessibility modifiers for a header
    ///
    /// This method applies the appropriate accessibility traits for a header component.
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Section Title")
    ///     .ctHeaderAccessibility()
    /// ```
    ///
    /// - Returns: The view with accessibility modifiers applied
    func ctHeaderAccessibility() -> some View {
        self.accessibilityAddTraits(.isHeader)
    }
    
    /// Apply standard accessibility modifiers for a link
    ///
    /// This method applies the appropriate accessibility label, hint, and traits
    /// for a link component.
    ///
    /// # Example
    ///
    /// ```swift
    /// Link("Terms of Service", destination: URL(string: "https://example.com/terms")!)
    ///     .ctLinkAccessibility(label: "Terms of Service")
    /// ```
    ///
    /// - Parameters:
    ///   - label: The accessibility label (what VoiceOver will read)
    ///   - hint: Optional custom hint. If nil, a default hint will be used
    /// - Returns: The view with accessibility modifiers applied
    func ctLinkAccessibility(label: String, hint: String? = nil) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "Tap to open link")
            .accessibilityAddTraits(.isLink)
    }
    
    /// Apply standard accessibility modifiers for a selected item
    ///
    /// This method applies the appropriate accessibility traits for a selected item.
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Selected Option")
    ///     .ctSelectedAccessibility(isSelected: true)
    /// ```
    ///
    /// - Parameter isSelected: Whether the item is selected
    /// - Returns: The view with accessibility modifiers applied
    func ctSelectedAccessibility(isSelected: Bool) -> some View {
        if isSelected {
            return self.accessibilityAddTraits(.isSelected)
        } else {
            return self
        }
    }
    
    /// Apply standard accessibility modifiers for a loading state
    ///
    /// This method applies the appropriate accessibility traits and label for a loading state.
    ///
    /// # Example
    ///
    /// ```swift
    /// ProgressView()
    ///     .ctLoadingAccessibility(isLoading: isLoading, label: "Loading data")
    /// ```
    ///
    /// - Parameters:
    ///   - isLoading: Whether the view is in a loading state
    ///   - label: The base label for the component
    /// - Returns: The view with accessibility modifiers applied
    func ctLoadingAccessibility(isLoading: Bool, label: String) -> some View {
        if isLoading {
            return self
                .accessibilityLabel("\(label), Loading")
                .accessibilityAddTraits(.updatesFrequently)
        } else {
            return self.accessibilityLabel(label)
        }
    }
    
    /// Apply standard accessibility modifiers for a required field
    ///
    /// This method applies the appropriate accessibility value for a required field.
    ///
    /// # Example
    ///
    /// ```swift
    /// TextField("Email", text: $email)
    ///     .ctRequiredFieldAccessibility(isRequired: true)
    /// ```
    ///
    /// - Parameter isRequired: Whether the field is required
    /// - Returns: The view with accessibility modifiers applied
    func ctRequiredFieldAccessibility(isRequired: Bool) -> some View {
        if isRequired {
            return self.accessibilityAddTraits(.isSelected)
        } else {
            return self
        }
    }
    
    /// Create an accessibility element with custom properties
    ///
    /// This method creates an accessibility element with the specified properties.
    ///
    /// # Example
    ///
    /// ```swift
    /// CustomView()
    ///     .ctAccessibilityElement(
    ///         label: "Custom View",
    ///         value: "Current Value",
    ///         hint: "Usage instructions",
    ///         traits: [.isButton, .allowsDirectInteraction]
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - label: The accessibility label (what VoiceOver will read)
    ///   - value: The accessibility value (optional)
    ///   - hint: The accessibility hint providing additional context (optional)
    ///   - traits: The accessibility traits for the element (optional)
    ///   - isModal: Whether the element is modal (captures all interactions)
    ///   - sortPriority: The priority for accessibility element ordering
    /// - Returns: The view with accessibility modifiers applied
    func ctAccessibilityElement(
        label: String,
        value: String? = nil,
        hint: String? = nil,
        traits: AccessibilityTraits = [],
        isModal: Bool = false,
        sortPriority: Double? = nil
    ) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityAddTraits(traits)
            .accessibilityValue(value ?? "")
            .accessibilityHint(hint ?? "")
            .accessibilityElement(children: isModal ? .contain : .ignore)
            .accessibilitySortPriority(sortPriority ?? 0)
    }
    
    /// Group multiple child views into a single accessibility element
    ///
    /// This method groups multiple child views into a single accessibility element.
    ///
    /// # Example
    ///
    /// ```swift
    /// HStack {
    ///     Image(systemName: "star.fill")
    ///     Text("5.0")
    ///     Text("Rating")
    /// }
    /// .ctAccessibilityGroup(label: "5.0 star rating")
    /// ```
    ///
    /// - Parameters:
    ///   - label: The accessibility label for the group
    ///   - traits: Additional accessibility traits for the group (optional)
    /// - Returns: The view with accessibility modifiers applied
    func ctAccessibilityGroup(label: String, traits: AccessibilityTraits = []) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityAddTraits(traits)
    }
    
    /// Hide the view from accessibility tools when a condition is met
    ///
    /// This method conditionally hides the view from accessibility tools.
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Debug info")
    ///     .ctAccessibilityHidden(when: isProduction)
    /// ```
    ///
    /// - Parameter condition: The condition determining whether to hide the view
    /// - Returns: The view with conditional accessibility hidden
    func ctAccessibilityHidden(when condition: Bool) -> some View {
        self.accessibilityHidden(condition)
    }
    
    /// Apply accessibility adjustments for controls when a condition is met
    ///
    /// This method enlarges the tap area for accessibility when needed.
    ///
    /// # Example
    ///
    /// ```swift
    /// Button("Tap me") { }
    ///     .ctAccessibilityEnlargedTapArea(when: true)
    /// ```
    ///
    /// - Parameter condition: The condition determining whether to enlarge the tap area
    /// - Returns: The view with conditional tap area enlargement
    func ctAccessibilityEnlargedTapArea(when condition: Bool = true) -> some View {
        if condition {
            return self.contentShape(Rectangle())
        } else {
            return self
        }
    }
}
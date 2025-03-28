//
//  View+Extensions.swift
//  CodetwelveUI
//
//  Created on 28/03/25.
//

import SwiftUI

public extension View {
    /// Apply a card style to a view
    ///
    /// This modifier wraps the view in a CTCard with default styling.
    ///
    /// # Example
    ///
    /// ```swift
    /// VStack {
    ///     Text("Card Content")
    /// }
    /// .ctCard()
    /// ```
    ///
    /// - Returns: The view wrapped in a CTCard
    func ctCard() -> some View {
        CTCard {
            self
        }
    }
} 
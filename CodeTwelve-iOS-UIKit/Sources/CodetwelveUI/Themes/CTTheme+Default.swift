//
//  CTTheme+Default.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//



import SwiftUI

/// Default implementations for CTTheme protocol
public extension CTTheme {
    /// Default implementation for button background color
    func buttonBackgroundColor(for style: CTButtonStyle) -> Color {
        switch style {
        case .primary:
            return primary
        case .secondary:
            return secondary
        case .destructive:
            return destructive
        case .outline, .ghost, .link:
            return Color.clear
        }
    }
    
    /// Default implementation for button foreground color
    func buttonForegroundColor(for style: CTButtonStyle) -> Color {
        switch style {
        case .primary, .secondary, .destructive:
            return textOnAccent
        case .outline:
            return primary
        case .ghost:
            return text
        case .link:
            return primary
        }
    }
    
    /// Default implementation for button border color
    func buttonBorderColor(for style: CTButtonStyle) -> Color {
        switch style {
        case .outline:
            return primary
        case .link, .ghost, .primary, .secondary, .destructive:
            return Color.clear
        }
    }
} 
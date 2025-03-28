//
//  Color+Hex.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// Extension on SwiftUI's Color to support initialization from hex strings
public extension Color {
    /// Initialize a Color from a hexadecimal string
    ///
    /// This initializer supports the following formats:
    /// - "#RGB"
    /// - "#RGBA"
    /// - "#RRGGBB"
    /// - "#RRGGBBAA"
    ///
    /// # Example
    ///
    /// ```swift
    /// let primaryColor = Color(hex: "#007AFF")
    /// let secondaryColor = Color(hex: "#5856D6")
    /// let transparentRed = Color(hex: "#FF0000AA")
    /// ```
    ///
    /// - Parameter hex: A hexadecimal string representation of the color
    /// - Returns: A Color instance or a fallback color if the string is invalid
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b, a) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17, 255)
        case 4: // RGBA (16-bit)
            (r, g, b, a) = ((int >> 12) * 17, (int >> 8 & 0xF) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b, a) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, 255)
        case 8: // RGBA (32-bit)
            (r, g, b, a) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            // Default to black for invalid input
            (r, g, b, a) = (0, 0, 0, 255)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// Initialize a Color from a hexadecimal integer value
    ///
    /// # Example
    ///
    /// ```swift
    /// let primaryColor = Color(hex: 0x007AFF)
    /// ```
    ///
    /// - Parameter hex: A hexadecimal integer representation of the color
    /// - Returns: A Color instance
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255,
            opacity: alpha
        )
    }
}
//
//  CTText.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable text component with various typography styles.
///
/// `CTText` provides a consistent text interface throughout your application
/// with support for different typography styles, weights, and colors.
///
/// # Example
///
/// ```swift
/// CTText("Hello, World!", style: .heading1)
///
/// CTText("This is a subtitle", style: .subtitle, color: .ctSecondary)
/// ```
public struct CTText: View {
    // MARK: - Public Properties
    
    /// The text content to be displayed.
    private let text: String
    
    /// The typography style to apply to the text.
    private let style: CTTypographyStyle
    
    /// The color of the text.
    private let color: Color
    
    /// The alignment of the text.
    private let alignment: TextAlignment
    
    /// The line spacing of the text.
    private let lineSpacing: CGFloat?
    
    /// Whether the text should be truncated with an ellipsis when it doesn't fit.
    private let truncationMode: Text.TruncationMode
    
    /// The maximum number of lines to display.
    private let lineLimit: Int?
    
    // MARK: - Environment Properties
    
    /// The current theme from the environment.
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a new text component with the specified content and styling.
    ///
    /// - Parameters:
    ///   - text: The text content to be displayed.
    ///   - style: The typography style to apply to the text.
    ///   - color: The color of the text (defaults to the theme's text color).
    ///   - alignment: The alignment of the text (defaults to leading).
    ///   - lineSpacing: The line spacing of the text (defaults to the style's default).
    ///   - truncationMode: The truncation mode for the text (defaults to tail).
    ///   - lineLimit: The maximum number of lines to display (defaults to nil, meaning no limit).
    public init(
        _ text: String,
        style: CTTypographyStyle = .body,
        color: Color? = nil,
        alignment: TextAlignment = .leading,
        lineSpacing: CGFloat? = nil,
        truncationMode: Text.TruncationMode = .tail,
        lineLimit: Int? = nil
    ) {
        self.text = text
        self.style = style
        self.color = color ?? .ctText
        self.alignment = alignment
        self.lineSpacing = lineSpacing
        self.truncationMode = truncationMode
        self.lineLimit = lineLimit
    }
    
    // MARK: - Body
    
    public var body: some View {
        Text(text)
            .ctTextStyle(style, color: color, lineSpacing: lineSpacing, alignment: alignment)
            .truncationMode(truncationMode)
            .lineLimit(lineLimit)
            .accessibilityAddTraits(.isStaticText)
    }
}

// MARK: - Previews

struct CTText_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            CTText("Heading 1", style: .heading1)
            CTText("Heading 2", style: .heading2)
            CTText("Heading 3", style: .heading3)
            CTText("Heading 4", style: .heading4)
            CTText("Body text", style: .body)
            CTText("Body bold text", style: .bodyBold)
            CTText("Small body text", style: .bodySmall)
            CTText("Subtitle text", style: .subtitle)
            CTText("Caption text", style: .caption)
            CTText("Small caption text", style: .captionSmall)
            CTText("Button text", style: .button)
            CTText("Small button text", style: .buttonSmall)
            CTText("Large button text", style: .buttonLarge)
            CTText("Code text", style: .code)
            CTText("Small code text", style: .codeSmall)
            
            CTText("Custom colored text", style: .body, color: .ctPrimary)
            CTText("Centered text with custom line spacing", style: .body, alignment: .center, lineSpacing: 8)
            CTText("Truncated text with line limit of 2. This text is intentionally long to demonstrate truncation behavior.", style: .body, lineLimit: 2)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
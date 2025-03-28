//
//  View+Typography.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// Extensions for applying typography styles to SwiftUI views
public extension View {
    /// Apply heading 1 typography style to a Text view
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Heading 1")
    ///     .ctHeading1()
    /// ```
    ///
    /// - Returns: The view with heading 1 typography applied
    func ctHeading1() -> some View {
        self.font(CTTypography.heading1())
    }
    
    /// Apply heading 2 typography style to a Text view
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Heading 2")
    ///     .ctHeading2()
    /// ```
    ///
    /// - Returns: The view with heading 2 typography applied
    func ctHeading2() -> some View {
        self.font(CTTypography.heading2())
    }
    
    /// Apply heading 3 typography style to a Text view
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Heading 3")
    ///     .ctHeading3()
    /// ```
    ///
    /// - Returns: The view with heading 3 typography applied
    func ctHeading3() -> some View {
        self.font(CTTypography.heading3())
    }
    
    /// Apply heading 4 typography style to a Text view
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Heading 4")
    ///     .ctHeading4()
    /// ```
    ///
    /// - Returns: The view with heading 4 typography applied
    func ctHeading4() -> some View {
        self.font(CTTypography.heading4())
    }
    
    /// Apply body typography style to a Text view
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Body text")
    ///     .ctBody()
    /// ```
    ///
    /// - Returns: The view with body typography applied
    func ctBody() -> some View {
        self.font(CTTypography.body())
    }
    
    /// Apply bold body typography style to a Text view
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Bold body text")
    ///     .ctBodyBold()
    /// ```
    ///
    /// - Returns: The view with bold body typography applied
    func ctBodyBold() -> some View {
        self.font(CTTypography.bodyBold())
    }
    
    /// Apply small body typography style to a Text view
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Small body text")
    ///     .ctBodySmall()
    /// ```
    ///
    /// - Returns: The view with small body typography applied
    func ctBodySmall() -> some View {
        self.font(CTTypography.bodySmall())
    }
    
    /// Apply subtitle typography style to a Text view
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Subtitle")
    ///     .ctSubtitle()
    /// ```
    ///
    /// - Returns: The view with subtitle typography applied
    func ctSubtitle() -> some View {
        self.font(CTTypography.subtitle())
    }
    
    /// Apply caption typography style to a Text view
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Caption")
    ///     .ctCaption()
    /// ```
    ///
    /// - Returns: The view with caption typography applied
    func ctCaption() -> some View {
        self.font(CTTypography.caption())
    }
    
    /// Apply small caption typography style to a Text view
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Small caption")
    ///     .ctCaptionSmall()
    /// ```
    ///
    /// - Returns: The view with small caption typography applied
    func ctCaptionSmall() -> some View {
        self.font(CTTypography.captionSmall())
    }
    
    /// Apply button typography style to a Text view
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Button")
    ///     .ctButton()
    /// ```
    ///
    /// - Returns: The view with button typography applied
    func ctButton() -> some View {
        self.font(CTTypography.button())
    }
    
    /// Apply small button typography style to a Text view
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Small button")
    ///     .ctButtonSmall()
    /// ```
    ///
    /// - Returns: The view with small button typography applied
    func ctButtonSmall() -> some View {
        self.font(CTTypography.buttonSmall())
    }
    
    /// Apply large button typography style to a Text view
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Large button")
    ///     .ctButtonLarge()
    /// ```
    ///
    /// - Returns: The view with large button typography applied
    func ctButtonLarge() -> some View {
        self.font(CTTypography.buttonLarge())
    }
    
    /// Apply code typography style to a Text view
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Code")
    ///     .ctCode()
    /// ```
    ///
    /// - Returns: The view with code typography applied
    func ctCode() -> some View {
        self.font(CTTypography.code())
    }
    
    /// Apply small code typography style to a Text view
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Small code")
    ///     .ctCodeSmall()
    /// ```
    ///
    /// - Returns: The view with small code typography applied
    func ctCodeSmall() -> some View {
        self.font(CTTypography.codeSmall())
    }
    
    /// Apply a complete typography style to a Text view, including font, color, and line spacing
    ///
    /// # Example
    ///
    /// ```swift
    /// Text("Styled text")
    ///     .ctTextStyle(.heading1, color: .ctPrimary, lineSpacing: 1.2)
    /// ```
    ///
    /// - Parameters:
    ///   - style: The typography style to apply
    ///   - color: The text color (defaults to the primary text color)
    ///   - lineSpacing: The line spacing factor (defaults to nil)
    ///   - alignment: The text alignment (defaults to leading)
    /// - Returns: The view with complete typography styling applied
    func ctTextStyle(
        _ style: CTTypographyStyle,
        color: Color = .ctText,
        lineSpacing: CGFloat? = nil,
        alignment: TextAlignment = .leading
    ) -> some View {
        self
            .font(style.font)
            .foregroundColor(color)
            .ctConditional(lineSpacing != nil) { view in
                view.lineSpacing(lineSpacing!)
                    .multilineTextAlignment(alignment)
            }
    }
}

/// Typography styles for the CodeTwelve UI design system
public enum CTTypographyStyle {
    /// Heading 1 style
    case heading1
    
    /// Heading 2 style
    case heading2
    
    /// Heading 3 style
    case heading3
    
    /// Heading 4 style
    case heading4
    
    /// Body style
    case body
    
    /// Bold body style
    case bodyBold
    
    /// Small body style
    case bodySmall
    
    /// Subtitle style
    case subtitle
    
    /// Caption style
    case caption
    
    /// Small caption style
    case captionSmall
    
    /// Button style
    case button
    
    /// Small button style
    case buttonSmall
    
    /// Large button style
    case buttonLarge
    
    /// Code style
    case code
    
    /// Small code style
    case codeSmall
    
    /// The font for this typography style
    var font: Font {
        switch self {
        case .heading1:
            return CTTypography.heading1()
        case .heading2:
            return CTTypography.heading2()
        case .heading3:
            return CTTypography.heading3()
        case .heading4:
            return CTTypography.heading4()
        case .body:
            return CTTypography.body()
        case .bodyBold:
            return CTTypography.bodyBold()
        case .bodySmall:
            return CTTypography.bodySmall()
        case .subtitle:
            return CTTypography.subtitle()
        case .caption:
            return CTTypography.caption()
        case .captionSmall:
            return CTTypography.captionSmall()
        case .button:
            return CTTypography.button()
        case .buttonSmall:
            return CTTypography.buttonSmall()
        case .buttonLarge:
            return CTTypography.buttonLarge()
        case .code:
            return CTTypography.code()
        case .codeSmall:
            return CTTypography.codeSmall()
        }
    }
}
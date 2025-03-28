//
//  TextExamples.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view that showcases the various styles and configurations of the CTText component.
///
/// This example view demonstrates:
/// - Different typography styles
/// - Text customization options (color, alignment, line spacing)
/// - Text truncation and line limiting
/// - Interactive examples
struct TextExamples: View {
    // MARK: - State Properties
    
    /// Toggle for controlling text alignment
    @State private var alignment: TextAlignment = .leading
    
    /// Slider for controlling line spacing
    @State private var lineSpacing: CGFloat = 4
    
    /// Toggle for controlling whether text is truncated
    @State private var isTruncated = false
    
    /// Slider for controlling the number of lines in truncated text
    @State private var lineLimit = 2.0
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.xl) {
                // Typography styles section
                typographySection
                
                CTDivider()
                
                // Text customization section
                customizationSection
                
                CTDivider()
                
                // Truncation and line limiting section
                truncationSection
                
                CTDivider()
                
                // Interactive examples section
                interactiveSection
            }
            .padding(CTSpacing.m)
        }
        .navigationTitle("Text")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - Typography Section
    
    /// Section demonstrating different typography styles
    private var typographySection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Section header
            Text("Typography Styles")
                .ctHeading2()
                .padding(.bottom, CTSpacing.xs)
            
            Text("The CTText component provides consistent typography across your app using predefined styles.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.s)
            
            // Typography style examples
            Group {
                typographyExample("Heading 1", style: .heading1)
                typographyExample("Heading 2", style: .heading2)
                typographyExample("Heading 3", style: .heading3)
                typographyExample("Heading 4", style: .heading4)
                typographyExample("Body", style: .body)
                typographyExample("Body Bold", style: .bodyBold)
                typographyExample("Body Small", style: .bodySmall)
                typographyExample("Subtitle", style: .subtitle)
                typographyExample("Caption", style: .caption)
                typographyExample("Caption Small", style: .captionSmall)
                typographyExample("Button", style: .button)
                typographyExample("Button Small", style: .buttonSmall)
                typographyExample("Button Large", style: .buttonLarge)
                typographyExample("Code", style: .code)
                typographyExample("Code Small", style: .codeSmall)
            }
            
            // Code example
            codeExample("""
            CTText("Heading 1", style: .heading1)
            CTText("Body text", style: .body)
            CTText("Caption text", style: .caption)
            
            // Other styles: .heading2, .heading3, .heading4, .bodyBold, .bodySmall,
            // .subtitle, .captionSmall, .button, .buttonSmall, .buttonLarge,
            // .code, .codeSmall
            """)
        }
    }
    
    // MARK: - Customization Section
    
    /// Section demonstrating text customization options
    private var customizationSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Section header
            Text("Text Customization")
                .ctHeading2()
                .padding(.bottom, CTSpacing.xs)
            
            Text("CTText supports various customization options including color, alignment, and line spacing.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.s)
            
            // Color customization examples
            Group {
                Text("Color Customization")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                HStack(spacing: CTSpacing.m) {
                    CTText("Default", style: .body)
                    CTText("Primary", style: .body, color: .ctPrimary)
                    CTText("Secondary", style: .body, color: .ctSecondary)
                    CTText("Success", style: .body, color: .ctSuccess)
                    CTText("Warning", style: .body, color: .ctWarning)
                }
                .padding(.bottom, CTSpacing.s)
            }
            
            // Text alignment examples
            Group {
                Text("Text Alignment")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                CTText("This text is aligned to the leading edge of the container.", style: .body, alignment: .leading)
                    .padding(.bottom, CTSpacing.xxs)
                
                CTText("This text is centered in the container.", style: .body, alignment: .center)
                    .padding(.bottom, CTSpacing.xxs)
                
                CTText("This text is aligned to the trailing edge of the container.", style: .body, alignment: .trailing)
                    .padding(.bottom, CTSpacing.s)
            }
            
            // Line spacing examples
            Group {
                Text("Line Spacing")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                CTText("This is a paragraph with default line spacing. Notice how the lines are spaced normally in this multi-line text block.", style: .body)
                    .padding(.bottom, CTSpacing.s)
                
                CTText("This is a paragraph with increased line spacing. Notice how the lines have more space between them in this multi-line text block.", style: .body, lineSpacing: 8)
                    .padding(.bottom, CTSpacing.s)
            }
            
            // Code example
            codeExample("""
            // Color customization
            CTText("Primary color", style: .body, color: .ctPrimary)
            
            // Text alignment
            CTText("Centered", style: .body, alignment: .center)
            
            // Line spacing
            CTText("With spacing", style: .body, lineSpacing: 8)
            """)
        }
    }
    
    // MARK: - Truncation Section
    
    /// Section demonstrating text truncation and line limiting
    private var truncationSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Section header
            Text("Truncation & Line Limiting")
                .ctHeading2()
                .padding(.bottom, CTSpacing.xs)
            
            Text("Control how text behaves when it doesn't fit in the available space.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.s)
            
            // Truncation examples
            Group {
                Text("Truncation Modes")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                HStack(spacing: CTSpacing.m) {
                    VStack {
                        Text("Head")
                            .ctCaption()
                        CTText("This long text will be truncated at the beginning...", style: .body, truncationMode: .head, lineLimit: 1)
                    }
                    
                    VStack {
                        Text("Middle")
                            .ctCaption()
                        CTText("This long text will be truncated in the middle...", style: .body, truncationMode: .middle, lineLimit: 1)
                    }
                    
                    VStack {
                        Text("Tail (Default)")
                            .ctCaption()
                        CTText("This long text will be truncated at the end...", style: .body, truncationMode: .tail, lineLimit: 1)
                    }
                }
                .padding(.bottom, CTSpacing.s)
            }
            
            // Line limit examples
            Group {
                Text("Line Limits")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                CTText("This is a single line of text.", style: .body, lineLimit: 1)
                    .padding(.bottom, CTSpacing.xxs)
                
                CTText("This is a longer paragraph that will be limited to two lines. The text will be truncated if it exceeds the specified line limit. Notice how the text is cut off with an ellipsis.", style: .body, lineLimit: 2)
                    .padding(.bottom, CTSpacing.xxs)
                
                CTText("This is a longer paragraph with no line limit. The text will wrap to as many lines as needed to display the entire content. This is useful when you want to ensure all content is visible regardless of its length.", style: .body)
                    .padding(.bottom, CTSpacing.s)
            }
            
            // Code example
            codeExample("""
            // Truncation mode
            CTText("Text...", style: .body, truncationMode: .middle, lineLimit: 1)
            
            // Line limit
            CTText("Text...", style: .body, lineLimit: 2)
            
            // No line limit (default)
            CTText("Text...", style: .body)
            """)
        }
    }
    
    // MARK: - Interactive Section
    
    /// Section demonstrating interactive text examples
    private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Section header
            Text("Interactive Examples")
                .ctHeading2()
                .padding(.bottom, CTSpacing.xs)
            
            Text("Try out these interactive examples to see the text component in action.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.s)
            
            // Alignment picker
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Text Alignment")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                Picker("Select Alignment", selection: $alignment) {
                    Text("Leading").tag(TextAlignment.leading)
                    Text("Center").tag(TextAlignment.center)
                    Text("Trailing").tag(TextAlignment.trailing)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, CTSpacing.xs)
                
                CTText("This paragraph demonstrates dynamic text alignment based on your selection above. The text will adjust its alignment according to the option you choose in the segmented control.", style: .body, alignment: alignment)
            }
            .padding(.bottom, CTSpacing.m)
            
            // Line spacing slider
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Line Spacing")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                HStack {
                    Text("Spacing: \(Int(lineSpacing))px")
                        .ctCaption()
                    
                    Slider(value: $lineSpacing, in: 0...20, step: 1)
                }
                .padding(.bottom, CTSpacing.xs)
                
                CTText("This paragraph demonstrates dynamic line spacing. As you adjust the slider above, the space between lines will increase or decrease accordingly. Try different spacing values to see how they affect the readability and appearance of multiline text.", style: .body, lineSpacing: lineSpacing)
            }
            .padding(.bottom, CTSpacing.m)
            
            // Truncation toggle and line limit
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Truncation and Line Limit")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                Toggle("Enable Line Limit", isOn: $isTruncated)
                    .padding(.bottom, CTSpacing.xs)
                
                if isTruncated {
                    HStack {
                        Text("Line Limit: \(Int(lineLimit))")
                            .ctCaption()
                        
                        Slider(value: $lineLimit, in: 1...10, step: 1)
                    }
                    .padding(.bottom, CTSpacing.xs)
                }
                
                CTText("This paragraph demonstrates dynamic truncation and line limiting. Toggle the switch above to enable or disable line limiting. When line limiting is enabled, you can adjust the slider to control the maximum number of lines displayed. This is particularly useful for interfaces where space is limited and you need to control how much text is visible.", style: .body, lineLimit: isTruncated ? Int(lineLimit) : nil)
            }
        }
    }
    
    // MARK: - Helper Views
    
    /// Helper function to create a typography example view
    /// - Parameters:
    ///   - label: The text to display
    ///   - style: The typography style to apply
    /// - Returns: A view displaying the example
    private func typographyExample(_ label: String, style: CTTypographyStyle) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            CTText(label, style: style)
            
            Text(".\(style)")
                .ctCaptionSmall()
                .foregroundColor(.ctTextSecondary)
        }
        .padding(.vertical, CTSpacing.xxs)
    }
    
    /// Helper function to create a code example view
    /// - Parameter code: The code to display
    /// - Returns: A view displaying the code
    private func codeExample(_ code: String) -> some View {
        VStack(alignment: .leading) {
            Text("Example Code:")
                .ctCaption()
                .foregroundColor(.ctTextSecondary)
                .padding(.top, CTSpacing.s)
            
            Text(code)
                .ctCode()
                .padding(CTSpacing.s)
                .background(Color.ctBackground)
                .cornerRadius(CTSpacing.xs)
        }
    }
}

// MARK: - Previews

struct TextExamples_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TextExamples()
        }
    }
}
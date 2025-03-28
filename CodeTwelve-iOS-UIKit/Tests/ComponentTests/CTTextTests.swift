//
//  CTTextTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTTextTests: XCTestCase {
    func testTextInitialization() {
        // Given
        let text = "Test Text"
        
        // When
        let ctText = CTText(text)
        
        // Then
        XCTAssertEqual(ctText.accessibilityTraits.contains(.isStaticText), true)
    }
    
    func testTextWithDifferentStyles() {
        // Test with different typography styles
        let styles: [CTTypographyStyle] = [
            .heading1, .heading2, .heading3, .heading4,
            .body, .bodyBold, .bodySmall,
            .subtitle, .caption, .captionSmall,
            .button, .buttonSmall, .buttonLarge,
            .code, .codeSmall
        ]
        
        for style in styles {
            // When
            let ctText = CTText("Test", style: style)
            
            // Then - Just verifying that initialization works without errors
            XCTAssertNotNil(ctText)
        }
    }
    
    func testTextWithCustomColor() {
        // Given
        let text = "Colored Text"
        let color = Color.red
        
        // When
        let ctText = CTText(text, color: color)
        
        // Then - Just verifying that initialization works without errors
        XCTAssertNotNil(ctText)
    }
    
    func testTextWithCustomAlignment() {
        // Given
        let text = "Aligned Text"
        let alignment: TextAlignment = .center
        
        // When
        let ctText = CTText(text, alignment: alignment)
        
        // Then - Just verifying that initialization works without errors
        XCTAssertNotNil(ctText)
    }
    
    func testTextWithLineSpacing() {
        // Given
        let text = "Spaced Text"
        let lineSpacing: CGFloat = 8
        
        // When
        let ctText = CTText(text, lineSpacing: lineSpacing)
        
        // Then - Just verifying that initialization works without errors
        XCTAssertNotNil(ctText)
    }
    
    func testTextWithTruncation() {
        // Given
        let text = "Truncated Text"
        let truncationMode: Text.TruncationMode = .middle
        
        // When
        let ctText = CTText(text, truncationMode: truncationMode)
        
        // Then - Just verifying that initialization works without errors
        XCTAssertNotNil(ctText)
    }
    
    func testTextWithLineLimit() {
        // Given
        let text = "Limited Text"
        let lineLimit: Int = 2
        
        // When
        let ctText = CTText(text, lineLimit: lineLimit)
        
        // Then - Just verifying that initialization works without errors
        XCTAssertNotNil(ctText)
    }
}
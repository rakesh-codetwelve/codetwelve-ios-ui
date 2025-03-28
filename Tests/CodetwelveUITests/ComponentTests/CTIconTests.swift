//
//  CTIconTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTIconTests: XCTestCase {
    func testIconInitialization() {
        // Given
        let systemName = "star.fill"
        
        // When
        let ctIcon = CTIcon(systemName)
        
        // Then
        XCTAssertFalse(ctIcon.accessibilityHidden)
    }
    
    func testIconWithDifferentSizes() {
        // Test with different sizes
        let sizes: [IconSize] = [
            .extraSmall, .small, .medium, .large, .extraLarge, .custom(40)
        ]
        
        for size in sizes {
            // When
            let ctIcon = CTIcon("star.fill", size: size)
            
            // Then - Just verifying that initialization works without errors
            XCTAssertNotNil(ctIcon)
        }
    }
    
    func testIconWithCustomColor() {
        // Given
        let systemName = "star.fill"
        let color = Color.red
        
        // When
        let ctIcon = CTIcon(systemName, color: color)
        
        // Then - Just verifying that initialization works without errors
        XCTAssertNotNil(ctIcon)
    }
    
    func testIconWithDifferentWeights() {
        // Test with different weights
        let weights: [Font.Weight] = [
            .ultraLight, .light, .regular, .medium, .semibold, .bold, .heavy, .black
        ]
        
        for weight in weights {
            // When
            let ctIcon = CTIcon("star.fill", weight: weight)
            
            // Then - Just verifying that initialization works without errors
            XCTAssertNotNil(ctIcon)
        }
    }
    
    func testIconWithDifferentRenderingModes() {
        // Test with different rendering modes
        let renderingModes: [SymbolRenderingMode] = [
            .multicolor, .hierarchical, .monochrome, .palette
        ]
        
        for renderingMode in renderingModes {
            // When
            let ctIcon = CTIcon("star.fill", renderingMode: renderingMode)
            
            // Then - Just verifying that initialization works without errors
            XCTAssertNotNil(ctIcon)
        }
    }
    
    func testIconAccessibilityLabel() {
        // Given
        let systemName = "star.fill"
        let accessibilityLabel = "Star Icon"
        
        // When
        let ctIcon = CTIcon(systemName, accessibilityLabel: accessibilityLabel)
        
        // Then
        XCTAssertFalse(ctIcon.accessibilityHidden)
    }
    
    func testDecorativeIcon() {
        // Given
        let systemName = "star.fill"
        
        // When
        let ctIcon = CTIcon(systemName, isDecorative: true)
        
        // Then
        XCTAssertTrue(ctIcon.accessibilityHidden)
    }
}
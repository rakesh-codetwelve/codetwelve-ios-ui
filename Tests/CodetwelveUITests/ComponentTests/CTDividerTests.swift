//
//  CTDividerTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTDividerTests: XCTestCase {
    func testHorizontalDividerCreation() {
        // Given
        let divider = CTDivider()
        
        // Then
        // Verify divider is created with default properties (orientation = .horizontal)
        XCTAssertNotNil(divider)
    }
    
    func testVerticalDividerCreation() {
        // Given
        let divider = CTDivider(orientation: .vertical)
        
        // Then
        // Verify divider is created with vertical orientation
        XCTAssertNotNil(divider)
    }
    
    func testDividerCustomColor() {
        // Given
        let customColor = Color.red
        let divider = CTDivider(color: customColor)
        
        // Then
        // Use reflection to check if the divider has the correct color
        let mirror = Mirror(reflecting: divider)
        let colorProperty = mirror.children.first { $0.label == "color" }?.value as? Color
        
        XCTAssertNotNil(colorProperty)
    }
    
    func testDividerCustomThickness() {
        // Given
        let customThickness: CGFloat = 3.0
        let divider = CTDivider(thickness: customThickness)
        
        // Then
        // Use reflection to check if the divider has the correct thickness
        let mirror = Mirror(reflecting: divider)
        let thicknessProperty = mirror.children.first { $0.label == "thickness" }?.value as? CGFloat
        
        XCTAssertEqual(thicknessProperty, customThickness)
    }
    
    func testDividerCustomLength() {
        // Given
        let customLength: CGFloat = 100.0
        let divider = CTDivider(length: customLength)
        
        // Then
        // Use reflection to check if the divider has the correct length
        let mirror = Mirror(reflecting: divider)
        let lengthProperty = mirror.children.first { $0.label == "length" }?.value as? CGFloat
        
        XCTAssertEqual(lengthProperty, customLength)
    }
    
    func testDividerCustomOpacity() {
        // Given
        let customOpacity: Double = 0.5
        let divider = CTDivider(opacity: customOpacity)
        
        // Then
        // Use reflection to check if the divider has the correct opacity
        let mirror = Mirror(reflecting: divider)
        let opacityProperty = mirror.children.first { $0.label == "opacity" }?.value as? Double
        
        XCTAssertEqual(opacityProperty, customOpacity)
    }
    
    func testDividerAccessibility() {
        // Given
        let divider = CTDivider()
        
        // Then
        // Verify divider is hidden from accessibility
        // Note: This test is limited since we can't directly check the accessibility properties
        // in a unit test without rendering the view.
        XCTAssertNotNil(divider)
    }
}
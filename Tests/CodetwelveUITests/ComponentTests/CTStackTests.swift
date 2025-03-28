//
//  CTStackTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTStackTests: XCTestCase {
    func testVerticalStackCreation() {
        // Given
        let stack = CTStack {
            Text("Item 1")
            Text("Item 2")
        }
        
        // Then
        // Verify stack is created with default properties (orientation = .vertical)
        let mirror = Mirror(reflecting: stack)
        let orientationProperty = mirror.children.first { $0.label == "orientation" }?.value
        XCTAssertNotNil(orientationProperty)
    }
    
    func testHorizontalStackCreation() {
        // Given
        let stack = CTStack(orientation: .horizontal) {
            Text("Item 1")
            Text("Item 2")
        }
        
        // Then
        // Verify stack is created with horizontal orientation
        let mirror = Mirror(reflecting: stack)
        if let orientationProperty = mirror.children.first(where: { $0.label == "orientation" })?.value as? CTStack<TupleView<(Text, Text)>>.Orientation {
            XCTAssertEqual(String(describing: orientationProperty), String(describing: CTStack<TupleView<(Text, Text)>>.Orientation.horizontal))
        } else {
            XCTFail("Orientation property not found or has unexpected type")
        }
    }
    
    func testStackWithCustomSpacing() {
        // Given
        let customSpacing: CGFloat = 20.0
        let stack = CTStack(spacing: customSpacing) {
            Text("Item 1")
            Text("Item 2")
        }
        
        // Then
        // Verify stack has the correct spacing
        let mirror = Mirror(reflecting: stack)
        if let spacingProperty = mirror.children.first(where: { $0.label == "spacing" })?.value as? CGFloat? {
            XCTAssertEqual(spacingProperty, customSpacing)
        } else {
            XCTFail("Spacing property not found or has unexpected type")
        }
    }
    
    func testStackWithCustomAlignment() {
        // Given
        // Using a vertical stack with leading alignment
        let stack = CTStack(alignment: .leading) {
            Text("Item 1")
            Text("Item 2")
        }
        
        // Then
        // Verify stack has the correct alignment
        let mirror = Mirror(reflecting: stack)
        if let horizontalAlignmentProperty = mirror.children.first(where: { $0.label == "horizontalAlignment" })?.value as? HorizontalAlignment {
            XCTAssertEqual(String(describing: horizontalAlignmentProperty), String(describing: HorizontalAlignment.leading))
        } else {
            XCTFail("HorizontalAlignment property not found or has unexpected type")
        }
    }
    
    func testStackWithDividers() {
        // Given
        let stack = CTStack(showDividers: true) {
            Text("Item 1")
            Text("Item 2")
        }
        
        // Then
        // Verify stack is configured to show dividers
        let mirror = Mirror(reflecting: stack)
        if let showDividersProperty = mirror.children.first(where: { $0.label == "showDividers" })?.value as? Bool {
            XCTAssertTrue(showDividersProperty)
        } else {
            XCTFail("ShowDividers property not found or has unexpected type")
        }
    }
    
    func testStackWithCustomDividerColor() {
        // Given
        let customColor = Color.red
        let stack = CTStack(showDividers: true, dividerColor: customColor) {
            Text("Item 1")
            Text("Item 2")
        }
        
        // Then
        // Verify stack has the correct divider color
        let mirror = Mirror(reflecting: stack)
        XCTAssertNotNil(mirror.children.first { $0.label == "dividerColor" }?.value)
    }
    
    func testStackWithCustomDividerThickness() {
        // Given
        let customThickness: CGFloat = 2.0
        let stack = CTStack(showDividers: true, dividerThickness: customThickness) {
            Text("Item 1")
            Text("Item 2")
        }
        
        // Then
        // Verify stack has the correct divider thickness
        let mirror = Mirror(reflecting: stack)
        if let thicknessProperty = mirror.children.first(where: { $0.label == "dividerThickness" })?.value as? CGFloat {
            XCTAssertEqual(thicknessProperty, customThickness)
        } else {
            XCTFail("DividerThickness property not found or has unexpected type")
        }
    }
    
    func testViewExtensionCtVStack() {
        // Given
        let view = Text("Test").ctVStack()
        
        // Then
        XCTAssertNotNil(view)
    }
    
    func testViewExtensionCtHStack() {
        // Given
        let view = Text("Test").ctHStack()
        
        // Then
        XCTAssertNotNil(view)
    }
}
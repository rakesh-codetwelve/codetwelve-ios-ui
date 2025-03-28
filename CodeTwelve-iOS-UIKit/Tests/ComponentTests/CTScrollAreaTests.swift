//
//  CTScrollAreaTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTScrollAreaTests: XCTestCase {
    
    func testScrollAreaCreation() {
        // Given
        let scrollArea = CTScrollArea {
            Text("Test Content")
        }
        
        // Then
        XCTAssertNotNil(scrollArea, "Scroll area should be created successfully")
        XCTAssertNotNil(scrollArea.body, "Scroll area body should not be nil")
    }
    
    func testScrollAreaWithCustomAxes() {
        // Given
        let verticalScrollArea = CTScrollArea(.vertical) {
            Text("Vertical Scroll")
        }
        
        let horizontalScrollArea = CTScrollArea(.horizontal) {
            Text("Horizontal Scroll")
        }
        
        let bothAxesScrollArea = CTScrollArea([.horizontal, .vertical]) {
            Text("Both Axes Scroll")
        }
        
        // Then
        XCTAssertNotNil(verticalScrollArea, "Vertical scroll area should be created successfully")
        XCTAssertNotNil(horizontalScrollArea, "Horizontal scroll area should be created successfully")
        XCTAssertNotNil(bothAxesScrollArea, "Both axes scroll area should be created successfully")
    }
    
    func testScrollAreaWithIndicatorsHidden() {
        // Given
        let scrollArea = CTScrollArea(showsIndicators: false) {
            Text("Hidden Indicators")
        }
        
        // Then
        XCTAssertNotNil(scrollArea, "Scroll area with hidden indicators should be created successfully")
    }
    
    func testScrollAreaWithCustomScrollBarStyle() {
        // Given
        let defaultStyleScrollArea = CTScrollArea(scrollBarStyle: .default) {
            Text("Default Style")
        }
        
        let customStyleScrollArea = CTScrollArea(scrollBarStyle: .custom) {
            Text("Custom Style")
        }
        
        let automaticStyleScrollArea = CTScrollArea(scrollBarStyle: .automatic) {
            Text("Automatic Style")
        }
        
        // Then
        XCTAssertNotNil(defaultStyleScrollArea, "Default style scroll area should be created successfully")
        XCTAssertNotNil(customStyleScrollArea, "Custom style scroll area should be created successfully")
        XCTAssertNotNil(automaticStyleScrollArea, "Automatic style scroll area should be created successfully")
    }
    
    func testScrollAreaWithCustomScrollBarColor() {
        // Given
        let scrollArea = CTScrollArea(scrollBarColor: .red) {
            Text("Custom Color")
        }
        
        // Then
        XCTAssertNotNil(scrollArea, "Scroll area with custom color should be created successfully")
    }
    
    func testScrollAreaWithCustomScrollBarWidth() {
        // Given
        let scrollArea = CTScrollArea(scrollBarWidth: 8) {
            Text("Custom Width")
        }
        
        // Then
        XCTAssertNotNil(scrollArea, "Scroll area with custom width should be created successfully")
    }
    
    func testScrollAreaWithCustomScrollBarPadding() {
        // Given
        let padding = EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let scrollArea = CTScrollArea(scrollBarPadding: padding) {
            Text("Custom Padding")
        }
        
        // Then
        XCTAssertNotNil(scrollArea, "Scroll area with custom scroll bar padding should be created successfully")
    }
    
    func testScrollAreaWithCustomScrollPadding() {
        // Given
        let padding = EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let scrollArea = CTScrollArea(scrollPadding: padding) {
            Text("Custom Padding")
        }
        
        // Then
        XCTAssertNotNil(scrollArea, "Scroll area with custom scroll padding should be created successfully")
    }
    
    func testViewExtensionMethods() {
        // Given
        let view = Text("Test")
        
        // When
        let verticalScrollArea = view.ctScrollAreaVertical()
        let horizontalScrollArea = view.ctScrollAreaHorizontal()
        
        // Then
        XCTAssertNotNil(verticalScrollArea, "Vertical scroll area extension should work")
        XCTAssertNotNil(horizontalScrollArea, "Horizontal scroll area extension should work")
    }
}
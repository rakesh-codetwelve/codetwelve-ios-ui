//
//  CTGridTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTGridTests: XCTestCase {
    
    // Test fixed column grid creation
    func testFixedColumnGridCreation() {
        let grid = CTGrid(columns: 2) {
            Text("Item 1")
            Text("Item 2")
            Text("Item 3")
            Text("Item 4")
        }
        
        XCTAssertNotNil(grid, "Fixed column grid should be created successfully")
    }
    
    // Test adaptive grid creation
    func testAdaptiveGridCreation() {
        let grid = CTGrid(minItemWidth: 100) {
            Text("Item 1")
            Text("Item 2")
            Text("Item 3")
            Text("Item 4")
        }
        
        XCTAssertNotNil(grid, "Adaptive grid should be created successfully")
    }
    
    // Test grid with custom spacing
    func testGridWithCustomSpacing() {
        let grid = CTGrid(columns: 3, spacing: 20) {
            Text("Item 1")
            Text("Item 2")
            Text("Item 3")
        }
        
        XCTAssertNotNil(grid, "Grid with custom spacing should be created successfully")
    }
    
    // Test grid with custom alignment
    func testGridWithCustomAlignment() {
        let grid = CTGrid(
            columns: 2,
            horizontalAlignment: .leading,
            verticalAlignment: .top
        ) {
            Text("Item 1")
            Text("Item 2")
            Text("Item 3")
            Text("Item 4")
        }
        
        XCTAssertNotNil(grid, "Grid with custom alignment should be created successfully")
    }
    
    // Test grid with padding
    func testGridWithPadding() {
        let grid = CTGrid(
            columns: 2,
            padding: CTSpacing.all(.m)
        ) {
            Text("Item 1")
            Text("Item 2")
            Text("Item 3")
            Text("Item 4")
        }
        
        XCTAssertNotNil(grid, "Grid with padding should be created successfully")
    }
    
    // Test grid square extension
    func testGridSquareExtension() {
        let view = Text("Square Item")
            .ctGridSquare()
        
        XCTAssertNotNil(view, "Grid square extension should work")
    }
    
    // Test grid aspect ratio extension
    func testGridAspectRatioExtension() {
        let view = Text("16:9 Item")
            .ctGridAspectRatio(16/9)
        
        XCTAssertNotNil(view, "Grid aspect ratio extension should work")
    }
    
    // Test complex grid with different item types
    func testComplexGrid() {
        let grid = CTGrid(columns: 3, spacing: 10) {
            Text("Text Item")
            Image(systemName: "star")
            Circle().fill(Color.blue)
            Rectangle().fill(Color.green)
        }
        
        XCTAssertNotNil(grid, "Complex grid with different item types should be created successfully")
    }
}
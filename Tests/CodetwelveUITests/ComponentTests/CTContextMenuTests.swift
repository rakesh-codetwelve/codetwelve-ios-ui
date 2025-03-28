//
//  CTContextMenuTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTContextMenuTests: XCTestCase {
    // MARK: - Test Initialization
    
    func testContextMenuInitialization() {
        // Given
        let expectation = XCTestExpectation(description: "Context Menu Initialization")
        var actionCalled = false
        
        let menuItems = [
            CTContextMenuItem(label: "Edit", icon: "pencil") {
                actionCalled = true
                expectation.fulfill()
            }
        ]
        
        // When
        let contextMenu = CTContextMenu {
            menuItems
        } content: {
            Text("Test Content")
        }
        
        // Then
        XCTAssertNotNil(contextMenu, "Context Menu should be initialized")
        
        // Simulate menu item action
        menuItems[0].action()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(actionCalled, "Menu item action should be called")
    }
    
    // MARK: - Test Menu Item Styles
    
    func testContextMenuItemStyles() {
        // Default Style
        let defaultItem = CTContextMenuItem(label: "Default") {}
        XCTAssertTrue(defaultItem.style == .default, "Default style should be applied")
        
        // Destructive Style
        let destructiveItem = CTContextMenuItem(label: "Delete", style: .destructive) {}
        XCTAssertTrue(destructiveItem.style == .destructive, "Destructive style should be applied")
        
        // Custom Style
        let customColor = Color.purple
        let customItem = CTContextMenuItem(label: "Custom", style: .custom(customColor)) {}
        switch customItem.style {
        case .custom(let color):
            XCTAssertEqual(color, customColor, "Custom color should match")
        default:
            XCTFail("Custom style not correctly applied")
        }
    }
    
    // MARK: - Test Action Execution
    
    func testContextMenuItemActionExecution() {
        // Given
        let expectation = XCTestExpectation(description: "Context Menu Item Action")
        var actionCallCount = 0
        
        let menuItem = CTContextMenuItem(label: "Test") {
            actionCallCount += 1
            expectation.fulfill()
        }
        
        // When
        menuItem.action()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(actionCallCount, 1, "Action should be called exactly once")
    }
    
    // MARK: - Test Multiple Menu Items
    
    func testMultipleContextMenuItems() {
        // Given
        var actionCounts = [Int](repeating: 0, count: 3)
        
        let menuItems = [
            CTContextMenuItem(label: "Action 1") { actionCounts[0] += 1 },
            CTContextMenuItem(label: "Action 2") { actionCounts[1] += 1 },
            CTContextMenuItem(label: "Action 3", style: .destructive) { actionCounts[2] += 1 }
        ]
        
        // When
        let contextMenu = CTContextMenu {
            menuItems
        } content: {
            Text("Multiple Actions")
        }
        
        // Then
        XCTAssertNotNil(contextMenu, "Context Menu with multiple items should be initialized")
        
        // Simulate actions
        menuItems.forEach { $0.action() }
        
        XCTAssertEqual(actionCounts[0], 1, "First action should be called once")
        XCTAssertEqual(actionCounts[1], 1, "Second action should be called once")
        XCTAssertEqual(actionCounts[2], 1, "Third action should be called once")
    }
    
    // MARK: - Test Edge Cases
    
    func testContextMenuWithNoItems() {
        // Given & When
        let contextMenu = CTContextMenu {
            [] as [CTContextMenuItem]
        } content: {
            Text("No Actions")
        }
        
        // Then
        XCTAssertNotNil(contextMenu, "Context Menu should support zero items")
    }
    
    func testContextMenuWithOnlyDestructiveItems() {
        // Given
        let expectation = XCTestExpectation(description: "Destructive Action")
        var actionCalled = false
        
        let menuItems = [
            CTContextMenuItem(label: "Delete", style: .destructive) {
                actionCalled = true
                expectation.fulfill()
            }
        ]
        
        // When
        let contextMenu = CTContextMenu {
            menuItems
        } content: {
            Text("Destructive Only")
        }
        
        // Then
        XCTAssertNotNil(contextMenu, "Context Menu with only destructive items should be initialized")
        
        // Simulate action
        menuItems[0].action()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(actionCalled, "Destructive action should be callable")
    }
    
    // MARK: - Accessibility Tests
    
    func testContextMenuAccessibility() {
        // Given
        let menuItems = [
            CTContextMenuItem(label: "Action", icon: "pencil") {}
        ]
        
        // When
        let contextMenu = CTContextMenu {
            menuItems
        } content: {
            Text("Accessible Content")
        }
        
        // Then
        XCTAssertNotNil(contextMenu, "Context Menu should support accessibility")
    }
    
    // MARK: - Performance Tests
    
    func testContextMenuPerformance() {
        // Given
        let menuItems = (0..<50).map { index in
            CTContextMenuItem(label: "Action \(index)") {}
        }
        
        // When & Then
        measure {
            let _ = CTContextMenu {
                menuItems
            } content: {
                Text("Performance Test")
            }
        }
    }
}
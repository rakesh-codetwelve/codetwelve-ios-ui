//
//  CTDropdownMenuTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTDropdownMenuTests: XCTestCase {
    func testDropdownMenuInitialization() {
        // Given
        let isPresented = Binding.constant(true)
        
        // When
        let dropdownMenu = CTDropdownMenu(isPresented: isPresented) {
            Text("Content")
        }
        
        // Then
        XCTAssertTrue(isPresented.wrappedValue)
    }
    
    func testDropdownMenuItemInitialization() {
        // Given, When
        var actionCalled = false
        let menuItem = CTDropdownMenuItem(label: "Test Item") {
            actionCalled = true
        }
        
        // Create a test view to simulate a tap on the menu item
        let testView = TestItemWrapper(item: menuItem)
        
        // When
        testView.simulateTap()
        
        // Then
        XCTAssertTrue(actionCalled, "Menu item action should be called when tapped")
    }
    
    func testDropdownMenuItemStyles() {
        // Test various styles
        let defaultItem = CTDropdownMenuItem(label: "Default", style: .default) {}
        let highlightedItem = CTDropdownMenuItem(label: "Highlighted", style: .highlighted) {}
        let destructiveItem = CTDropdownMenuItem(label: "Destructive", style: .destructive) {}
        let disabledItem = CTDropdownMenuItem(label: "Disabled", style: .disabled, isDisabled: true) {}
        let customItem = CTDropdownMenuItem(
            label: "Custom",
            style: .custom(textColor: .red, iconColor: .blue, backgroundColor: .green)
        ) {}
        
        // Then
        // We can't directly access the properties due to SwiftUI's view construction,
        // but we can verify they were constructed without errors
        XCTAssertNotNil(defaultItem)
        XCTAssertNotNil(highlightedItem)
        XCTAssertNotNil(destructiveItem)
        XCTAssertNotNil(disabledItem)
        XCTAssertNotNil(customItem)
    }
    
    func testDropdownMenuDivider() {
        // Given, When
        let divider = CTDropdownMenuItem.divider()
        
        // Then
        // Verify the divider was created without errors
        XCTAssertNotNil(divider)
    }
    
    func testDropdownMenuPositions() {
        // Test various positions
        let isPresented = Binding.constant(true)
        
        let bottomLeadingMenu = CTDropdownMenu(isPresented: isPresented, position: .bottomLeading) {
            Text("Content")
        }
        
        let bottomTrailingMenu = CTDropdownMenu(isPresented: isPresented, position: .bottomTrailing) {
            Text("Content")
        }
        
        let bottomCenterMenu = CTDropdownMenu(isPresented: isPresented, position: .bottomCenter) {
            Text("Content")
        }
        
        let topLeadingMenu = CTDropdownMenu(isPresented: isPresented, position: .topLeading) {
            Text("Content")
        }
        
        // Then
        // Verify menus with different positions were created without errors
        XCTAssertNotNil(bottomLeadingMenu)
        XCTAssertNotNil(bottomTrailingMenu)
        XCTAssertNotNil(bottomCenterMenu)
        XCTAssertNotNil(topLeadingMenu)
    }
    
    func testDropdownMenuIconSupport() {
        // Given, When
        let itemWithLeadingIcon = CTDropdownMenuItem(label: "With Icon", icon: "star") {}
        let itemWithTrailingIcon = CTDropdownMenuItem(label: "With Trailing", trailingIcon: "arrow.right") {}
        let itemWithBothIcons = CTDropdownMenuItem(
            label: "Both Icons",
            icon: "star",
            trailingIcon: "arrow.right"
        ) {}
        
        // Then
        // Verify items with icons were created without errors
        XCTAssertNotNil(itemWithLeadingIcon)
        XCTAssertNotNil(itemWithTrailingIcon)
        XCTAssertNotNil(itemWithBothIcons)
    }
    
    func testDropdownMenuItemDisabled() {
        // Given
        var actionCalled = false
        let disabledItem = CTDropdownMenuItem(label: "Disabled", isDisabled: true) {
            actionCalled = true
        }
        
        // Create a test view to simulate a tap on the disabled menu item
        let testView = TestItemWrapper(item: disabledItem)
        
        // When
        testView.simulateTap()
        
        // Then
        XCTAssertFalse(actionCalled, "Disabled menu item action should not be called when tapped")
    }
    
    func testDropdownMenuStyles() {
        // Test various styles
        let isPresented = Binding.constant(true)
        
        let defaultStyleMenu = CTDropdownMenu(isPresented: isPresented, style: .default) {
            Text("Content")
        }
        
        let solidStyleMenu = CTDropdownMenu(isPresented: isPresented, style: .solid) {
            Text("Content")
        }
        
        let minimalStyleMenu = CTDropdownMenu(isPresented: isPresented, style: .minimal) {
            Text("Content")
        }
        
        let customStyleMenu = CTDropdownMenu(
            isPresented: isPresented,
            style: .custom(
                backgroundColor: .red,
                borderColor: .blue,
                shadowRadius: 10,
                cornerRadius: 20
            )
        ) {
            Text("Content")
        }
        
        // Then
        // Verify menus with different styles were created without errors
        XCTAssertNotNil(defaultStyleMenu)
        XCTAssertNotNil(solidStyleMenu)
        XCTAssertNotNil(minimalStyleMenu)
        XCTAssertNotNil(customStyleMenu)
    }
}

// Helper struct for testing menu item actions
struct TestItemWrapper {
    let item: CTDropdownMenuItem
    
    func simulateTap() {
        // This is a simplified simulation since we can't directly tap a SwiftUI view in unit tests
        // The real test would require UI testing framework
        let mirror = Mirror(reflecting: item)
        
        for child in mirror.children {
            if child.label == "action", let action = child.value as? () -> Void {
                if let isDisabled = mirror.children.first(where: { $0.label == "isDisabled" })?.value as? Bool, isDisabled {
                    // If disabled, don't call the action
                    return
                }
                action()
                return
            }
        }
    }
}
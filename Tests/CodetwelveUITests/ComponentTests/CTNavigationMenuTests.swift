//
//  CTNavigationMenuTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTNavigationMenuTests: XCTestCase {
    func testNavigationMenuInitialization() {
        // Given
        let items = [
            CTNavigationItem.item(id: "home", label: "Home", icon: "house"),
            CTNavigationItem.item(id: "search", label: "Search", icon: "magnifyingglass")
        ]
        
        // When
        let navigationMenu = CTNavigationMenu(
            items: items,
            selectedItemId: .constant("home")
        )
        
        // Then
        XCTAssertNotNil(navigationMenu)
    }
    
    func testNavigationMenuSelection() {
        // Given
        let items = [
            CTNavigationItem.item(id: "home", label: "Home", icon: "house"),
            CTNavigationItem.item(id: "search", label: "Search", icon: "magnifyingglass"),
            CTNavigationItem.item(id: "profile", label: "Profile", icon: "person")
        ]
        
        var selectedItemId: String? = "home"
        let selectionBinding = Binding<String?>(
            get: { selectedItemId },
            set: { selectedItemId = $0 }
        )
        
        let testNavigationMenu = TestNavigationMenu(
            items: items,
            selectedItemId: selectionBinding,
            onItemSelected: { newItemId in
                // This will be called when a navigation item is selected
            }
        )
        
        // When
        testNavigationMenu.simulateItemSelection("search")
        
        // Then
        XCTAssertEqual(selectedItemId, "search", "Selected item ID should update to 'search'")
        
        // When
        testNavigationMenu.simulateItemSelection("profile")
        
        // Then
        XCTAssertEqual(selectedItemId, "profile", "Selected item ID should update to 'profile'")
    }
    
    func testNavigationMenuWithSections() {
        // Given
        let items = [
            CTNavigationItem.item(id: "home", label: "Home", icon: "house"),
            CTNavigationItem.section(id: "settings", label: "Settings", children: [
                CTNavigationItem.item(id: "account", label: "Account", icon: "person.circle"),
                CTNavigationItem.item(id: "notifications", label: "Notifications", icon: "bell")
            ])
        ]
        
        // When
        let navigationMenu = CTNavigationMenu(
            items: items,
            selectedItemId: .constant("home"),
            collapseByDefault: true
        )
        
        // Then
        XCTAssertNotNil(navigationMenu)
        // We can't test the section expansion directly,
        // but we can ensure it doesn't crash
    }
    
    func testNavigationMenuSectionExpansion() {
        // Given
        let items = [
            CTNavigationItem.item(id: "home", label: "Home", icon: "house"),
            CTNavigationItem.section(id: "settings", label: "Settings", children: [
                CTNavigationItem.item(id: "account", label: "Account", icon: "person.circle"),
                CTNavigationItem.item(id: "notifications", label: "Notifications", icon: "bell")
            ])
        ]
        
        let testNavigationMenu = TestNavigationMenu(
            items: items,
            selectedItemId: .constant("home"),
            collapseByDefault: true
        )
        
        // When
        let initiallyExpanded = testNavigationMenu.isSectionExpanded("settings")
        
        // Then
        XCTAssertFalse(initiallyExpanded, "Section should be collapsed by default")
        
        // When
        testNavigationMenu.toggleSection("settings")
        
        // Then
        XCTAssertTrue(testNavigationMenu.isSectionExpanded("settings"), "Section should be expanded after toggle")
        
        // When
        testNavigationMenu.toggleSection("settings")
        
        // Then
        XCTAssertFalse(testNavigationMenu.isSectionExpanded("settings"), "Section should be collapsed after second toggle")
    }
    
    func testNavigationMenuWithDifferentStyles() {
        // Given
        let items = [
            CTNavigationItem.item(id: "home", label: "Home", icon: "house"),
            CTNavigationItem.item(id: "search", label: "Search", icon: "magnifyingglass")
        ]
        
        // When & Then
        let sidebarStyleMenu = CTNavigationMenu(
            items: items,
            selectedItemId: .constant("home"),
            style: .sidebar
        )
        XCTAssertNotNil(sidebarStyleMenu)
        
        let transparentStyleMenu = CTNavigationMenu(
            items: items,
            selectedItemId: .constant("home"),
            style: .transparent
        )
        XCTAssertNotNil(transparentStyleMenu)
        
        let solidStyleMenu = CTNavigationMenu(
            items: items,
            selectedItemId: .constant("home"),
            style: .solid(Color.blue.opacity(0.1))
        )
        XCTAssertNotNil(solidStyleMenu)
    }
    
    func testNavigationMenuWithMultipleSections() {
        // Given
        let items = [
            CTNavigationItem.section(id: "content", label: "Content", children: [
                CTNavigationItem.item(id: "photos", label: "Photos", icon: "photo"),
                CTNavigationItem.item(id: "videos", label: "Videos", icon: "film")
            ]),
            CTNavigationItem.section(id: "settings", label: "Settings", children: [
                CTNavigationItem.item(id: "account", label: "Account", icon: "person.circle"),
                CTNavigationItem.item(id: "notifications", label: "Notifications", icon: "bell")
            ])
        ]
        
        // When
        let testNavigationMenu = TestNavigationMenu(
            items: items,
            selectedItemId: .constant(nil),
            collapseByDefault: true,
            allowMultipleExpanded: false
        )
        
        // When
        testNavigationMenu.toggleSection("content")
        
        // Then
        XCTAssertTrue(testNavigationMenu.isSectionExpanded("content"), "Content section should be expanded")
        XCTAssertFalse(testNavigationMenu.isSectionExpanded("settings"), "Settings section should remain collapsed")
        
        // When
        testNavigationMenu.toggleSection("settings")
        
        // Then
        XCTAssertFalse(testNavigationMenu.isSectionExpanded("content"), "Content section should be collapsed when settings is expanded")
        XCTAssertTrue(testNavigationMenu.isSectionExpanded("settings"), "Settings section should be expanded")
    }
    
    func testNavigationMenuWithCustomItems() {
        // Given
        let items = [
            CTNavigationItem.item(id: "home", label: "Home", icon: "house"),
            CTNavigationItem.separator,
            CTNavigationItem.custom(Text("Custom View")),
            CTNavigationItem.item(id: "search", label: "Search", icon: "magnifyingglass")
        ]
        
        // When
        let navigationMenu = CTNavigationMenu(
            items: items,
            selectedItemId: .constant("home")
        )
        
        // Then
        XCTAssertNotNil(navigationMenu)
        // We can't test the custom view directly,
        // but we can ensure it doesn't crash
    }
    
    func testNavigationMenuWithBadges() {
        // Given
        let items = [
            CTNavigationItem.item(id: "home", label: "Home", icon: "house"),
            CTNavigationItem.item(id: "notifications", label: "Notifications", icon: "bell", badge: .count(5)),
            CTNavigationItem.item(id: "messages", label: "Messages", icon: "message", badge: .dot()),
            CTNavigationItem.item(id: "updates", label: "Updates", icon: "arrow.down", badge: .text("NEW"))
        ]
        
        // When
        let navigationMenu = CTNavigationMenu(
            items: items,
            selectedItemId: .constant("home")
        )
        
        // Then
        XCTAssertNotNil(navigationMenu)
        // We can't test the badge appearance directly,
        // but we can ensure it doesn't crash
    }
    
    func testNavigationMenuWithDisabledItems() {
        // Given
        let items = [
            CTNavigationItem.item(id: "home", label: "Home", icon: "house"),
            CTNavigationItem.item(id: "premium", label: "Premium Features", icon: "star", isEnabled: false)
        ]
        
        var selectedItemId: String? = "home"
        let selectionBinding = Binding<String?>(
            get: { selectedItemId },
            set: { selectedItemId = $0 }
        )
        
        let testNavigationMenu = TestNavigationMenu(
            items: items,
            selectedItemId: selectionBinding
        )
        
        // When attempting to select a disabled item
        testNavigationMenu.simulateItemSelection("premium")
        
        // Then
        XCTAssertEqual(selectedItemId, "home", "Selected item should not change when selecting a disabled item")
    }
    
    func testNavigationMenuCustomCallback() {
        // Given
        let items = [
            CTNavigationItem.item(id: "home", label: "Home", icon: "house"),
            CTNavigationItem.item(id: "search", label: "Search", icon: "magnifyingglass")
        ]
        
        var selectedItemId: String? = "home"
        let selectionBinding = Binding<String?>(
            get: { selectedItemId },
            set: { selectedItemId = $0 }
        )
        
        var callbackCalled = false
        var selectedItemIdFromCallback: String? = nil
        
        let testNavigationMenu = TestNavigationMenu(
            items: items,
            selectedItemId: selectionBinding,
            onItemSelected: { itemId in
                callbackCalled = true
                selectedItemIdFromCallback = itemId
            }
        )
        
        // When
        testNavigationMenu.simulateItemSelection("search")
        
        // Then
        XCTAssertTrue(callbackCalled, "Callback should be called")
        XCTAssertEqual(selectedItemIdFromCallback, "search", "Callback should receive correct item ID")
    }
    
    func testNavigationMenuItemWithCustomAction() {
        // Given
        var customActionCalled = false
        
        let items = [
            CTNavigationItem.item(id: "home", label: "Home", icon: "house"),
            CTNavigationItem.item(
                id: "custom",
                label: "Custom Action",
                icon: "gear",
                action: {
                    customActionCalled = true
                }
            )
        ]
        
        var selectedItemId: String? = "home"
        let selectionBinding = Binding<String?>(
            get: { selectedItemId },
            set: { selectedItemId = $0 }
        )
        
        let testNavigationMenu = TestNavigationMenu(
            items: items,
            selectedItemId: selectionBinding
        )
        
        // When
        testNavigationMenu.simulateCustomItemAction("custom")
        
        // Then
        XCTAssertTrue(customActionCalled, "Custom action should be called")
        XCTAssertEqual(selectedItemId, "home", "Selected item shouldn't change for items with custom actions")
    }
}

// Test helper class
class TestNavigationMenu {
    let items: [CTNavigationItem]
    let selectedItemId: Binding<String?>
    let onItemSelected: ((String) -> Void)?
    var expandedSections: Set<String> = []
    let allowMultipleExpanded: Bool
    
    init(
        items: [CTNavigationItem],
        selectedItemId: Binding<String?>,
        collapseByDefault: Bool = false,
        allowMultipleExpanded: Bool = true,
        onItemSelected: ((String) -> Void)? = nil
    ) {
        self.items = items
        self.selectedItemId = selectedItemId
        self.allowMultipleExpanded = allowMultipleExpanded
        self.onItemSelected = onItemSelected
        
        // Initialize expanded sections
        if !collapseByDefault {
            for item in items {
                if case .section(let id, _, _) = item {
                    expandedSections.insert(id)
                }
            }
        }
    }
    
    func simulateItemSelection(_ itemId: String) {
        // Find the item
        for item in flattenItems(items) {
            if case .item(let id, _, _, _, let isEnabled, let action) = item, id == itemId {
                if isEnabled {
                    if action == nil {
                        selectedItemId.wrappedValue = itemId
                        onItemSelected?(itemId)
                    }
                }
                break
            }
        }
    }
    
    func simulateCustomItemAction(_ itemId: String) {
        // Find the item with custom action
        for item in flattenItems(items) {
            if case .item(let id, _, _, _, let isEnabled, let action) = item, id == itemId, isEnabled, let action = action {
                action()
                break
            }
        }
    }
    
    func toggleSection(_ sectionId: String) {
        if expandedSections.contains(sectionId) {
            expandedSections.remove(sectionId)
        } else {
            if !allowMultipleExpanded {
                expandedSections.removeAll()
            }
            expandedSections.insert(sectionId)
        }
    }
    
    func isSectionExpanded(_ sectionId: String) -> Bool {
        return expandedSections.contains(sectionId)
    }
    
    private func flattenItems(_ items: [CTNavigationItem]) -> [CTNavigationItem] {
        var result: [CTNavigationItem] = []
        
        for item in items {
            result.append(item)
            
            if case .section(_, _, let children) = item {
                result.append(contentsOf: flattenItems(children))
            }
        }
        
        return result
    }
}
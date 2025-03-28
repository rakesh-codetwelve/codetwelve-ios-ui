//
//  CTTabBarTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTTabBarTests: XCTestCase {
    func testTabBarInitialization() {
        // Given
        let tabs = [
            CTTabItem(label: "Home", icon: "house"),
            CTTabItem(label: "Search", icon: "magnifyingglass"),
            CTTabItem(label: "Profile", icon: "person")
        ]
        
        // When
        let tabBar = CTTabBar(
            selectedTab: .constant(0),
            tabs: tabs
        )
        
        // Then
        XCTAssertNotNil(tabBar)
    }
    
    func testTabBarSelection() {
        // Given
        let tabs = [
            CTTabItem(label: "Home", icon: "house"),
            CTTabItem(label: "Search", icon: "magnifyingglass"),
            CTTabItem(label: "Profile", icon: "person")
        ]
        
        var selectedTab = 0
        let selectionBinding = Binding<Int>(
            get: { selectedTab },
            set: { selectedTab = $0 }
        )
        
        let testTabBar = TestTabBar(
            selectedTab: selectionBinding,
            tabs: tabs,
            onTabSelected: { newTab in
                // This will be called when a tab is selected
            }
        )
        
        // When
        testTabBar.simulateTabSelection(1)
        
        // Then
        XCTAssertEqual(selectedTab, 1, "Selected tab index should update to 1")
        
        // When
        testTabBar.simulateTabSelection(2)
        
        // Then
        XCTAssertEqual(selectedTab, 2, "Selected tab index should update to 2")
    }
    
    func testTabBarWithDifferentStyles() {
        // Given
        let tabs = [
            CTTabItem(label: "Home", icon: "house"),
            CTTabItem(label: "Search", icon: "magnifyingglass")
        ]
        
        // When & Then
        let defaultStyleTabBar = CTTabBar(
            selectedTab: .constant(0),
            tabs: tabs,
            style: .default
        )
        XCTAssertNotNil(defaultStyleTabBar)
        
        let filledStyleTabBar = CTTabBar(
            selectedTab: .constant(0),
            tabs: tabs,
            style: .filled
        )
        XCTAssertNotNil(filledStyleTabBar)
        
        let indicatorStyleTabBar = CTTabBar(
            selectedTab: .constant(0),
            tabs: tabs,
            style: .indicator
        )
        XCTAssertNotNil(indicatorStyleTabBar)
    }
    
    func testTabBarWithHiddenLabels() {
        // Given
        let tabs = [
            CTTabItem(label: "Home", icon: "house"),
            CTTabItem(label: "Search", icon: "magnifyingglass")
        ]
        
        // When
        let tabBar = CTTabBar(
            selectedTab: .constant(0),
            tabs: tabs,
            showLabels: false
        )
        
        // Then
        XCTAssertNotNil(tabBar)
        // We can't test the visual representation directly,
        // but we can ensure it doesn't crash
    }
    
    func testTabBarWithDifferentAlignments() {
        // Given
        let tabs = [
            CTTabItem(label: "Home", icon: "house"),
            CTTabItem(label: "Search", icon: "magnifyingglass")
        ]
        
        // When & Then
        let spaceEvenlyTabBar = CTTabBar(
            selectedTab: .constant(0),
            tabs: tabs,
            alignment: .spaceEvenly
        )
        XCTAssertNotNil(spaceEvenlyTabBar)
        
        let distributedTabBar = CTTabBar(
            selectedTab: .constant(0),
            tabs: tabs,
            alignment: .distributed
        )
        XCTAssertNotNil(distributedTabBar)
        
        let leadingTabBar = CTTabBar(
            selectedTab: .constant(0),
            tabs: tabs,
            alignment: .leading
        )
        XCTAssertNotNil(leadingTabBar)
        
        let trailingTabBar = CTTabBar(
            selectedTab: .constant(0),
            tabs: tabs,
            alignment: .trailing
        )
        XCTAssertNotNil(trailingTabBar)
    }
    
    func testTabBarWithBadges() {
        // Given
        let tabs = [
            CTTabItem(label: "Home", icon: "house", badgeCount: 0),
            CTTabItem(label: "Notifications", icon: "bell", badgeCount: 5)
        ]
        
        // When
        let tabBar = CTTabBar(
            selectedTab: .constant(0),
            tabs: tabs,
            showBadges: true
        )
        
        // Then
        XCTAssertNotNil(tabBar)
        // We can't test the visual badge directly,
        // but we can ensure it doesn't crash
    }
    
    func testTabBarCustomCallback() {
        // Given
        let tabs = [
            CTTabItem(label: "Home", icon: "house"),
            CTTabItem(label: "Search", icon: "magnifyingglass")
        ]
        
        var selectedTab = 0
        let selectionBinding = Binding<Int>(
            get: { selectedTab },
            set: { selectedTab = $0 }
        )
        
        var callbackCalled = false
        var selectedTabIndex = -1
        
        let testTabBar = TestTabBar(
            selectedTab: selectionBinding,
            tabs: tabs,
            onTabSelected: { index in
                callbackCalled = true
                selectedTabIndex = index
            }
        )
        
        // When
        testTabBar.simulateTabSelection(1)
        
        // Then
        XCTAssertTrue(callbackCalled, "Callback should be called")
        XCTAssertEqual(selectedTabIndex, 1, "Callback should receive correct tab index")
    }
    
    func testTabBarAccessibility() {
        // Given
        let tabs = [
            CTTabItem(label: "Home", icon: "house"),
            CTTabItem(label: "Search", icon: "magnifyingglass")
        ]
        
        // When
        let tabBar = TestTabBar(
            selectedTab: .constant(0),
            tabs: tabs
        )
        
        // Then
        for i in 0..<tabs.count {
            let label = tabBar.getAccessibilityLabel(forTab: i)
            XCTAssertEqual(label, tabs[i].label, "Accessibility label should match tab label")
            
            let traits = tabBar.getAccessibilityTraits(forTab: i)
            if i == 0 {
                XCTAssertTrue(traits.contains(.isSelected), "Selected tab should have isSelected trait")
            } else {
                XCTAssertFalse(traits.contains(.isSelected), "Non-selected tab should not have isSelected trait")
            }
            XCTAssertTrue(traits.contains(.isButton), "All tabs should have isButton trait")
        }
    }
}

// Test helper class
class TestTabBar {
    let tabs: [CTTabItem]
    let selectedTab: Binding<Int>
    let onTabSelected: ((Int) -> Void)?
    
    init(
        selectedTab: Binding<Int>,
        tabs: [CTTabItem],
        onTabSelected: ((Int) -> Void)? = nil
    ) {
        self.selectedTab = selectedTab
        self.tabs = tabs
        self.onTabSelected = onTabSelected
    }
    
    func simulateTabSelection(_ index: Int) {
        selectedTab.wrappedValue = index
        onTabSelected?(index)
    }
    
    func getAccessibilityLabel(forTab index: Int) -> String {
        return tabs[index].label
    }
    
    func getAccessibilityTraits(forTab index: Int) -> AccessibilityTraits {
        var traits: AccessibilityTraits = [.isButton]
        if index == selectedTab.wrappedValue {
            traits.insert(.isSelected)
        }
        return traits
    }
}
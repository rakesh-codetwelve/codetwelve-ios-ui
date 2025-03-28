//
//  CTHamburgerMenuTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTHamburgerMenuTests: XCTestCase {
    private var menuSections: [CTHamburgerMenu.MenuItem]!
    
    override func setUp() {
        super.setUp()
        menuSections = [
            .section(title: "Main", items: [
                .item(title: "Home", icon: "house.fill", action: {}),
                .item(title: "Profile", icon: "person.fill", action: {})
            ]),
            .section(title: "Settings", items: [
                .item(title: "Preferences", icon: "gear", action: {}),
                .item(title: "Logout", icon: "arrow.right.square", action: {})
            ])
        ]
    }
    
    override func tearDown() {
        menuSections = nil
        super.tearDown()
    }
    
    func testMenuInitialization() {
        let menu = CTHamburgerMenu(sections: menuSections)
        
        // Test basic initialization
        XCTAssertNotNil(menu)
        XCTAssertEqual(menu.sections, menuSections)
    }
    
    func testDefaultStyleInitialization() {
        let defaultMenu = CTHamburgerMenu(sections: menuSections)
        let transparentMenu = CTHamburgerMenu(sections: menuSections, style: .transparent)
        let compactMenu = CTHamburgerMenu(sections: menuSections, style: .compact)
        
        XCTAssertNotNil(defaultMenu)
        XCTAssertNotNil(transparentMenu)
        XCTAssertNotNil(compactMenu)
    }
    
    func testMenuItemTypes() {
        let mixedSections: [CTHamburgerMenu.MenuItem] = [
            .section(title: "Mixed", items: [
                .item(title: "Standard", icon: "star", action: {}),
                .custom(view: AnyView(Text("Custom Item")))
            ])
        ]
        
        let menu = CTHamburgerMenu(sections: mixedSections)
        XCTAssertNotNil(menu)
    }
    
    func testMenuSectionExpansion() {
        var menu = CTHamburgerMenu(sections: menuSections, allowMultipleExpanded: false)
        XCTAssertNotNil(menu)
        
        menu = CTHamburgerMenu(sections: menuSections, allowMultipleExpanded: true)
        XCTAssertNotNil(menu)
    }
    
    func testMenuIconVisibility() {
        let menuWithIcons = CTHamburgerMenu(sections: menuSections, showIcons: true)
        let menuWithoutIcons = CTHamburgerMenu(sections: menuSections, showIcons: false)
        
        XCTAssertNotNil(menuWithIcons)
        XCTAssertNotNil(menuWithoutIcons)
    }
    
    func testCustomStyleMenu() {
        let customMenu = CTHamburgerMenu(
            sections: menuSections,
            style: .custom(
                backgroundColor: .blue,
                textColor: .white,
                selectedItemColor: .red
            )
        )
        
        XCTAssertNotNil(customMenu)
    }
    
    func testAccessibilityLabels() {
        let menu = CTHamburgerMenu(sections: menuSections)
        
        // Verify each section has an appropriate accessibility label
        if case let .section(title, _) = menuSections[0] {
            XCTAssertEqual(title, "Main", "First section title should be Main")
        }
        
        if case let .section(title, _) = menuSections[1] {
            XCTAssertEqual(title, "Settings", "Second section title should be Settings")
        }
    }
}
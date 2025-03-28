//
//  CTAccordionTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTAccordionTests: XCTestCase {
    // Test accordion initialization with a simple text label
    func testAccordionCreation() {
        let accordion = CTAccordion(label: "Test Accordion") {
            Text("Accordion content")
        }
        
        XCTAssertNotNil(accordion)
    }
    
    // Test accordion initialization with a custom header
    func testAccordionWithCustomHeader() {
        let accordion = CTAccordion(
            headerContent: {
                HStack {
                    Image(systemName: "star.fill")
                    Text("Custom Header")
                }
            },
            content: {
                Text("Accordion content")
            }
        )
        
        XCTAssertNotNil(accordion)
    }
    
    // Test accordion with different styles
    func testAccordionStyles() {
        let defaultStyle = CTAccordion(label: "Default Style", style: .default) {
            Text("Content")
        }
        
        let borderedStyle = CTAccordion(label: "Bordered Style", style: .bordered) {
            Text("Content")
        }
        
        let filledStyle = CTAccordion(label: "Filled Style", style: .filled) {
            Text("Content")
        }
        
        let subtleStyle = CTAccordion(label: "Subtle Style", style: .subtle) {
            Text("Content")
        }
        
        let customStyle = CTAccordion(
            style: .custom(
                headerColor: .red,
                chevronColor: .blue,
                headerBackgroundColor: .green,
                contentBackgroundColor: .yellow,
                headerPadding: EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8),
                contentPadding: EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8),
                cornerRadius: 8,
                font: .headline
            ),
            headerContent: {
                Text("Custom Style")
            },
            content: {
                Text("Content")
            }
        )
        
        XCTAssertNotNil(defaultStyle)
        XCTAssertNotNil(borderedStyle)
        XCTAssertNotNil(filledStyle)
        XCTAssertNotNil(subtleStyle)
        XCTAssertNotNil(customStyle)
    }
    
    // Test accordion initial expansion state
    func testAccordionInitialExpansion() {
        // Create an accordion that starts expanded
        let expandedAccordion = TestAccordion(initiallyExpanded: true)
        
        // Create an accordion that starts collapsed
        let collapsedAccordion = TestAccordion(initiallyExpanded: false)
        
        XCTAssertTrue(expandedAccordion.isExpanded, "Accordion should be initially expanded")
        XCTAssertFalse(collapsedAccordion.isExpanded, "Accordion should be initially collapsed")
    }
    
    // Test accordion group controller
    func testAccordionGroupController() {
        let controller = AccordionGroupController()
        
        // Initially no accordion should be expanded
        XCTAssertNil(controller.expandedAccordionID)
        
        // Set an expanded accordion
        controller.setExpandedAccordion(id: "section1")
        XCTAssertEqual(controller.expandedAccordionID, "section1")
        
        // Set a different expanded accordion
        controller.setExpandedAccordion(id: "section2")
        XCTAssertEqual(controller.expandedAccordionID, "section2")
        
        // Collapse all
        controller.collapseAll()
        XCTAssertNil(controller.expandedAccordionID)
    }
}

// Helper class for testing internal state
private struct TestAccordion: View {
    @State var isExpanded: Bool
    
    init(initiallyExpanded: Bool) {
        self._isExpanded = State(initialValue: initiallyExpanded)
    }
    
    var body: some View {
        CTAccordion(
            label: "Test",
            initiallyExpanded: isExpanded
        ) {
            Text("Content")
        }
    }
}
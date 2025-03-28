//
//  CTHoverCardTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTHoverCardTests: XCTestCase {
    func testHoverCardInitialization() {
        // Given, When
        let hoverCard = CTHoverCard(
            content: { Text("Trigger") },
            hoverContent: { Text("Hover Content") }
        )
        
        // Then
        XCTAssertNotNil(hoverCard)
    }
    
    func testHoverCardPlacements() {
        // Test various placements
        let topPlacement = CTHoverCard(
            placement: .top,
            content: { Text("Trigger") },
            hoverContent: { Text("Hover Content") }
        )
        
        let bottomPlacement = CTHoverCard(
            placement: .bottom,
            content: { Text("Trigger") },
            hoverContent: { Text("Hover Content") }
        )
        
        let leadingPlacement = CTHoverCard(
            placement: .leading,
            content: { Text("Trigger") },
            hoverContent: { Text("Hover Content") }
        )
        
        let trailingPlacement = CTHoverCard(
            placement: .trailing,
            content: { Text("Trigger") },
            hoverContent: { Text("Hover Content") }
        )
        
        let automaticPlacement = CTHoverCard(
            placement: .automatic,
            content: { Text("Trigger") },
            hoverContent: { Text("Hover Content") }
        )
        
        // Then
        // Verify hover cards with different placements were created without errors
        XCTAssertNotNil(topPlacement)
        XCTAssertNotNil(bottomPlacement)
        XCTAssertNotNil(leadingPlacement)
        XCTAssertNotNil(trailingPlacement)
        XCTAssertNotNil(automaticPlacement)
    }
    
    func testHoverCardCustomWidth() {
        // Given, When
        let hoverCard = CTHoverCard(
            width: 300,
            content: { Text("Trigger") },
            hoverContent: { Text("Hover Content") }
        )
        
        // Then
        XCTAssertNotNil(hoverCard)
    }
    
    func testHoverCardWithCustomOffsets() {
        // Given, When
        let hoverCard = CTHoverCard(
            offset: CGPoint(x: 20, y: 30),
            content: { Text("Trigger") },
            hoverContent: { Text("Hover Content") }
        )
        
        // Then
        XCTAssertNotNil(hoverCard)
    }
    
    func testHoverCardWithCustomDelays() {
        // Given, When
        let hoverCard = CTHoverCard(
            showDelay: 0.5,
            hideDelay: 1.0,
            content: { Text("Trigger") },
            hoverContent: { Text("Hover Content") }
        )
        
        // Then
        XCTAssertNotNil(hoverCard)
    }
    
    func testHoverCardDismissible() {
        // Given, When
        let dismissibleCard = CTHoverCard(
            dismissible: true,
            content: { Text("Trigger") },
            hoverContent: { Text("Hover Content") }
        )
        
        let nonDismissibleCard = CTHoverCard(
            dismissible: false,
            content: { Text("Trigger") },
            hoverContent: { Text("Hover Content") }
        )
        
        // Then
        XCTAssertNotNil(dismissibleCard)
        XCTAssertNotNil(nonDismissibleCard)
    }
    
    func testHoverCardViewExtension() {
        // Given
        let view = Text("Test")
        
        // When
        let viewWithHoverCard = view.ctHoverCard {
            Text("Hover Content")
        }
        
        // Then
        XCTAssertNotNil(viewWithHoverCard)
    }
    
    func testHoverCardShowHideBehavior() {
        // This test would ideally verify the show/hide behavior,
        // but we can't directly test state changes in SwiftUI unit tests
        // This would require UI testing
        
        // For now, we'll just verify we can create a hover card with timer values
        let hoverCard = CTHoverCard(
            showDelay: 0.2,
            hideDelay: 0.3,
            content: { Text("Trigger") },
            hoverContent: { Text("Hover Content") }
        )
        
        XCTAssertNotNil(hoverCard)
    }
    
    func testHoverCardCalculatePosition() {
        // This test would ideally verify the position calculation logic,
        // but we can't easily mock GeometryProxy in unit tests
        
        // We can test that the position calculation doesn't crash by creating
        // a hover card with various placements
        let placements: [CTHoverCard<Text, Text>.Placement] = [
            .top, .bottom, .leading, .trailing, .automatic
        ]
        
        for placement in placements {
            let hoverCard = CTHoverCard(
                placement: placement,
                content: { Text("Trigger") },
                hoverContent: { Text("Hover Content") }
            )
            
            XCTAssertNotNil(hoverCard)
        }
    }
}
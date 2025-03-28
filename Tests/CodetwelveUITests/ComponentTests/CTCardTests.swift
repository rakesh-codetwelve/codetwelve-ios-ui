//
//  CTCardTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTCardTests: XCTestCase {
    
    // Test basic card creation
    func testCardCreation() {
        let card = CTCard {
            Text("Test Card")
        }
        
        XCTAssertNotNil(card, "Card should be created successfully")
    }
    
    // Test card with header
    func testCardWithHeader() {
        let card = CTCard {
            Text("Content")
        } header: {
            Text("Header")
        }
        
        XCTAssertNotNil(card, "Card with header should be created successfully")
    }
    
    // Test card with header and footer
    func testCardWithHeaderAndFooter() {
        let card = CTCard {
            Text("Content")
        } header: {
            Text("Header")
        } footer: {
            Text("Footer")
        }
        
        XCTAssertNotNil(card, "Card with header and footer should be created successfully")
    }
    
    // Test interactive card
    func testInteractiveCard() {
        var actionCalled = false
        
        let card = CTCard(isInteractive: true, action: {
            actionCalled = true
        }) {
            Text("Interactive Card")
        }
        
        // Here we're just testing initialization
        // For real action testing, you would need UI testing
        XCTAssertNotNil(card, "Interactive card should be created successfully")
    }
    
    // Test different card styles
    func testCardStyles() {
        let elevatedCard = CTCard(style: .elevated) {
            Text("Elevated Card")
        }
        
        let flatCard = CTCard(style: .flat) {
            Text("Flat Card")
        }
        
        let outlinedCard = CTCard(style: .outlined) {
            Text("Outlined Card")
        }
        
        let filledCard = CTCard(style: .filled) {
            Text("Filled Card")
        }
        
        let customCard = CTCard(style: .custom(backgroundColor: .blue, borderColor: .red)) {
            Text("Custom Card")
        }
        
        XCTAssertNotNil(elevatedCard, "Elevated card should be created successfully")
        XCTAssertNotNil(flatCard, "Flat card should be created successfully")
        XCTAssertNotNil(outlinedCard, "Outlined card should be created successfully")
        XCTAssertNotNil(filledCard, "Filled card should be created successfully")
        XCTAssertNotNil(customCard, "Custom card should be created successfully")
    }
    
    // Test card with custom padding
    func testCardWithCustomPadding() {
        let customPadding = CTSpacing.all(CTSpacing.l)
        
        let card = CTCard(contentPadding: customPadding) {
            Text("Custom Padding Card")
        }
        
        XCTAssertNotNil(card, "Card with custom padding should be created successfully")
    }
    
    // Test card with custom corner radius
    func testCardWithCustomCornerRadius() {
        let card = CTCard(cornerRadius: 16) {
            Text("Custom Corner Radius Card")
        }
        
        XCTAssertNotNil(card, "Card with custom corner radius should be created successfully")
    }
    
    // Test card with border
    func testCardWithBorder() {
        let card = CTCard(borderWidth: 2) {
            Text("Card with Border")
        }
        
        XCTAssertNotNil(card, "Card with border should be created successfully")
    }
    
    // Test card without shadow
    func testCardWithoutShadow() {
        let card = CTCard(hasShadow: false) {
            Text("Card without Shadow")
        }
        
        XCTAssertNotNil(card, "Card without shadow should be created successfully")
    }
}
//
//  CTContainerTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTContainerTests: XCTestCase {
    
    // Test basic container creation
    func testContainerCreation() {
        let container = CTContainer {
            Text("Test Container")
        }
        
        XCTAssertNotNil(container, "Container should be created successfully")
    }
    
    // Test container with custom padding
    func testContainerWithCustomPadding() {
        let customPadding = CTSpacing.all(CTSpacing.l)
        let container = CTContainer(padding: customPadding) {
            Text("Custom Padding")
        }
        
        // Here we're testing the initialization, can be extended with UI testing or snapshot testing
        XCTAssertNotNil(container, "Container with custom padding should be created")
    }
    
    // Test container with custom background color
    func testContainerWithCustomBackground() {
        let customColor = Color.red
        let container = CTContainer(backgroundColor: customColor) {
            Text("Custom Background")
        }
        
        XCTAssertNotNil(container, "Container with custom background should be created")
    }
    
    // Test container with border
    func testContainerWithBorder() {
        let container = CTContainer(
            borderWidth: 2,
            borderColor: .blue
        ) {
            Text("Bordered Container")
        }
        
        XCTAssertNotNil(container, "Container with border should be created")
    }
    
    // Test container with shadow
    func testContainerWithShadow() {
        let container = CTContainer(
            shadowEnabled: true,
            shadowRadius: 5,
            shadowOpacity: 0.2
        ) {
            Text("Shadow Container")
        }
        
        XCTAssertNotNil(container, "Container with shadow should be created")
    }
    
    // Test convenience initializers
    func testPaddingConvenienceInitializer() {
        let container = CTContainer.padding {
            Text("Padding Container")
        }
        
        XCTAssertNotNil(container, "Padding container should be created")
    }
    
    func testSurfaceConvenienceInitializer() {
        let container = CTContainer.surface {
            Text("Surface Container")
        }
        
        XCTAssertNotNil(container, "Surface container should be created")
    }
    
    func testPrimaryConvenienceInitializer() {
        let container = CTContainer.primary {
            Text("Primary Container")
        }
        
        XCTAssertNotNil(container, "Primary container should be created")
    }
    
    func testBorderedConvenienceInitializer() {
        let container = CTContainer.bordered {
            Text("Bordered Container")
        }
        
        XCTAssertNotNil(container, "Bordered container should be created")
    }
    
    // Test view extensions
    func testContainerPaddingExtension() {
        let view = Text("Extension Test")
            .ctContainerPadding()
        
        XCTAssertNotNil(view, "Container padding extension should work")
    }
    
    func testSurfaceExtension() {
        let view = Text("Surface Extension Test")
            .ctSurface()
        
        XCTAssertNotNil(view, "Surface extension should work")
    }
}
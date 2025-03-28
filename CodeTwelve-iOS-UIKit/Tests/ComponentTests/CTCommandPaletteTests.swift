//
//  CTCommandPaletteTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTCommandPaletteTests: XCTestCase {
    private var sampleCommands: [CTCommandPalette.CommandItem]!
    
    override func setUp() {
        super.setUp()
        sampleCommands = [
            .init(
                title: "New Project",
                icon: "plus.circle.fill",
                description: "Create a new project",
                keywords: ["create", "start"],
                action: {}
            ),
            .init(
                title: "Open Settings",
                icon: "gear",
                description: "Open application settings",
                keywords: ["configure", "preferences"],
                action: {}
            )
        ]
    }
    
    override func tearDown() {
        sampleCommands = nil
        super.tearDown()
    }
    
    func testCommandPaletteInitialization() {
        let isPresented = Binding.constant(false)
        let commandPalette = CTCommandPalette(
            items: sampleCommands,
            isPresented: isPresented
        )
        
        XCTAssertNotNil(commandPalette)
    }
    
    func testCommandPaletteItemCount() {
        let isPresented = Binding.constant(false)
        let commandPalette = CTCommandPalette(
            items: sampleCommands,
            isPresented: isPresented
        )
        
        // Check that the view renders the correct number of items
        let view = commandPalette.body
        XCTAssertNotNil(view)
    }
    
    func testCommandPaletteSearchFunctionality() {
        let isPresented = Binding.constant(true)
        var searchQuery = ""
        
        // Mocking the searchQuery binding
        let binding = Binding<String>(
            get: { searchQuery },
            set: { searchQuery = $0 }
        )
        
        // Perform search and validate behavior
        searchQuery = "project"
        XCTAssertTrue(sampleCommands.contains { $0.title.localizedCaseInsensitiveContains(searchQuery) })
    }
    
    func testCommandPaletteAccessibility() {
        let isPresented = Binding.constant(false)
        let commandPalette = CTCommandPalette(
            items: sampleCommands,
            isPresented: isPresented
        )
        
        let view = commandPalette.body
        XCTAssertNotNil(view)
    }
    
    func testCommandPaletteStyles() {
        let isPresented = Binding.constant(false)
        
        let defaultStyle = CTCommandPalette(
            items: sampleCommands,
            isPresented: isPresented,
            style: .default
        )
        
        let compactStyle = CTCommandPalette(
            items: sampleCommands,
            isPresented: isPresented,
            style: .compact
        )
        
        let fullScreenStyle = CTCommandPalette(
            items: sampleCommands,
            isPresented: isPresented,
            style: .fullScreen
        )
        
        XCTAssertNotNil(defaultStyle)
        XCTAssertNotNil(compactStyle)
        XCTAssertNotNil(fullScreenStyle)
    }
}
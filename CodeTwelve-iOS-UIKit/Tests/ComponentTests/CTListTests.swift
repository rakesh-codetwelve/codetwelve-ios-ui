//
//  CTListTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTListTests: XCTestCase {
    // Test data
    struct TestItem: Hashable {
        let id: String
        let value: String
    }
    
    private let testData = [
        TestItem(id: "1", value: "First"),
        TestItem(id: "2", value: "Second"),
        TestItem(id: "3", value: "Third")
    ]
    
    func testListInitialization() {
        let list = CTList(testData) { item in
            Text(item.value)
        }
        
        XCTAssertEqual(list.layout, .vertical, "Default list layout should be vertical")
    }
    
    func testHorizontalListInitialization() {
        let list = CTList(
            testData,
            layout: .horizontal
        ) { item in
            Text(item.value)
        }
        
        XCTAssertEqual(list.layout, .horizontal, "Horizontal list layout should be set correctly")
    }
    
    func testGridListInitialization() {
        let list = CTList(
            testData,
            layout: .grid(columns: 3)
        ) { item in
            Text(item.value)
        }
        
        XCTAssertEqual(list.layout, .grid(columns: 3), "Grid list layout should be set correctly")
    }
    
    func testListSelection() {
        var selectedItem: TestItem?
        let list = CTList(
            testData,
            selection: Binding(
                get: { selectedItem },
                set: { selectedItem = $0 }
            )
        ) { item in
            Text(item.value)
        }
        
        XCTAssertNil(selectedItem, "Initial selection should be nil")
    }
    
    func testListWithStringData() {
        let stringList = CTList(["A", "B", "C"])
        
        XCTAssertEqual(stringList.layout, .vertical, "String list should default to vertical layout")
    }
}
//
//  CTPaginationTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTPaginationTests: XCTestCase {
    func testPaginationInitialization() {
        // Arrange
        var currentPage = 1
        
        // Act
        let paginationView = CTPagination(
            currentPage: Binding(
                get: { currentPage },
                set: { currentPage = $0 }
            ),
            totalPages: 10
        )
        
        // Assert
        XCTAssertNotNil(paginationView)
    }
    
    func testPaginationPageChange() {
        // Arrange
        var currentPage = 1
        var pageChangeCalled = false
        
        // Act
        let paginationView = CTPagination(
            currentPage: Binding(
                get: { currentPage },
                set: { currentPage = $0 }
            ),
            totalPages: 10,
            onPageChange: { _ in
                pageChangeCalled = true
            }
        )
        
        // Simulate page change
        paginationView.changePage(to: 5)
        
        // Assert
        XCTAssertEqual(currentPage, 5)
        XCTAssertTrue(pageChangeCalled)
    }
    
    func testPaginationBoundaries() {
        // Arrange
        var currentPage = 1
        
        // Test lower boundary
        let lowerView = CTPagination(
            currentPage: Binding(
                get: { currentPage },
                set: { currentPage = $0 }
            ),
            totalPages: 10
        )
        lowerView.changePage(to: 0)
        XCTAssertEqual(currentPage, 1)
        
        // Test upper boundary
        let upperView = CTPagination(
            currentPage: Binding(
                get: { currentPage },
                set: { currentPage = $0 }
            ),
            totalPages: 10
        )
        upperView.changePage(to: 11)
        XCTAssertEqual(currentPage, 1)
    }
    
    func testPaginationVisiblePages() {
        // Arrange
        var currentPage = 5
        let paginationView = CTPagination(
            currentPage: Binding(
                get: { currentPage },
                set: { currentPage = $0 }
            ),
            totalPages: 10,
            pageRange: 2
        )
        
        // Act
        let visiblePages = paginationView.visiblePages
        
        // Assert
        XCTAssertEqual(visiblePages, [3, 4, 5, 6, 7])
    }
    
    func testPaginationSizes() {
        // Test different pagination sizes
        let sizes: [CTPagination.PaginationSize] = [.small, .medium, .large]
        
        sizes.forEach { size in
            let paginationView = CTPagination(
                currentPage: Binding(
                    get: { 5 },
                    set: { _ in }
                ),
                totalPages: 10,
                size: size
            )
            
            XCTAssertNotNil(paginationView)
        }
    }
    
    func testPaginationEdgeButtons() {
        // Arrange
        var currentPage = 5
        
        // Test with edge buttons shown
        let withEdgeButtons = CTPagination(
            currentPage: Binding(
                get: { currentPage },
                set: { currentPage = $0 }
            ),
            totalPages: 10,
            showEdgeButtons: true
        )
        
        // Test with edge buttons hidden
        let withoutEdgeButtons = CTPagination(
            currentPage: Binding(
                get: { currentPage },
                set: { currentPage = $0 }
            ),
            totalPages: 10,
            showEdgeButtons: false
        )
        
        // Assert
        XCTAssertNotNil(withEdgeButtons)
        XCTAssertNotNil(withoutEdgeButtons)
    }
    
    func testPaginationAccessibility() {
        // Arrange
        var currentPage = 5
        
        // Act
        let paginationView = CTPagination(
            currentPage: Binding(
                get: { currentPage },
                set: { currentPage = $0 }
            ),
            totalPages: 10
        )
        
        // Assert
        // Verify that the pagination view has a meaningful accessibility label
        XCTAssertTrue(
            paginationView.accessibilityLabel.contains("Pagination"),
            "Accessibility label should contain 'Pagination'"
        )
        XCTAssertTrue(
            paginationView.accessibilityLabel.contains("Page 5 of 10"),
            "Accessibility label should specify current and total pages"
        )
    }
    
    func testPaginationWithEdgeCases() {
        // Test first page
        var currentPage = 1
        let firstPageView = CTPagination(
            currentPage: Binding(
                get: { currentPage },
                set: { currentPage = $0 }
            ),
            totalPages: 10
        )
        
        // Test last page
        currentPage = 10
        let lastPageView = CTPagination(
            currentPage: Binding(
                get: { currentPage },
                set: { currentPage = $0 }
            ),
            totalPages: 10
        )
        
        // Test single page
        let singlePageView = CTPagination(
            currentPage: Binding(
                get: { 1 },
                set: { _ in }
            ),
            totalPages: 1
        )
        
        // Assert
        XCTAssertNotNil(firstPageView)
        XCTAssertNotNil(lastPageView)
        XCTAssertNotNil(singlePageView)
    }
    
    func testPaginationPageRangeVariations() {
        // Test different page range configurations
        let pageRanges = [0, 1, 2, 3, 5]
        
        pageRanges.forEach { range in
            let paginationView = CTPagination(
                currentPage: Binding(
                    get: { 5 },
                    set: { _ in }
                ),
                totalPages: 10,
                pageRange: range
            )
            
            XCTAssertNotNil(paginationView)
        }
    }
    
    func testCustomPaginationStyle() {
        // Arrange
        let customColor = Color.purple
        
        // Act
        let customPaginationView = CTPagination(
            currentPage: Binding(
                get: { 5 },
                set: { _ in }
            ),
            totalPages: 10,
            style: .custom(customColor)
        )
        
        // Assert
        XCTAssertNotNil(customPaginationView)
    }
}
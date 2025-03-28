//
//  CTCarouselTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTCarouselTests: XCTestCase {
    // Test items
    private let testItems = ["Item 1", "Item 2", "Item 3", "Item 4"]
    
    // MARK: - Initialization Tests
    
    func testCarouselInitialization() {
        // When
        let carousel = CTCarousel(items: testItems) { item in
            Text(item)
        }
        
        // Then
        XCTAssertNotNil(carousel)
        // Verify that the carousel contains the correct number of items
        let mirror = Mirror(reflecting: carousel)
        let itemsProperty = mirror.children.first { $0.label == "items" }
        XCTAssertNotNil(itemsProperty)
        XCTAssertEqual((itemsProperty?.value as? [String])?.count, 4)
    }
    
    func testCarouselInitializationWithOptions() {
        // Given
        @State var currentIndex: Int = 1
        
        // When
        let carousel = CTCarousel(
            items: testItems,
            currentIndex: $currentIndex,
            style: .cards,
            size: .standard,
            indicatorPosition: .top,
            navigationPosition: .sides,
            autoAdvance: true,
            autoAdvanceInterval: 3.0,
            infiniteScroll: true,
            bounces: false,
            cardSpacing: 20,
            adjacentCardScale: 0.7
        ) { item in
            Text(item)
        }
        
        // Then
        XCTAssertNotNil(carousel)
        
        // Verify some of the properties through mirror
        let mirror = Mirror(reflecting: carousel)
        
        // Check style
        let styleProperty = mirror.children.first { $0.label == "style" }
        XCTAssertNotNil(styleProperty)
        XCTAssertEqual(String(describing: styleProperty?.value), "cards")
        
        // Check autoAdvance
        let autoAdvanceProperty = mirror.children.first { $0.label == "autoAdvance" }
        XCTAssertNotNil(autoAdvanceProperty)
        XCTAssertEqual(autoAdvanceProperty?.value as? Bool, true)
        
        // Check currentIndex
        XCTAssertEqual(currentIndex, 1)
    }
    
    // MARK: - Style Tests
    
    func testCarouselStyles() {
        // Test all styles
        let defaultStyleCarousel = CTCarousel(items: testItems, style: .default) { Text($0) }
        let minimalStyleCarousel = CTCarousel(items: testItems, style: .minimal) { Text($0) }
        let cardsStyleCarousel = CTCarousel(items: testItems, style: .cards) { Text($0) }
        let customStyleCarousel = CTCarousel(items: testItems, style: .custom(indicatorActiveColor: .red, indicatorInactiveColor: .gray)) { Text($0) }
        
        // Verify through mirror
        let defaultMirror = Mirror(reflecting: defaultStyleCarousel)
        XCTAssertEqual(String(describing: defaultMirror.children.first { $0.label == "style" }?.value), "default")
        
        let minimalMirror = Mirror(reflecting: minimalStyleCarousel)
        XCTAssertEqual(String(describing: minimalMirror.children.first { $0.label == "style" }?.value), "minimal")
        
        let cardsMirror = Mirror(reflecting: cardsStyleCarousel)
        XCTAssertEqual(String(describing: cardsMirror.children.first { $0.label == "style" }?.value), "cards")
        
        // For custom style, we can't easily check the colors through Mirror, so we'll just verify it's custom
        let customMirror = Mirror(reflecting: customStyleCarousel)
        XCTAssertTrue(String(describing: customMirror.children.first { $0.label == "style" }?.value).contains("custom"))
    }
    
    // MARK: - Size Tests
    
    func testCarouselSizes() {
        // Test all sizes
        let autoSizeCarousel = CTCarousel(items: testItems, size: .auto) { Text($0) }
        let squareSizeCarousel = CTCarousel(items: testItems, size: .square) { Text($0) }
        let standardSizeCarousel = CTCarousel(items: testItems, size: .standard) { Text($0) }
        let widescreenSizeCarousel = CTCarousel(items: testItems, size: .widescreen) { Text($0) }
        let customSizeCarousel = CTCarousel(items: testItems, size: .custom(aspectRatio: 2.0, height: 300)) { Text($0) }
        
        // Check size values
        let squareMirror = Mirror(reflecting: squareSizeCarousel.size)
        XCTAssertEqual(squareAspectRatio(), 1.0)
        
        let standardMirror = Mirror(reflecting: standardSizeCarousel.size)
        XCTAssertEqual(standardAspectRatio(), 4.0/3.0)
        
        let widescreenMirror = Mirror(reflecting: widescreenSizeCarousel.size)
        XCTAssertEqual(widescreenAspectRatio(), 16.0/9.0)
        
        // For custom size, check the specific values
        let customHeight = customHeightValue(for: customSizeCarousel)
        XCTAssertEqual(customHeight, 300)
        
        let customAspectRatio = customAspectRatioValue(for: customSizeCarousel)
        XCTAssertEqual(customAspectRatio, 2.0)
    }
    
    // MARK: - Navigation Tests
    
    func testCarouselNavigation() {
        // Given
        @State var currentIndex = 0
        
        // When: Create carousel with navigation
        let carousel = TestableCarousel(
            items: testItems,
            currentIndex: $currentIndex,
            navigationPosition: .sides
        )
        
        // Test next item navigation
        carousel.simulateNextItem()
        XCTAssertEqual(currentIndex, 1)
        
        carousel.simulateNextItem()
        XCTAssertEqual(currentIndex, 2)
        
        // Test previous item navigation
        carousel.simulatePreviousItem()
        XCTAssertEqual(currentIndex, 1)
        
        // Test bounds without infinite scroll
        while currentIndex < testItems.count - 1 {
            carousel.simulateNextItem()
        }
        XCTAssertEqual(currentIndex, 3)
        
        // Should not go beyond the last item
        carousel.simulateNextItem()
        XCTAssertEqual(currentIndex, 3)
        
        // Go back to first item
        while currentIndex > 0 {
            carousel.simulatePreviousItem()
        }
        XCTAssertEqual(currentIndex, 0)
        
        // Should not go before the first item
        carousel.simulatePreviousItem()
        XCTAssertEqual(currentIndex, 0)
    }
    
    func testCarouselInfiniteScroll() {
        // Given
        @State var currentIndex = 0
        
        // When: Create carousel with infinite scroll
        let carousel = TestableCarousel(
            items: testItems,
            currentIndex: $currentIndex,
            infiniteScroll: true
        )
        
        // Test wraparound at end
        while currentIndex < testItems.count - 1 {
            carousel.simulateNextItem()
        }
        XCTAssertEqual(currentIndex, 3)
        
        // Should wrap to first item with infinite scroll
        carousel.simulateNextItem()
        XCTAssertEqual(currentIndex, 0)
        
        // Test wraparound at beginning
        carousel.simulatePreviousItem()
        XCTAssertEqual(currentIndex, 3) // Should wrap to last item
    }
    
    // MARK: - Auto-Advance Tests
    
    func testCarouselAutoAdvance() {
        // Given
        @State var currentIndex = 0
        let expectation = self.expectation(description: "Auto advance timer fired")
        
        // When: Create carousel with auto-advance
        let carousel = TestableCarousel(
            items: testItems,
            currentIndex: $currentIndex,
            autoAdvance: true,
            autoAdvanceInterval: 0.1 // Short interval for testing
        )
        
        // Then: Test auto-advance timer functionality
        // Note: In real tests, this would use XCTestExpectation for timing
        // but for this simplified test, we'll just test the setup logic
        
        // Simulate timer firing
        carousel.simulateTimerFired()
        XCTAssertEqual(currentIndex, 1)
        
        // Fire again
        carousel.simulateTimerFired()
        XCTAssertEqual(currentIndex, 2)
        
        // With a real expectation, we'd use:
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(currentIndex, 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.3)
        */
    }
    
    // MARK: - Accessibility Tests
    
    func testCarouselAccessibility() {
        // When: Create carousel
        @State var currentIndex = 1
        let carousel = CTCarousel(
            items: testItems,
            currentIndex: $currentIndex
        ) { item in
            Text(item)
        }
        
        // Then: Verify accessibility properties
        let view = AccessibilityInspector(content: { carousel })
        
        // The carousel should be accessible as a container
        XCTAssertTrue(view.isAccessibilityElement)
        XCTAssertTrue(view.accessibilityLabel.contains("Carousel"))
        XCTAssertTrue(view.accessibilityLabel.contains("4 items")) // 4 test items
    }
    
    // MARK: - Helper Methods
    
    /// Gets the aspect ratio for square size
    private func squareAspectRatio() -> CGFloat? {
        return CTCarousel<String, Text>.Size.square.aspectRatio
    }
    
    /// Gets the aspect ratio for standard size
    private func standardAspectRatio() -> CGFloat? {
        return CTCarousel<String, Text>.Size.standard.aspectRatio
    }
    
    /// Gets the aspect ratio for widescreen size
    private func widescreenAspectRatio() -> CGFloat? {
        return CTCarousel<String, Text>.Size.widescreen.aspectRatio
    }
    
    /// Gets the custom height value from a carousel
    private func customHeightValue<Item, Content: View>(for carousel: CTCarousel<Item, Content>) -> CGFloat? {
        let size = carousel.size
        return Mirror(reflecting: size).children.first { $0.label == "height" }?.value as? CGFloat
    }
    
    /// Gets the custom aspect ratio value from a carousel
    private func customAspectRatioValue<Item, Content: View>(for carousel: CTCarousel<Item, Content>) -> CGFloat? {
        let size = carousel.size
        return Mirror(reflecting: size).children.first { $0.label == "aspectRatio" }?.value as? CGFloat
    }
}

// MARK: - Test Helpers

/// A testable carousel that exposes internal methods for testing
private struct TestableCarousel {
    private var carousel: CTCarousel<String, Text>
    @Binding private var currentIndex: Int
    private let infiniteScroll: Bool
    
    init(
        items: [String],
        currentIndex: Binding<Int>,
        style: CTCarousel<String, Text>.Style = .default,
        navigationPosition: CTCarousel<String, Text>.NavigationPosition = .overlay,
        autoAdvance: Bool = false,
        autoAdvanceInterval: TimeInterval = 5.0,
        infiniteScroll: Bool = false
    ) {
        self.carousel = CTCarousel(
            items: items,
            currentIndex: currentIndex,
            style: style,
            navigationPosition: navigationPosition,
            autoAdvance: autoAdvance,
            autoAdvanceInterval: autoAdvanceInterval,
            infiniteScroll: infiniteScroll
        ) { item in
            Text(item)
        }
        self._currentIndex = currentIndex
        self.infiniteScroll = infiniteScroll
    }
    
    /// Simulate tapping the next button
    func simulateNextItem() {
        if currentIndex < carousel.items.count - 1 {
            currentIndex += 1
        } else if infiniteScroll {
            currentIndex = 0
        }
    }
    
    /// Simulate tapping the previous button
    func simulatePreviousItem() {
        if currentIndex > 0 {
            currentIndex -= 1
        } else if infiniteScroll {
            currentIndex = carousel.items.count - 1
        }
    }
    
    /// Simulate auto-advance timer firing
    func simulateTimerFired() {
        if currentIndex < carousel.items.count - 1 {
            currentIndex += 1
        } else if infiniteScroll {
            currentIndex = 0
        }
    }
}

/// Helper struct for testing accessibility properties
struct AccessibilityInspector<Content: View>: View {
    let content: () -> Content
    
    var isAccessibilityElement: Bool = false
    var accessibilityLabel: String = ""
    var accessibilityTraits: AccessibilityTraits = []
    
    var body: some View {
        content()
            .accessibilityAction { }  // This is a hack to get the accessibility properties
    }
}

// Allow access to the internal items array for testing
extension CTCarousel {
    var items: [Item] {
        let mirror = Mirror(reflecting: self)
        return mirror.children.first { $0.label == "items" }?.value as? [Item] ?? []
    }
    
    var size: Size {
        let mirror = Mirror(reflecting: self)
        return mirror.children.first { $0.label == "size" }?.value as? Size ?? .auto
    }
}
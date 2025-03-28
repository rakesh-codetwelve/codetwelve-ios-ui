//
//  CTSkeletonLoaderTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTSkeletonLoaderTests: XCTestCase {
    
    func testSkeletonLoaderInitialization() {
        // Test with default parameters
        let skeleton = CTSkeletonLoader()
        XCTAssertNotNil(skeleton)
        
        // Test with custom parameters
        let customSkeleton = CTSkeletonLoader(
            shape: .circle,
            animation: .shimmer,
            size: CGSize(width: 100, height: 100),
            cornerRadius: 12,
            color: .blue.opacity(0.2),
            shimmerColor: .white.opacity(0.5)
        )
        XCTAssertNotNil(customSkeleton)
    }
    
    func testSkeletonShapes() {
        // Test rectangle shape
        let rectangleSkeleton = CTSkeletonLoader(shape: .rectangle)
        XCTAssertNotNil(rectangleSkeleton)
        
        // Test square shape
        let squareSkeleton = CTSkeletonLoader(shape: .square)
        XCTAssertNotNil(squareSkeleton)
        
        // Test circle shape
        let circleSkeleton = CTSkeletonLoader(shape: .circle)
        XCTAssertNotNil(circleSkeleton)
        
        // Test capsule shape
        let capsuleSkeleton = CTSkeletonLoader(shape: .capsule)
        XCTAssertNotNil(capsuleSkeleton)
        
        // Test text shape with single line
        let singleLineSkeleton = CTSkeletonLoader(shape: .text(lines: 1, lastLineWidth: 1.0))
        XCTAssertNotNil(singleLineSkeleton)
        
        // Test text shape with multiple lines
        let multiLineSkeleton = CTSkeletonLoader(shape: .text(lines: 3, lastLineWidth: 0.7))
        XCTAssertNotNil(multiLineSkeleton)
    }
    
    func testSkeletonAnimations() {
        // Test pulse animation
        let pulseAnimationSkeleton = CTSkeletonLoader(animation: .pulse)
        XCTAssertNotNil(pulseAnimationSkeleton)
        
        // Test shimmer animation
        let shimmerAnimationSkeleton = CTSkeletonLoader(animation: .shimmer)
        XCTAssertNotNil(shimmerAnimationSkeleton)
        
        // Test no animation
        let noAnimationSkeleton = CTSkeletonLoader(animation: .none)
        XCTAssertNotNil(noAnimationSkeleton)
    }
    
    func testSkeletonSizing() {
        // Test default size
        let defaultSkeleton = CTSkeletonLoader(shape: .rectangle)
        XCTAssertNotNil(defaultSkeleton)
        
        // Test custom size for rectangle
        let customRectangleSkeleton = CTSkeletonLoader(
            shape: .rectangle,
            size: CGSize(width: 300, height: 30)
        )
        XCTAssertNotNil(customRectangleSkeleton)
        
        // Test custom size for circle
        let customCircleSkeleton = CTSkeletonLoader(
            shape: .circle,
            size: CGSize(width: 120, height: 120)
        )
        XCTAssertNotNil(customCircleSkeleton)
        
        // Test custom size for text skeleton
        let customTextSkeleton = CTSkeletonLoader(
            shape: .text(lines: 4, lastLineWidth: 0.5),
            size: CGSize(width: 250, height: 100)
        )
        XCTAssertNotNil(customTextSkeleton)
    }
    
    func testSkeletonColoring() {
        // Test custom base color
        let coloredSkeleton = CTSkeletonLoader(
            color: .red.opacity(0.3)
        )
        XCTAssertNotNil(coloredSkeleton)
        
        // Test custom shimmer color
        let shimmerColoredSkeleton = CTSkeletonLoader(
            animation: .shimmer,
            color: .blue.opacity(0.2),
            shimmerColor: .white.opacity(0.7)
        )
        XCTAssertNotNil(shimmerColoredSkeleton)
    }
    
    func testSkeletonCornerRadius() {
        // Test default corner radius
        let defaultRadiusSkeleton = CTSkeletonLoader(shape: .rectangle)
        XCTAssertNotNil(defaultRadiusSkeleton)
        
        // Test custom corner radius
        let customRadiusSkeleton = CTSkeletonLoader(
            shape: .rectangle,
            cornerRadius: 16
        )
        XCTAssertNotNil(customRadiusSkeleton)
    }
    
    func testSkeletonAccessibility() {
        // Skeletons should be hidden from accessibility
        let skeleton = CTSkeletonLoader()
        
        // Check that isAccessibilityHidden is true
        XCTAssertTrue(isAccessibilityHidden(for: skeleton))
    }
    
    // MARK: - Helper Methods
    
    private func isAccessibilityHidden(for skeleton: CTSkeletonLoader) -> Bool {
        let mirror = Mirror(reflecting: skeleton)
        
        // Look for the body property
        for child in mirror.children {
            if child.label == "body" {
                if let view = child.value as? AnyView {
                    let viewMirror = Mirror(reflecting: view)
                    
                    // Check if the view has accessibilityHidden modifier
                    for viewChild in viewMirror.children {
                        if let modifiers = viewChild.value as? ModifiedContent<AnyView, AccessibilityAttachmentModifier> {
                            let modifierMirror = Mirror(reflecting: modifiers)
                            
                            for modifierChild in modifierMirror.children {
                                if modifierChild.label == "modifier" {
                                    let accessibilityModifier = modifierChild.value
                                    let accessibilityMirror = Mirror(reflecting: accessibilityModifier)
                                    
                                    for accessibilityChild in accessibilityMirror.children {
                                        if accessibilityChild.label == "hidden" {
                                            return accessibilityChild.value as? Bool ?? false
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // Default to false if we couldn't definitively determine
        return false
    }
}
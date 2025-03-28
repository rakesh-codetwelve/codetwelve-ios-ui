//
//  CTAspectRatioTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

final class CTAspectRatioTests: XCTestCase {
    // Test aspect ratio initialization with a simple ratio
    func testAspectRatioCreation() {
        let aspectRatio = CTAspectRatio(ratio: 16/9) {
            Color.blue
        }
        
        XCTAssertNotNil(aspectRatio)
    }
    
    // Test aspect ratio initialization with a preset
    func testAspectRatioWithPreset() {
        let aspectRatio = CTAspectRatio(preset: .widescreen) {
            Color.blue
        }
        
        XCTAssertNotNil(aspectRatio)
    }
    
    // Test different content modes
    func testContentModes() {
        let fillMode = CTAspectRatio(ratio: 1, contentMode: .fill) {
            Color.blue
        }
        
        let fitMode = CTAspectRatio(ratio: 1, contentMode: .fit) {
            Color.blue
        }
        
        XCTAssertNotNil(fillMode)
        XCTAssertNotNil(fitMode)
    }
    
    // Test aspect ratio preset values
    func testAspectRatioPresets() {
        // Test various presets to ensure they have the correct ratios
        XCTAssertEqual(AspectRatioPreset.square.ratio, 1.0)
        XCTAssertEqual(AspectRatioPreset.widescreen.ratio, 16.0 / 9.0)
        XCTAssertEqual(AspectRatioPreset.standard.ratio, 4.0 / 3.0)
        XCTAssertEqual(AspectRatioPreset.ultrawide.ratio, 21.0 / 9.0)
        XCTAssertEqual(AspectRatioPreset.photo.ratio, 3.0 / 2.0)
        XCTAssertEqual(AspectRatioPreset.portrait.ratio, 3.0 / 4.0)
        XCTAssertEqual(AspectRatioPreset.mobilePortrait.ratio, 9.0 / 16.0)
        XCTAssertEqual(AspectRatioPreset.panorama.ratio, 2.0 / 1.0)
        XCTAssertEqual(AspectRatioPreset.tallPortrait.ratio, 1.0 / 2.0)
        
        // Test custom ratio
        let customRatio = AspectRatioPreset.custom(width: 5, height: 3)
        XCTAssertEqual(customRatio.ratio, 5.0 / 3.0)
    }
    
    // Test aspect ratio preset names
    func testAspectRatioPresetNames() {
        XCTAssertEqual(AspectRatioPreset.square.name, "Square (1:1)")
        XCTAssertEqual(AspectRatioPreset.widescreen.name, "Widescreen (16:9)")
        XCTAssertEqual(AspectRatioPreset.custom(width: 5, height: 3).name, "Custom (5:3)")
    }
    
    // Test view extensions
    func testViewExtensions() {
        let view = Text("Test")
        
        let ratioView = view.ctAspectRatio(2)
        let presetView = view.ctAspectRatio(preset: .widescreen)
        let squareView = view.ctSquare()
        let widescreenView = view.ctWidescreen()
        
        XCTAssertNotNil(ratioView)
        XCTAssertNotNil(presetView)
        XCTAssertNotNil(squareView)
        XCTAssertNotNil(widescreenView)
    }
    
    // Test different alignments
    func testAlignments() {
        let centerAligned = CTAspectRatio(ratio: 1, alignment: .center) {
            Text("Center")
        }
        
        let topLeadingAligned = CTAspectRatio(ratio: 1, alignment: .topLeading) {
            Text("Top Leading")
        }
        
        let bottomTrailingAligned = CTAspectRatio(ratio: 1, alignment: .bottomTrailing) {
            Text("Bottom Trailing")
        }
        
        XCTAssertNotNil(centerAligned)
        XCTAssertNotNil(topLeadingAligned)
        XCTAssertNotNil(bottomTrailingAligned)
    }
}
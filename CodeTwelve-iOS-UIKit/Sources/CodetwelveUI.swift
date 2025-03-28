//
//  CodetwelveUI.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// The main entry point for the CodetwelveUI library.
///
/// This file serves as the main entry point for the CodetwelveUI library,
/// exposing the public API and providing centralized access to the library's functionality.
///
/// # Usage
///
/// Import the library in your Swift files:
///
/// ```swift
/// import CodetwelveUI
/// ```
///
/// Then use the components with the CT prefix:
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         VStack {
///             // Use CodetwelveUI components here
///         }
///     }
/// }
/// ```
public struct CodetwelveUI {
    /// The current version of the CodetwelveUI library.
    public static let version = "1.0.0"
    
    /// Initialize the CodetwelveUI library.
    ///
    /// This method can be called to perform any necessary setup for the library.
    /// Currently, it's a placeholder for future initialization logic.
    public static func initialize() {
        // Placeholder for any future initialization logic
        print("CodetwelveUI \(version) initialized")
    }
}
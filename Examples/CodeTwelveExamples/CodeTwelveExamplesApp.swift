//
//  CodeTwelveExamplesApp.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

@main
struct CodeTwelveExamplesApp: App {
    init() {
        // Initialize the CodetwelveUI library
        CodetwelveUI.initialize()
        
        // Register default themes
        CTThemeManager.shared.registerThemes([
            CTDefaultTheme(),
            CTLightTheme(),
            CTDarkTheme()
        ])
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .ctTheme(CTThemeManager.shared.currentTheme)
                .ctObserveThemeChanges()
        }
    }
}
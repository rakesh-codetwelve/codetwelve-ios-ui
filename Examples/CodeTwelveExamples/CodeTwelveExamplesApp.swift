//
//  CodeTwelveExamplesApp.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

// MARK: - Root View

struct RootView: View {
    @State private var isDarkMode = false
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject private var themeManager = CTThemeManager.shared
    
    var body: some View {
        ContentView()
            .onChange(of: colorScheme) { newColorScheme in
                isDarkMode = newColorScheme == .dark
                updateTheme()
            }
            .onAppear {
                isDarkMode = colorScheme == .dark
                updateTheme()
            }
    }
    
    private func updateTheme() {
        if isDarkMode {
            CTThemeManager.shared.setTheme(CTDarkTheme())
        } else {
            CTThemeManager.shared.setTheme(CTLightTheme())
        }
    }
}

// MARK: - App

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
            RootView()
                .ctObserveThemeChanges()
        }
    }
}
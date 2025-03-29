//
//  ContentView.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

struct ContentView: View {
    // MARK: - State Properties
    
    @State private var isDarkMode = false
    @ObservedObject private var themeManager = CTThemeManager.shared
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: CTSpacing.l) {
                // Header section
                VStack(spacing: CTSpacing.m) {
                    Image(systemName: "paintbrush.pointed.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color.ctPrimary)
                        .padding(.bottom, CTSpacing.m)
                    
                    Text("CodeTwelve UI")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color.ctText)
                    
                    Text("A comprehensive SwiftUI component library")
                        .font(.system(size: 16))
                        .foregroundColor(Color.ctTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, CTSpacing.l)
                }
                .padding(.top, CTSpacing.xl)
                
                Spacer()
                
                // Navigation buttons
                VStack(spacing: CTSpacing.m) {
                    NavigationLink(destination: ComponentCatalog()) {
                        HStack {
                            Image(systemName: "square.grid.2x2")
                                .font(.system(size: 18))
                            Text("Component Catalog")
                                .font(.system(size: 18, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.ctPrimary)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: ThemeExplorer()) {
                        HStack {
                            Image(systemName: "paintpalette")
                                .font(.system(size: 18))
                            Text("Theme Explorer")
                                .font(.system(size: 18, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.ctSurface)
                        .foregroundColor(Color.ctPrimary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.ctPrimary, lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, CTSpacing.l)
                
                Spacer()
                
                // Footer
                Text("Version \(CodetwelveUI.version)")
                    .font(.caption)
                    .foregroundColor(Color.ctTextSecondary)
                    .padding(.bottom, CTSpacing.l)
            }
            .background(Color.ctBackground.edgesIgnoringSafeArea(.all))
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isDarkMode.toggle()
                        if isDarkMode {
                            CTThemeManager.shared.setTheme(CTDarkTheme())
                        } else {
                            CTThemeManager.shared.setTheme(CTLightTheme())
                        }
                    }) {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .foregroundColor(Color.ctPrimary)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
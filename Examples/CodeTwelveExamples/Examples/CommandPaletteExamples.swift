//
//  CommandPaletteExamples.swift
//  CodeTwelveExamples
//
//  Created on 28/03/25.
//

import SwiftUI
import CodetwelveUI

/// Examples demonstrating the usage of the CTCommandPalette component
struct CommandPaletteExamples: View {
    // MARK: - State Properties
    
    /// State for command palette visibility
    @State private var isBasicPalettePresented = false
    @State private var isStyledPalettePresented = false
    @State private var isDetailedPalettePresented = false
    @State private var isInteractivePalettePresented = false
    
    /// State for selected commands
    @State private var selectedCommand: String? = nil
    
    /// Toggle for showing code examples
    @State private var showBasicCode = false
    @State private var showStyledCode = false
    @State private var showDetailedCode = false
    @State private var showInteractiveCode = false
    
    /// Interactive example options
    @State private var useIcons = true
    @State private var useDescriptions = true
    @State private var useKeywords = true
    @State private var customCommandCount = 5
    @State private var selectedStyle: Int = 0
    
    // MARK: - Sample Data
    
    /// Basic command palette items
    private let basicCommands = [
        CTCommandPalette.CommandItem(
            title: "New Project",
            icon: "plus.circle",
            action: { print("New Project") }
        ),
        CTCommandPalette.CommandItem(
            title: "Open File",
            icon: "folder",
            action: { print("Open File") }
        ),
        CTCommandPalette.CommandItem(
            title: "Save",
            icon: "square.and.arrow.down",
            action: { print("Save") }
        ),
        CTCommandPalette.CommandItem(
            title: "Settings",
            icon: "gear",
            action: { print("Settings") }
        )
    ]
    
    /// Detailed command palette items with descriptions and keywords
    private let detailedCommands = [
        CTCommandPalette.CommandItem(
            title: "Create New Document",
            icon: "doc.badge.plus",
            description: "Create a blank document from scratch",
            keywords: ["new", "create", "document", "file"],
            action: { print("Create New Document") }
        ),
        CTCommandPalette.CommandItem(
            title: "Import from Cloud",
            icon: "icloud.and.arrow.down",
            description: "Import files from your cloud storage",
            keywords: ["import", "download", "cloud", "storage"],
            action: { print("Import from Cloud") }
        ),
        CTCommandPalette.CommandItem(
            title: "Export as PDF",
            icon: "arrow.up.doc",
            description: "Export the current document as a PDF file",
            keywords: ["export", "pdf", "document", "save"],
            action: { print("Export as PDF") }
        ),
        CTCommandPalette.CommandItem(
            title: "Share with Collaborators",
            icon: "person.2",
            description: "Invite others to collaborate on this document",
            keywords: ["share", "collaborate", "invite", "team"],
            action: { print("Share with Collaborators") }
        ),
        CTCommandPalette.CommandItem(
            title: "Advanced Settings",
            icon: "slider.horizontal.3",
            description: "Configure advanced document settings",
            keywords: ["settings", "configure", "preferences", "options"],
            action: { print("Advanced Settings") }
        ),
        CTCommandPalette.CommandItem(
            title: "Help and Documentation",
            icon: "questionmark.circle",
            description: "View help documentation and tutorials",
            keywords: ["help", "docs", "tutorial", "guide"],
            action: { print("Help and Documentation") }
        )
    ]
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                basicCommandPaletteSection
                styledCommandPaletteSection
                detailedCommandPaletteSection
                interactiveSection
            }
            .padding()
        }
        .navigationTitle("Command Palette")
    }
    
    // MARK: - Basic Command Palette Section
    
    private var basicCommandPaletteSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Basic Command Palette", showCode: $showBasicCode)
            
            Text("A command palette provides keyboard-driven navigation and quick access to actions.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            Button("Show Basic Command Palette") {
                isBasicPalettePresented = true
            }
            .ctButton(style: .primary)
            
            if showBasicCode {
                CodePreview(code: """
                @State private var isCommandPalettePresented = false
                
                Button("Show Command Palette") {
                    isCommandPalettePresented = true
                }
                
                CTCommandPalette(
                    items: [
                        .init(
                            title: "New Project",
                            icon: "plus.circle",
                            action: { /* Handle action */ }
                        ),
                        .init(
                            title: "Open File",
                            icon: "folder",
                            action: { /* Handle action */ }
                        ),
                        .init(
                            title: "Save",
                            icon: "square.and.arrow.down",
                            action: { /* Handle action */ }
                        ),
                        .init(
                            title: "Settings",
                            icon: "gear",
                            action: { /* Handle action */ }
                        )
                    ],
                    isPresented: $isCommandPalettePresented
                )
                """)
            }
        }
        .overlay(
            Group {
                if isBasicPalettePresented {
                    CTCommandPalette(
                        items: basicCommands,
                        isPresented: $isBasicPalettePresented,
                        onItemSelect: { item in
                            selectedCommand = item.title
                        }
                    )
                }
            }
        )
    }
    
    // MARK: - Styled Command Palette Section
    
    private var styledCommandPaletteSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Command Palette Styles", showCode: $showStyledCode)
            
            Text("Command palettes can be styled differently to match your app's design.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            Button("Show Styled Command Palette") {
                isStyledPalettePresented = true
            }
            .ctButton(style: .secondary)
            
            if showStyledCode {
                CodePreview(code: """
                // Default Style
                CTCommandPalette(
                    items: commandItems,
                    isPresented: $isCommandPalettePresented,
                    style: .default
                )
                
                // Compact Style
                CTCommandPalette(
                    items: commandItems,
                    isPresented: $isCommandPalettePresented,
                    style: .compact
                )
                
                // Floating Style
                CTCommandPalette(
                    items: commandItems,
                    isPresented: $isCommandPalettePresented,
                    style: .floating
                )
                
                // Full Screen Style
                CTCommandPalette(
                    items: commandItems,
                    isPresented: $isCommandPalettePresented,
                    style: .fullScreen
                )
                """)
            }
        }
        .overlay(
            Group {
                if isStyledPalettePresented {
                    CTCommandPalette(
                        items: basicCommands,
                        isPresented: $isStyledPalettePresented,
                        style: .floating,
                        onItemSelect: { item in
                            selectedCommand = item.title
                        }
                    )
                }
            }
        )
    }
    
    // MARK: - Detailed Command Palette Section
    
    private var detailedCommandPaletteSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Detailed Command Palette", showCode: $showDetailedCode)
            
            Text("Command palettes can include detailed information and keyword search.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            Button("Show Detailed Command Palette") {
                isDetailedPalettePresented = true
            }
            .ctButton(style: .outline)
            
            if showDetailedCode {
                          CodePreview(code: """
                          CTCommandPalette(
                              items: [
                                  .init(
                                      title: "Create New Document",
                                      icon: "doc.badge.plus",
                                      description: "Create a blank document from scratch",
                                      keywords: ["new", "create", "document", "file"],
                                      action: { /* Handle action */ }
                                  ),
                                  .init(
                                      title: "Import from Cloud",
                                      icon: "icloud.and.arrow.down",
                                      description: "Import files from your cloud storage",
                                      keywords: ["import", "download", "cloud", "storage"],
                                      action: { /* Handle action */ }
                                  ),
                                  // Additional items...
                              ],
                              isPresented: $isCommandPalettePresented,
                              maxDisplayItems: 10
                          )
                          """)
                      }
                      
                      if let selectedCommand = selectedCommand {
                          Text("Selected: \(selectedCommand)")
                              .ctBody()
                              .foregroundColor(.ctPrimary)
                              .padding(.top, CTSpacing.s)
                      }
                  }
                  .overlay(
                      Group {
                          if isDetailedPalettePresented {
                              CTCommandPalette(
                                  items: detailedCommands,
                                  isPresented: $isDetailedPalettePresented,
                                  onItemSelect: { item in
                                      selectedCommand = item.title
                                  }
                              )
                          }
                      }
                  )
              }
              
              // MARK: - Interactive Section
              
              private var interactiveSection: some View {
                  VStack(alignment: .leading, spacing: CTSpacing.m) {
                      Text("Interactive Example")
                          .ctHeading3()
                          .padding(.bottom, CTSpacing.s)
                      
                      Text("Configure your command palette by adjusting the options below.")
                          .ctBody()
                          .padding(.bottom, CTSpacing.m)
                      
                      // Configuration options
                      VStack(alignment: .leading, spacing: CTSpacing.s) {
                          // Style picker
                          HStack {
                              Text("Style:").ctBody().frame(width: 120, alignment: .leading)
                              Picker("Style", selection: $selectedStyle) {
                                  Text("Default").tag(0)
                                  Text("Compact").tag(1)
                                  Text("Floating").tag(2)
                                  Text("Full Screen").tag(3)
                              }
                              .pickerStyle(SegmentedPickerStyle())
                          }
                          
                          // Include icons
                          HStack {
                              Text("Include Icons:").ctBody().frame(width: 120, alignment: .leading)
                              Toggle("", isOn: $useIcons)
                          }
                          
                          // Include descriptions
                          HStack {
                              Text("Descriptions:").ctBody().frame(width: 120, alignment: .leading)
                              Toggle("", isOn: $useDescriptions)
                          }
                          
                          // Include keywords
                          HStack {
                              Text("Keywords:").ctBody().frame(width: 120, alignment: .leading)
                              Toggle("", isOn: $useKeywords)
                          }
                          
                          // Command count
                          HStack {
                              Text("Number of commands:").ctBody().frame(width: 120, alignment: .leading)
                              Slider(value: $customCommandCount.double, in: 2...10, step: 1)
                              Text("\(customCommandCount)").ctCaption().frame(width: 30)
                          }
                      }
                      .padding()
                      .background(Color.ctSurface)
                      .cornerRadius(12)
                      
                      // Preview button
                      Button("Show Interactive Command Palette") {
                          isInteractivePalettePresented = true
                      }
                      .ctButton(style: .primary)
                      .padding(.top, CTSpacing.m)
                      
                      if showInteractiveCode {
                          CodePreview(code: generateInteractiveCode())
                      } else {
                          Button("Show Code") {
                              showInteractiveCode = true
                          }
                          .padding(.top, CTSpacing.s)
                      }
                  }
                  .overlay(
                      Group {
                          if isInteractivePalettePresented {
                              CTCommandPalette(
                                  items: generateCustomCommands(),
                                  isPresented: $isInteractivePalettePresented,
                                  style: getSelectedStyle(),
                                  onItemSelect: { item in
                                      selectedCommand = item.title
                                  }
                              )
                          }
                      }
                  )
              }
              
              // MARK: - Helper Methods
              
              /// Generate custom commands based on interactive settings
              private func generateCustomCommands() -> [CTCommandPalette.CommandItem] {
                  let commandTitles = [
                      "New Project", "Open File", "Save Document", "Export as PDF",
                      "Share with Team", "Print Document", "Delete Item", "Search Files",
                      "User Settings", "Help & Documentation"
                  ]
                  
                  let commandIcons = [
                      "plus.circle", "folder", "square.and.arrow.down", "arrow.up.doc",
                      "person.2", "printer", "trash", "magnifyingglass",
                      "gear", "questionmark.circle"
                  ]
                  
                  let commandDescriptions = [
                      "Create a new project from scratch",
                      "Open an existing file from your device",
                      "Save the current document to your device",
                      "Export the current document as a PDF file",
                      "Share this document with your team members",
                      "Print the current document",
                      "Delete the selected item permanently",
                      "Search through all your files and documents",
                      "Change your user preferences and settings",
                      "Access help documentation and tutorials"
                  ]
                  
                  let commandKeywords: [[String]] = [
                      ["new", "create", "project", "start"],
                      ["open", "file", "browse", "load"],
                      ["save", "store", "document"],
                      ["export", "pdf", "document", "save as"],
                      ["share", "collaborate", "team", "send"],
                      ["print", "paper", "hardcopy"],
                      ["delete", "remove", "trash"],
                      ["search", "find", "query", "lookup"],
                      ["settings", "preferences", "configure", "options"],
                      ["help", "documentation", "support", "guide"]
                  ]
                  
                  var commands: [CTCommandPalette.CommandItem] = []
                  
                  for i in 0..<min(customCommandCount, commandTitles.count) {
                      commands.append(
                          CTCommandPalette.CommandItem(
                              title: commandTitles[i],
                              icon: useIcons ? commandIcons[i] : nil,
                              description: useDescriptions ? commandDescriptions[i] : nil,
                              keywords: useKeywords ? commandKeywords[i] : nil,
                              action: { print("Selected: \(commandTitles[i])") }
                          )
                      )
                  }
                  
                  return commands
              }
              
              /// Get the selected style based on the picker selection
              private func getSelectedStyle() -> CTCommandPalette.Style {
                  switch selectedStyle {
                  case 0: return .default
                  case 1: return .compact
                  case 2: return .floating
                  case 3: return .fullScreen
                  default: return .default
                  }
              }
              
              /// Generate code for the interactive example
              private func generateInteractiveCode() -> String {
                  let styleName: String
                  switch selectedStyle {
                  case 0: styleName = "default"
                  case 1: styleName = "compact"
                  case 2: styleName = "floating"
                  case 3: styleName = "fullScreen"
                  default: styleName = "default"
                  }
                  
                  var code = """
                  @State private var isCommandPalettePresented = false
                  
                  Button("Show Command Palette") {
                      isCommandPalettePresented = true
                  }
                  
                  CTCommandPalette(
                      items: [
                  """
                  
                  let commandTitles = [
                      "New Project", "Open File", "Save Document", "Export as PDF",
                      "Share with Team", "Print Document", "Delete Item", "Search Files",
                      "User Settings", "Help & Documentation"
                  ]
                  
                  let commandIcons = [
                      "plus.circle", "folder", "square.and.arrow.down", "arrow.up.doc",
                      "person.2", "printer", "trash", "magnifyingglass",
                      "gear", "questionmark.circle"
                  ]
                  
                  let commandDescriptions = [
                      "Create a new project from scratch",
                      "Open an existing file from your device",
                      "Save the current document to your device",
                      "Export the current document as a PDF file",
                      "Share this document with your team members",
                      "Print the current document",
                      "Delete the selected item permanently",
                      "Search through all your files and documents",
                      "Change your user preferences and settings",
                      "Access help documentation and tutorials"
                  ]
                  
                  let commandKeywords: [[String]] = [
                      ["new", "create", "project", "start"],
                      ["open", "file", "browse", "load"],
                      ["save", "store", "document"],
                      ["export", "pdf", "document", "save as"],
                      ["share", "collaborate", "team", "send"],
                      ["print", "paper", "hardcopy"],
                      ["delete", "remove", "trash"],
                      ["search", "find", "query", "lookup"],
                      ["settings", "preferences", "configure", "options"],
                      ["help", "documentation", "support", "guide"]
                  ]
                  
                  for i in 0..<min(customCommandCount, commandTitles.count) {
                      code += "\n        .init("
                      code += "\n            title: \"\(commandTitles[i])\","
                      
                      if useIcons {
                          code += "\n            icon: \"\(commandIcons[i])\","
                      }
                      
                      if useDescriptions {
                          code += "\n            description: \"\(commandDescriptions[i])\","
                      }
                      
                      if useKeywords {
                          code += "\n            keywords: [\"\(commandKeywords[i].joined(separator: "\", \""))\"],"
                      }
                      
                      code += "\n            action: { /* Handle action */ }"
                      code += "\n        ),"
                  }
                  
                  code += "\n    ],"
                  code += "\n    isPresented: $isCommandPalettePresented,"
                  
                  if styleName != "default" {
                      code += "\n    style: .\(styleName),"
                  }
                  
                  code += "\n)"
                  
                  return code
              }
          }

          // MARK: - Preview Provider

          struct CommandPaletteExamples_Previews: PreviewProvider {
              static var previews: some View {
                  CommandPaletteExamples()
              }
          }

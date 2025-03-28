//
//  NavigationMenuExamples.swift
//  CodeTwelveExamples
//
//  Created on 28/03/25.
//

import SwiftUI
import CodetwelveUI

/// Examples demonstrating the usage of the CTNavigationMenu component
struct NavigationMenuExamples: View {
    // MARK: - State Properties
    
    /// Selected item in various examples
    @State private var selectedItem1: String? = "home"
    @State private var selectedItem2: String? = "dashboard"
    @State private var selectedItem3: String? = "profile"
    @State private var selectedItem4: String? = "photos"
    @State private var selectedCustomItem: String? = "home"
    
    /// Toggle for showing code examples
    @State private var showBasicCode = false
    @State private var showStylesCode = false
    @State private var showSectionsCode = false
    @State private var showBadgesCode = false
    @State private var showInteractiveCode = false
    
    /// Interactive example options
    @State private var selectedStyle: CTNavigationMenuStyle = .sidebar
    @State private var selectedSections: Bool = true
    @State private var selectedDividers: Bool = true
    @State private var selectedBadges: Bool = true
    @State private var multipleExpanded: Bool = true
    @State private var expandByDefault: Bool = true
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                basicUsageSection
                stylesSection
                sectionsAndNestedItemsSection
                badgesSection
                interactiveSection
            }
            .padding()
        }
        .navigationTitle("Navigation Menu")
    }
    
    // MARK: - Basic Usage Section
    
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Basic Usage", showCode: $showBasicCode)
            
            Text("Navigation menus provide structured navigation for your application.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            NavigationMenuContainer {
                CTNavigationMenu(
                    items: [
                        .item(id: "home", label: "Home", icon: "house"),
                        .item(id: "search", label: "Search", icon: "magnifyingglass"),
                        .item(id: "favorites", label: "Favorites", icon: "heart"),
                        .separator,
                        .item(id: "settings", label: "Settings", icon: "gear"),
                        .item(id: "profile", label: "Profile", icon: "person.circle")
                    ],
                    selectedItemId: $selectedItem1
                )
            }
            
            if showBasicCode {
                CodePreview(code: """
                @State private var selectedItem: String? = "home"
                
                CTNavigationMenu(
                    items: [
                        .item(id: "home", label: "Home", icon: "house"),
                        .item(id: "search", label: "Search", icon: "magnifyingglass"),
                        .item(id: "favorites", label: "Favorites", icon: "heart"),
                        .separator,
                        .item(id: "settings", label: "Settings", icon: "gear"),
                        .item(id: "profile", label: "Profile", icon: "person.circle")
                    ],
                    selectedItemId: $selectedItem
                )
                """)
            }
        }
    }
    
    // MARK: - Styles Section
    
    private var stylesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Navigation Menu Styles", showCode: $showStylesCode)
            
            Text("Navigation menus support different visual styles.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            VStack(spacing: CTSpacing.l) {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Sidebar Style").ctBody().fontWeight(.medium)
                    
                    NavigationMenuContainer {
                        CTNavigationMenu(
                            items: [
                                .item(id: "dashboard", label: "Dashboard", icon: "chart.bar"),
                                .item(id: "analytics", label: "Analytics", icon: "chart.pie"),
                                .item(id: "reports", label: "Reports", icon: "doc.text")
                            ],
                            selectedItemId: $selectedItem2,
                            style: .sidebar
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Transparent Style").ctBody().fontWeight(.medium)
                    
                    NavigationMenuContainer {
                        CTNavigationMenu(
                            items: [
                                .item(id: "dashboard", label: "Dashboard", icon: "chart.bar"),
                                .item(id: "analytics", label: "Analytics", icon: "chart.pie"),
                                .item(id: "reports", label: "Reports", icon: "doc.text")
                            ],
                            selectedItemId: $selectedItem2,
                            style: .transparent
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Solid Color Style").ctBody().fontWeight(.medium)
                    
                    NavigationMenuContainer {
                        CTNavigationMenu(
                            items: [
                                .item(id: "dashboard", label: "Dashboard", icon: "chart.bar"),
                                .item(id: "analytics", label: "Analytics", icon: "chart.pie"),
                                .item(id: "reports", label: "Reports", icon: "doc.text")
                            ],
                            selectedItemId: $selectedItem2,
                            style: .solid(Color.ctPrimary.opacity(0.1))
                        )
                    }
                }
            }
            
            if showStylesCode {
                CodePreview(code: """
                // Sidebar Style
                CTNavigationMenu(
                    items: menuItems,
                    selectedItemId: $selectedItem,
                    style: .sidebar
                )
                
                // Transparent Style
                CTNavigationMenu(
                    items: menuItems,
                    selectedItemId: $selectedItem,
                    style: .transparent
                )
                
                // Solid Color Style
                CTNavigationMenu(
                    items: menuItems,
                    selectedItemId: $selectedItem,
                    style: .solid(Color.ctPrimary.opacity(0.1))
                )
                """)
            }
        }
    }
    
    // MARK: - Sections and Nested Items
    
    private var sectionsAndNestedItemsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Sections and Nested Items", showCode: $showSectionsCode)
            
            Text("Navigation menus can contain sections with nested items.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            NavigationMenuContainer {
                CTNavigationMenu(
                    items: [
                        .item(id: "dashboard", label: "Dashboard", icon: "chart.bar"),
                        .separator,
                        .section(id: "content", label: "Content", children: [
                            .item(id: "photos", label: "Photos", icon: "photo"),
                            .item(id: "videos", label: "Videos", icon: "video"),
                            .item(id: "audio", label: "Audio", icon: "music.note")
                        ]),
                        .section(id: "settings", label: "Settings", children: [
                            .item(id: "profile", label: "Profile", icon: "person"),
                            .item(id: "privacy", label: "Privacy", icon: "lock.shield"),
                            .item(id: "notifications", label: "Notifications", icon: "bell")
                        ])
                    ],
                    selectedItemId: $selectedItem4,
                    collapseByDefault: false,
                    allowMultipleExpanded: true
                )
            }
            
            if showSectionsCode {
                CodePreview(code: """
                CTNavigationMenu(
                    items: [
                        .item(id: "dashboard", label: "Dashboard", icon: "chart.bar"),
                        .separator,
                        .section(id: "content", label: "Content", children: [
                            .item(id: "photos", label: "Photos", icon: "photo"),
                            .item(id: "videos", label: "Videos", icon: "video"),
                            .item(id: "audio", label: "Audio", icon: "music.note")
                        ]),
                        .section(id: "settings", label: "Settings", children: [
                            .item(id: "profile", label: "Profile", icon: "person"),
                            .item(id: "privacy", label: "Privacy", icon: "lock.shield"),
                            .item(id: "notifications", label: "Notifications", icon: "bell")
                        ])
                    ],
                    selectedItemId: $selectedItem,
                    collapseByDefault: false,
                    allowMultipleExpanded: true
                )
                """)
            }
        }
    }
    
    // MARK: - Badges Section
    
    private var badgesSection: View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            SectionHeader(title: "Navigation with Badges", showCode: $showBadgesCode)
            
            Text("Navigation menu items can display badges to indicate counts or status.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            NavigationMenuContainer {
                CTNavigationMenu(
                    items: [
                        .item(id: "inbox", label: "Inbox", icon: "envelope", badge: .count(5)),
                        .item(id: "messages", label: "Messages", icon: "bubble.left", badge: .count(12)),
                        .item(id: "notifications", label: "Notifications", icon: "bell", badge: .dot()),
                        .separator,
                        .item(id: "tasks", label: "Tasks", icon: "checkmark.circle", badge: .text("NEW")),
                        .item(id: "calendar", label: "Calendar", icon: "calendar", badge: .count(3, color: .green)),
                        .item(id: "profile", label: "Profile", icon: "person.circle")
                    ],
                    selectedItemId: $selectedItem3
                )
            }
            
            if showBadgesCode {
                CodePreview(code: """
                CTNavigationMenu(
                    items: [
                        .item(id: "inbox", label: "Inbox", icon: "envelope", badge: .count(5)),
                        .item(id: "messages", label: "Messages", icon: "bubble.left", badge: .count(12)),
                        .item(id: "notifications", label: "Notifications", icon: "bell", badge: .dot()),
                        .separator,
                        .item(id: "tasks", label: "Tasks", icon: "checkmark.circle", badge: .text("NEW")),
                        .item(id: "calendar", label: "Calendar", icon: "calendar", badge: .count(3, color: .green)),
                        .item(id: "profile", label: "Profile", icon: "person.circle")
                    ],
                    selectedItemId: $selectedItem
                )
                """)
            }
        }
    }
    
    // MARK: - Interactive Section
    
    private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Interactive Example")
                .ctHeading3()
                .padding(.bottom, CTSpacing.s)
            
            Text("Configure your navigation menu by adjusting the options below.")
                .ctBody()
                .padding(.bottom, CTSpacing.m)
            
            // Configuration options
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                // Style picker
                HStack {
                    Text("Style:").ctBody().frame(width: 150, alignment: .leading)
                    Picker("Style", selection: $selectedStyle) {
                        Text("Sidebar").tag(CTNavigationMenuStyle.sidebar)
                        Text("Transparent").tag(CTNavigationMenuStyle.transparent)
                        Text("Solid Color").tag(CTNavigationMenuStyle.solid(Color.ctPrimary.opacity(0.1)))
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Include sections
                HStack {
                    Text("Include Sections:").ctBody().frame(width: 150, alignment: .leading)
                    Toggle("", isOn: $selectedSections)
                }
                
                // Include dividers
                HStack {
                    Text("Include Dividers:").ctBody().frame(width: 150, alignment: .leading)
                    Toggle("", isOn: $selectedDividers)
                }
                
                // Include badges
                HStack {
                    Text("Include Badges:").ctBody().frame(width: 150, alignment: .leading)
                    Toggle("", isOn: $selectedBadges)
                }
                
                // Allow multiple expanded
                HStack {
                    Text("Multiple Expanded:").ctBody().frame(width: 150, alignment: .leading)
                    Toggle("", isOn: $multipleExpanded)
                }
                
                // Expand by default
                HStack {
                    Text("Expand by Default:").ctBody().frame(width: 150, alignment: .leading)
                    Toggle("", isOn: $expandByDefault)
                }
            }
            .padding()
            .background(Color.ctSurface)
            .cornerRadius(12)
            
            // Preview
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Preview").ctBody().fontWeight(.medium)
                
                NavigationMenuContainer {
                    CTNavigationMenu(
                        items: generateMenuItems(),
                        selectedItemId: $selectedCustomItem,
                        style: selectedStyle,
                        collapseByDefault: !expandByDefault,
                        allowMultipleExpanded: multipleExpanded
                    )
                }
                
                Button(action: {
                    showInteractiveCode.toggle()
                }) {
                    Text(showInteractiveCode ? "Hide Code" : "Show Code")
                }
                .padding(.vertical, CTSpacing.s)
                
                if showInteractiveCode {
                    CodePreview(code: generateInteractiveCode())
                }
            }
            .padding(.top, CTSpacing.m)
        }
    }
    
    // MARK: - Helper Methods
    
    /// Generate menu items for the interactive example
    private func generateMenuItems() -> [CTNavigationItem] {
        var items: [CTNavigationItem] = [
            .item(id: "home", label: "Home", icon: "house", badge: selectedBadges ? .dot() : nil)
        ]
        
        if selectedBadges {
            items.append(.item(id: "inbox", label: "Inbox", icon: "envelope", badge: .count(5)))
        } else {
            items.append(.item(id: "inbox", label: "Inbox", icon: "envelope"))
        }
        
        if selectedDividers {
            items.append(.separator)
        }
        
        if selectedSections {
            items.append(
                .section(id: "content", label: "Content", children: [
                    .item(id: "photos", label: "Photos", icon: "photo"),
                    .item(id: "videos", label: "Videos", icon: "video", badge: selectedBadges ? .text("NEW") : nil)
                ])
            )
            
            items.append(
                .section(id: "settings", label: "Settings", children: [
                    .item(id: "account", label: "Account", icon: "person.circle"),
                    .item(id: "security", label: "Security", icon: "lock.shield")
                ])
            )
        } else {
            items.append(.item(id: "photos", label: "Photos", icon: "photo"))
            items.append(.item(id: "videos", label: "Videos", icon: "video", badge: selectedBadges ? .text("NEW") : nil))
            
            if selectedDividers {
                items.append(.separator)
            }
            
            items.append(.item(id: "account", label: "Account", icon: "person.circle"))
            items.append(.item(id: "security", label: "Security", icon: "lock.shield"))
        }
        
        return items
    }
    
    /// Generate code for the interactive example
    private func generateInteractiveCode() -> String {
        var code = "@State private var selectedItem: String? = \"home\"\n\n"
        
        code += "CTNavigationMenu(\n"
        code += "    items: [\n"
        
        // Add home item
        code += "        .item(id: \"home\", label: \"Home\", icon: \"house\""
        if selectedBadges {
            code += ", badge: .dot()"
        }
        code += "),\n"
        
        // Add inbox item
        code += "        .item(id: \"inbox\", label: \"Inbox\", icon: \"envelope\""
        if selectedBadges {
            code += ", badge: .count(5)"
        }
        code += "),\n"
        
        // Add separator if selected
        if selectedDividers {
            code += "        .separator,\n"
        }
        
        // Add sections or flat items
        if selectedSections {
            code += "        .section(id: \"content\", label: \"Content\", children: [\n"
            code += "            .item(id: \"photos\", label: \"Photos\", icon: \"photo\"),\n"
            code += "            .item(id: \"videos\", label: \"Videos\", icon: \"video\""
            if selectedBadges {
                code += ", badge: .text(\"NEW\")"
            }
            code += ")\n"
            code += "        ]),\n"
            
            code += "        .section(id: \"settings\", label: \"Settings\", children: [\n"
            code += "            .item(id: \"account\", label: \"Account\", icon: \"person.circle\"),\n"
            code += "            .item(id: \"security\", label: \"Security\", icon: \"lock.shield\")\n"
            code += "        ])\n"
        } else {
            code += "        .item(id: \"photos\", label: \"Photos\", icon: \"photo\"),\n"
            code += "        .item(id: \"videos\", label: \"Videos\", icon: \"video\""
            if selectedBadges {
                code += ", badge: .text(\"NEW\")"
            }
            code += "),\n"
            
            if selectedDividers {
                code += "        .separator,\n"
            }
            
            code += "        .item(id: \"account\", label: \"Account\", icon: \"person.circle\"),\n"
            code += "        .item(id: \"security\", label: \"Security\", icon: \"lock.shield\")\n"
        }
        
        code += "    ],\n"
        code += "    selectedItemId: $selectedItem,\n"
        
        // Style
        if selectedStyle != .sidebar {
            switch selectedStyle {
            case .transparent:
                code += "    style: .transparent,\n"
            case .solid:
                code += "    style: .solid(Color.ctPrimary.opacity(0.1)),\n"
            default:
                break
            }
        }
        
        // Collapse by default (if false)
        if !expandByDefault {
            code += "    collapseByDefault: true,\n"
        }
        
        // Multiple expanded (if false)
        if !multipleExpanded {
            code += "    allowMultipleExpanded: false,\n"
        }
        
        code += ")"
        
        return code
    }
}

// MARK: - Helper Views

/// A container view for navigation menu examples
struct NavigationMenuContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(width: 280, height: 350)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.ctBorder, lineWidth: 1)
            )
    }
}

// MARK: - Preview Provider

struct NavigationMenuExamples_Previews: PreviewProvider {
    static var previews: some View {
        NavigationMenuExamples()
    }
}

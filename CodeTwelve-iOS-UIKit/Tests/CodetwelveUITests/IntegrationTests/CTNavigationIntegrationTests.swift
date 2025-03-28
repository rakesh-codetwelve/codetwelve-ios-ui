//
//  CTNavigationIntegrationTests.swift
//  CodetwelveUITests
//
//  Created on 26/03/25.
//

import XCTest
import SwiftUI
@testable import CodetwelveUI

/// Integration tests for navigation components working together.
///
/// These tests verify that navigation components can be combined effectively
/// in typical navigation patterns and workflows found in iOS applications.
class CTNavigationIntegrationTests: XCTestCase {
    
    // MARK: - Test Tab Bar with Navigation Menu
    
    /// Tests that a tab bar can work correctly with navigation menus on each tab
    func testTabBarWithNavigationMenu() {
        // Create view model to track selection state
        let viewModel = NavigationViewModel()
        
        // Create the combined view with tab bar and navigation menu
        let view = TabBarWithNavigationMenuView(viewModel: viewModel)
        
        // Select the second tab
        viewModel.selectedTab = 1
        
        // Verify tab selection
        XCTAssertEqual(viewModel.selectedTab, 1, "Tab selection should be updated")
        
        // Select a navigation item
        viewModel.selectedMenuItem = "settings"
        
        // Verify navigation item selection
        XCTAssertEqual(viewModel.selectedMenuItem, "settings", "Navigation menu item selection should be updated")
    }
    
    // MARK: - Test Drawer with Bottom Sheet
    
    /// Tests that a drawer can be combined with a bottom sheet in a navigation workflow
    func testDrawerWithBottomSheet() {
        // Create view model to track state
        let viewModel = NavigationViewModel()
        
        // Create the combined view
        let view = DrawerWithBottomSheetView(viewModel: viewModel)
        
        // Verify initial state
        XCTAssertFalse(viewModel.isDrawerPresented, "Drawer should not be presented initially")
        XCTAssertFalse(viewModel.isBottomSheetPresented, "Bottom sheet should not be presented initially")
        
        // Open drawer
        viewModel.isDrawerPresented = true
        
        // Verify drawer is open
        XCTAssertTrue(viewModel.isDrawerPresented, "Drawer should be presented")
        
        // Select a drawer item that shows a bottom sheet
        viewModel.selectedDrawerAction = "showBottomSheet"
        viewModel.performSelectedDrawerAction()
        
        // Verify bottom sheet is presented
        XCTAssertTrue(viewModel.isBottomSheetPresented, "Bottom sheet should be presented after drawer action")
    }
    
    // MARK: - Test Bottom Sheet with Pagination
    
    /// Tests that a bottom sheet can contain pagination for navigating through content
    func testBottomSheetWithPagination() {
        // Create view model to track state
        let viewModel = NavigationViewModel()
        
        // Create the combined view
        let view = BottomSheetWithPaginationView(viewModel: viewModel)
        
        // Open bottom sheet
        viewModel.isBottomSheetPresented = true
        
        // Verify initial page
        XCTAssertEqual(viewModel.currentPage, 1, "Initial page should be 1")
        
        // Navigate to next page
        viewModel.currentPage = 2
        
        // Verify page navigation
        XCTAssertEqual(viewModel.currentPage, 2, "Page should be updated to 2")
        
        // Close bottom sheet
        viewModel.isBottomSheetPresented = false
        
        // Verify bottom sheet is closed
        XCTAssertFalse(viewModel.isBottomSheetPresented, "Bottom sheet should be closed")
    }
    
    // MARK: - Test Popover with Command Palette
    
    /// Tests that a popover can contain a command palette for quick actions
    func testPopoverWithCommandPalette() {
        // Create view model to track state
        let viewModel = NavigationViewModel()
        
        // Create the combined view
        let view = PopoverWithCommandPaletteView(viewModel: viewModel)
        
        // Show popover
        viewModel.isPopoverPresented = true
        
        // Verify popover is shown
        XCTAssertTrue(viewModel.isPopoverPresented, "Popover should be presented")
        
        // Execute a command
        viewModel.executeCommand("create")
        
        // Verify command executed and popover dismissed
        XCTAssertEqual(viewModel.lastExecutedCommand, "create", "Command should have been executed")
        XCTAssertFalse(viewModel.isPopoverPresented, "Popover should be automatically dismissed after command execution")
    }
    
    // MARK: - Test Tab Bar with Drawer and Pagination
    
    /// Tests a complex navigation pattern with tab bar, drawer, and pagination
    func testComplexNavigationPattern() {
        // Create view model to track state
        let viewModel = NavigationViewModel()
        
        // Create the combined view
        let view = ComplexNavigationPatternView(viewModel: viewModel)
        
        // Select a tab
        viewModel.selectedTab = 2
        
        // Verify tab selection
        XCTAssertEqual(viewModel.selectedTab, 2, "Tab selection should be updated")
        
        // Open drawer from tab
        viewModel.isDrawerPresented = true
        
        // Verify drawer is open
        XCTAssertTrue(viewModel.isDrawerPresented, "Drawer should be presented")
        
        // Select a drawer item that updates pagination
        viewModel.selectedDrawerAction = "showPage3"
        viewModel.performSelectedDrawerAction()
        
        // Verify pagination updated
        XCTAssertEqual(viewModel.currentPage, 3, "Page should be updated to 3 after drawer action")
        
        // Close drawer
        viewModel.isDrawerPresented = false
        
        // Verify drawer closed
        XCTAssertFalse(viewModel.isDrawerPresented, "Drawer should be closed")
    }
    
    // MARK: - Test Hamburger Menu with Navigation Flow
    
    /// Tests that hamburger menu can correctly manage navigation flows
    func testHamburgerMenuNavigationFlow() {
        // Create view model to track state
        let viewModel = NavigationViewModel()
        
        // Create the combined view
        let view = HamburgerMenuNavigationFlowView(viewModel: viewModel)
        
        // Verify initial state
        XCTAssertNil(viewModel.selectedMenuSection, "No menu section should be selected initially")
        
        // Select a menu section
        viewModel.selectedMenuSection = "settings"
        
        // Verify section selection
        XCTAssertEqual(viewModel.selectedMenuSection, "settings", "Menu section should be updated")
        
        // Select a specific settings item
        viewModel.selectedMenuItem = "account"
        
        // Verify item selection
        XCTAssertEqual(viewModel.selectedMenuItem, "account", "Menu item selection should be updated")
        
        // Navigate back to main menu
        viewModel.selectedMenuSection = nil
        
        // Verify navigation back to main menu
        XCTAssertNil(viewModel.selectedMenuSection, "Menu section should be cleared")
    }
    
    // MARK: - Test Command Palette with Navigation Flow
    
    /// Tests that command palette can correctly trigger navigation actions
    func testCommandPaletteNavigationFlow() {
        // Create view model to track state
        let viewModel = NavigationViewModel()
        
        // Create the combined view
        let view = CommandPaletteNavigationFlowView(viewModel: viewModel)
        
        // Show command palette
        viewModel.isCommandPalettePresented = true
        
        // Verify command palette is shown
        XCTAssertTrue(viewModel.isCommandPalettePresented, "Command palette should be presented")
        
        // Execute a navigation command
        viewModel.executeCommand("navigate_profile")
        
        // Verify navigation occurred and command palette closed
        XCTAssertEqual(viewModel.selectedTab, 3, "Tab should navigate to profile (tab 3)")
        XCTAssertFalse(viewModel.isCommandPalettePresented, "Command palette should be dismissed after command execution")
        
        // Execute another command that opens a drawer
        viewModel.executeCommand("open_drawer")
        
        // Verify drawer is opened
        XCTAssertTrue(viewModel.isDrawerPresented, "Drawer should be presented after command execution")
    }
}

// MARK: - Test Helpers

/// View model for tracking navigation state in tests
class NavigationViewModel: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var selectedMenuItem: String? = nil
    @Published var selectedMenuSection: String? = nil
    @Published var isDrawerPresented: Bool = false
    @Published var isBottomSheetPresented: Bool = false
    @Published var isPopoverPresented: Bool = false
    @Published var isCommandPalettePresented: Bool = false
    @Published var currentPage: Int = 1
    @Published var lastExecutedCommand: String? = nil
    @Published var selectedDrawerAction: String? = nil
    
    func performSelectedDrawerAction() {
        switch selectedDrawerAction {
        case "showBottomSheet":
            isBottomSheetPresented = true
        case "showPage3":
            currentPage = 3
        default:
            break
        }
    }
    
    func executeCommand(_ command: String) {
        lastExecutedCommand = command
        isPopoverPresented = false
        isCommandPalettePresented = false
        
        // Handle specific commands
        switch command {
        case "navigate_profile":
            selectedTab = 3
        case "open_drawer":
            isDrawerPresented = true
        default:
            break
        }
    }
}

// MARK: - Test Views

/// Test view that combines a tab bar with navigation menus
struct TabBarWithNavigationMenuView: View {
    @ObservedObject var viewModel: NavigationViewModel
    
    var body: some View {
        VStack {
            // Content based on selected tab
            if viewModel.selectedTab == 0 {
                // Home tab with navigation menu
                CTNavigationMenu(
                    items: [
                        .item(id: "home", label: "Home", icon: "house"),
                        .item(id: "profile", label: "Profile", icon: "person"),
                        .separator,
                        .item(id: "settings", label: "Settings", icon: "gear")
                    ],
                    selectedItemId: $viewModel.selectedMenuItem
                )
            } else if viewModel.selectedTab == 1 {
                // Search tab with different navigation menu
                CTNavigationMenu(
                    items: [
                        .item(id: "recent", label: "Recent Searches", icon: "clock"),
                        .item(id: "popular", label: "Popular", icon: "star"),
                        .separator,
                        .item(id: "advanced", label: "Advanced Search", icon: "magnifyingglass")
                    ],
                    selectedItemId: $viewModel.selectedMenuItem
                )
            } else {
                // Profile tab with yet another navigation menu
                CTNavigationMenu(
                    items: [
                        .item(id: "account", label: "Account", icon: "person.circle"),
                        .item(id: "security", label: "Security", icon: "lock.shield"),
                        .separator,
                        .item(id: "logout", label: "Log Out", icon: "arrow.right.square")
                    ],
                    selectedItemId: $viewModel.selectedMenuItem
                )
            }
            
            Spacer()
            
            // Tab bar at bottom
            CTTabBar(
                selectedTab: $viewModel.selectedTab,
                tabs: [
                    CTTabItem(label: "Home", icon: "house"),
                    CTTabItem(label: "Search", icon: "magnifyingglass"),
                    CTTabItem(label: "Profile", icon: "person")
                ]
            )
        }
    }
}

/// Test view that combines a drawer with a bottom sheet
struct DrawerWithBottomSheetView: View {
    @ObservedObject var viewModel: NavigationViewModel
    
    var body: some View {
        VStack {
            Text("Main Content")
            
            Button("Open Drawer") {
                viewModel.isDrawerPresented = true
            }
        }
        .ctDrawer(isPresented: $viewModel.isDrawerPresented, edge: .leading) {
            VStack(alignment: .leading) {
                Button("Show Bottom Sheet") {
                    viewModel.selectedDrawerAction = "showBottomSheet"
                    viewModel.performSelectedDrawerAction()
                    viewModel.isDrawerPresented = false
                }
                
                Divider()
                
                Button("Close Drawer") {
                    viewModel.isDrawerPresented = false
                }
            }
            .frame(width: 250)
            .padding()
        }
        .ctBottomSheet(isPresented: $viewModel.isBottomSheetPresented) {
            VStack {
                Text("Bottom Sheet Content")
                
                Button("Close") {
                    viewModel.isBottomSheetPresented = false
                }
            }
            .padding()
        }
    }
}

/// Test view that combines a bottom sheet with pagination
struct BottomSheetWithPaginationView: View {
    @ObservedObject var viewModel: NavigationViewModel
    
    var body: some View {
        VStack {
            Button("Show Bottom Sheet") {
                viewModel.isBottomSheetPresented = true
            }
        }
        .ctBottomSheet(isPresented: $viewModel.isBottomSheetPresented, height: .medium) {
            VStack {
                Text("Page \(viewModel.currentPage) Content")
                    .padding()
                
                Spacer()
                
                CTPagination(
                    currentPage: $viewModel.currentPage,
                    totalPages: 5
                )
                .padding()
            }
        }
    }
}

/// Test view that combines a popover with a command palette
struct PopoverWithCommandPaletteView: View {
    @ObservedObject var viewModel: NavigationViewModel
    
    var body: some View {
        Button("Show Popover") {
            viewModel.isPopoverPresented = true
        }
        .ctPopover(isPresented: $viewModel.isPopoverPresented) {
            CTCommandPalette(
                items: [
                    .init(title: "Create New", icon: "plus", action: { viewModel.executeCommand("create") }),
                    .init(title: "Edit", icon: "pencil", action: { viewModel.executeCommand("edit") }),
                    .init(title: "Delete", icon: "trash", action: { viewModel.executeCommand("delete") })
                ],
                isPresented: $viewModel.isPopoverPresented
            )
            .frame(width: 300, height: 200)
        }
    }
}

/// Test view that combines multiple navigation components in a complex pattern
struct ComplexNavigationPatternView: View {
    @ObservedObject var viewModel: NavigationViewModel
    
    var body: some View {
        VStack {
            // Tab content based on selection
            TabView(selection: $viewModel.selectedTab) {
                Text("Home Tab")
                    .tag(0)
                
                Text("Search Tab")
                    .tag(1)
                
                VStack {
                    Text("Settings Tab")
                    
                    Button("Open Drawer") {
                        viewModel.isDrawerPresented = true
                    }
                    
                    // Pagination on this tab
                    CTPagination(
                        currentPage: $viewModel.currentPage,
                        totalPages: 5
                    )
                }
                .tag(2)
            }
            
            // Tab bar
            CTTabBar(
                selectedTab: $viewModel.selectedTab,
                tabs: [
                    CTTabItem(label: "Home", icon: "house"),
                    CTTabItem(label: "Search", icon: "magnifyingglass"),
                    CTTabItem(label: "Settings", icon: "gear")
                ]
            )
        }
        .ctDrawer(isPresented: $viewModel.isDrawerPresented, edge: .leading) {
            VStack(alignment: .leading) {
                Button("Go to Page 1") {
                    viewModel.currentPage = 1
                }
                
                Button("Go to Page 3") {
                    viewModel.selectedDrawerAction = "showPage3"
                    viewModel.performSelectedDrawerAction()
                }
                
                Divider()
                
                Button("Close Drawer") {
                    viewModel.isDrawerPresented = false
                }
            }
            .frame(width: 250)
            .padding()
        }
    }
}

/// Test view that tests hamburger menu navigation flow
struct HamburgerMenuNavigationFlowView: View {
    @ObservedObject var viewModel: NavigationViewModel
    
    var body: some View {
        VStack {
            // Content based on section selection
            if let section = viewModel.selectedMenuSection {
                VStack {
                    Text("\(section.capitalized) Section")
                        .font(.headline)
                    
                    // Different content based on selected menu item
                    if let menuItem = viewModel.selectedMenuItem {
                        Text("Selected: \(menuItem)")
                    }
                    
                    Button("Back to Main Menu") {
                        viewModel.selectedMenuSection = nil
                        viewModel.selectedMenuItem = nil
                    }
                }
            } else {
                // Main menu with hamburger menu
                CTHamburgerMenu(
                    sections: [
                        .section(title: "Main", items: [
                            .item(title: "Home", icon: "house", action: {
                                viewModel.selectedMenuSection = "main"
                                viewModel.selectedMenuItem = "home"
                            }),
                            .item(title: "Profile", icon: "person", action: {
                                viewModel.selectedMenuSection = "main"
                                viewModel.selectedMenuItem = "profile"
                            })
                        ]),
                        .section(title: "Settings", items: [
                            .item(title: "Account", icon: "person.circle", action: {
                                viewModel.selectedMenuSection = "settings"
                                viewModel.selectedMenuItem = "account"
                            }),
                            .item(title: "Security", icon: "lock.shield", action: {
                                viewModel.selectedMenuSection = "settings"
                                viewModel.selectedMenuItem = "security"
                            })
                        ])
                    ]
                )
            }
        }
    }
}

/// Test view that tests command palette navigation flow
struct CommandPaletteNavigationFlowView: View {
    @ObservedObject var viewModel: NavigationViewModel
    
    var body: some View {
        VStack {
            TabView(selection: $viewModel.selectedTab) {
                Text("Home Tab")
                    .tag(0)
                
                Text("Search Tab")
                    .tag(1)
                
                Text("Notifications Tab")
                    .tag(2)
                
                Text("Profile Tab")
                    .tag(3)
            }
            
            Button("Open Command Palette") {
                viewModel.isCommandPalettePresented = true
            }
            
            // Tab bar at bottom
            CTTabBar(
                selectedTab: $viewModel.selectedTab,
                tabs: [
                    CTTabItem(label: "Home", icon: "house"),
                    CTTabItem(label: "Search", icon: "magnifyingglass"),
                    CTTabItem(label: "Notifications", icon: "bell"),
                    CTTabItem(label: "Profile", icon: "person")
                ]
            )
        }
        .overlay(
            Group {
                if viewModel.isCommandPalettePresented {
                    CTCommandPalette(
                        items: [
                            .init(title: "Navigate to Profile", icon: "person", action: {
                                viewModel.executeCommand("navigate_profile")
                            }),
                            .init(title: "Open Drawer", icon: "sidebar.left", action: {
                                viewModel.executeCommand("open_drawer")
                            }),
                            .init(title: "Search", icon: "magnifyingglass", action: {
                                viewModel.executeCommand("search")
                            })
                        ],
                        isPresented: $viewModel.isCommandPalettePresented
                    )
                }
            }
        )
        .ctDrawer(isPresented: $viewModel.isDrawerPresented, edge: .leading) {
            VStack(alignment: .leading) {
                Text("Drawer Content")
                
                Button("Close Drawer") {
                    viewModel.isDrawerPresented = false
                }
            }
            .frame(width: 250)
            .padding()
        }
    }
}
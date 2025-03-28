//
//  ButtonExamples.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view that showcases the various styles and configurations of the CTButton component.
///
/// This example view demonstrates:
/// - Different button styles
/// - Various button sizes
/// - Button states (loading, disabled)
/// - Buttons with icons
/// - Interactive examples
struct ButtonExamples: View {
    // MARK: - State Properties
    
    /// State to track whether the loading button is in loading state
    @State private var isLoading = false
    
    /// State to track whether the toggle button is primary or secondary
    @State private var isPrimary = true
    
    /// State to track a counter for demonstrating button actions
    @State private var counter = 0
    
    /// State to track whether full width is enabled
    @State private var isFullWidth = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.xl) {
                // Button styles section
                styleSection
                
                CTDivider()
                
                // Button sizes section
                sizeSection
                
                CTDivider()
                
                // Button states section
                stateSection
                
                CTDivider()
                
                // Buttons with icons section
                iconSection
                
                CTDivider()
                
                // Interactive examples section
                interactiveSection
            }
            .padding(CTSpacing.m)
        }
        .navigationTitle("Button")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - Style Section
    
    /// Section demonstrating different button styles
    private var styleSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Section header
            Text("Styles")
                .ctHeading2()
                .padding(.bottom, CTSpacing.xs)
            
            Text("Buttons come in different styles to convey different meanings and hierarchy.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.s)
            
            // Button style examples
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                CTButton("Primary", style: .primary) {
                    // Action for demonstration
                }
                
                CTButton("Secondary", style: .secondary) {
                    // Action for demonstration
                }
                
                CTButton("Destructive", style: .destructive) {
                    // Action for demonstration
                }
                
                CTButton("Outline", style: .outline) {
                    // Action for demonstration
                }
                
                CTButton("Ghost", style: .ghost) {
                    // Action for demonstration
                }
                
                CTButton("Link", style: .link) {
                    // Action for demonstration
                }
            }
            
            // Code example
            codeExample("""
            CTButton("Primary", style: .primary) {
                // Button action
            }
            
            CTButton("Secondary", style: .secondary) {
                // Button action
            }
            
            // Other styles: .destructive, .outline, .ghost, .link
            """)
        }
    }
    
    // MARK: - Size Section
    
    /// Section demonstrating different button sizes
    private var sizeSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Section header
            Text("Sizes")
                .ctHeading2()
                .padding(.bottom, CTSpacing.xs)
            
            Text("Buttons come in different sizes to fit various contexts.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.s)
            
            // Button size examples
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                CTButton("Small", size: .small) {
                    // Action for demonstration
                }
                
                CTButton("Medium (Default)", size: .medium) {
                    // Action for demonstration
                }
                
                CTButton("Large", size: .large) {
                    // Action for demonstration
                }
            }
            
            // Code example
            codeExample("""
            CTButton("Small", size: .small) {
                // Button action
            }
            
            CTButton("Medium", size: .medium) {
                // Button action
            }
            
            CTButton("Large", size: .large) {
                // Button action
            }
            """)
        }
    }
    
    // MARK: - State Section
    
    /// Section demonstrating different button states
    private var stateSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Section header
            Text("States")
                .ctHeading2()
                .padding(.bottom, CTSpacing.xs)
            
            Text("Buttons can be in different states like loading or disabled.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.s)
            
            // Button state examples
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                CTButton("Loading State", isLoading: true) {
                    // Action for demonstration
                }
                
                CTButton("Disabled State", isDisabled: true) {
                    // Action for demonstration
                }
                
                Toggle("Full Width", isOn: $isFullWidth)
                    .padding(.vertical, CTSpacing.xs)
                
                CTButton("Full Width Button", fullWidth: isFullWidth) {
                    // Action for demonstration
                }
            }
            
            // Code example
            codeExample("""
            CTButton("Loading", isLoading: true) {
                // Button action
            }
            
            CTButton("Disabled", isDisabled: true) {
                // Button action
            }
            
            CTButton("Full Width", fullWidth: true) {
                // Button action
            }
            """)
        }
    }
    
    // MARK: - Icon Section
    
    /// Section demonstrating buttons with icons
    private var iconSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Section header
            Text("Icons")
                .ctHeading2()
                .padding(.bottom, CTSpacing.xs)
            
            Text("Buttons can include icons to enhance visual communication.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.s)
            
            // Button with icons examples
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                CTButton("Leading Icon", icon: "arrow.left", iconPosition: .leading) {
                    // Action for demonstration
                }
                
                CTButton("Trailing Icon", icon: "arrow.right", iconPosition: .trailing) {
                    // Action for demonstration
                }
                
                CTButton("Add Item", icon: "plus", style: .primary) {
                    // Action for demonstration
                }
                
                CTButton("Share", icon: "square.and.arrow.up", style: .outline) {
                    // Action for demonstration
                }
            }
            
            // Code example
            codeExample("""
            CTButton("Leading Icon", icon: "arrow.left") {
                // Button action
            }
            
            CTButton("Trailing Icon", icon: "arrow.right", iconPosition: .trailing) {
                // Button action
            }
            """)
        }
    }
    
    // MARK: - Interactive Section
    
    /// Section demonstrating interactive button examples
    private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Section header
            Text("Interactive Examples")
                .ctHeading2()
                .padding(.bottom, CTSpacing.xs)
            
            Text("Try out these interactive examples to see the buttons in action.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.s)
            
            // Interactive loading button example
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                Text("Loading Button")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                CTButton(isLoading ? "Processing..." : "Click to Load", isLoading: isLoading) {
                    isLoading = true
                    
                    // Simulate a network request
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLoading = false
                    }
                }
            }
            
            // Style toggle example
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                Text("Toggle Style")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                CTButton("Toggle Style", style: isPrimary ? .primary : .secondary) {
                    isPrimary.toggle()
                }
            }
            
            // Counter button example
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                Text("Counter Button")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                HStack(spacing: CTSpacing.m) {
                    CTButton("Count: \(counter)", style: .primary) {
                        counter += 1
                    }
                    
                    CTButton("Reset", style: .outline) {
                        counter = 0
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Views
    
    /// Helper function to create a code example view
    /// - Parameter code: The code to display
    /// - Returns: A view displaying the code
    private func codeExample(_ code: String) -> some View {
        VStack(alignment: .leading) {
            Text("Example Code:")
                .ctCaption()
                .foregroundColor(.ctTextSecondary)
                .padding(.top, CTSpacing.s)
            
            Text(code)
                .ctCode()
                .padding(CTSpacing.s)
                .background(Color.ctBackground)
                .cornerRadius(CTSpacing.xs)
        }
    }
}

// MARK: - Previews

struct ButtonExamples_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ButtonExamples()
        }
    }
}

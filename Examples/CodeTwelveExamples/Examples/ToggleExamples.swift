//
//  ToggleExamples.swift
//  CodetwelveUI
//
//  Created by Rakesh R on 28/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view that showcases the CTToggle component with various configurations.
struct ToggleExamples: View {
    // MARK: - State Properties
    
    @State private var isEnabled1 = false
    @State private var isEnabled2 = true
    @State private var isEnabled3 = false
    @State private var isEnabled4 = false
    @State private var isEnabled5 = false
    
    @State private var showCode = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                basicUsageSection
                stylesSection
                sizesSection
                statesSection
                interactiveSection
            }
            .padding()
        }
        .navigationTitle("Toggles")
    }
    
    // MARK: - Basic Usage Section
    
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Basic Usage")
                .font(.title2)
                .fontWeight(.bold)
            
            CTToggle(
                "Basic toggle",
                isOn: $isEnabled1
            )
            
            codeExample("""
            @State private var isEnabled = false
            
            CTToggle(
                "Basic toggle",
                isOn: $isEnabled
            )
            """)
        }
    }
    
    // MARK: - Styles Section
    
    private var stylesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Styles")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                CTToggle(
                    "Primary style",
                    isOn: $isEnabled2,
                    style: .primary
                )
                
                CTToggle(
                    "Secondary style",
                    isOn: $isEnabled3,
                    style: .secondary
                )
                
                CTToggle(
                    "Custom style",
                    isOn: $isEnabled4,
                    style: .custom(colors: CTToggleColorOptions(
                        onColor: .purple,
                        offColor: .gray,
                        thumbColor: .white
                    ))
                )
            }
            
            codeExample("""
            // Primary style (default)
            CTToggle(
                "Primary style",
                isOn: $isEnabled,
                style: .primary
            )
            
            // Secondary style
            CTToggle(
                "Secondary style",
                isOn: $isEnabled,
                style: .secondary
            )
            
            // Custom style
            CTToggle(
                "Custom style",
                isOn: $isEnabled,
                style: .custom(colors: CTToggleColorOptions(
                    onColor: .purple,
                    offColor: .gray,
                    thumbColor: .white
                ))
            )
            """)
        }
    }
    
    // MARK: - Sizes Section
    
    private var sizesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Sizes")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack(spacing: CTSpacing.m) {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Small")
                        .font(.headline)
                    
                    CTToggle(
                        "Small toggle",
                        isOn: $isEnabled3,
                        size: .small
                    )
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Medium (Default)")
                        .font(.headline)
                    
                    CTToggle(
                        "Medium toggle",
                        isOn: $isEnabled3,
                        size: .medium
                    )
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Large")
                        .font(.headline)
                    
                    CTToggle(
                        "Large toggle",
                        isOn: $isEnabled3,
                        size: .large
                    )
                }
            }
            
            codeExample("""
            // Small size
            CTToggle(
                "Small toggle",
                isOn: $isEnabled,
                size: .small
            )
            
            // Medium size (default)
            CTToggle(
                "Medium toggle",
                isOn: $isEnabled,
                size: .medium
            )
            
            // Large size
            CTToggle(
                "Large toggle",
                isOn: $isEnabled,
                size: .large
            )
            """)
        }
    }
    
    // MARK: - States Section
    
    private var statesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("States")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                CTToggle(
                    "Enabled on",
                    isOn: .constant(true)
                )
                
                CTToggle(
                    "Enabled off",
                    isOn: .constant(false)
                )
                
                CTToggle(
                    "Disabled on",
                    isOn: .constant(true),
                    isDisabled: true
                )
                
                CTToggle(
                    "Disabled off",
                    isOn: .constant(false),
                    isDisabled: true
                )
            }
            
            codeExample("""
            // Enabled on
            CTToggle(
                "Enabled on",
                isOn: .constant(true)
            )
            
            // Enabled off
            CTToggle(
                "Enabled off",
                isOn: .constant(false)
            )
            
            // Disabled on
            CTToggle(
                "Disabled on",
                isOn: .constant(true),
                isDisabled: true
            )
            
            // Disabled off
            CTToggle(
                "Disabled off",
                isOn: .constant(false),
                isDisabled: true
            )
            """)
        }
    }
    
    // MARK: - Interactive Section
    
    private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Interactive Example")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                Text("Notification Settings")
                    .font(.headline)
                    .padding(.bottom, CTSpacing.xs)
                
                CTToggle(
                    "Push Notifications",
                    isOn: $isEnabled1
                )
                
                CTToggle(
                    "Email Notifications",
                    isOn: $isEnabled2
                )
                
                CTToggle(
                    "SMS Notifications",
                    isOn: $isEnabled3
                )
                
                CTButton(
                    "Save Settings",
                    style: .primary
                ) {
                    // Handle saving settings
                    print("Settings saved!")
                    print("Push: \(isEnabled1)")
                    print("Email: \(isEnabled2)")
                    print("SMS: \(isEnabled3)")
                }
                .padding(.top, CTSpacing.s)
            }
            .padding()
            .background(Color.ctSurface)
            .cornerRadius(12)
            
            codeExample("""
            @State private var pushEnabled = false
            @State private var emailEnabled = false
            @State private var smsEnabled = false
            
            // Notification settings form
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                Text("Notification Settings")
                    .font(.headline)
                
                CTToggle(
                    "Push Notifications",
                    isOn: $pushEnabled
                )
                
                CTToggle(
                    "Email Notifications",
                    isOn: $emailEnabled
                )
                
                CTToggle(
                    "SMS Notifications",
                    isOn: $smsEnabled
                )
                
                CTButton(
                    "Save Settings",
                    style: .primary
                ) {
                    // Handle saving settings
                }
            }
            """)
        }
    }
    
    // MARK: - Helper Views
    
    private func codeExample(_ code: String) -> some View {
        VStack(alignment: .leading, spacing: CTSpacing.s) {
            Button(action: { showCode.toggle() }) {
                HStack {
                    Text(showCode ? "Hide Code" : "Show Code")
                        .font(.subheadline)
                        .foregroundColor(.ctPrimary)
                    
                    Image(systemName: showCode ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.ctPrimary)
                }
            }
            
            if showCode {
                Text(code)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.ctText)
                    .padding()
                    .background(Color.ctSurface)
                    .cornerRadius(8)
            }
        }
    }
}

// MARK: - Previews

struct ToggleExamples_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ToggleExamples()
        }
    }
}


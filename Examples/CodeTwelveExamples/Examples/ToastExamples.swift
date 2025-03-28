//
//  ToastExamples.swift
//  CodeTwelveExamples
//
//  Created on 28/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view that demonstrates different ways to use the CTToast component.
struct ToastExamples: View {
    // MARK: - State Properties
    
    /// Message text for the custom toast
    @State private var toastMessage = "This is a custom toast message"
    
    /// Selected toast type for the custom toast
    @State private var selectedToastType: CTToastType = .info
    
    /// Duration for the custom toast in seconds
    @State private var toastDuration: Double = 3.0
    
    /// Whether to show a close button on the custom toast
    @State private var showCloseButton = true
    
    /// State for showing a custom toast
    @State private var showCustomToast = false
    
    /// State for showing code examples
    @State private var showBasicCode = false
    @State private var showCustomCode = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: CTSpacing.l) {
                basicUsageSection
                toastTypesSection
                customToastSection
                bestPracticesSection
            }
            .padding()
        }
        .navigationTitle("Toast")
        .modifier(ToastPresenter(showToast: $showCustomToast, message: toastMessage, type: selectedToastType, duration: toastDuration, hasCloseButton: showCloseButton))
    }
    
    // MARK: - Sections
    
    /// Basic usage examples of toasts
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Basic Usage").ctHeading2()
            
            Text("Toasts are temporary notifications that appear at the bottom of the screen and automatically dismiss after a set duration.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            HStack(spacing: CTSpacing.m) {
                CTButton("Show Info Toast") {
                    CTToastManager.shared.showInfo(message: "This is an info toast")
                }
                
                CTButton("Show Success", style: .primary) {
                    CTToastManager.shared.showSuccess(message: "Operation completed successfully")
                }
            }
            
            ToggleCodeButton(isExpanded: $showBasicCode)
                .padding(.top, CTSpacing.s)
            
            if showBasicCode {
                codeExample("""
                // Show an info toast
                CTToastManager.shared.showInfo(
                    message: "This is an info toast"
                )
                
                // Show a success toast
                CTToastManager.shared.showSuccess(
                    message: "Operation completed successfully"
                )
                """)
            }
        }
        .ctCard()
    }
    
    /// Examples of different types of toasts
    private var toastTypesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Toast Types").ctHeading2()
            
            Text("Toasts come in different types to convey different kinds of messages. Each type has its own color and icon.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            VStack(spacing: CTSpacing.m) {
                CTButton("Success Toast", style: .success) {
                    CTToastManager.shared.showSuccess(message: "Operation completed successfully")
                }
                
                CTButton("Error Toast", style: .destructive) {
                    CTToastManager.shared.showError(message: "Failed to complete operation")
                }
                
                CTButton("Warning Toast", style: .outline) {
                    CTToastManager.shared.showWarning(message: "Your session will expire soon")
                }
                
                CTButton("Info Toast", style: .primary) {
                    CTToastManager.shared.showInfo(message: "You have 3 new notifications")
                }
            }
        }
        .ctCard()
    }
    
    /// Custom toast configuration section
    private var customToastSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Custom Toast").ctHeading2()
            
            Text("You can customize various aspects of toasts including the message, type, duration, and whether to show a close button.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            // Message input
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Message:").ctBodyBold()
                TextField("Toast message", text: $toastMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // Toast type picker
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Toast Type:").ctBodyBold()
                Picker("Type", selection: $selectedToastType) {
                    Text("Info").tag(CTToastType.info)
                    Text("Success").tag(CTToastType.success)
                    Text("Warning").tag(CTToastType.warning)
                    Text("Error").tag(CTToastType.error)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            // Duration slider
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Duration: \(String(format: "%.1f", toastDuration)) seconds").ctBodyBold()
                Slider(value: $toastDuration, in: 1.0...10.0, step: 0.5)
            }
            
            // Close button toggle
            Toggle("Show Close Button", isOn: $showCloseButton)
                .padding(.vertical, CTSpacing.s)
            
            // Show toast button
            CTButton("Show Custom Toast", fullWidth: true) {
                showCustomToast = true
            }
            
            ToggleCodeButton(isExpanded: $showCustomCode)
                .padding(.top, CTSpacing.s)
            
            if showCustomCode {
                codeExample("""
                // Create a custom toast
                CTToastManager.shared.show(
                    message: "\(toastMessage)",
                    type: .\(toastTypeString(selectedToastType)),
                    duration: \(String(format: "%.1f", toastDuration)),
                    hasCloseButton: \(showCloseButton)
                )
                """)
            }
        }
        .ctCard()
    }
    
    /// Best practices for using toasts
    private var bestPracticesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Best Practices").ctHeading2()
            
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Do:").ctBodyBold()
                
                HStack(alignment: .top, spacing: CTSpacing.s) {
                    CTIcon("checkmark.circle.fill", color: .ctSuccess)
                    Text("Use toasts for non-critical information that doesn't require user action")
                        .ctBody()
                }
                
                HStack(alignment: .top, spacing: CTSpacing.s) {
                    CTIcon("checkmark.circle.fill", color: .ctSuccess)
                    Text("Keep messages short and to the point")
                        .ctBody()
                }
                
                HStack(alignment: .top, spacing: CTSpacing.s) {
                    CTIcon("checkmark.circle.fill", color: .ctSuccess)
                    Text("Use appropriate toast types to match your message (success, error, etc.)")
                        .ctBody()
                }
            }
            .padding(.bottom, CTSpacing.s)
            
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Don't:").ctBodyBold()
                
                HStack(alignment: .top, spacing: CTSpacing.s) {
                    CTIcon("xmark.circle.fill", color: .ctDestructive)
                    Text("Use toasts for critical errors that require user action")
                        .ctBody()
                }
                
                HStack(alignment: .top, spacing: CTSpacing.s) {
                    CTIcon("xmark.circle.fill", color: .ctDestructive)
                    Text("Display multiple toasts at the same time (they will queue automatically)")
                        .ctBody()
                }
                
                HStack(alignment: .top, spacing: CTSpacing.s) {
                    CTIcon("xmark.circle.fill", color: .ctDestructive)
                    Text("Use toasts for lengthy messages that require careful reading")
                        .ctBody()
                }
            }
        }
        .ctCard()
    }
    
    // MARK: - Helper Methods
    
    /// Returns a code example view with the provided code string
    /// - Parameter code: The code to display
    /// - Returns: A styled code example view
    private func codeExample(_ code: String) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(code)
                .ctCode()
                .padding(CTSpacing.m)
                .background(Color.black.opacity(0.05))
                .cornerRadius(CTSpacing.s)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    /// Converts a CTToastType to its string representation
    /// - Parameter type: The toast type
    /// - Returns: String representation of the toast type
    private func toastTypeString(_ type: CTToastType) -> String {
        switch type {
        case .success:
            return "success"
        case .error:
            return "error"
        case .warning:
            return "warning"
        case .info:
            return "info"
        default:
            return "info"
        }
    }
}

// MARK: - Supporting Views

/// Toggle button for showing/hiding code examples
struct ToggleCodeButton: View {
    @Binding var isExpanded: Bool
    
    var body: some View {
        Button(action: {
            withAnimation {
                isExpanded.toggle()
            }
        }) {
            HStack {
                Text(isExpanded ? "Hide Code" : "Show Code")
                    .ctBodySmall()
                    .foregroundColor(.ctPrimary)
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 12))
                    .foregroundColor(.ctPrimary)
            }
            .padding(.vertical, CTSpacing.xs)
            .padding(.horizontal, CTSpacing.s)
            .background(Color.ctPrimary.opacity(0.1))
            .cornerRadius(CTSpacing.xs)
        }
    }
}

/// Modifier for presenting a toast
struct ToastPresenter: ViewModifier {
    @Binding var showToast: Bool
    let message: String
    let type: CTToastType
    let duration: Double
    let hasCloseButton: Bool
    
    func body(content: Content) -> some View {
        content
            .onChange(of: showToast) { newValue in
                if newValue {
                    CTToastManager.shared.show(
                        message: message,
                        type: type,
                        duration: duration,
                        hasCloseButton: hasCloseButton
                    )
                    showToast = false
                }
            }
    }
}

// MARK: - Previews

struct ToastExamples_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ToastExamples()
                .ctToastContainer()
        }
    }
}

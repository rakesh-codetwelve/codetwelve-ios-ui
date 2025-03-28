//
//  AlertExamples.swift
//  CodeTwelveExamples
//
//  Created on 28/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view that demonstrates different ways to use the CTAlert component.
struct AlertExamples: View {
    // MARK: - State Properties
    
    /// State for showing dialog examples
    @State private var showBasicDialog = false
    @State private var showConfirmDialog = false
    @State private var showDestructiveDialog = false
    @State private var showCustomDialog = false
    
    /// State for the custom alert
    @State private var alertTitle = "Alert Title"
    @State private var alertMessage = "This is an alert message that explains something important to the user."
    @State private var selectedSeverity: CTAlertSeverity = .info
    @State private var isDismissible = true
    
    /// State for showing code examples
    @State private var showBasicCode = false
    @State private var showSeverityCode = false
    @State private var showDialogCode = false
    @State private var showCustomCode = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: CTSpacing.l) {
                basicUsageSection
                alertSeveritiesSection
                alertDialogSection
                customAlertSection
            }
            .padding()
        }
        .navigationTitle("Alert")
        // Alert dialogs
        .ctAlertDialog(isPresented: $showBasicDialog) {
            CTAlertDialogContent(
                title: "Information",
                message: "This is a basic alert dialog with a single action.",
                primaryAction: CTAlertDialogAction(
                    label: "OK",
                    handler: { showBasicDialog = false }
                )
            )
        }
        .ctAlertDialog(isPresented: $showConfirmDialog) {
            CTAlertDialogContent(
                title: "Confirm Action",
                message: "Are you sure you want to proceed with this action?",
                primaryAction: CTAlertDialogAction(
                    label: "Confirm",
                    handler: { showConfirmDialog = false }
                ),
                secondaryAction: CTAlertDialogAction(
                    label: "Cancel",
                    style: .secondary,
                    handler: { showConfirmDialog = false }
                )
            )
        }
        .ctAlertDialog(isPresented: $showDestructiveDialog) {
            CTAlertDialogContent(
                title: "Delete Item",
                message: "Are you sure you want to delete this item? This action cannot be undone.",
                primaryAction: CTAlertDialogAction(
                    label: "Cancel",
                    style: .secondary,
                    handler: { showDestructiveDialog = false }
                ),
                destructiveAction: CTAlertDialogAction(
                    label: "Delete",
                    style: .destructive,
                    handler: { showDestructiveDialog = false }
                )
            )
        }
        .ctAlertDialog(isPresented: $showCustomDialog) {
            CTAlertDialogContent(title: "Custom Content") {
                VStack(spacing: CTSpacing.m) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.yellow)
                    
                    Text("This is a custom alert dialog with rich content.")
                        .multilineTextAlignment(.center)
                        .padding(.bottom, CTSpacing.s)
                    
                    Text("You can include any SwiftUI views here!")
                        .ctBodySmall()
                        .foregroundColor(.ctTextSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, CTSpacing.m)
            } primaryAction: {
                CTAlertDialogAction(
                    label: "Awesome!",
                    handler: { showCustomDialog = false }
                )
            }
        }
    }
    
    // MARK: - Sections
    
    /// Basic usage examples of alerts
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Basic Usage").ctHeading2()
            
            Text("Alerts are used to display important messages that don't require immediate user action.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            CTAlert(
                title: "Information",
                message: "This is a basic alert with an info severity. Use it to display information to users.",
                severity: .info
            )
            
            CTAlert(
                message: "This is an alert without a title, which can be used for simpler messages.",
                severity: .info
            )
            
            CTAlert(
                title: "Dismissible Alert",
                message: "This alert can be dismissed by clicking the X button in the corner.",
                severity: .info,
                isDismissible: true
            )
            
            ToggleCodeButton(isExpanded: $showBasicCode)
                .padding(.top, CTSpacing.s)
            
            if showBasicCode {
                codeExample("""
                // Basic alert with title
                CTAlert(
                    title: "Information",
                    message: "This is a basic alert with an info severity.",
                    severity: .info
                )
                
                // Alert without title
                CTAlert(
                    message: "This is an alert without a title.",
                    severity: .info
                )
                
                // Dismissible alert
                CTAlert(
                    title: "Dismissible Alert",
                    message: "This alert can be dismissed.",
                    severity: .info,
                    isDismissible: true,
                    onDismiss: {
                        // Handle dismiss action
                    }
                )
                """)
            }
        }
        .ctCard()
    }
    
    /// Examples of different alert severities
    private var alertSeveritiesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Alert Severities").ctHeading2()
            
            Text("Alerts come in different severities to convey different levels of importance.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            CTAlert(
                title: "Information",
                message: "This is an informational alert. Use it for general information and updates.",
                severity: .info
            )
            
            CTAlert(
                title: "Success",
                message: "This is a success alert. Use it to confirm that an action was completed successfully.",
                severity: .success
            )
            
            CTAlert(
                title: "Warning",
                message: "This is a warning alert. Use it to warn users about potential issues that might need attention.",
                severity: .warning
            )
            
            CTAlert(
                title: "Error",
                message: "This is an error alert. Use it to inform users about errors or problems that have occurred.",
                severity: .error
            )
            
            ToggleCodeButton(isExpanded: $showSeverityCode)
                .padding(.top, CTSpacing.s)
            
            if showSeverityCode {
                codeExample("""
                // Info alert
                CTAlert(
                    title: "Information",
                    message: "This is an informational alert.",
                    severity: .info
                )
                
                // Success alert
                CTAlert(
                    title: "Success",
                    message: "This is a success alert.",
                    severity: .success
                )
                
                // Warning alert
                CTAlert(
                    title: "Warning",
                    message: "This is a warning alert.",
                    severity: .warning
                )
                
                // Error alert
                CTAlert(
                    title: "Error",
                    message: "This is an error alert.",
                    severity: .error
                )
                """)
            }
        }
        .ctCard()
    }
    
    /// Alert dialog examples
    private var alertDialogSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Alert Dialogs").ctHeading2()
            
            Text("Alert dialogs are modal dialogs that require user action before proceeding.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            HStack {
                CTButton("Basic Dialog") {
                    showBasicDialog = true
                }
                
                CTButton("Confirm Dialog") {
                    showConfirmDialog = true
                }
            }
            
            HStack {
                CTButton("Destructive Dialog", style: .destructive) {
                    showDestructiveDialog = true
                }
                
                CTButton("Custom Dialog", style: .outline) {
                    showCustomDialog = true
                }
            }
            
            ToggleCodeButton(isExpanded: $showDialogCode)
                .padding(.top, CTSpacing.s)
            
            if showDialogCode {
                codeExample("""
                // View with alert dialog
                YourView()
                    .ctAlertDialog(isPresented: $showDialog) {
                        CTAlertDialogContent(
                            title: "Confirm Action",
                            message: "Are you sure you want to proceed?",
                            primaryAction: CTAlertDialogAction(
                                label: "Confirm",
                                handler: {
                                    // Handle confirmation
                                    showDialog = false
                                }
                            ),
                            secondaryAction: CTAlertDialogAction(
                                label: "Cancel",
                                style: .secondary,
                                handler: {
                                    // Handle cancellation
                                    showDialog = false
                                }
                            )
                        )
                    }
                """)
            }
        }
        .ctCard()
    }
    
    /// Custom alert configuration section
    private var customAlertSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Custom Alert").ctHeading2()
            
            Text("You can customize various aspects of alerts including the title, message, severity, and dismissibility.")
                .ctBody()
                .padding(.bottom, CTSpacing.s)
            
            // Title input
            VStack(alignment: .leading, spacing: CTSpacing.xs) {
                Text("Title:").ctBodyBold()
                TextField("Alert title", text: $alertTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // Message input
            VStack(alignment: .leading, spacing: CTSpacing.xs) {
                Text("Message:").ctBodyBold()
                TextEditor(text: $alertMessage)
                    .frame(height: 80)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            
            // Severity picker
            VStack(alignment: .leading, spacing: CTSpacing.xs) {
                Text("Severity:").ctBodyBold()
                Picker("Severity", selection: $selectedSeverity) {
                    Text("Info").tag(CTAlertSeverity.info)
                    Text("Success").tag(CTAlertSeverity.success)
                    Text("Warning").tag(CTAlertSeverity.warning)
                    Text("Error").tag(CTAlertSeverity.error)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            // Dismissible toggle
            Toggle("Dismissible", isOn: $isDismissible)
                .padding(.vertical, CTSpacing.xs)
            
            // Preview
            Text("Preview:").ctBodyBold()
                .padding(.top, CTSpacing.xs)
            
            CTAlert(
                title: alertTitle.isEmpty ? nil : alertTitle,
                message: alertMessage,
                severity: selectedSeverity,
                isDismissible: isDismissible
            )
            
            ToggleCodeButton(isExpanded: $showCustomCode)
                .padding(.top, CTSpacing.s)
            
            if showCustomCode {
                codeExample("""
                CTAlert(
                    \(alertTitle.isEmpty ? "" : "title: \"\(alertTitle)\",")
                    message: \"\(alertMessage)\",
                    severity: .\(severityString(selectedSeverity)),
                    isDismissible: \(isDismissible)
                )
                """)
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
    
    /// Converts a CTAlertSeverity to its string representation
    /// - Parameter severity: The alert severity
    /// - Returns: String representation of the severity
    private func severityString(_ severity: CTAlertSeverity) -> String {
        switch severity {
        case .info:
            return "info"
        case .success:
            return "success"
        case .warning:
            return "warning"
        case .error:
            return "error"
        default:
            return "info"
        }
    }
}

// MARK: - Previews

struct AlertExamples_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AlertExamples()
        }
    }
}

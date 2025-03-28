//
//  CheckboxExamples.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view that showcases the CTCheckbox component with various configurations.
struct CheckboxExamples: View {
    // MARK: - State Properties
    
    @State private var isChecked1 = false
    @State private var isChecked2 = true
    @State private var isChecked3 = false
    @State private var isChecked4 = false
    @State private var isChecked5 = false
    @State private var isChecked6 = false
    @State private var isChecked7 = false
    @State private var isChecked8 = false
    
    @State private var privacyPolicyAccepted = false
    @State private var marketingEmailsAccepted = false
    @State private var termsAccepted = false
    
    @State private var showCode = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                basicUsageSection
                stylesSection
                sizesSection
                statesSection
                labelPositionSection
                interactiveSection
            }
            .padding()
        }
        .navigationTitle("Checkboxes")
    }
    
    // MARK: - Basic Usage Section
    
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Basic Usage")
                .font(.title2)
                .fontWeight(.bold)
            
            CTCheckbox(
                "Basic checkbox",
                isChecked: $isChecked1
            )
            
            codeExample("""
            @State private var isChecked = false
            
            CTCheckbox(
                "Basic checkbox",
                isChecked: $isChecked
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
                CTCheckbox(
                    "Primary style",
                    isChecked: $isChecked2,
                    style: .primary
                )
                
                CTCheckbox(
                    "Secondary style",
                    isChecked: $isChecked3,
                    style: .secondary
                )
                
                CTCheckbox(
                    "Filled style",
                    isChecked: $isChecked4,
                    style: .filled
                )
                
                CTCheckbox(
                    "Outline style",
                    isChecked: $isChecked5,
                    style: .outline
                )
                
                CTCheckbox(
                    "Custom style",
                    isChecked: $isChecked6,
                    style: .custom(
                        checkedBackground: .purple,
                        checkedBorder: .purple,
                        uncheckedBackground: .clear,
                        uncheckedBorder: .gray,
                        checkmark: .white
                    )
                )
            }
            
            codeExample("""
            // Primary style (default)
            CTCheckbox(
                "Primary style",
                isChecked: $isChecked,
                style: .primary
            )
            
            // Secondary style
            CTCheckbox(
                "Secondary style",
                isChecked: $isChecked,
                style: .secondary
            )
            
            // Filled style
            CTCheckbox(
                "Filled style",
                isChecked: $isChecked,
                style: .filled
            )
            
            // Outline style
            CTCheckbox(
                "Outline style",
                isChecked: $isChecked,
                style: .outline
            )
            
            // Custom style
            CTCheckbox(
                "Custom style",
                isChecked: $isChecked,
                style: .custom(
                    checkedBackground: .purple,
                    checkedBorder: .purple,
                    uncheckedBackground: .clear,
                    uncheckedBorder: .gray,
                    checkmark: .white
                )
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
                    
                    CTCheckbox(
                        "Small checkbox",
                        isChecked: $isChecked3,
                        size: .small
                    )
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Medium (Default)")
                        .font(.headline)
                    
                    CTCheckbox(
                        "Medium checkbox",
                        isChecked: $isChecked3,
                        size: .medium
                    )
                }
                
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Large")
                        .font(.headline)
                    
                    CTCheckbox(
                        "Large checkbox",
                        isChecked: $isChecked3,
                        size: .large
                    )
                }
            }
            
            codeExample("""
            // Small size
            CTCheckbox(
                "Small checkbox",
                isChecked: $isChecked,
                size: .small
            )
            
            // Medium size (default)
            CTCheckbox(
                "Medium checkbox",
                isChecked: $isChecked,
                size: .medium
            )
            
            // Large size
            CTCheckbox(
                "Large checkbox",
                isChecked: $isChecked,
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
                CTCheckbox(
                    "Checked state",
                    isChecked: .constant(true)
                )
                
                CTCheckbox(
                    "Unchecked state",
                    isChecked: .constant(false)
                )
                
                CTCheckbox(
                    "Disabled checked",
                    isChecked: .constant(true),
                    isDisabled: true
                )
                
                CTCheckbox(
                    "Disabled unchecked",
                    isChecked: .constant(false),
                    isDisabled: true
                )
                
                CTCheckbox(
                    nil,
                    isChecked: $isChecked7
                )
            }
            
            codeExample("""
            // Checked state
            CTCheckbox(
                "Checked state",
                isChecked: .constant(true)
            )
            
            // Unchecked state
            CTCheckbox(
                "Unchecked state",
                isChecked: .constant(false)
            )
            
            // Disabled checked
            CTCheckbox(
                "Disabled checked",
                isChecked: .constant(true),
                isDisabled: true
            )
            
            // Disabled unchecked
            CTCheckbox(
                "Disabled unchecked",
                isChecked: .constant(false),
                isDisabled: true
            )
            
            // Checkbox without label
            CTCheckbox(
                nil,
                isChecked: $isChecked
            )
            """)
        }
    }
    
    // MARK: - Label Position Section
    
    private var labelPositionSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Label Position")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                CTCheckbox(
                    "Trailing label (default)",
                    isChecked: $isChecked7,
                    labelAlignment: .trailing
                )
                
                CTCheckbox(
                    "Leading label",
                    isChecked: $isChecked8,
                    labelAlignment: .leading
                )
            }
            
            codeExample("""
            // Trailing label (default)
            CTCheckbox(
                "Trailing label",
                isChecked: $isChecked,
                labelAlignment: .trailing
            )
            
            // Leading label
            CTCheckbox(
                "Leading label",
                isChecked: $isChecked,
                labelAlignment: .leading
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
                Text("Privacy Settings")
                    .font(.headline)
                    .padding(.bottom, CTSpacing.xs)
                
                CTCheckbox(
                    "I have read and accept the Privacy Policy",
                    isChecked: $privacyPolicyAccepted
                )
                
                CTCheckbox(
                    "I have read and accept the Terms of Service",
                    isChecked: $termsAccepted
                )
                
                CTCheckbox(
                    "I would like to receive marketing emails",
                    isChecked: $marketingEmailsAccepted
                )
                
                CTButton(
                    "Submit",
                    style: .primary,
                    isDisabled: !privacyPolicyAccepted || !termsAccepted
                ) {
                    // Handle submission
                    print("Form submitted!")
                    print("Privacy Policy: \(privacyPolicyAccepted)")
                    print("Terms of Service: \(termsAccepted)")
                    print("Marketing Emails: \(marketingEmailsAccepted)")
                }
                .padding(.top, CTSpacing.s)
            }
            .padding()
                  .background(Color.ctSurface)
                  .cornerRadius(12)
                  
                  codeExample("""
                  @State private var privacyPolicyAccepted = false
                  @State private var termsAccepted = false
                  @State private var marketingEmailsAccepted = false
                  
                  // Privacy settings form
                  VStack(alignment: .leading, spacing: CTSpacing.m) {
                      Text("Privacy Settings")
                          .font(.headline)
                      
                      CTCheckbox(
                          "I have read and accept the Privacy Policy",
                          isChecked: $privacyPolicyAccepted
                      )
                      
                      CTCheckbox(
                          "I have read and accept the Terms of Service",
                          isChecked: $termsAccepted
                      )
                      
                      CTCheckbox(
                          "I would like to receive marketing emails",
                          isChecked: $marketingEmailsAccepted
                      )
                      
                      CTButton(
                          "Submit",
                          style: .primary,
                          isDisabled: !privacyPolicyAccepted || !termsAccepted
                      ) {
                          // Handle submission
                      }
                  }
                  """)
              }
          }
          
          // MARK: - Helper Methods
          
          /// Displays a code example with proper formatting
          private func codeExample(_ code: String) -> some View {
              VStack(alignment: .leading) {
                  HStack {
                      Text("Example Code")
                          .font(.subheadline)
                          .foregroundColor(.secondary)
                      
                      Spacer()
                      
                      Button(action: {
                          showCode.toggle()
                      }) {
                          Text(showCode ? "Hide Code" : "Show Code")
                              .font(.caption)
                              .foregroundColor(.blue)
                      }
                  }
                  
                  if showCode {
                      Text(code)
                          .font(.system(.caption, design: .monospaced))
                          .padding()
                          .frame(maxWidth: .infinity, alignment: .leading)
                          .background(Color(.systemGray6))
                          .cornerRadius(8)
                  }
              }
          }
      }

      struct CheckboxExamples_Previews: PreviewProvider {
          static var previews: some View {
              NavigationView {
                  CheckboxExamples()
              }
          }
      }

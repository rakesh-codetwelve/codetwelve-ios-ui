//
//  RadioGroupExamples.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view that showcases the CTRadioGroup component with various configurations.
struct RadioGroupExamples: View {
    // MARK: - State Properties
    
    // Basic radio group options
    private let stringOptions = [
        "option1": "Option 1",
        "option2": "Option 2",
        "option3": "Option 3"
    ]
    
    // Numeric radio group options
    private let numericOptions = [
        "1": "One",
        "2": "Two",
        "3": "Three",
        "4": "Four",
        "5": "Five"
    ]
    
    // Style demonstration states
    @State private var selectedStyleOption = "option1"
    @State private var selectedSizeOption = "option1"
    @State private var selectedOrientationOption = "option1"
    
    // Interactive form states
    @State private var selectedProductId = "product1"
    @State private var selectedPaymentMethod = "credit"
    @State private var selectedShippingOption = "standard"
    
    @State private var showCode = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                basicUsageSection
                stylesSection
                sizesSection
                orientationSection
                interactiveSection
            }
            .padding()
        }
        .navigationTitle("Radio Groups")
    }
    
    // MARK: - Basic Usage Section
    
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Basic Usage")
                .font(.title2)
                .fontWeight(.bold)
            
            CTRadioGroup(
                options: stringOptions,
                selectedOption: $selectedStyleOption
            )
            
            codeExample("""
            @State private var selectedOption = "option1"
            
            let options = [
                "option1": "Option 1",
                "option2": "Option 2",
                "option3": "Option 3"
            ]
            
            CTRadioGroup(
                options: options,
                selectedOption: $selectedOption
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
            
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                Text("Primary Style (Default)")
                    .font(.headline)
                
                CTRadioGroup(
                    options: stringOptions,
                    selectedOption: $selectedStyleOption,
                    style: .primary
                )
                
                Text("Secondary Style")
                    .font(.headline)
                
                CTRadioGroup(
                    options: stringOptions,
                    selectedOption: $selectedStyleOption,
                    style: .secondary
                )
                
                Text("Outline Style")
                    .font(.headline)
                
                CTRadioGroup(
                    options: stringOptions,
                    selectedOption: $selectedStyleOption,
                    style: .outline
                )
                
                Text("Custom Style")
                    .font(.headline)
                
                CTRadioGroup(
                    options: stringOptions,
                    selectedOption: $selectedStyleOption,
                    style: .custom(
                        selectedFill: .purple,
                        selectedBorder: .purple,
                        unselectedBorder: .gray
                    )
                )
            }
            
            codeExample("""
            // Primary style (default)
            CTRadioGroup(
                options: options,
                selectedOption: $selectedOption,
                style: .primary
            )
            
            // Secondary style
            CTRadioGroup(
                options: options,
                selectedOption: $selectedOption,
                style: .secondary
            )
            
            // Outline style
            CTRadioGroup(
                options: options,
                selectedOption: $selectedOption,
                style: .outline
            )
            
            // Custom style
            CTRadioGroup(
                options: options,
                selectedOption: $selectedOption,
                style: .custom(
                    selectedFill: .purple,
                    selectedBorder: .purple,
                    unselectedBorder: .gray
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
            
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                Text("Small Size")
                    .font(.headline)
                
                CTRadioGroup(
                    options: stringOptions,
                    selectedOption: $selectedSizeOption,
                    size: .small
                )
                
                Text("Medium Size (Default)")
                    .font(.headline)
                
                CTRadioGroup(
                    options: stringOptions,
                    selectedOption: $selectedSizeOption,
                    size: .medium
                )
                
                Text("Large Size")
                    .font(.headline)
                
                CTRadioGroup(
                    options: stringOptions,
                    selectedOption: $selectedSizeOption,
                    size: .large
                )
            }
            
            codeExample("""
            // Small size
            CTRadioGroup(
                options: options,
                selectedOption: $selectedOption,
                size: .small
            )
            
            // Medium size (default)
            CTRadioGroup(
                options: options,
                selectedOption: $selectedOption,
                size: .medium
            )
            
            // Large size
            CTRadioGroup(
                options: options,
                selectedOption: $selectedOption,
                size: .large
            )
            """)
        }
    }
    
    // MARK: - Orientation Section
    
    private var orientationSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Orientation")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                Text("Vertical Orientation (Default)")
                    .font(.headline)
                
                CTRadioGroup(
                    options: stringOptions,
                    selectedOption: $selectedOrientationOption,
                    orientation: .vertical
                )
                
                Text("Horizontal Orientation")
                    .font(.headline)
                
                CTRadioGroup(
                    options: stringOptions,
                    selectedOption: $selectedOrientationOption,
                    orientation: .horizontal
                )
                
                Text("Numeric Options")
                    .font(.headline)
                
                CTRadioGroup(
                    options: numericOptions,
                    selectedOption: $selectedOrientationOption
                )
            }
            
            codeExample("""
            // Vertical orientation (default)
            CTRadioGroup(
                options: options,
                selectedOption: $selectedOption,
                orientation: .vertical
            )
            
            // Horizontal orientation
            CTRadioGroup(
                options: options,
                selectedOption: $selectedOption,
                orientation: .horizontal
            )
            
            // Using numeric options with integers as keys
            let numericOptions = [
                1: "One",
                2: "Two",
                3: "Three"
            ]
            
            CTRadioGroup(
                options: numericOptions,
                selectedOption: $selectedNumericOption
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
                Text("Product Selection Form")
                    .font(.headline)
                    .padding(.bottom, CTSpacing.xs)
                
                Group {
                    Text("Select Product")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    let productOptions = [
                        "product1": "Basic Package ($9.99)",
                        "product2": "Standard Package ($19.99)",
                        "product3": "Premium Package ($29.99)"
                    ]
                    
                    CTRadioGroup(
                        options: productOptions,
                        selectedOption: $selectedProductId,
                        style: .primary
                    )
                }
                .padding(.bottom, CTSpacing.s)
                
                Group {
                    Text("Payment Method")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    let paymentOptions = [
                        "credit": "Credit Card",
                        "paypal": "PayPal",
                        "applepay": "Apple Pay"
                    ]
                    
                    CTRadioGroup(
                        options: paymentOptions,
                        selectedOption: $selectedPaymentMethod,
                        style: .outline
                    )
                }
                .padding(.bottom, CTSpacing.s)
                
                Group {
                    Text("Shipping Option")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    let shippingOptions = [
                        "standard": "Standard Shipping (3-5 days)",
                        "express": "Express Shipping (1-2 days)",
                        "overnight": "Overnight Shipping"
                    ]
                    
                    CTRadioGroup(
                        options: shippingOptions,
                        selectedOption: $selectedShippingOption,
                        style: .secondary
                    )
                }
                .padding(.bottom, CTSpacing.s)
                
                CTButton("Complete Order", style: .primary) {
                    // Handle order completion
                    print("Order completed!")
                    print("Selected product: \(selectedProductId)")
                    print("Payment method: \(selectedPaymentMethod)")
                    print("Shipping option: \(selectedShippingOption)")
                }
                .padding(.top, CTSpacing.s)
            }
            .padding()
            .background(Color.ctSurface)
            .cornerRadius(12)
            
            codeExample("""
            // State variables
            @State private var selectedProductId = "product1"
            @State private var selectedPaymentMethod = "credit"
            @State private var selectedShippingOption = "standard"
            
            // Product selection
            let productOptions = [
                "product1": "Basic Package ($9.99)",
                "product2": "Standard Package ($19.99)",
                "product3": "Premium Package ($29.99)"
            ]
            
            CTRadioGroup(
                options: productOptions,
                selectedOption: $selectedProductId,
                style: .primary
            )
            
            // Payment method
            let paymentOptions = [
                "credit": "Credit Card",
                "paypal": "PayPal",
                "applepay": "Apple Pay"
            ]
            
            CTRadioGroup(
                options: paymentOptions,
                selectedOption: $selectedPaymentMethod,
                style: .outline
            )
            
            // Submit button
            CTButton("Complete Order", style: .primary) {
                // Handle order completion
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

struct RadioGroupExamples_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RadioGroupExamples()
        }
    }
}

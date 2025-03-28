//
//  SelectExamples.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view that showcases the CTSelect component with various configurations.
struct SelectExamples: View {
    // MARK: - State Properties
    
    // Basic select states
    @State private var selectedOption = "option1"
    @State private var selectedStyle = "option1"
    @State private var selectedSize = "option2"
    
    // Array-based select
    @State private var selectedNumber = 1
    
    // With icons select
    @State private var selectedCategory = "electronics"
    
    // Form select states
    @State private var selectedCountry = "us"
    @State private var selectedState = "ca"
    @State private var selectedTitle = "mr"
    
    // Error state
    @State private var errorMessage: String? = nil
    
    @State private var showCode = false
    
    // MARK: - Private Properties
    
    // Basic options
    private let options = [
        "option1": "Option 1",
        "option2": "Option 2",
        "option3": "Option 3",
        "option4": "Option 4"
    ]
    
    // Numeric options
    private let numberOptions = [
        1: "One",
        2: "Two",
        3: "Three",
        4: "Four",
        5: "Five"
    ]
    
    // Options with icons
    private let categoryOptions: [String: CTSelectOption] = [
        "electronics": CTSelectOption(label: "Electronics", icon: "laptopcomputer"),
        "clothing": CTSelectOption(label: "Clothing", icon: "tshirt"),
        "food": CTSelectOption(label: "Food & Groceries", icon: "cart"),
        "health": CTSelectOption(label: "Health & Beauty", icon: "heart"),
        "home": CTSelectOption(label: "Home & Garden", icon: "house")
    ]
    
    // Country options
    private let countryOptions = [
        "us": "United States",
        "ca": "Canada",
        "uk": "United Kingdom",
        "au": "Australia",
        "de": "Germany",
        "fr": "France",
        "jp": "Japan"
    ]
    
    // State options
    private let stateOptions = [
        "ca": "California",
        "ny": "New York",
        "tx": "Texas",
        "fl": "Florida",
        "il": "Illinois"
    ]
    
    // Title options
    private let titleOptions = [
        "mr": "Mr.",
        "mrs": "Mrs.",
        "ms": "Ms.",
        "dr": "Dr.",
        "prof": "Prof."
    ]
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                basicUsageSection
                stylesSection
                sizesSection
                optionsWithIconsSection
                arrayOptionsSection
                statesSection
                interactiveSection
            }
            .padding()
        }
        .navigationTitle("Select Dropdowns")
    }
    
    // MARK: - Basic Usage Section
    
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Basic Usage")
                .font(.title2)
                .fontWeight(.bold)
            
            CTSelect(
                "Basic Select",
                options: options,
                selection: $selectedOption
            )
            
            codeExample("""
            @State private var selectedOption = "option1"
            
            let options = [
                "option1": "Option 1",
                "option2": "Option 2",
                "option3": "Option 3",
                "option4": "Option 4"
            ]
            
            CTSelect(
                "Basic Select",
                options: options,
                selection: $selectedOption
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
                Text("Default Style")
                    .font(.headline)
                
                CTSelect(
                    "Default Style",
                    options: options,
                    selection: $selectedStyle,
                    style: .default
                )
                
                Text("Filled Style")
                    .font(.headline)
                
                CTSelect(
                    "Filled Style",
                    options: options,
                    selection: $selectedStyle,
                    style: .filled
                )
                
                Text("Outlined Style")
                    .font(.headline)
                
                CTSelect(
                    "Outlined Style",
                    options: options,
                    selection: $selectedStyle,
                    style: .outlined
                )
            }
            
            codeExample("""
            // Default style
            CTSelect(
                "Default Style",
                options: options,
                selection: $selectedOption,
                style: .default
            )
            
            // Filled style
            CTSelect(
                "Filled Style",
                options: options,
                selection: $selectedOption,
                style: .filled
            )
            
            // Outlined style
            CTSelect(
                "Outlined Style",
                options: options,
                selection: $selectedOption,
                style: .outlined
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
            
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Small Size")
                    .font(.headline)
                
                CTSelect(
                    "Small Size",
                    options: options,
                    selection: $selectedSize,
                    size: .small
                )
                
                Text("Medium Size (Default)")
                    .font(.headline)
                
                CTSelect(
                    "Medium Size",
                    options: options,
                    selection: $selectedSize,
                    size: .medium
                )
                
                Text("Large Size")
                    .font(.headline)
                
                CTSelect(
                    "Large Size",
                    options: options,
                    selection: $selectedSize,
                    size: .large
                )
            }
            
            codeExample("""
            // Small size
            CTSelect(
                "Small Size",
                options: options,
                selection: $selectedOption,
                size: .small
            )
            
            // Medium size (default)
            CTSelect(
                "Medium Size",
                options: options,
                selection: $selectedOption,
                size: .medium
            )
            
            // Large size
            CTSelect(
                "Large Size",
                options: options,
                selection: $selectedOption,
                size: .large
            )
            """)
        }
    }
    
    // MARK: - Options With Icons Section
    
    private var optionsWithIconsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Options With Icons")
                .font(.title2)
                .fontWeight(.bold)
            
            CTSelect(
                "Select Category",
                optionsWithIcons: categoryOptions,
                selection: $selectedCategory,
                style: .filled
            )
            
            codeExample("""
            @State private var selectedCategory = "electronics"
            
            // Options with icons
            let categoryOptions: [String: CTSelectOption] = [
                "electronics": CTSelectOption(label: "Electronics", icon: "laptopcomputer"),
                "clothing": CTSelectOption(label: "Clothing", icon: "tshirt"),
                "food": CTSelectOption(label: "Food & Groceries", icon: "cart"),
                "health": CTSelectOption(label: "Health & Beauty", icon: "heart"),
                "home": CTSelectOption(label: "Home & Garden", icon: "house")
            ]
            
            CTSelect(
                "Select Category",
                optionsWithIcons: categoryOptions,
                selection: $selectedCategory,
                style: .filled
            )
            """)
        }
    }
    
    // MARK: - Array Options Section
    
    private var arrayOptionsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Array-based Options")
                .font(.title2)
                .fontWeight(.bold)
            
            CTSelect(
                "Select Number",
                options: numberOptions,
                selection: $selectedNumber,
                style: .outlined
            )
            
            codeExample("""
            @State private var selectedNumber = 1
            
            // Numeric options (Int keys)
            let numberOptions = [
                1: "One",
                2: "Two",
                3: "Three",
                4: "Four",
                5: "Five"
            ]
            
            CTSelect(
                "Select Number",
                options: numberOptions,
                selection: $selectedNumber,
                style: .outlined
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
                Text("Required Field")
                    .font(.headline)
                
                CTSelect(
                    "Required Select",
                    options: options,
                    selection: $selectedOption,
                    isRequired: true
                )
                
                Text("Disabled Field")
                    .font(.headline)
                
                CTSelect(
                    "Disabled Select",
                    options: options,
                    selection: $selectedOption,
                    isDisabled: true
                )
                
                Text("With Error")
                    .font(.headline)
                
                CTSelect(
                    "Select with Error",
                    options: options,
                    selection: $selectedOption,
                    error: $errorMessage
                )
                
                Button("Show/Hide Error") {
                    if errorMessage == nil {
                        errorMessage = "Please select a valid option"
                    } else {
                        errorMessage = nil
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.vertical, CTSpacing.xs)
            }
            
            codeExample("""
            // Required field
            CTSelect(
                "Required Select",
                options: options,
                selection: $selectedOption,
                isRequired: true
            )
            
            // Disabled field
            CTSelect(
                "Disabled Select",
                options: options,
                selection: $selectedOption,
                isDisabled: true
            )
            
            // With error
            @State private var errorMessage: String? = "Please select a valid option"
            
            CTSelect(
                "Select with Error",
                options: options,
                selection: $selectedOption,
                error: $errorMessage
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
                Text("Address Form")
                    .font(.headline)
                    .padding(.bottom, CTSpacing.xs)
                
                Group {
                    CTSelect(
                        "Title",
                        options: titleOptions,
                        selection: $selectedTitle,
                        size: .small
                    ) { newValue in
                        print("Selected title: \(newValue)")
                    }
                    
                    CTTextField(
                        "Name",
                        placeholder: "Enter your name",
                        text: .constant(""),
                        isRequired: true
                    )
                    
                    CTSelect(
                        "Country",
                        options: countryOptions,
                        selection: $selectedCountry,
                        isRequired: true
                    ) { newValue in
                        // Reset state selection when country changes
                        if newValue != "us" {
                            selectedState = ""
                        } else {
                            selectedState = "ca"
                        }
                    }
                    
                    if selectedCountry == "us" {
                        CTSelect(
                            "State",
                            options: stateOptions,
                            selection: $selectedState,
                            isRequired: true
                        )
                    }
                    
                    CTTextField(
                        "Address Line 1",
                        placeholder: "Enter your street address",
                        text: .constant(""),
                        isRequired: true
                    )
                    
                    CTTextField(
                        "Address Line 2",
                        placeholder: "Apartment, suite, etc. (optional)",
                        text: .constant("")
                    )
                    
                    CTTextField(
                        "City",
                        placeholder: "Enter your city",
                        text: .constant(""),
                        isRequired: true
                    )
                    
                    CTTextField(
                        "Postal/Zip Code",
                        placeholder: "Enter your postal code",
                        text: .constant(""),
                        isRequired: true
                    )
                }
                
                CTButton("Save Address", style: .primary) {
                    // Handle address save
                    print("Address saved!")
                    print("Title: \(selectedTitle)")
                    print("Country: \(selectedCountry)")
                    if selectedCountry == "us" {
                        print("State: \(selectedState)")
                    }
                }
                .padding(.top, CTSpacing.s)
            }
            .padding()
            .background(Color.ctSurface)
            .cornerRadius(12)
            
            codeExample("""
            // State variables
            @State private var selectedTitle = "mr"
            @State private var selectedCountry = "us"
            @State private var selectedState = "ca"
            
            // Title options
            let titleOptions = [
                "mr": "Mr.",
                "mrs": "Mrs.",
                "ms": "Ms.",
                "dr": "Dr.",
                "prof": "Prof."
            ]
            
            // Country options
            let countryOptions = [
                "us": "United States",
                "ca": "Canada",
                "uk": "United Kingdom",
                // more countries...
            ]
            
            // Select fields
            CTSelect(
                "Title",
                options: titleOptions,
                selection: $selectedTitle,
                size: .small
            )
            
            CTSelect(
                "Country",
                options: countryOptions,
                selection: $selectedCountry,
                isRequired: true
            ) { newValue in
                // Reset state selection when country changes
                if newValue != "us" {
                    selectedState = ""
                }
            }
            
            if selectedCountry == "us" {
                CTSelect(
                    "State",
                    options: stateOptions,
                    selection: $selectedState,
                    isRequired: true
                )
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

struct SelectExamples_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SelectExamples()
        }
    }
}

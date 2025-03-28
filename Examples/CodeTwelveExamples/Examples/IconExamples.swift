//
//  IconExamples.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view that showcases the various styles and configurations of the CTIcon component.
///
/// This example view demonstrates:
/// - Different icon sizes
/// - Icon color customization
/// - Icon weight variations
/// - Different rendering modes
/// - Accessibility features
struct IconExamples: View {
    // MARK: - State Properties
    
    /// Selected icon from the picker
    @State private var selectedIcon = "star.fill"
    
    /// Selected color from the picker
    @State private var selectedColor: IconColor = .primary
    
    /// Selected weight from the picker
    @State private var selectedWeight: Font.Weight = .regular
    
    /// Selected rendering mode from the picker
    @State private var selectedRenderingMode: SymbolRenderingMode = .multicolor
    
    /// Available SF Symbol icons for the interactive example
    private let availableIcons = [
        "star.fill",
        "heart.fill",
        "bolt.fill",
        "globe",
        "person.fill",
        "house.fill",
        "gear",
        "envelope.fill",
        "bell.fill",
        "calendar",
        "bookmark.fill",
        "cart.fill",
        "hand.thumbsup.fill",
        "moon.fill",
        "sun.max.fill"
    ]
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.xl) {
                // Icon sizes section
                sizesSection
                
                CTDivider()
                
                // Icon colors section
                colorsSection
                
                CTDivider()
                
                // Icon weights section
                weightsSection
                
                CTDivider()
                
                // Icon rendering modes section
                renderingModesSection
                
                CTDivider()
                
                // Interactive customization section
                interactiveSection
                
                CTDivider()
                
                // Accessibility section
                accessibilitySection
            }
            .padding(CTSpacing.m)
        }
        .navigationTitle("Icon")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - Size Section
    
    /// Section demonstrating different icon sizes
    private var sizesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Section header
            Text("Sizes")
                .ctHeading2()
                .padding(.bottom, CTSpacing.xs)
            
            Text("Icons come in different sizes to fit various UI contexts.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.s)
            
            // Icon size grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: CTSpacing.l) {
                iconSizeExample(size: .extraSmall, label: "XS")
                iconSizeExample(size: .small, label: "S")
                iconSizeExample(size: .medium, label: "M")
                iconSizeExample(size: .large, label: "L")
                iconSizeExample(size: .extraLarge, label: "XL")
            }
            
            // Custom size example
            VStack(alignment: .center) {
                Text("Custom Size")
                    .ctSubtitle()
                    .padding(.bottom, CTSpacing.xxs)
                
                CTIcon("star.fill", size: .custom(60), color: .ctPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, CTSpacing.s)
            
            // Code example
            codeExample("""
            // Predefined sizes
            CTIcon("star.fill", size: .extraSmall)
            CTIcon("star.fill", size: .small)
            CTIcon("star.fill", size: .medium) // Default
            CTIcon("star.fill", size: .large)
            CTIcon("star.fill", size: .extraLarge)
            
            // Custom size
            CTIcon("star.fill", size: .custom(60))
            """)
        }
    }
    
    // MARK: - Colors Section
    
    /// Section demonstrating different icon colors
    private var colorsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Section header
            Text("Colors")
                .ctHeading2()
                .padding(.bottom, CTSpacing.xs)
            
            Text("Icons can be tinted with different colors to match your design.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.s)
            
            // Icon color grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: CTSpacing.l) {
                iconColorExample(color: .ctPrimary, label: "Primary")
                iconColorExample(color: .ctSecondary, label: "Secondary")
                iconColorExample(color: .ctSuccess, label: "Success")
                iconColorExample(color: .ctDestructive, label: "Destructive")
                iconColorExample(color: .ctWarning, label: "Warning")
                iconColorExample(color: .ctInfo, label: "Info")
                iconColorExample(color: .ctText, label: "Text")
                iconColorExample(color: .ctTextSecondary, label: "Text Secondary")
            }
            
            // Code example
            codeExample("""
            // Default color (uses current text color)
            CTIcon("star.fill")
            
            // Specific colors
            CTIcon("star.fill", color: .ctPrimary)
            CTIcon("star.fill", color: .ctSecondary)
            CTIcon("star.fill", color: .ctSuccess)
            CTIcon("star.fill", color: .ctDestructive)
            """)
        }
    }
    
    // MARK: - Weights Section
    
    /// Section demonstrating different icon weights
    private var weightsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Section header
            Text("Weights")
                .ctHeading2()
                .padding(.bottom, CTSpacing.xs)
            
            Text("Icons can have different weights to adjust their visual strength.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.s)
            
            // Icon weights examples
            HStack(spacing: CTSpacing.l) {
                iconWeightExample(weight: .ultraLight, label: "Ultra Light")
                iconWeightExample(weight: .light, label: "Light")
                iconWeightExample(weight: .regular, label: "Regular")
                iconWeightExample(weight: .medium, label: "Medium")
            }
            
            HStack(spacing: CTSpacing.l) {
                iconWeightExample(weight: .semibold, label: "Semibold")
                iconWeightExample(weight: .bold, label: "Bold")
                iconWeightExample(weight: .heavy, label: "Heavy")
                iconWeightExample(weight: .black, label: "Black")
            }
            
            // Code example
            codeExample("""
            // Default weight (regular)
            CTIcon("star.fill")
            
            // Custom weights
            CTIcon("star.fill", weight: .ultraLight)
            CTIcon("star.fill", weight: .light)
            CTIcon("star.fill", weight: .regular)
            CTIcon("star.fill", weight: .medium)
            CTIcon("star.fill", weight: .semibold)
            CTIcon("star.fill", weight: .bold)
            CTIcon("star.fill", weight: .heavy)
            CTIcon("star.fill", weight: .black)
            """)
        }
    }
    
    // MARK: - Rendering Modes Section
    
    /// Section demonstrating different rendering modes
    private var renderingModesSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Section header
            Text("Rendering Modes")
                .ctHeading2()
                .padding(.bottom, CTSpacing.xs)
            
            Text("SF Symbols support different rendering modes for visual variety.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.s)
            
            // Rendering modes examples
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: CTSpacing.l) {
                renderingModeExample(mode: .monochrome, label: "Monochrome")
                renderingModeExample(mode: .hierarchical, label: "Hierarchical")
                renderingModeExample(mode: .multicolor, label: "Multicolor")
                renderingModeExample(mode: .palette, label: "Palette")
            }
            
            // Note about multicolor and palette
            Text("Note: Multicolor and palette modes only work with compatible SF Symbols that support these rendering modes. Not all symbols support all rendering modes.")
                .ctCaption()
                .foregroundColor(.ctTextSecondary)
                .padding(.top, CTSpacing.xs)
            
            // Code example
            codeExample("""
            // Different rendering modes
            CTIcon("star.fill", renderingMode: .monochrome)
            CTIcon("star.fill", renderingMode: .hierarchical)
            CTIcon("star.fill", renderingMode: .multicolor) // Default
            CTIcon("star.fill", renderingMode: .palette)
            """)
        }
    }
    
    // MARK: - Interactive Section
    
    /// Section with interactive icon customization
    private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Section header
            Text("Interactive Example")
                .ctHeading2()
                .padding(.bottom, CTSpacing.xs)
            
            Text("Experiment with different icon configurations.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.m)
            
            // Icon preview
            HStack {
                Spacer()
                
                CTIcon(
                    selectedIcon,
                    size: .extraLarge,
                    color: colorForSelection(selectedColor),
                    weight: selectedWeight,
                    renderingMode: selectedRenderingMode
                )
                
                Spacer()
            }
            .padding(.bottom, CTSpacing.m)
            
            // Icon selection
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Icon")
                    .ctSubtitle()
                
                Picker("Select Icon", selection: $selectedIcon) {
                    ForEach(availableIcons, id: \.self) { icon in
                        HStack {
                            Image(systemName: icon)
                            Text(icon)
                        }
                        .tag(icon)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.bottom, CTSpacing.s)
            
            // Color selection
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Color")
                    .ctSubtitle()
                
                Picker("Select Color", selection: $selectedColor) {
                    Text("Primary").tag(IconColor.primary)
                    Text("Secondary").tag(IconColor.secondary)
                    Text("Success").tag(IconColor.success)
                    Text("Destructive").tag(IconColor.destructive)
                    Text("Warning").tag(IconColor.warning)
                    Text("Info").tag(IconColor.info)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.bottom, CTSpacing.s)
            
            // Weight selection
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Weight")
                    .ctSubtitle()
                
                Picker("Select Weight", selection: $selectedWeight) {
                    Text("Light").tag(Font.Weight.light)
                    Text("Regular").tag(Font.Weight.regular)
                    Text("Medium").tag(Font.Weight.medium)
                    Text("Bold").tag(Font.Weight.bold)
                    Text("Heavy").tag(Font.Weight.heavy)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.bottom, CTSpacing.s)
            
            // Rendering mode selection
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Rendering Mode")
                    .ctSubtitle()
                
                Picker("Select Rendering Mode", selection: $selectedRenderingMode) {
                    Text("Mono").tag(SymbolRenderingMode.monochrome)
                    Text("Hierarchical").tag(SymbolRenderingMode.hierarchical)
                    Text("Multicolor").tag(SymbolRenderingMode.multicolor)
                    Text("Palette").tag(SymbolRenderingMode.palette)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            // Generated code
            VStack(alignment: .leading, spacing: CTSpacing.s) {
                Text("Generated Code:")
                    .ctSubtitle()
                    .padding(.top, CTSpacing.m)
                
                Text("""
                CTIcon(
                    "\(selectedIcon)",
                    size: .extraLarge,
                    color: .\(selectedColor.rawValue),
                    weight: .\(weightString(selectedWeight)),
                    renderingMode: .\(renderingModeString(selectedRenderingMode))
                )
                """)
                .ctCode()
                .padding(CTSpacing.s)
                .background(Color.ctBackground)
                .cornerRadius(CTSpacing.xs)
            }
        }
    }
    
    // MARK: - Accessibility Section
    
    /// Section discussing icon accessibility
    private var accessibilitySection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            // Section header
            Text("Accessibility")
                .ctHeading2()
                .padding(.bottom, CTSpacing.xs)
            
            Text("Icons can be made accessible to screen readers in different ways.")
                .ctBody()
                .foregroundColor(.ctTextSecondary)
                .padding(.bottom, CTSpacing.s)
            
            // Accessibility examples
            VStack(alignment: .leading, spacing: CTSpacing.m) {
                // With accessibility label
                VStack(alignment: .leading, spacing: CTSpacing.xs) {
                    Text("With Accessibility Label")
                        .ctSubtitle()
                    
                    HStack {
                        CTIcon("heart.fill", size: .large, color: .ctDestructive, accessibilityLabel: "Favorite")
                        
                        Text("This icon has an accessibility label 'Favorite' for screen readers")
                            .ctBody()
                    }
                }
                
                // Decorative icon
                VStack(alignment: .leading, spacing: CTSpacing.xs) {
                    Text("Decorative Icon")
                        .ctSubtitle()
                    
                    HStack {
                        CTIcon("circle.fill", size: .large, color: .ctPrimary, isDecorative: true)
                        
                        Text("This icon is marked as decorative and will be ignored by screen readers")
                            .ctBody()
                    }
                }
            }
            
            // Code example
            codeExample("""
            // With accessibility label
            CTIcon("heart.fill", accessibilityLabel: "Favorite")
            
            // Decorative icon (ignored by screen readers)
            CTIcon("circle.fill", isDecorative: true)
            """)
        }
    }
    
    // MARK: - Helper Views and Methods
    
    /// Helper method to create an icon size example
    /// - Parameters:
    ///   - size: The icon size
    ///   - label: The label for the size
    /// - Returns: A view displaying the icon size example
    private func iconSizeExample(size: IconSize, label: String) -> some View {
        VStack {
            CTIcon("star.fill", size: size, color: .ctPrimary)
            Text(label)
                .ctCaption()
                .foregroundColor(.ctTextSecondary)
        }
    }
    
    /// Helper method to create an icon color example
    /// - Parameters:
    ///   - color: The icon color
    ///   - label: The label for the color
    /// - Returns: A view displaying the icon color example
    private func iconColorExample(color: Color, label: String) -> some View {
        VStack {
            CTIcon("star.fill", size: .medium, color: color)
            Text(label)
                .ctCaptionSmall()
                .foregroundColor(.ctTextSecondary)
                .lineLimit(1)
        }
    }
    
    /// Helper method to create an icon weight example
    /// - Parameters:
    ///   - weight: The icon weight
    ///   - label: The label for the weight
    /// - Returns: A view displaying the icon weight example
    private func iconWeightExample(weight: Font.Weight, label: String) -> some View {
        VStack {
            CTIcon("person.fill", size: .medium, color: .ctPrimary, weight: weight)
            Text(label)
                .ctCaptionSmall()
                .foregroundColor(.ctTextSecondary)
        }
    }
    
    /// Helper method to create a rendering mode example
    /// - Parameters:
    ///   - mode: The rendering mode
    ///   - label: The label for the mode
    /// - Returns: A view displaying the rendering mode example
    private func renderingModeExample(mode: SymbolRenderingMode, label: String) -> some View {
        VStack {
            CTIcon("cloud.sun.fill", size: .medium, color: .ctPrimary, renderingMode: mode)
            Text(label)
                .ctCaptionSmall()
                .foregroundColor(.ctTextSecondary)
        }
    }
    
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
    
    /// Helper method to get the color for a selected icon color
    /// - Parameter selectedColor: The selected icon color
    /// - Returns: The corresponding SwiftUI Color
    private func colorForSelection(_ selectedColor: IconColor) -> Color {
        switch selectedColor {
        case .primary:
            return .ctPrimary
        case .secondary:
            return .ctSecondary
        case .success:
            return .ctSuccess
        case .destructive:
            return .ctDestructive
        case .warning:
            return .ctWarning
        case .info:
            return .ctInfo
        }
    }
    
    /// Helper method to get the string representation of a weight
    /// - Parameter weight: The font weight
    /// - Returns: The string representation
    private func weightString(_ weight: Font.Weight) -> String {
        switch weight {
        case .ultraLight:
            return "ultraLight"
        case .thin:
            return "thin"
        case .light:
            return "light"
        case .regular:
            return "regular"
        case .medium:
            return "medium"
        case .semibold:
            return "semibold"
        case .bold:
            return "bold"
        case .heavy:
            return "heavy"
        case .black:
            return "black"
        default:
            return "regular"
        }
    }
    
    /// Helper method to get the string representation of a rendering mode
    /// - Parameter mode: The symbol rendering mode
    /// - Returns: The string representation
    private func renderingModeString(_ mode: SymbolRenderingMode) -> String {
        switch mode {
        case .monochrome:
            return "monochrome"
        case .hierarchical:
            return "hierarchical"
        case .multicolor:
            return "multicolor"
        case .palette:
            return "palette"
        default:
            return "monochrome"
        }
    }
}

// MARK: - SymbolRenderingMode Extensions

extension SymbolRenderingMode: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .monochrome:
            hasher.combine(0)
        case .multicolor:
            hasher.combine(1)
        case .hierarchical:
            hasher.combine(2)
        case .palette:
            hasher.combine(3)
        default:
            hasher.combine(-1)
        }
    }
    
    public static func == (lhs: SymbolRenderingMode, rhs: SymbolRenderingMode) -> Bool {
        // Convert each mode to a unique integer for comparison
        func modeToInt(_ mode: SymbolRenderingMode) -> Int {
            switch mode {
            case .monochrome: return 0
            case .multicolor: return 1
            case .hierarchical: return 2
            case .palette: return 3
            default: return -1
            }
        }
        return modeToInt(lhs) == modeToInt(rhs)
    }
}

// MARK: - Supporting Types

/// Enum representing icon color options for the interactive example
enum IconColor: String {
    case primary = "ctPrimary"
    case secondary = "ctSecondary"
    case success = "ctSuccess"
    case destructive = "ctDestructive"
    case warning = "ctWarning"
    case info = "ctInfo"
}

// MARK: - Previews

struct IconExamples_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IconExamples()
        }
    }
}
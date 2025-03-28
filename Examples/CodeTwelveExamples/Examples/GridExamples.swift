//
//  GridExamples.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI

/// A view that showcases CTGrid component examples
///
/// This view demonstrates different aspects of the CTGrid component:
/// - Fixed column grids
/// - Adaptive grids
/// - Custom grid spacing and alignment
/// - Grid items with specialized sizing
/// - Interactive grid builder
struct GridExamples: View {
    // MARK: - State Properties
    
    @State private var gridType: GridType = .fixed
    @State private var columns: Int = 2
    @State private var minItemWidth: CGFloat = 120
    @State private var spacing: CGFloat = CTSpacing.m
    @State private var horizontalAlignment: HorizontalAlignment = .center
    @State private var verticalAlignment: VerticalAlignment = .center
    @State private var usePadding: Bool = false
    @State private var itemCount: Double = 6
    
    // MARK: - Private Properties
    
    private enum GridType {
        case fixed
        case adaptive
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                // Basic usage section
                basicUsageSection
                
                // Adaptive grid section
                adaptiveGridSection
                
                // Customization section
                customizationSection
                
                // Specialized items section
                specializedItemsSection
                
                // Interactive section
                interactiveSection
            }
            .padding()
        }
        .navigationTitle("Grid")
        .background(Color.ctBackground.edgesIgnoringSafeArea(.all))
    }
    
    // MARK: - Private Views
    
    /// Basic grid usage examples
    private var basicUsageSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Basic Usage")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTGrid provides a flexible grid layout for arranging views in rows and columns.")
                .padding(.bottom, CTSpacing.s)
            
            // Fixed 2-column grid
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Fixed 2-Column Grid")
                        .font(.headline)
                    
                    CTGrid(columns: 2, spacing: CTSpacing.m) {
                        ForEach(1...4, id: \.self) { index in
                            gridItem(index: index)
                        }
                    }
                    .frame(height: 200)
                    
                    codeExample("""
                    CTGrid(columns: 2, spacing: CTSpacing.m) {
                        ForEach(1...4, id: \\.self) { index in
                            // Grid item \(index)
                        }
                    }
                    """)
                }
            }
            
            // Fixed 3-column grid
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Fixed 3-Column Grid")
                        .font(.headline)
                    
                    CTGrid(columns: 3, spacing: CTSpacing.m) {
                        ForEach(1...6, id: \.self) { index in
                            gridItem(index: index)
                        }
                    }
                    .frame(height: 200)
                    
                    codeExample("""
                    CTGrid(columns: 3, spacing: CTSpacing.m) {
                        ForEach(1...6, id: \\.self) { index in
                            // Grid item \(index)
                        }
                    }
                    """)
                }
            }
        }
    }
    
    /// Adaptive grid examples
    private var adaptiveGridSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Adaptive Grids")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Adaptive grids adjust the number of columns based on available width.")
                .padding(.bottom, CTSpacing.s)
            
            // Adaptive grid
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Adaptive Grid (min width: 120pt)")
                        .font(.headline)
                    
                    CTGrid(minItemWidth: 120, spacing: CTSpacing.m) {
                        ForEach(1...8, id: \.self) { index in
                            gridItem(index: index, color: .ctSecondary)
                        }
                    }
                    .frame(height: 300)
                    
                    codeExample("""
                    CTGrid(minItemWidth: 120, spacing: CTSpacing.m) {
                        ForEach(1...8, id: \\.self) { index in
                            // Grid item \(index)
                        }
                    }
                    """)
                }
            }
            
            // Smaller adaptive grid
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Adaptive Grid (min width: 80pt)")
                        .font(.headline)
                    
                    CTGrid(minItemWidth: 80, spacing: CTSpacing.m) {
                        ForEach(1...10, id: \.self) { index in
                            gridItem(index: index, color: .ctInfo)
                        }
                    }
                    .frame(height: 300)
                    
                    codeExample("""
                    CTGrid(minItemWidth: 80, spacing: CTSpacing.m) {
                        ForEach(1...10, id: \\.self) { index in
                            // Grid item \(index)
                        }
                    }
                    """)
                }
            }
        }
    }
    
    /// Customization examples
    private var customizationSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Customization")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Grids can be customized with different spacing, alignment, and padding.")
                .padding(.bottom, CTSpacing.s)
            
            // Custom spacing
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Custom Spacing")
                        .font(.headline)
                    
                    VStack(spacing: CTSpacing.m) {
                        Text("Small Spacing (8pt)")
                            .font(.subheadline)
                        
                        CTGrid(columns: 3, spacing: CTSpacing.s) {
                            ForEach(1...6, id: \.self) { index in
                                gridItem(index: index, color: .ctInfo)
                            }
                        }
                        .frame(height: 120)
                        
                        Text("Large Spacing (24pt)")
                            .font(.subheadline)
                        
                        CTGrid(columns: 3, spacing: CTSpacing.l) {
                            ForEach(1...6, id: \.self) { index in
                                gridItem(index: index, color: .ctInfo)
                            }
                        }
                        .frame(height: 120)
                    }
                    
                    codeExample("""
                    // Small spacing
                    CTGrid(columns: 3, spacing: CTSpacing.s) {
                        // Grid items
                    }
                    
                    // Large spacing
                    CTGrid(columns: 3, spacing: CTSpacing.l) {
                        // Grid items
                    }
                    """)
                }
            }
            
            // Alignment
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Custom Alignment")
                        .font(.headline)
                    
                    VStack(spacing: CTSpacing.m) {
                        Text("Horizontal Alignment: Leading")
                            .font(.subheadline)
                        
                        CTGrid(
                            columns: 3,
                            spacing: CTSpacing.m,
                            horizontalAlignment: .leading
                        ) {
                            gridItemWithText("Leading")
                                .frame(width: 100)
                            
                            gridItemWithText("Alignment")
                                .frame(width: 100)
                            
                            gridItemWithText("Example")
                                .frame(width: 100)
                        }
                        .frame(height: 100)
                        
                        Text("Vertical Alignment: Bottom")
                            .font(.subheadline)
                        
                        CTGrid(
                            columns: 3,
                            spacing: CTSpacing.m,
                            horizontalAlignment: .center,
                            verticalAlignment: .bottom
                        ) {
                            gridItemWithText("Item 1")
                                .frame(height: 40)
                            
                            gridItemWithText("Item 2\nWith\nMultiple\nLines")
                                .frame(height: 100)
                            
                            gridItemWithText("Item 3")
                                .frame(height: 60)
                        }
                        .frame(height: 120)
                    }
                    
                    codeExample("""
                    CTGrid(
                        columns: 3,
                        spacing: CTSpacing.m,
                        horizontalAlignment: .leading
                    ) {
                        // Grid items
                    }
                    
                    CTGrid(
                        columns: 3,
                        spacing: CTSpacing.m,
                        verticalAlignment: .bottom
                    ) {
                        // Grid items with varying heights
                    }
                    """)
                }
            }
            
            // Padding
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Grid with Padding")
                        .font(.headline)
                    
                    CTGrid(
                        columns: 2,
                        spacing: CTSpacing.m,
                        padding: EdgeInsets(
                            top: CTSpacing.m,
                            leading: CTSpacing.m,
                            bottom: CTSpacing.m,
                            trailing: CTSpacing.m
                        )
                    ) {
                        ForEach(1...4, id: \.self) { index in
                            gridItem(index: index, color: .ctSuccess)
                        }
                    }
                    .frame(height: 200)
                    .background(Color.ctSuccess.opacity(0.1))
                    .cornerRadius(8)
                    
                    codeExample("""
                    CTGrid(
                        columns: 2,
                        spacing: CTSpacing.m,
                        padding: EdgeInsets(
                            top: CTSpacing.m,
                            leading: CTSpacing.m,
                            bottom: CTSpacing.m,
                            trailing: CTSpacing.m
                        )
                    ) {
                        // Grid items
                    }
                    """)
                }
            }
        }
    }
    
    /// Specialized item examples
    private var specializedItemsSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Specialized Items")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Grid items can have specialized sizing like squares and aspect ratios.")
                .padding(.bottom, CTSpacing.s)
            
            // Square items
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Square Items")
                        .font(.headline)
                    
                    CTGrid(columns: 3, spacing: CTSpacing.m) {
                        ForEach(1...6, id: \.self) { index in
                            Text("\(index)")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.ctPrimary.opacity(0.1))
                                .foregroundColor(Color.ctPrimary)
                                .cornerRadius(8)
                                .ctGridSquare()
                        }
                    }
                    .frame(height: 200)
                    
                    codeExample("""
                    CTGrid(columns: 3, spacing: CTSpacing.m) {
                        ForEach(1...6, id: \\.self) { index in
                            Text("\\(index)")
                                // Make the item square
                                .ctGridSquare()
                        }
                    }
                    """)
                }
            }
            
            // Aspect ratio items
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Aspect Ratio Items")
                        .font(.headline)
                    
                    CTGrid(columns: 2, spacing: CTSpacing.m) {
                        // 16:9 item
                        Text("16:9")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.ctSecondary.opacity(0.1))
                            .foregroundColor(Color.ctSecondary)
                            .cornerRadius(8)
                            .ctGridAspectRatio(16/9)
                        
                        // 4:3 item
                        Text("4:3")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.ctSecondary.opacity(0.1))
                            .foregroundColor(Color.ctSecondary)
                            .cornerRadius(8)
                            .ctGridAspectRatio(4/3)
                        
                        // 1:1 item (square)
                        Text("1:1")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.ctSecondary.opacity(0.1))
                            .foregroundColor(Color.ctSecondary)
                            .cornerRadius(8)
                            .ctGridAspectRatio(1)
                        
                        // 2:1 item
                        Text("2:1")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.ctSecondary.opacity(0.1))
                            .foregroundColor(Color.ctSecondary)
                            .cornerRadius(8)
                            .ctGridAspectRatio(2)
                    }
                    .frame(height: 300)
                    
                    codeExample("""
                    CTGrid(columns: 2, spacing: CTSpacing.m) {
                        // 16:9 widescreen item
                        Text("16:9")
                            .ctGridAspectRatio(16/9)
                            
                        // 4:3 standard item
                        Text("4:3")
                            .ctGridAspectRatio(4/3)
                            
                        // Custom aspect ratio
                        Text("Custom")
                            .ctGridAspectRatio(2.5)
                    }
                    """)
                }
            }
        }
    }
    
    /// Interactive grid builder
    private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Interactive Example")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Configure a grid and see how it changes.")
                .padding(.bottom, CTSpacing.s)
            
            // Controls
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.m) {
                    // Grid type control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Grid Type:")
                            .font(.headline)
                        
                        Picker("Grid Type", selection: $gridType) {
                            Text("Fixed Columns").tag(GridType.fixed)
                            Text("Adaptive").tag(GridType.adaptive)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Columns or min item width
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        if gridType == .fixed {
                            Text("Columns: \(columns)")
                                .font(.headline)
                            
                            Slider(value: Binding(
                                get: { Double(columns) },
                                set: { columns = max(1, Int($0)) }
                            ), in: 1...4, step: 1)
                        } else {
                            Text("Min Item Width: \(Int(minItemWidth))")
                                .font(.headline)
                            
                            Slider(value: $minItemWidth, in: 60...200, step: 20)
                        }
                    }
                    
                    // Spacing control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Spacing: \(Int(spacing))")
                            .font(.headline)
                        
                        Slider(value: $spacing, in: 0...48, step: 8)
                    }
                    
                    // Alignment controls
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Horizontal Alignment:")
                            .font(.headline)
                        
                        Picker("Horizontal Alignment", selection: $horizontalAlignment) {
                            Text("Leading").tag(HorizontalAlignment.leading)
                            Text("Center").tag(HorizontalAlignment.center)
                            Text("Trailing").tag(HorizontalAlignment.trailing)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Vertical Alignment:")
                            .font(.headline)
                        
                        Picker("Vertical Alignment", selection: $verticalAlignment) {
                            Text("Top").tag(VerticalAlignment.top)
                            Text("Center").tag(VerticalAlignment.center)
                            Text("Bottom").tag(VerticalAlignment.bottom)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Padding control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Toggle("Add Padding", isOn: $usePadding)
                            .font(.headline)
                    }
                    
                    // Item count control
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Item Count: \(Int(itemCount))")
                            .font(.headline)
                        
                        Slider(value: $itemCount, in: 1...12, step: 1)
                    }
                }
            }
            
            // Preview
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Preview")
                        .font(.headline)
                    
                    Group {
                        if gridType == .fixed {
                            CTGrid(
                                columns: columns,
                                spacing: spacing,
                                horizontalAlignment: horizontalAlignment,
                                verticalAlignment: verticalAlignment,
                                padding: usePadding ? EdgeInsets(top: CTSpacing.m, leading: CTSpacing.m, bottom: CTSpacing.m, trailing: CTSpacing.m) : nil
                            ) {
                                ForEach(1...Int(itemCount), id: \.self) { index in
                                    gridItem(index: index, color: .ctPrimary)
                                }
                            }
                        } else {
                            CTGrid(
                                minItemWidth: minItemWidth,
                                spacing: spacing,
                                horizontalAlignment: horizontalAlignment,
                                verticalAlignment: verticalAlignment,
                                padding: usePadding ? EdgeInsets(top: CTSpacing.m, leading: CTSpacing.m, bottom: CTSpacing.m, trailing: CTSpacing.m) : nil
                            ) {
                                ForEach(1...Int(itemCount), id: \.self) { index in
                                    gridItem(index: index, color: .ctPrimary)
                                }
                            }
                        }
                    }
                    .frame(height: 300)
                    .background(usePadding ? Color.ctBackground : nil)
                    .cornerRadius(usePadding ? 8 : 0)
                    
                    codeExample(generateCode())
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// Creates a grid item with an index and background color
    /// - Parameters:
    ///   - index: The index number to display
    ///   - color: The background color of the item
    /// - Returns: A formatted grid item
    private func gridItem(index: Int, color: Color = .ctPrimary) -> some View {
        Text("\(index)")
            .font(.title2)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fill)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(8)
    }
    
    /// Creates a grid item with custom text
    /// - Parameter text: The text to display
    /// - Returns: A formatted grid item
    private func gridItemWithText(_ text: String) -> some View {
        Text(text)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.ctPrimary.opacity(0.1))
            .foregroundColor(Color.ctPrimary)
            .cornerRadius(8)
    }
    
    /// Creates a formatted code example view
    /// - Parameter code: The code string to display
    /// - Returns: A formatted code view
    private func codeExample(_ code: String) -> some View {
        VStack(alignment: .leading) {
            Text("Code Example:")
                .font(.subheadline)
                .padding(.top, CTSpacing.xs)
            
            ScrollView(.horizontal, showsIndicators: false) {
                Text(code)
                    .font(.system(.footnote, design: .monospaced))
                    .padding(CTSpacing.s)
            }
            .background(Color.black.opacity(0.03))
            .cornerRadius(8)
        }
    }
    
    /// Generates code based on the current interactive settings
    /// - Returns: A code string reflecting current settings
    private func generateCode() -> String {
        var code = ""
        
        if gridType == .fixed {
            code += "CTGrid(\n"
            code += "    columns: \(columns),\n"
        } else {
            code += "CTGrid(\n"
            code += "    minItemWidth: \(minItemWidth),\n"
        }
        
        code += "    spacing: \(spacing != CTSpacing.m ? String(format: "%.1f", spacing) : "CTSpacing.m"),\n"
        
        if horizontalAlignment != .center {
            switch horizontalAlignment {
            case .leading:
                code += "    horizontalAlignment: .leading,\n"
            case .trailing:
                code += "    horizontalAlignment: .trailing,\n"
            default:
                break
            }
        }
        
        if verticalAlignment != .center {
            switch verticalAlignment {
            case .top:
                code += "    verticalAlignment: .top,\n"
            case .bottom:
                code += "    verticalAlignment: .bottom,\n"
            default:
                break
            }
        }
        
        if usePadding {
            code += "    padding: EdgeInsets(\n"
            code += "        top: CTSpacing.m,\n"
            code += "        leading: CTSpacing.m,\n"
            code += "        bottom: CTSpacing.m,\n"
            code += "        trailing: CTSpacing.m\n"
            code += "    ),\n"
        }
        
        code += ") {\n"
        code += "    ForEach(1...\(Int(itemCount)), id: \\.self) { index in\n"
        code += "        // Grid item content\n"
        code += "    }\n"
        code += "}"
        
        return code
    }
}

struct GridExamples_Previews: PreviewProvider {
    static var previews: some View {
        GridExamples()
    }
}
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
/// - Basic grid usage with different column configurations
/// - Responsive grid layouts
/// - Grid with different spacing options
/// - Grid with custom item styling
/// - Interactive grid builder
struct GridExamples: View {
    // MARK: - Supporting Types
    
    /// Wrapper for grid column width options
    enum GridColumnWidth {
        case fixed(Int)
        case adaptive(minWidth: CGFloat)
        
        var columns: Int? {
            switch self {
            case .fixed(let columns):
                return columns
            case .adaptive:
                return nil
            }
        }
        
        var minItemWidth: CGFloat? {
            switch self {
            case .fixed:
                return nil
            case .adaptive(let minWidth):
                return minWidth
            }
        }
    }
    
    // MARK: - State Properties
    
    @State private var columns: Int = 2
    @State private var horizontalSpacing: CGFloat = 10
    @State private var verticalSpacing: CGFloat = 10
    @State private var itemPadding: CGFloat = 12
    @State private var itemBackgroundColor: Color = .blue.opacity(0.1)
    @State private var itemCornerRadius: CGFloat = 8
    @State private var columnWidthStrategy: ColumnWidthStrategy = .fixed(2)
    @State private var minItemWidth: CGFloat = 100
    @State private var columnsDouble: Double = 2.0
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CTSpacing.l) {
                // Basic usage section
                basicUsageSection
                
                // Column configuration section
                columnConfigurationSection
                
                // Spacing section
                spacingSection
                
                // Responsive section
                responsiveSection
                
                // Custom styling section
                customStylingSection
                
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
            
            Text("CTGrid provides a flexible way to arrange views in a grid layout.")
                .padding(.bottom, CTSpacing.s)
            
            // Basic grid
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Basic Grid")
                        .font(.headline)
                    
                    CTGrid(columns: 3, spacing: CTSpacing.m) {
                        ForEach(1..<7, id: \.self) { index in
                            gridItem(index)
                        }
                    }
                    
                    codeExample("""
                    CTGrid(columns: 3, spacing: CTSpacing.m) {
                        ForEach(1...6, id: \\.self) { index in
                            Text("Item \\(index)")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.ctPrimary.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    """)
                }
            }
        }
    }
    
    /// Column configuration examples
    private var columnConfigurationSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Column Configuration")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTGrid supports different column width strategies.")
                .padding(.bottom, CTSpacing.s)
            
            // Fixed column width
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Fixed Column Width")
                        .font(.headline)
                    
                    CTGrid(columns: 2, spacing: CTSpacing.m) {
                        ForEach(1...6, id: \.self) { index in
                            gridItem(index)
                        }
                    }
                    
                    codeExample("""
                    CTGrid(columns: 2, spacing: CTSpacing.m) {
                        ForEach(1...6, id: \\.self) { index in
                            Text("Item \\(index)")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.ctPrimary.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    """)
                }
            }
            
            // Flexible column width
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Flexible Column Width")
                        .font(.headline)
                    
                    CTGrid(minItemWidth: 100, spacing: CTSpacing.m) {
                        ForEach(1...6, id: \.self) { index in
                            gridItem(index)
                        }
                    }
                    
                    codeExample("""
                    CTGrid(minItemWidth: 100, spacing: CTSpacing.m) {
                        // Grid items
                    }
                    """)
                }
            }
            
            // Adaptive column width
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Adaptive Column Width")
                        .font(.headline)
                    
                    makeGrid(columnWidth: .adaptive(minWidth: 100), spacing: CTSpacing.m) {
                        ForEach(1...6, id: \.self) { index in
                            gridItem(index)
                        }
                    }
                    
                    codeExample("""
                    CTGrid(minItemWidth: 100, spacing: CTSpacing.m) {
                        // Grid items
                    }
                    """)
                }
            }
        }
    }
    
    /// Spacing examples
    private var spacingSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Spacing")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Control the spacing between items in the grid.")
                .padding(.bottom, CTSpacing.s)
            
            // Spacing options
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Different Spacing Options")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: CTSpacing.m) {
                        Text("No Spacing")
                            .font(.subheadline)
                        
                        CTGrid(columns: 3, spacing: 0) {
                            ForEach(1...6, id: \.self) { index in
                                gridItem(index)
                            }
                        }
                        
                        Text("Small Spacing (8pt)")
                            .font(.subheadline)
                        
                        CTGrid(columns: 3, spacing: CTSpacing.s) {
                            ForEach(1...6, id: \.self) { index in
                                gridItem(index)
                            }
                        }
                        
                        Text("Large Spacing (24pt)")
                            .font(.subheadline)
                        
                        CTGrid(columns: 3, spacing: CTSpacing.l) {
                            ForEach(1...6, id: \.self) { index in
                                gridItem(index)
                            }
                        }
                    }
                    
                    codeExample("""
                    // No spacing
                    CTGrid(columns: 3, spacing: 0) {
                        // Grid items
                    }
                    
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
            
            // Different horizontal and vertical spacing
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Different Horizontal & Vertical Spacing")
                        .font(.headline)
                    
                    CTGrid(
                        columns: 3,
                        spacing: CTSpacing.l
                    ) {
                        ForEach(1..<7, id: \.self) { index in
                            gridItem(index)
                        }
                    }
                    
                    codeExample("""
                    CTGrid(
                        columns: 3,
                        spacing: CTSpacing.l
                    ) {
                        ForEach(1..<7, id: \\.self) { index in
                            gridItem(index)
                        }
                    }
                    """)
                }
            }
        }
    }
    
    /// Responsive grid examples
    private var responsiveSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Responsive Grids")
                .font(.title)
                .fontWeight(.bold)
            
            Text("CTGrid automatically adapts to different screen sizes.")
                .padding(.bottom, CTSpacing.s)
            
            // Adaptive grid
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Adaptive Grid")
                        .font(.headline)
                    
                    Text("This grid automatically adjusts the number of columns based on available width.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, CTSpacing.xs)
                    
                    makeGrid(columnWidth: .adaptive(minWidth: 120), spacing: CTSpacing.m) {
                        ForEach(1...8, id: \.self) { index in
                            gridItem(index)
                        }
                    }
                    
                    codeExample("""
                    // Resize your window to see the columns adapt
                    CTGrid(minItemWidth: 120, spacing: CTSpacing.m) {
                        // Grid items
                    }
                    """)
                }
            }
            
            // Responsive columns grid
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Responsive Columns")
                        .font(.headline)
                    
                    Text("This grid changes columns based on environment size class.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, CTSpacing.xs)
                    
                    ResponsiveColumnsGrid()
                    
                    codeExample("""
                    @Environment(\\.horizontalSizeClass) var horizontalSizeClass
                    
                    var columns: Int {
                        horizontalSizeClass == .compact ? 2 : 4
                    }
                    
                    var body: some View {
                        CTGrid(columns: columns, spacing: CTSpacing.m) {
                            // Grid items
                        }
                    }
                    """)
                }
            }
        }
    }
    
    /// Custom styling examples
    private var customStylingSection: some View {
        VStack(alignment: .leading, spacing: CTSpacing.m) {
            Text("Custom Styling")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Customize the appearance of grid items.")
                .padding(.bottom, CTSpacing.s)
            
            // Styled grid items
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Styled Grid Items")
                        .font(.headline)
                    
                    CTGrid(columns: 3, spacing: CTSpacing.m) {
                        gridItem(1, style: .primary)
                        gridItem(2, style: .secondary)
                        gridItem(3, style: .success)
                        gridItem(4, style: .warning)
                        gridItem(5, style: .danger)
                        gridItem(6, style: .info)
                    }
                    
                    codeExample("""
                    CTGrid(columns: 3, spacing: CTSpacing.m) {
                        // Items with different styles
                        // Primary, Secondary, Success, etc.
                    }
                    """)
                }
            }
            
            // Card grid
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Card Grid")
                        .font(.headline)
                    
                    CTGrid(columns: 2, spacing: CTSpacing.m) {
                        ForEach(1...4, id: \.self) { index in
                            CTCard(style: .outlined, borderWidth: 1) {
                                VStack(alignment: .leading, spacing: CTSpacing.s) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    
                                    Text("Card \(index)")
                                        .font(.headline)
                                    
                                    Text("A grid of cards with custom content")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                            }
                        }
                    }
                    
                    codeExample("""
                    CTGrid(columns: 2, spacing: CTSpacing.m) {
                        ForEach(1...4, id: \\.self) { index in
                            CTCard(style: .outlined, borderWidth: 1) {
                                // Card content
                            }
                        }
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
                    // Column width strategy
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Layout Strategy:")
                            .font(.headline)
                        
                        Picker("Layout Strategy", selection: $columnWidthStrategy) {
                            Text("Fixed").tag(ColumnWidthStrategy.fixed(2))
                            Text("Adaptive").tag(ColumnWidthStrategy.adaptive(100))
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: columnWidthStrategy) { newValue in
                            // Reset values when switching strategies
                            switch newValue {
                            case .fixed:
                                columns = 2
                            case .adaptive:
                                minItemWidth = 100
                            }
                        }
                        
                        // Show different controls based on strategy
                        switch columnWidthStrategy {
                        case .fixed:
                            HStack {
                                Text("Columns: \(columns)")
                                Slider(value: $columnsDouble, in: 1...6, step: 1)
                                    .onChange(of: columnsDouble) { newValue in
                                        columns = Int(newValue)
                                        // Update the strategy
                                        columnWidthStrategy = .fixed(columns)
                                    }
                            }
                            
                        case .adaptive:
                            HStack {
                                Text("Min Width: \(Int(minItemWidth))px")
                                Slider(value: $minItemWidth, in: 50...300, step: 5)
                                    .onChange(of: minItemWidth) { newValue in
                                        // Update the strategy
                                        columnWidthStrategy = .adaptive(newValue)
                                    }
                            }
                        }
                    }
                    
                    // Spacing controls
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Horizontal Spacing: \(Int(horizontalSpacing))")
                            .font(.headline)
                        
                        Slider(value: $horizontalSpacing.animation(), in: 0...32, step: 4)
                    }
                    
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Vertical Spacing: \(Int(verticalSpacing))")
                            .font(.headline)
                        
                        Slider(value: $verticalSpacing.animation(), in: 0...32, step: 4)
                    }
                    
                    // Item styling
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Item Padding: \(Int(itemPadding))")
                            .font(.headline)
                        
                        Slider(value: $itemPadding.animation(), in: 0...24, step: 4)
                    }
                    
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Item Corner Radius: \(Int(itemCornerRadius))")
                            .font(.headline)
                        
                        Slider(value: $itemCornerRadius.animation(), in: 0...20, step: 2)
                    }
                    
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text("Item Background:")
                            .font(.headline)
                        
                        ColorPicker("", selection: $itemBackgroundColor)
                            .labelsHidden()
                    }
                }
            }
            
            // Preview
            CTCard {
                VStack(alignment: .leading, spacing: CTSpacing.s) {
                    Text("Preview")
                        .font(.headline)
                    
                    Group {
                        switch columnWidthStrategy {
                        case .fixed:
                            CTGrid(
                                columns: Int(columns),
                                spacing: horizontalSpacing
                            ) {
                                ForEach(1...9, id: \.self) { index in
                                    interactiveGridItem(index)
                                }
                            }
                        case .adaptive:
                            CTGrid(
                                minItemWidth: minItemWidth,
                                spacing: horizontalSpacing
                            ) {
                                ForEach(1...9, id: \.self) { index in
                                    interactiveGridItem(index)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    codeExample(generateCode())
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Creates a grid with the specified column width
    private func makeGrid<Content: View>(columnWidth: GridColumnWidth, spacing: CGFloat = CTSpacing.m, @ViewBuilder content: () -> Content) -> some View {
        Group {
            if let columns = columnWidth.columns {
                CTGrid(columns: columns, spacing: spacing, content: content)
            } else if let minWidth = columnWidth.minItemWidth {
                CTGrid(minItemWidth: minWidth, spacing: spacing, content: content)
            } else {
                // Default to 2 columns
                CTGrid(columns: 2, spacing: spacing, content: content)
            }
        }
    }
    
    /// Creates a grid item with the specified index and style
    /// - Parameters:
    ///   - index: The item number
    ///   - style: Optional style for coloring the item
    /// - Returns: A standard grid item view
    private func gridItem(_ index: Int, style: ItemStyle = .default) -> some View {
        Text("Item \(index)")
            .padding()
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(style.backgroundColor)
            .foregroundColor(style.foregroundColor)
            .cornerRadius(8)
    }
    
    /// Creates an interactive grid item
    /// - Parameter index: The item number
    /// - Returns: A grid item with interactive styling
    private func interactiveGridItem(_ index: Int) -> some View {
        Text("Item \(index)")
            .padding(itemPadding)
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(itemBackgroundColor)
            .foregroundColor(itemBackgroundColor.opacity(0.5).cgColor?.alpha ?? 0 < 0.5 ? .primary : .white)
            .cornerRadius(itemCornerRadius)
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
        var code = "CTGrid(\n"
        
        // Column configuration
        switch columnWidthStrategy {
        case .fixed:
            code += "    columns: \(columns),\n"
        case .adaptive:
            code += "    minItemWidth: \(Int(minItemWidth)),\n"
        }
        
        // Spacing
        if horizontalSpacing == verticalSpacing {
            code += "    spacing: \(Int(horizontalSpacing)),\n"
        } else {
            code += "    horizontalSpacing: \(Int(horizontalSpacing)),\n"
            code += "    verticalSpacing: \(Int(verticalSpacing)),\n"
        }
        
        code += ") {\n"
        code += "    ForEach(1...9, id: \\.self) { index in\n"
        code += "        Text(\"Item \\(index)\")\n"
        code += "            .padding(\(Int(itemPadding)))\n"
        code += "            .frame(maxWidth: .infinity, minHeight: 60)\n"
        code += "            .background(Color.ctPrimary.opacity(0.1))\n"
        code += "            .cornerRadius(\(Int(itemCornerRadius)))\n"
        code += "    }\n"
        code += "}"
        
        return code
    }
    
    // MARK: - Supporting Types
    
    /// Style options for grid items
    enum ItemStyle {
        case `default`
        case primary
        case secondary
        case success
        case warning
        case danger
        case info
        
        var backgroundColor: Color {
            switch self {
            case .default:
                return Color.ctPrimary.opacity(0.1)
            case .primary:
                return Color.ctPrimary
            case .secondary:
                return Color.gray
            case .success:
                return Color.green
            case .warning:
                return Color.yellow
            case .danger:
                return Color.red
            case .info:
                return Color.blue
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .default:
                return .primary
            case .warning:
                return .black
            case .primary, .secondary, .success, .danger, .info:
                return .white
            }
        }
    }
    
    /// Define column width strategy for the example
    enum ColumnWidthStrategy: Hashable, Equatable {
        case fixed(Int)
        case adaptive(CGFloat)
        
        var description: String {
            switch self {
            case .fixed(let columns):
                return "Fixed (\(columns) columns)"
            case .adaptive(let width):
                return "Adaptive (min width: \(Int(width)))"
            }
        }
        
        var minWidth: CGFloat {
            switch self {
            case .fixed:
                return 0 // Not applicable for fixed columns
            case .adaptive(let width):
                return width
            }
        }
        
        // MARK: - Hashable & Equatable Conformance
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .fixed(let columns):
                hasher.combine(0) // Use 0 as discriminator for fixed
                hasher.combine(columns)
            case .adaptive(let width):
                hasher.combine(1) // Use 1 as discriminator for adaptive
                hasher.combine(width)
            }
        }
        
        static func == (lhs: ColumnWidthStrategy, rhs: ColumnWidthStrategy) -> Bool {
            switch (lhs, rhs) {
            case (.fixed(let lhsColumns), .fixed(let rhsColumns)):
                return lhsColumns == rhsColumns
            case (.adaptive(let lhsWidth), .adaptive(let rhsWidth)):
                return lhsWidth == rhsWidth
            default:
                return false
            }
        }
    }
    
    /// A grid that changes columns based on the environment size class
    struct ResponsiveColumnsGrid: View {
        @Environment(\.horizontalSizeClass) var horizontalSizeClass
        
        var columns: Int {
            horizontalSizeClass == .compact ? 2 : 4
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Current columns: \(columns) (based on size class)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, CTSpacing.xs)
                
                CTGrid(columns: columns, spacing: CTSpacing.m) {
                    ForEach(1...8, id: \.self) { index in
                        Text("Item \(index)")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.ctPrimary.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
}

struct GridExamples_Previews: PreviewProvider {
    static var previews: some View {
        GridExamples()
    }
}
//
//  CTChartLegend.swift
//  CodetwelveUI
//
//  Created on 29/03/25.
//

import SwiftUI

/// A legend component for charts.
///
/// `CTChartLegend` displays a legend with color indicators and labels for each series in a chart.
/// It can be configured for different layouts and positions.
///
/// # Example
///
/// ```swift
/// CTChartLegend(
///     items: [
///         CTChartLegendItem(name: "Sales", color: .blue),
///         CTChartLegendItem(name: "Revenue", color: .green)
///     ],
///     layout: .horizontal,
///     alignment: .center
/// )
/// ```
public struct CTChartLegend: View {
    // MARK: - Properties
    
    /// The items to display in the legend
    private let items: [CTChartLegendItem]
    
    /// The layout direction of the legend
    private let layout: CTChartLegendLayout
    
    /// The alignment of the legend items
    private let alignment: Alignment
    
    /// The spacing between legend items
    private let spacing: CGFloat
    
    /// The font for the legend labels
    private let font: Font?
    
    /// The color for the legend labels
    private let textColor: Color?
    
    /// The shape of the color indicators
    private let indicatorShape: CTChartLegendIndicatorShape
    
    /// The size of the color indicators
    private let indicatorSize: CGFloat
    
    /// Whether the legend is interactive
    private let isInteractive: Bool
    
    /// Callback for when a legend item is tapped
    private let onItemTap: ((CTChartLegendItem) -> Void)?
    
    /// Current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializer
    
    /// Initialize a chart legend
    /// - Parameters:
    ///   - items: The items to display in the legend
    ///   - layout: The layout direction of the legend
    ///   - alignment: The alignment of the legend items
    ///   - spacing: The spacing between legend items
    ///   - font: The font for the legend labels
    ///   - textColor: The color for the legend labels
    ///   - indicatorShape: The shape of the color indicators
    ///   - indicatorSize: The size of the color indicators
    ///   - isInteractive: Whether the legend is interactive
    ///   - onItemTap: Callback for when a legend item is tapped
    public init(
        items: [CTChartLegendItem],
        layout: CTChartLegendLayout = .horizontal,
        alignment: Alignment = .center,
        spacing: CGFloat = CTSpacing.s,
        font: Font? = nil,
        textColor: Color? = nil,
        indicatorShape: CTChartLegendIndicatorShape = .rectangle,
        indicatorSize: CGFloat = 12,
        isInteractive: Bool = false,
        onItemTap: ((CTChartLegendItem) -> Void)? = nil
    ) {
        self.items = items
        self.layout = layout
        self.alignment = alignment
        self.spacing = spacing
        self.font = font
        self.textColor = textColor
        self.indicatorShape = indicatorShape
        self.indicatorSize = indicatorSize
        self.isInteractive = isInteractive
        self.onItemTap = onItemTap
    }
    
    /// Initialize a chart legend from data series
    /// - Parameters:
    ///   - series: The data series to create legend items from
    ///   - layout: The layout direction of the legend
    ///   - alignment: The alignment of the legend items
    ///   - spacing: The spacing between legend items
    ///   - font: The font for the legend labels
    ///   - textColor: The color for the legend labels
    ///   - indicatorShape: The shape of the color indicators
    ///   - indicatorSize: The size of the color indicators
    ///   - isInteractive: Whether the legend is interactive
    ///   - onItemTap: Callback when a legend item is tapped
    public init(
        series: [CTChartSeries],
        style: CTChartStyle,
        layout: CTChartLegendLayout = .horizontal,
        alignment: Alignment = .center,
        spacing: CGFloat = CTSpacing.s,
        font: Font? = nil,
        textColor: Color? = nil,
        indicatorShape: CTChartLegendIndicatorShape = .rectangle,
        indicatorSize: CGFloat = 12,
        isInteractive: Bool = false,
        onItemTap: ((CTChartLegendItem) -> Void)? = nil
    ) {
        // Create legend items from chart series
        var legendItems: [CTChartLegendItem] = []
        
        for (index, series) in series.enumerated() {
            legendItems.append(
                CTChartLegendItem(
                    name: series.name,
                    color: series.color ?? style.nextColor(forIndex: index, theme: CTDefaultTheme()),
                    isActive: series.isVisible
                )
            )
        }
        
        self.items = legendItems
        self.layout = layout
        self.alignment = alignment
        self.spacing = spacing
        self.font = font
        self.textColor = textColor
        self.indicatorShape = indicatorShape
        self.indicatorSize = indicatorSize
        self.isInteractive = isInteractive
        self.onItemTap = onItemTap
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            if layout == .horizontal {
                HStack(alignment: .center, spacing: spacing) {
                    ForEach(items) { item in
                        legendItemView(item)
                    }
                }
            } else {
                VStack(alignment: .leading, spacing: spacing) {
                    ForEach(items) { item in
                        legendItemView(item)
                    }
                }
            }
        }
        .padding(CTSpacing.xs)
        .background(theme.surface.opacity(0.8))
        .cornerRadius(theme.borderRadius / 2)
        .ctAccessibilityGroup(label: "Chart legend")
    }
    
    // MARK: - Private Methods
    
    /// Create a view for a single legend item
    /// - Parameter item: The legend item
    /// - Returns: A view for the legend item
    private func legendItemView(_ item: CTChartLegendItem) -> some View {
        HStack(spacing: CTSpacing.xs) {
            // Color indicator
            Group {
                switch indicatorShape {
                case .rectangle:
                    Rectangle()
                        .fill(item.color)
                
                case .circle:
                    Circle()
                        .fill(item.color)
                
                case .roundedRectangle(let cornerRadius):
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(item.color)
                }
            }
            .frame(width: indicatorSize, height: indicatorSize)
            .opacity(item.isActive ? 1.0 : 0.5)
            
            // Item label
            Text(item.name)
                .font(font ?? CTTypography.captionSmall())
                .foregroundColor(textColor ?? theme.text)
                .opacity(item.isActive ? 1.0 : 0.7)
        }
        .padding(.horizontal, CTSpacing.xs)
        .padding(.vertical, 2)
        .background(
            isInteractive ?
                theme.background.opacity(0.3)
                .cornerRadius(theme.borderRadius / 4) :
                Color.clear
        )
        .onTapGesture {
            if isInteractive {
                onItemTap?(item)
            }
        }
        .ctAccessibilityElement(
            label: "\(item.name), \(item.isActive ? "enabled" : "disabled")",
            traits: isInteractive ? [.isButton] : []
        )
    }
}

/// An item in a chart legend
public struct CTChartLegendItem: Identifiable {
    /// Unique identifier for the item
    public let id = UUID()
    
    /// The name of the item
    public let name: String
    
    /// The color of the item
    public let color: Color
    
    /// Whether the item is active
    public let isActive: Bool
    
    /// Initialize a legend item
    /// - Parameters:
    ///   - name: The name of the item
    ///   - color: The color of the item
    ///   - isActive: Whether the item is active
    public init(name: String, color: Color, isActive: Bool = true) {
        self.name = name
        self.color = color
        self.isActive = isActive
    }
}

/// The layout direction of a chart legend
public enum CTChartLegendLayout {
    /// Horizontal layout with items in a row
    case horizontal
    
    /// Vertical layout with items in a column
    case vertical
}

/// The shape of color indicators in a chart legend
public enum CTChartLegendIndicatorShape {
    /// Rectangle shape
    case rectangle
    
    /// Circle shape
    case circle
    
    /// Rounded rectangle shape with custom corner radius
    case roundedRectangle(cornerRadius: CGFloat)
}

/// A builder for creating a chart legend with series
public struct CTChartLegendBuilder {
    /// The data series to create legend items from
    private let series: [CTChartSeries]
    
    /// The color style for the chart
    private let style: CTChartStyle
    
    /// Create a legend builder with series
    /// - Parameters:
    ///   - series: The data series
    ///   - style: The chart style
    public init(series: [CTChartSeries], style: CTChartStyle) {
        self.series = series
        self.style = style
    }
    
    /// Build a legend with horizontal layout
    /// - Parameters:
    ///   - alignment: The alignment of the legend
    ///   - isInteractive: Whether the legend is interactive
    ///   - onItemTap: Callback for when a legend item is tapped
    /// - Returns: A chart legend view
    public func buildHorizontal(
        alignment: Alignment = .center,
        isInteractive: Bool = false,
        onItemTap: ((CTChartLegendItem) -> Void)? = nil
    ) -> CTChartLegend {
        CTChartLegend(
            series: series,
            style: style,
            layout: .horizontal,
            alignment: alignment,
            isInteractive: isInteractive,
            onItemTap: onItemTap
        )
    }
    
    /// Build a legend with vertical layout
    /// - Parameters:
    ///   - alignment: The alignment of the legend
    ///   - isInteractive: Whether the legend is interactive
    ///   - onItemTap: Callback for when a legend item is tapped
    /// - Returns: A chart legend view
    public func buildVertical(
        alignment: Alignment = .leading,
        isInteractive: Bool = false,
        onItemTap: ((CTChartLegendItem) -> Void)? = nil
    ) -> CTChartLegend {
        CTChartLegend(
            series: series,
            style: style,
            layout: .vertical,
            alignment: alignment,
            isInteractive: isInteractive,
            onItemTap: onItemTap
        )
    }
    
    /// Build a legend with custom configuration
    /// - Parameters:
    ///   - layout: The layout direction of the legend
    ///   - alignment: The alignment of the legend
    ///   - spacing: The spacing between legend items
    ///   - font: The font for the legend labels
    ///   - textColor: The color for the legend labels
    ///   - indicatorShape: The shape of the color indicators
    ///   - indicatorSize: The size of the color indicators
    ///   - isInteractive: Whether the legend is interactive
    ///   - onItemTap: Callback for when a legend item is tapped
    /// - Returns: A chart legend view
    public func buildCustom(
        layout: CTChartLegendLayout = .horizontal,
        alignment: Alignment = .center,
        spacing: CGFloat = CTSpacing.s,
        font: Font? = nil,
        textColor: Color? = nil,
        indicatorShape: CTChartLegendIndicatorShape = .rectangle,
        indicatorSize: CGFloat = 12,
        isInteractive: Bool = false,
        onItemTap: ((CTChartLegendItem) -> Void)? = nil
    ) -> CTChartLegend {
        CTChartLegend(
            series: series,
            style: style,
            layout: layout,
            alignment: alignment,
            spacing: spacing,
            font: font,
            textColor: textColor,
            indicatorShape: indicatorShape,
            indicatorSize: indicatorSize,
            isInteractive: isInteractive,
            onItemTap: onItemTap
        )
    }
}

// MARK: - Preview

struct CTChartLegend_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Horizontal legend
            CTChartLegend(
                items: [
                    CTChartLegendItem(name: "Sales", color: .blue),
                    CTChartLegendItem(name: "Revenue", color: .green),
                    CTChartLegendItem(name: "Profit", color: .orange, isActive: false)
                ],
                layout: .horizontal
            )
            .padding()
            .previewDisplayName("Horizontal Legend")
            
            // Vertical legend
            CTChartLegend(
                items: [
                    CTChartLegendItem(name: "Sales", color: .blue),
                    CTChartLegendItem(name: "Revenue", color: .green),
                    CTChartLegendItem(name: "Profit", color: .orange, isActive: false)
                ],
                layout: .vertical
            )
            .padding()
            .previewDisplayName("Vertical Legend")
            
            // Interactive legend with different indicator shape
            CTChartLegend(
                items: [
                    CTChartLegendItem(name: "Sales", color: .blue),
                    CTChartLegendItem(name: "Revenue", color: .green),
                    CTChartLegendItem(name: "Profit", color: .orange)
                ],
                layout: .horizontal,
                indicatorShape: .circle,
                isInteractive: true,
                onItemTap: { item in
                    print("Tapped \(item.name)")
                }
            )
            .padding()
            .previewDisplayName("Interactive Legend")
        }
        .padding()
    }
}

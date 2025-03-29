//
//  CTChartGrid.swift
//  CodetwelveUI
//
//  Created on 29/03/25.
//

import SwiftUI

/// A grid component for charts.
///
/// `CTChartGrid` renders grid lines for charts to make data easier to read.
/// It can be configured with different styles and density of grid lines.
///
/// # Example
///
/// ```swift
/// CTChartGrid(
///     xTicks: [0, 20, 40, 60, 80, 100],
///     yTicks: [0, 25, 50, 75, 100],
///     config: .default,
///     xAxisVisible: true,
///     yAxisVisible: true
/// )
/// ```
public struct CTChartGrid: View {
    // MARK: - Properties
    
    /// The x-axis tick positions for the grid lines
    private let xTicks: [Double]
    
    /// The y-axis tick positions for the grid lines
    private let yTicks: [Double]
    
    /// The configuration for the grid
    private let config: CTChartGridConfig
    
    /// Whether the x-axis is visible
    private let xAxisVisible: Bool
    
    /// Whether the y-axis is visible
    private let yAxisVisible: Bool
    
    /// The range of the grid in the x direction
    private let xRange: ClosedRange<Double>
    
    /// The range of the grid in the y direction
    private let yRange: ClosedRange<Double>
    
    /// Current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializer
    
    /// Initialize a chart grid
    /// - Parameters:
    ///   - xTicks: The x-axis tick positions for the grid lines
    ///   - yTicks: The y-axis tick positions for the grid lines
    ///   - config: The configuration for the grid
    ///   - xAxisVisible: Whether the x-axis is visible
    ///   - yAxisVisible: Whether the y-axis is visible
    ///   - xRange: The range of the grid in the x direction
    ///   - yRange: The range of the grid in the y direction
    public init(
        xTicks: [Double],
        yTicks: [Double],
        config: CTChartGridConfig = .default,
        xAxisVisible: Bool = true,
        yAxisVisible: Bool = true,
        xRange: ClosedRange<Double>,
        yRange: ClosedRange<Double>
    ) {
        self.xTicks = xTicks
        self.yTicks = yTicks
        self.config = config
        self.xAxisVisible = xAxisVisible
        self.yAxisVisible = yAxisVisible
        self.xRange = xRange
        self.yRange = yRange
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                if let backgroundColor = config.backgroundColor {
                    Rectangle()
                        .fill(backgroundColor)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
                
                // Vertical grid lines (along X-axis ticks)
                if config.showVerticalLines {
                    ForEach(0..<xTicks.count, id: \.self) { i in
                        verticalGridLine(at: xTicks[i], in: geometry)
                    }
                }
                
                // Horizontal grid lines (along Y-axis ticks)
                if config.showHorizontalLines {
                    ForEach(0..<yTicks.count, id: \.self) { i in
                        horizontalGridLine(at: yTicks[i], in: geometry)
                    }
                }
                
                // X-axis
                if xAxisVisible && config.showAxes {
                    Path { path in
                        let y = geometry.size.height
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                    }
                    .stroke(config.axisColor ?? theme.text, lineWidth: config.axisLineWidth)
                }
                
                // Y-axis
                if yAxisVisible && config.showAxes {
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
                    }
                    .stroke(config.axisColor ?? theme.text, lineWidth: config.axisLineWidth)
                }
            }
            .ctAccessibilityHidden(when: true) // Grid is purely visual
        }
    }
    
    // MARK: - Private Methods
    
    /// Create a vertical grid line at a specific tick position
    /// - Parameters:
    ///   - tick: The x-axis tick value
    ///   - geometry: The container geometry
    /// - Returns: A vertical grid line view
    private func verticalGridLine(at tick: Double, in geometry: GeometryProxy) -> some View {
        let x = calculateXPosition(for: tick, in: geometry)
        let isMinorLine = config.minorTickPositions.contains(tick)
        let lineColor = isMinorLine ? config.minorGridColor ?? theme.border.opacity(0.3) : config.gridColor ?? theme.border.opacity(0.5)
        let lineWidth = isMinorLine ? config.minorGridLineWidth : config.gridLineWidth
        let dashPattern = isMinorLine ? config.minorGridLineDashPattern : config.gridLineDashPattern
        
        return Path { path in
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: geometry.size.height))
        }
        .stroke(
            lineColor,
            style: StrokeStyle(
                lineWidth: lineWidth,
                lineCap: .butt,
                lineJoin: .miter,
                miterLimit: 10,
                dash: dashPattern,
                dashPhase: 0
            )
        )
    }
    
    /// Create a horizontal grid line at a specific tick position
    /// - Parameters:
    ///   - tick: The y-axis tick value
    ///   - geometry: The container geometry
    /// - Returns: A horizontal grid line view
    private func horizontalGridLine(at tick: Double, in geometry: GeometryProxy) -> some View {
        let y = calculateYPosition(for: tick, in: geometry)
        let isMinorLine = config.minorTickPositions.contains(tick)
        let lineColor = isMinorLine ? config.minorGridColor ?? theme.border.opacity(0.3) : config.gridColor ?? theme.border.opacity(0.5)
        let lineWidth = isMinorLine ? config.minorGridLineWidth : config.gridLineWidth
        let dashPattern = isMinorLine ? config.minorGridLineDashPattern : config.gridLineDashPattern
        
        return Path { path in
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: geometry.size.width, y: y))
        }
        .stroke(
            lineColor,
            style: StrokeStyle(
                lineWidth: lineWidth,
                lineCap: .butt,
                lineJoin: .miter,
                miterLimit: 10,
                dash: dashPattern,
                dashPhase: 0
            )
        )
    }
    
    /// Calculate the x position for a tick value
    /// - Parameters:
    ///   - tick: The tick value
    ///   - geometry: The container geometry
    /// - Returns: The x position in the view
    private func calculateXPosition(for tick: Double, in geometry: GeometryProxy) -> CGFloat {
        return CTChartUtilities.scale(
            value: tick,
            sourceDomain: xRange,
            targetRange: 0...geometry.size.width
        )
    }
    
    /// Calculate the y position for a tick value
    /// - Parameters:
    ///   - tick: The tick value
    ///   - geometry: The container geometry
    /// - Returns: The y position in the view
    private func calculateYPosition(for tick: Double, in geometry: GeometryProxy) -> CGFloat {
        // Invert the y-coordinate because SwiftUI's coordinate system has y increasing downward
        return geometry.size.height - CTChartUtilities.scale(
            value: tick,
            sourceDomain: yRange,
            targetRange: 0...geometry.size.height
        )
    }
}

/// Configuration for chart grids
public struct CTChartGridConfig {
    /// Whether to show grid lines along the x-axis ticks
    public var showVerticalLines: Bool
    
    /// Whether to show grid lines along the y-axis ticks
    public var showHorizontalLines: Bool
    
    /// Whether to show the axes
    public var showAxes: Bool
    
    /// The color of the grid lines
    public var gridColor: Color?
    
    /// The width of the grid lines
    public var gridLineWidth: CGFloat
    
    /// The dash pattern for the grid lines
    public var gridLineDashPattern: [CGFloat]
    
    /// The color of the minor grid lines
    public var minorGridColor: Color?
    
    /// The width of the minor grid lines
    public var minorGridLineWidth: CGFloat
    
    /// The dash pattern for the minor grid lines
    public var minorGridLineDashPattern: [CGFloat]
    
    /// The positions of minor ticks
    public var minorTickPositions: [Double]
    
    /// The color of the axes
    public var axisColor: Color?
    
    /// The width of the axis lines
    public var axisLineWidth: CGFloat
    
    /// The background color of the grid
    public var backgroundColor: Color?
    
    /// Default grid configuration
    public static var `default`: CTChartGridConfig {
        CTChartGridConfig(
            showVerticalLines: true,
            showHorizontalLines: true,
            showAxes: true,
            gridColor: nil,
            gridLineWidth: 0.5,
            gridLineDashPattern: [2, 2],
            minorGridColor: nil,
            minorGridLineWidth: 0.3,
            minorGridLineDashPattern: [1, 2],
            minorTickPositions: [],
            axisColor: nil,
            axisLineWidth: 1,
            backgroundColor: nil
        )
    }
    
    /// Minimal grid configuration with fewer lines
    public static var minimal: CTChartGridConfig {
        var config = CTChartGridConfig.default
        config.gridLineDashPattern = [1, 3]
        config.gridLineWidth = 0.3
        return config
    }
    
    /// Detailed grid configuration with more lines
    public static var detailed: CTChartGridConfig {
        var config = CTChartGridConfig.default
        config.gridLineWidth = 0.7
        config.gridLineDashPattern = [3, 3]
        return config
    }
    
    /// Initialize grid configuration with custom parameters
    /// - Parameters:
    ///   - showVerticalLines: Whether to show vertical grid lines
    ///   - showHorizontalLines: Whether to show horizontal grid lines
    ///   - showAxes: Whether to show the axes
    ///   - gridColor: The color of the grid lines
    ///   - gridLineWidth: The width of the grid lines
    ///   - gridLineDashPattern: The dash pattern for the grid lines
    ///   - minorGridColor: The color of the minor grid lines
    ///   - minorGridLineWidth: The width of the minor grid lines
    ///   - minorGridLineDashPattern: The dash pattern for the minor grid lines
    ///   - minorTickPositions: The positions of minor ticks
    ///   - axisColor: The color of the axes
    ///   - axisLineWidth: The width of the axis lines
    ///   - backgroundColor: The background color of the grid
    public init(
        showVerticalLines: Bool = true,
        showHorizontalLines: Bool = true,
        showAxes: Bool = true,
        gridColor: Color? = nil,
        gridLineWidth: CGFloat = 0.5,
        gridLineDashPattern: [CGFloat] = [2, 2],
        minorGridColor: Color? = nil,
        minorGridLineWidth: CGFloat = 0.3,
        minorGridLineDashPattern: [CGFloat] = [1, 2],
        minorTickPositions: [Double] = [],
        axisColor: Color? = nil,
        axisLineWidth: CGFloat = 1,
        backgroundColor: Color? = nil
    ) {
        self.showVerticalLines = showVerticalLines
        self.showHorizontalLines = showHorizontalLines
        self.showAxes = showAxes
        self.gridColor = gridColor
        self.gridLineWidth = gridLineWidth
        self.gridLineDashPattern = gridLineDashPattern
        self.minorGridColor = minorGridColor
        self.minorGridLineWidth = minorGridLineWidth
        self.minorGridLineDashPattern = minorGridLineDashPattern
        self.minorTickPositions = minorTickPositions
        self.axisColor = axisColor
        self.axisLineWidth = axisLineWidth
        self.backgroundColor = backgroundColor
    }
}

/// Helper for creating and configuring chart grids
public struct CTChartGridBuilder {
    /// The x-axis ticks
    private let xTicks: [Double]
    
    /// The y-axis ticks
    private let yTicks: [Double]
    
    /// The range of the grid in the x direction
    private let xRange: ClosedRange<Double>
    
    /// The range of the grid in the y direction
    private let yRange: ClosedRange<Double>
    
    /// The grid configuration
    private var config: CTChartGridConfig
    
    /// Initialize a grid builder
    /// - Parameters:
    ///   - xTicks: The x-axis ticks
    ///   - yTicks: The y-axis ticks
    ///   - xRange: The range of the grid in the x direction
    ///   - yRange: The range of the grid in the y direction
    ///   - config: The grid configuration
    public init(
        xTicks: [Double],
        yTicks: [Double],
        xRange: ClosedRange<Double>,
        yRange: ClosedRange<Double>,
        config: CTChartGridConfig = .default
    ) {
        self.xTicks = xTicks
        self.yTicks = yTicks
        self.xRange = xRange
        self.yRange = yRange
        self.config = config
    }
    
    /// Build a grid with the current configuration
    /// - Parameters:
    ///   - xAxisVisible: Whether the x-axis is visible
    ///   - yAxisVisible: Whether the y-axis is visible
    /// - Returns: A chart grid view
    public func build(
        xAxisVisible: Bool = true,
        yAxisVisible: Bool = true
    ) -> CTChartGrid {
        return CTChartGrid(
            xTicks: xTicks,
            yTicks: yTicks,
            config: config,
            xAxisVisible: xAxisVisible,
            yAxisVisible: yAxisVisible,
            xRange: xRange,
            yRange: yRange
        )
    }
    
    /// Build a grid with custom grid line visibility
    /// - Parameters:
    ///   - showVerticalLines: Whether to show vertical grid lines
    ///   - showHorizontalLines: Whether to show horizontal grid lines
    ///   - showAxes: Whether to show the axes
    /// - Returns: A chart grid view
    public func buildWithVisibility(
        showVerticalLines: Bool,
        showHorizontalLines: Bool,
        showAxes: Bool = true
    ) -> CTChartGrid {
        var newConfig = config
        newConfig.showVerticalLines = showVerticalLines
        newConfig.showHorizontalLines = showHorizontalLines
        newConfig.showAxes = showAxes
        
        return CTChartGrid(
            xTicks: xTicks,
            yTicks: yTicks,
            config: newConfig,
            xAxisVisible: showAxes,
            yAxisVisible: showAxes,
            xRange: xRange,
            yRange: yRange
        )
    }
    
    /// Update the configuration
    /// - Parameter config: The new configuration
    /// - Returns: An updated builder
    public func withConfig(_ config: CTChartGridConfig) -> CTChartGridBuilder {
        var builder = self
        builder.config = config
        return builder
    }
    
    /// Update the grid colors
    /// - Parameters:
    ///   - gridColor: The color of the grid lines
    ///   - minorGridColor: The color of the minor grid lines
    ///   - axisColor: The color of the axes
    /// - Returns: An updated builder
    public func withColors(
        gridColor: Color? = nil,
        minorGridColor: Color? = nil,
        axisColor: Color? = nil
    ) -> CTChartGridBuilder {
        var builder = self
        if let gridColor = gridColor {
            builder.config.gridColor = gridColor
        }
        if let minorGridColor = minorGridColor {
            builder.config.minorGridColor = minorGridColor
        }
        if let axisColor = axisColor {
            builder.config.axisColor = axisColor
        }
        return builder
    }
    
    /// Update the grid line widths
    /// - Parameters:
    ///   - gridLineWidth: The width of the grid lines
    ///   - minorGridLineWidth: The width of the minor grid lines
    ///   - axisLineWidth: The width of the axis lines
    /// - Returns: An updated builder
    public func withLineWidths(
        gridLineWidth: CGFloat? = nil,
        minorGridLineWidth: CGFloat? = nil,
        axisLineWidth: CGFloat? = nil
    ) -> CTChartGridBuilder {
        var builder = self
        if let gridLineWidth = gridLineWidth {
            builder.config.gridLineWidth = gridLineWidth
        }
        if let minorGridLineWidth = minorGridLineWidth {
            builder.config.minorGridLineWidth = minorGridLineWidth
        }
        if let axisLineWidth = axisLineWidth {
            builder.config.axisLineWidth = axisLineWidth
        }
        return builder
    }
    
    /// Generate minor ticks between major ticks
    /// - Parameter count: The number of minor ticks between major ticks
    /// - Returns: An updated builder with minor tick positions
    public func withMinorTicks(count: Int) -> CTChartGridBuilder {
        var builder = self
        
        // Generate minor ticks for x-axis
        var minorTickPositions: [Double] = []
        
        for i in 0..<(xTicks.count - 1) {
            let start = xTicks[i]
            let end = xTicks[i + 1]
            let step = (end - start) / Double(count + 1)
            
            for j in 1...count {
                minorTickPositions.append(start + step * Double(j))
            }
        }
        
        // Generate minor ticks for y-axis
        for i in 0..<(yTicks.count - 1) {
            let start = yTicks[i]
            let end = yTicks[i + 1]
            let step = (end - start) / Double(count + 1)
            
            for j in 1...count {
                minorTickPositions.append(start + step * Double(j))
            }
        }
        
        builder.config.minorTickPositions = minorTickPositions
        return builder
    }
}

// MARK: - Preview

struct CTChartGrid_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            CTChartGrid(
                xTicks: [0, 25, 50, 75, 100],
                yTicks: [0, 20, 40, 60, 80, 100],
                config: .default,
                xRange: 0...100,
                yRange: 0...100
            )
            .frame(width: 300, height: 200)
            .border(Color.gray, width: 1)
            .padding()
            .previewDisplayName("Default Grid")
            
            // Add a sample data point to demonstrate how it would look on the grid
            Circle()
                .fill(Color.blue)
                .frame(width: 8, height: 8)
                .position(x: 75, y: 60)
        }
    }
}

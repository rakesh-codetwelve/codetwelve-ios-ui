//
//  CTChartAxis.swift
//  CodetwelveUI
//
//  Created on 29/03/25.
//

import SwiftUI

/// An axis component for charts.
///
/// `CTChartAxis` renders an axis with tick marks and labels for charts.
/// It can be configured for different orientations, styles, and tick configurations.
///
/// # Example
///
/// ```swift
/// CTChartAxis(
///     orientation: .horizontal,
///     position: .bottom,
///     ticks: [0, 10, 20, 30, 40, 50],
///     labels: ["0", "10", "20", "30", "40", "50"],
///     title: "Value"
/// )
/// ```
public struct CTChartAxis: View {
    // MARK: - Properties
    
    /// The orientation of the axis
    private let orientation: CTChartAxisOrientation
    
    /// The position of the axis
    private let position: CTChartAxisPosition
    
    /// The tick values for the axis
    private let ticks: [Double]
    
    /// The labels for the ticks
    private let labels: [String]
    
    /// The title for the axis
    private let title: String?
    
    /// The configuration for the axis
    private let config: CTChartAxisConfig
    
    /// The range of the axis in the view
    private let axisRange: ClosedRange<CGFloat>
    
    /// The data range that maps to the axis
    private let dataRange: ClosedRange<Double>
    
    /// The current theme from environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializer
    
    /// Initialize a chart axis
    /// - Parameters:
    ///   - orientation: The orientation of the axis
    ///   - position: The position of the axis
    ///   - ticks: The tick values for the axis
    ///   - labels: The labels for the ticks
    ///   - title: The title for the axis
    ///   - config: The configuration for the axis
    ///   - axisRange: The range of the axis in the view
    ///   - dataRange: The data range that maps to the axis
    public init(
        orientation: CTChartAxisOrientation,
        position: CTChartAxisPosition,
        ticks: [Double],
        labels: [String],
        title: String? = nil,
        config: CTChartAxisConfig = .default,
        axisRange: ClosedRange<CGFloat> = 0...100,
        dataRange: ClosedRange<Double>
    ) {
        self.orientation = orientation
        self.position = position
        self.ticks = ticks
        self.labels = labels
        self.title = title
        self.config = config
        self.axisRange = axisRange
        self.dataRange = dataRange
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            // Axis line
            axisLine
            
            // Tick marks and labels
            ForEach(0..<min(ticks.count, labels.count), id: \.self) { i in
                tickMark(at: ticks[i], label: labels[i])
            }
            
            // Axis title
            if let title = title, config.showTitle {
                axisTitle(title)
            }
        }
        .ctAccessibilityGroup(label: "\(orientation.rawValue) axis, \(title ?? "")")
    }
    
    // MARK: - Private Views
    
    /// The main axis line
    private var axisLine: some View {
        Group {
            if orientation == .horizontal {
                Path { path in
                    path.move(to: CGPoint(x: axisRange.lowerBound, y: 0))
                    path.addLine(to: CGPoint(x: axisRange.upperBound, y: 0))
                }
                .stroke(config.axisColor ?? theme.text, lineWidth: config.axisLineWidth)
            } else {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: axisRange.lowerBound))
                    path.addLine(to: CGPoint(x: 0, y: axisRange.upperBound))
                }
                .stroke(config.axisColor ?? theme.text, lineWidth: config.axisLineWidth)
            }
        }
    }
    
    /// Create a tick mark and label at a specific value
    /// - Parameters:
    ///   - value: The value for the tick
    ///   - label: The label for the tick
    /// - Returns: A view containing the tick mark and label
    private func tickMark(at value: Double, label: String) -> some View {
        let tickPosition = calculateTickPosition(for: value)
        
        return Group {
            if orientation == .horizontal {
                VStack(spacing: config.tickLabelSpacing) {
                    // Tick mark
                    Rectangle()
                        .fill(config.tickColor ?? theme.text.opacity(0.7))
                        .frame(width: config.tickLineWidth, height: config.tickLength)
                    
                    // Label
                    if config.showLabels {
                        Text(label)
                            .font(config.labelFont ?? CTTypography.captionSmall())
                            .foregroundColor(config.labelColor ?? theme.textSecondary)
                            .fixedSize()
                            .ctAccessibilityHidden(when: !config.showLabels)
                    }
                }
                .position(x: tickPosition, y: config.tickLabelSpacing + config.tickLength / 2)
            } else {
                HStack(spacing: config.tickLabelSpacing) {
                    // Label (if leading position)
                    if config.showLabels && (position == .leading) {
                        Text(label)
                            .font(config.labelFont ?? CTTypography.captionSmall())
                            .foregroundColor(config.labelColor ?? theme.textSecondary)
                            .multilineTextAlignment(.trailing)
                            .fixedSize()
                            .ctAccessibilityHidden(when: !config.showLabels)
                    }
                    
                    // Tick mark
                    Rectangle()
                        .fill(config.tickColor ?? theme.text.opacity(0.7))
                        .frame(width: config.tickLength, height: config.tickLineWidth)
                    
                    // Label (if trailing position)
                    if config.showLabels && (position == .trailing) {
                        Text(label)
                            .font(config.labelFont ?? CTTypography.captionSmall())
                            .foregroundColor(config.labelColor ?? theme.textSecondary)
                            .multilineTextAlignment(.leading)
                            .fixedSize()
                            .ctAccessibilityHidden(when: !config.showLabels)
                    }
                }
                .position(x: config.tickLabelSpacing + config.tickLength / 2, y: tickPosition)
            }
        }
    }
    
    /// Create the axis title view
    /// - Parameter title: The title text
    /// - Returns: A view containing the axis title
    private func axisTitle(_ title: String) -> some View {
        Text(title)
            .font(config.titleFont ?? CTTypography.caption())
            .foregroundColor(config.titleColor ?? theme.text)
            .padding(.all, CTSpacing.s)
            .position(titlePosition)
            .rotationEffect(titleRotation)
            .ctAccessibilityHidden(when: !config.showTitle)
    }
    
    // MARK: - Private Helper Methods
    
    /// Calculate the position of a tick mark for a specific value
    /// - Parameter value: The tick value
    /// - Returns: The position in the view
    private func calculateTickPosition(for value: Double) -> CGFloat {
        let normalizedPosition = CTChartUtilities.scale(
            value: value,
            sourceDomain: dataRange,
            targetRange: axisRange
        )
        
        return normalizedPosition
    }
    
    /// The position for the axis title
    private var titlePosition: CGPoint {
        if orientation == .horizontal {
            return CGPoint(
                x: (axisRange.upperBound + axisRange.lowerBound) / 2,
                y: config.tickLength + config.tickLabelSpacing * 2 + 20
            )
        } else {
            return CGPoint(
                x: position == .leading ? -50 : 50,
                y: (axisRange.upperBound + axisRange.lowerBound) / 2
            )
        }
    }
    
    /// The rotation for the axis title
    private var titleRotation: Angle {
        if orientation == .horizontal {
            return .degrees(0)
        } else {
            return .degrees(-90)
        }
    }
}

/// The orientation of an axis
public enum CTChartAxisOrientation: String {
    /// Horizontal axis (X-axis)
    case horizontal = "Horizontal"
    
    /// Vertical axis (Y-axis)
    case vertical = "Vertical"
}

/// The position of an axis
public enum CTChartAxisPosition {
    /// Bottom position for horizontal axes
    case bottom
    
    /// Top position for horizontal axes
    case top
    
    /// Leading (left) position for vertical axes
    case leading
    
    /// Trailing (right) position for vertical axes
    case trailing
}

/// Configuration for chart axes
public struct CTChartAxisConfig {
    /// Whether to show labels on the axis
    public var showLabels: Bool
    
    /// Whether to show the axis title
    public var showTitle: Bool
    
    /// Whether to show grid lines from the ticks
    public var showGridLines: Bool
    
    /// The color of the axis line
    public var axisColor: Color?
    
    /// The width of the axis line
    public var axisLineWidth: CGFloat
    
    /// The color of the tick marks
    public var tickColor: Color?
    
    /// The width of the tick lines
    public var tickLineWidth: CGFloat
    
    /// The length of the tick lines
    public var tickLength: CGFloat
    
    /// The font for the tick labels
    public var labelFont: Font?
    
    /// The color for the tick labels
    public var labelColor: Color?
    
    /// The spacing between the tick mark and its label
    public var tickLabelSpacing: CGFloat
    
    /// The font for the axis title
    public var titleFont: Font?
    
    /// The color for the axis title
    public var titleColor: Color?
    
    /// The color for the grid lines
    public var gridColor: Color?
    
    /// The width of the grid lines
    public var gridLineWidth: CGFloat
    
    /// The dash pattern for the grid lines
    public var gridLineDashPattern: [CGFloat]
    
    /// The padding between the axis and the chart content
    public var padding: EdgeInsets
    
    /// Default axis configuration
    public static var `default`: CTChartAxisConfig {
        CTChartAxisConfig(
            showLabels: true,
            showTitle: true,
            showGridLines: true,
            axisColor: nil,
            axisLineWidth: 1,
            tickColor: nil,
            tickLineWidth: 1,
            tickLength: 5,
            labelFont: nil,
            labelColor: nil,
            tickLabelSpacing: 4,
            titleFont: nil,
            titleColor: nil,
            gridColor: nil,
            gridLineWidth: 0.5,
            gridLineDashPattern: [2, 2],
            padding: EdgeInsets(top: 20, leading: 40, bottom: 30, trailing: 20)
        )
    }
    
    /// Minimal axis configuration with fewer visual elements
    public static var minimal: CTChartAxisConfig {
        var config = CTChartAxisConfig.default
        config.showTitle = false
        config.showGridLines = false
        config.tickLength = 3
        config.axisLineWidth = 0.5
        config.tickLineWidth = 0.5
        config.padding = EdgeInsets(top: 10, leading: 30, bottom: 20, trailing: 10)
        return config
    }
    
    /// Detailed axis configuration with more visual elements
    public static var detailed: CTChartAxisConfig {
        var config = CTChartAxisConfig.default
        config.tickLength = 6
        config.axisLineWidth = 1.5
        config.tickLineWidth = 1.5
        config.gridLineWidth = 0.7
        config.padding = EdgeInsets(top: 30, leading: 50, bottom: 40, trailing: 30)
        return config
    }
    
    /// Initialize axis configuration with custom parameters
    /// - Parameters:
    ///   - showLabels: Whether to show labels on the axis
    ///   - showTitle: Whether to show the axis title
    ///   - showGridLines: Whether to show grid lines from the ticks
    ///   - axisColor: The color of the axis line
    ///   - axisLineWidth: The width of the axis line
    ///   - tickColor: The color of the tick marks
    ///   - tickLineWidth: The width of the tick lines
    ///   - tickLength: The length of the tick lines
    ///   - labelFont: The font for the tick labels
    ///   - labelColor: The color for the tick labels
    ///   - tickLabelSpacing: The spacing between the tick mark and its label
    ///   - titleFont: The font for the axis title
    ///   - titleColor: The color for the axis title
    ///   - gridColor: The color for the grid lines
    ///   - gridLineWidth: The width of the grid lines
    ///   - gridLineDashPattern: The dash pattern for the grid lines
    ///   - padding: The padding between the axis and the chart content
    public init(
        showLabels: Bool = true,
        showTitle: Bool = true,
        showGridLines: Bool = true,
        axisColor: Color? = nil,
        axisLineWidth: CGFloat = 1,
        tickColor: Color? = nil,
        tickLineWidth: CGFloat = 1,
        tickLength: CGFloat = 5,
        labelFont: Font? = nil,
        labelColor: Color? = nil,
        tickLabelSpacing: CGFloat = 4,
        titleFont: Font? = nil,
        titleColor: Color? = nil,
        gridColor: Color? = nil,
        gridLineWidth: CGFloat = 0.5,
        gridLineDashPattern: [CGFloat] = [2, 2],
        padding: EdgeInsets = EdgeInsets(top: 20, leading: 40, bottom: 30, trailing: 20)
    ) {
        self.showLabels = showLabels
        self.showTitle = showTitle
        self.showGridLines = showGridLines
        self.axisColor = axisColor
        self.axisLineWidth = axisLineWidth
        self.tickColor = tickColor
        self.tickLineWidth = tickLineWidth
        self.tickLength = tickLength
        self.labelFont = labelFont
        self.labelColor = labelColor
        self.tickLabelSpacing = tickLabelSpacing
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.gridColor = gridColor
        self.gridLineWidth = gridLineWidth
        self.gridLineDashPattern = gridLineDashPattern
        self.padding = padding
    }
}

/// Helper for creating and configuring chart axes
public struct CTChartAxisBuilder {
    /// The orientation of the axis
    private let orientation: CTChartAxisOrientation
    
    /// The data range for the axis
    private let dataRange: ClosedRange<Double>
    
    /// The axis configuration
    private var config: CTChartAxisConfig
    
    /// Initialize an axis builder
    /// - Parameters:
    ///   - orientation: The orientation of the axis
    ///   - dataRange: The data range for the axis
    ///   - config: The axis configuration
    public init(
        orientation: CTChartAxisOrientation,
        dataRange: ClosedRange<Double>,
        config: CTChartAxisConfig = .default
    ) {
        self.orientation = orientation
        self.dataRange = dataRange
        self.config = config
    }
    
    /// Build an axis with evenly spaced ticks
    /// - Parameters:
    ///   - tickCount: The number of ticks to show
    ///   - formatter: A formatter for the tick labels
    ///   - title: The axis title
    ///   - axisRange: The range of the axis in the view
    /// - Returns: A chart axis view
    public func buildWithEvenTicks(
        tickCount: Int = 5,
        formatter: ((Double) -> String)? = nil,
        title: String? = nil,
        axisRange: ClosedRange<CGFloat> = 0...100
    ) -> CTChartAxis {
        let ticks = CTChartUtilities.generateTicks(domain: dataRange, count: tickCount)
        let labels = ticks.map { formatter?($0) ?? CTChartUtilities.formatNumber($0) }
        
        return CTChartAxis(
            orientation: orientation,
            position: orientation == .horizontal ? .bottom : .leading,
            ticks: ticks,
            labels: labels,
            title: title,
            config: config,
            axisRange: axisRange,
            dataRange: dataRange
        )
    }
    
    /// Build an axis with custom ticks
    /// - Parameters:
    ///   - ticks: The custom tick values
    ///   - labels: The custom labels for the ticks
    ///   - title: The axis title
    ///   - axisRange: The range of the axis in the view
    /// - Returns: A chart axis view
    public func buildWithCustomTicks(
        ticks: [Double],
        labels: [String],
        title: String? = nil,
        axisRange: ClosedRange<CGFloat> = 0...100
    ) -> CTChartAxis {
        return CTChartAxis(
            orientation: orientation,
            position: orientation == .horizontal ? .bottom : .leading,
            ticks: ticks,
            labels: labels,
            title: title,
            config: config,
            axisRange: axisRange,
            dataRange: dataRange
        )
    }
    
    /// Update the configuration
    /// - Parameter config: The new configuration
    /// - Returns: An updated builder
    public func withConfig(_ config: CTChartAxisConfig) -> CTChartAxisBuilder {
        var builder = self
        builder.config = config
        return builder
    }
    
    /// Update whether to show labels
    /// - Parameter show: Whether to show labels
    /// - Returns: An updated builder
    public func showLabels(_ show: Bool) -> CTChartAxisBuilder {
        var builder = self
        builder.config.showLabels = show
        return builder
    }
    
    /// Update whether to show the title
    /// - Parameter show: Whether to show the title
    /// - Returns: An updated builder
    public func showTitle(_ show: Bool) -> CTChartAxisBuilder {
        var builder = self
        builder.config.showTitle = show
        return builder
    }
    
    /// Update whether to show grid lines
    /// - Parameter show: Whether to show grid lines
    /// - Returns: An updated builder
    public func showGridLines(_ show: Bool) -> CTChartAxisBuilder {
        var builder = self
        builder.config.showGridLines = show
        return builder
    }
}

// MARK: - Preview

struct CTChartAxis_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            // Horizontal axis
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 100)
                
                CTChartAxis(
                    orientation: .horizontal,
                    position: .bottom,
                    ticks: [0, 10, 20, 30, 40, 50],
                    labels: ["0", "10", "20", "30", "40", "50"],
                    title: "X-Axis",
                    axisRange: 0...300,
                    dataRange: 0...50
                )
            }
            .frame(height: 100)
            .padding(.horizontal, 40)
            .previewDisplayName("Horizontal Axis")
            
            // Vertical axis
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 100, height: 200)
                
                CTChartAxis(
                    orientation: .vertical,
                    position: .leading,
                    ticks: [0, 25, 50, 75, 100],
                    labels: ["0", "25", "50", "75", "100"],
                    title: "Y-Axis",
                    axisRange: 0...200,
                    dataRange: 0...100
                )
            }
            .frame(width: 100, height: 200)
            .padding(.leading, 40)
            .previewDisplayName("Vertical Axis")
        }
        .padding()
    }
}

//
//  CTChartConfig.swift
//  CodetwelveUI
//
//  Created on 29/03/25.
//

import SwiftUI

/// Configuration options for charts in the CodeTwelve UI system.
///
/// `CTChartConfig` provides a consistent way to configure appearance and behavior
/// of charts across the CodeTwelve UI system.
///
/// # Example
///
/// ```swift
/// let chartConfig = CTChartConfig.default
///     .withTitle("Sales Overview")
///     .withAnimated(true)
///     .withShowLegend(true)
/// ```
public struct CTChartConfig {
    // MARK: - Common Configuration
    
    /// The title displayed above the chart
    public var title: String?
    
    /// The subtitle displayed below the title
    public var subtitle: String?
    
    /// Whether the chart should be animated
    public var animated: Bool
    
    /// The duration of the animation in seconds
    public var animationDuration: Double
    
    /// Whether the chart is interactive (responds to gestures)
    public var interactive: Bool
    
    /// The padding around the chart content
    public var contentPadding: EdgeInsets
    
    /// The background color for the chart
    public var backgroundColor: Color?
    
    /// Whether to show a legend with the chart
    public var showLegend: Bool
    
    /// The position of the legend
    public var legendPosition: CTChartLegendPosition
    
    /// Whether to show the chart axes
    public var showAxes: Bool
    
    /// Whether to show a grid behind the chart
    public var showGrid: Bool
    
    /// Whether to show tooltips on hover/tap
    public var showTooltips: Bool
    
    /// Whether to show data point labels
    public var showDataLabels: Bool
    
    /// Accessibility label for the chart
    public var accessibilityLabel: String?
    
    /// Accessibility hint for the chart
    public var accessibilityHint: String?
    
    // MARK: - Axis Configuration
    
    /// Configuration for the X axis
    public var xAxisConfig: CTChartAxisConfig
    
    /// Configuration for the Y axis
    public var yAxisConfig: CTChartAxisConfig
    
    // MARK: - Style Configuration
    
    /// Configuration for the chart style
    public var style: CTChartStyle
    
    // MARK: - Display Options
    
    /// The target width of the chart (optional)
    public var width: CGFloat?
    
    /// The target height of the chart
    public var height: CGFloat
    
    // MARK: - Static Configurations
    
    /// Default chart configuration
    public static var `default`: CTChartConfig {
        CTChartConfig(
            title: nil,
            subtitle: nil,
            animated: true,
            animationDuration: 0.8,
            interactive: true,
            contentPadding: EdgeInsets(top: CTSpacing.m, leading: CTSpacing.m, bottom: CTSpacing.m, trailing: CTSpacing.m),
            backgroundColor: nil,
            showLegend: false,
            legendPosition: .topTrailing,
            showAxes: true,
            showGrid: true,
            showTooltips: true,
            showDataLabels: false,
            accessibilityLabel: nil,
            accessibilityHint: nil,
            xAxisConfig: .default,
            yAxisConfig: .default,
            style: .default,
            width: nil,
            height: 300
        )
    }
    
    /// Minimal chart configuration with less visual elements
    public static var minimal: CTChartConfig {
        CTChartConfig.default
            .withShowGrid(false)
            .withContentPadding(EdgeInsets(top: CTSpacing.s, leading: CTSpacing.s, bottom: CTSpacing.s, trailing: CTSpacing.s))
            .withStyle(CTChartStyle.minimal)
    }
    
    /// Compact chart configuration for small spaces
    public static var compact: CTChartConfig {
        CTChartConfig.default
            .withShowGrid(false)
            .withShowAxes(false)
            .withShowLegend(false)
            .withContentPadding(EdgeInsets(top: CTSpacing.xs, leading: CTSpacing.xs, bottom: CTSpacing.xs, trailing: CTSpacing.xs))
            .withHeight(200)
    }
    
    /// Detailed chart configuration with all elements enabled
    public static var detailed: CTChartConfig {
        CTChartConfig.default
            .withShowLegend(true)
            .withShowDataLabels(true)
            .withShowTooltips(true)
            .withStyle(CTChartStyle.detailed)
    }
    
    // MARK: - Initializer
    
    /// Initialize a chart configuration with custom parameters
    ///
    /// - Parameters:
    ///   - title: The title displayed above the chart
    ///   - subtitle: The subtitle displayed below the title
    ///   - animated: Whether the chart should be animated
    ///   - animationDuration: The duration of the animation in seconds
    ///   - interactive: Whether the chart is interactive
    ///   - contentPadding: The padding around the chart content
    ///   - backgroundColor: The background color for the chart
    ///   - showLegend: Whether to show a legend with the chart
    ///   - legendPosition: The position of the legend
    ///   - showAxes: Whether to show the chart axes
    ///   - showGrid: Whether to show a grid behind the chart
    ///   - showTooltips: Whether to show tooltips on hover/tap
    ///   - showDataLabels: Whether to show data point labels
    ///   - accessibilityLabel: Accessibility label for the chart
    ///   - accessibilityHint: Accessibility hint for the chart
    ///   - xAxisConfig: Configuration for the X axis
    ///   - yAxisConfig: Configuration for the Y axis
    ///   - style: Configuration for the chart style
    ///   - width: The target width of the chart (optional)
    ///   - height: The target height of the chart
    public init(
        title: String? = nil,
        subtitle: String? = nil,
        animated: Bool = true,
        animationDuration: Double = 0.8,
        interactive: Bool = true,
        contentPadding: EdgeInsets = EdgeInsets(top: CTSpacing.m, leading: CTSpacing.m, bottom: CTSpacing.m, trailing: CTSpacing.m),
        backgroundColor: Color? = nil,
        showLegend: Bool = false,
        legendPosition: CTChartLegendPosition = .topTrailing,
        showAxes: Bool = true,
        showGrid: Bool = true,
        showTooltips: Bool = true,
        showDataLabels: Bool = false,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        xAxisConfig: CTChartAxisConfig = .default,
        yAxisConfig: CTChartAxisConfig = .default,
        style: CTChartStyle = .default,
        width: CGFloat? = nil,
        height: CGFloat = 300
    ) {
        self.title = title
        self.subtitle = subtitle
        self.animated = animated
        self.animationDuration = animationDuration
        self.interactive = interactive
        self.contentPadding = contentPadding
        self.backgroundColor = backgroundColor
        self.showLegend = showLegend
        self.legendPosition = legendPosition
        self.showAxes = showAxes
        self.showGrid = showGrid
        self.showTooltips = showTooltips
        self.showDataLabels = showDataLabels
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.xAxisConfig = xAxisConfig
        self.yAxisConfig = yAxisConfig
        self.style = style
        self.width = width
        self.height = height
    }
    
    // MARK: - Builder Methods
    
    /// Set the chart title
    /// - Parameter title: The title to set
    /// - Returns: Updated configuration
    public func withTitle(_ title: String?) -> CTChartConfig {
        var config = self
        config.title = title
        return config
    }
    
    /// Set the chart subtitle
    /// - Parameter subtitle: The subtitle to set
    /// - Returns: Updated configuration
    public func withSubtitle(_ subtitle: String?) -> CTChartConfig {
        var config = self
        config.subtitle = subtitle
        return config
    }
    
    /// Set whether the chart should be animated
    /// - Parameter animated: Whether to animate
    /// - Returns: Updated configuration
    public func withAnimated(_ animated: Bool) -> CTChartConfig {
        var config = self
        config.animated = animated
        return config
    }
    
    /// Set the animation duration
    /// - Parameter duration: The duration in seconds
    /// - Returns: Updated configuration
    public func withAnimationDuration(_ duration: Double) -> CTChartConfig {
        var config = self
        config.animationDuration = duration
        return config
    }
    
    /// Set whether the chart is interactive
    /// - Parameter interactive: Whether the chart is interactive
    /// - Returns: Updated configuration
    public func withInteractive(_ interactive: Bool) -> CTChartConfig {
        var config = self
        config.interactive = interactive
        return config
    }
    
    /// Set the content padding
    /// - Parameter padding: The padding to set
    /// - Returns: Updated configuration
    public func withContentPadding(_ padding: EdgeInsets) -> CTChartConfig {
        var config = self
        config.contentPadding = padding
        return config
    }
    
    /// Set the background color
    /// - Parameter color: The color to set
    /// - Returns: Updated configuration
    public func withBackgroundColor(_ color: Color?) -> CTChartConfig {
        var config = self
        config.backgroundColor = color
        return config
    }
    
    /// Set whether to show the legend
    /// - Parameter show: Whether to show the legend
    /// - Returns: Updated configuration
    public func withShowLegend(_ show: Bool) -> CTChartConfig {
        var config = self
        config.showLegend = show
        return config
    }
    
    /// Set the legend position
    /// - Parameter position: The position to set
    /// - Returns: Updated configuration
    public func withLegendPosition(_ position: CTChartLegendPosition) -> CTChartConfig {
        var config = self
        config.legendPosition = position
        return config
    }
    
    /// Set whether to show the axes
    /// - Parameter show: Whether to show the axes
    /// - Returns: Updated configuration
    public func withShowAxes(_ show: Bool) -> CTChartConfig {
        var config = self
        config.showAxes = show
        return config
    }
    
    /// Set whether to show the grid
    /// - Parameter show: Whether to show the grid
    /// - Returns: Updated configuration
    public func withShowGrid(_ show: Bool) -> CTChartConfig {
        var config = self
        config.showGrid = show
        return config
    }
    
    /// Set whether to show tooltips
    /// - Parameter show: Whether to show tooltips
    /// - Returns: Updated configuration
    public func withShowTooltips(_ show: Bool) -> CTChartConfig {
        var config = self
        config.showTooltips = show
        return config
    }
    
    /// Set whether to show data labels
    /// - Parameter show: Whether to show data labels
    /// - Returns: Updated configuration
    public func withShowDataLabels(_ show: Bool) -> CTChartConfig {
        var config = self
        config.showDataLabels = show
        return config
    }
    
    /// Set the accessibility label
    /// - Parameter label: The label to set
    /// - Returns: Updated configuration
    public func withAccessibilityLabel(_ label: String?) -> CTChartConfig {
        var config = self
        config.accessibilityLabel = label
        return config
    }
    
    /// Set the accessibility hint
    /// - Parameter hint: The hint to set
    /// - Returns: Updated configuration
    public func withAccessibilityHint(_ hint: String?) -> CTChartConfig {
        var config = self
        config.accessibilityHint = hint
        return config
    }
    
    /// Set the X axis configuration
    /// - Parameter config: The configuration to set
    /// - Returns: Updated configuration
    public func withXAxisConfig(_ config: CTChartAxisConfig) -> CTChartConfig {
        var newConfig = self
        newConfig.xAxisConfig = config
        return newConfig
    }
    
    /// Set the Y axis configuration
    /// - Parameter config: The configuration to set
    /// - Returns: Updated configuration
    public func withYAxisConfig(_ config: CTChartAxisConfig) -> CTChartConfig {
        var newConfig = self
        newConfig.yAxisConfig = config
        return newConfig
    }
    
    /// Set the chart style
    /// - Parameter style: The style to set
    /// - Returns: Updated configuration
    public func withStyle(_ style: CTChartStyle) -> CTChartConfig {
        var config = self
        config.style = style
        return config
    }
    
    /// Set the chart width
    /// - Parameter width: The width to set
    /// - Returns: Updated configuration
    public func withWidth(_ width: CGFloat?) -> CTChartConfig {
        var config = self
        config.width = width
        return config
    }
    
    /// Set the chart height
    /// - Parameter height: The height to set
    /// - Returns: Updated configuration
    public func withHeight(_ height: CGFloat) -> CTChartConfig {
        var config = self
        config.height = height
        return config
    }
}

/// The position of the legend in a chart
public enum CTChartLegendPosition {
    /// Top left corner
    case topLeading
    
    /// Top right corner
    case topTrailing
    
    /// Bottom left corner
    case bottomLeading
    
    /// Bottom right corner
    case bottomTrailing
    
    /// Below the chart
    case bottom
    
    /// Above the chart
    case top
}

/// Style configuration for charts
public struct CTChartStyle {
    /// The color palette to use for the chart
    public let colors: [Color]
    
    /// The line width for line charts
    public let lineWidth: CGFloat
    
    /// The opacity for fills in area charts
    public let fillOpacity: Double
    
    /// The curve type for line and area charts
    public let curveType: CurveType
    
    /// The bar corner radius for bar charts
    public let barCornerRadius: CGFloat
    
    /// The spacing between bars in bar charts
    public let barSpacing: CGFloat
    
    /// The animation curve for the chart
    public let animationCurve: Animation
    
    /// The background color for grid lines
    public let gridColor: Color?
    
    /// The color for axes lines
    public let axesColor: Color?
    
    /// The color for labels
    public let labelColor: Color?
    
    /// The font for labels
    public let labelFont: Font?
    
    /// The default chart style
    public static var `default`: CTChartStyle {
        CTChartStyle(
            colors: [],  // Will use theme colors
            lineWidth: 2,
            fillOpacity: 0.2,
            curveType: .monotone,
            barCornerRadius: 4,
            barSpacing: 0.2,
            animationCurve: .easeInOut,
            gridColor: nil,
            axesColor: nil,
            labelColor: nil,
            labelFont: nil
        )
    }
    
    /// The minimal chart style with thin lines and subtle colors
    public static var minimal: CTChartStyle {
        CTChartStyle(
            colors: [],  // Will use theme colors
            lineWidth: 1,
            fillOpacity: 0.1,
            curveType: .linear,
            barCornerRadius: 2,
            barSpacing: 0.3,
            animationCurve: .easeInOut,
            gridColor: nil,
            axesColor: nil,
            labelColor: nil,
            labelFont: nil
        )
    }
    
    /// The bold chart style with thick lines and vivid colors
    public static var bold: CTChartStyle {
        CTChartStyle(
            colors: [],  // Will use theme colors
            lineWidth: 3,
            fillOpacity: 0.3,
            curveType: .cardinal,
            barCornerRadius: 6,
            barSpacing: 0.15,
            animationCurve: .spring(response: 0.5, dampingFraction: 0.7),
            gridColor: nil,
            axesColor: nil,
            labelColor: nil,
            labelFont: nil
        )
    }
    
    /// Detailed chart style with emphasis on data visualization
    public static var detailed: CTChartStyle {
        CTChartStyle(
            colors: [],
            lineWidth: 2.5,
            fillOpacity: 0.15,
            curveType: .monotone,
            barCornerRadius: 3,
            barSpacing: 0.18,
            animationCurve: .easeInOut,
            gridColor: nil,
            axesColor: nil,
            labelColor: nil,
            labelFont: CTTypography.captionSmall()
        )
    }
    
    /// Initialize a chart style with custom parameters
    /// - Parameters:
    ///   - colors: The color palette to use for the chart
    ///   - lineWidth: The line width for line charts
    ///   - fillOpacity: The opacity for fills in area charts
    ///   - curveType: The curve type for line and area charts
    ///   - barCornerRadius: The bar corner radius for bar charts
    ///   - barSpacing: The spacing between bars in bar charts
    ///   - animationCurve: The animation curve for the chart
    ///   - gridColor: The background color for grid lines
    ///   - axesColor: The color for axes lines
    ///   - labelColor: The color for labels
    ///   - labelFont: The font for labels
    public init(
        colors: [Color],
        lineWidth: CGFloat = 2,
        fillOpacity: Double = 0.2,
        curveType: CurveType = .monotone,
        barCornerRadius: CGFloat = 4,
        barSpacing: CGFloat = 0.2,
        animationCurve: Animation = .easeInOut,
        gridColor: Color? = nil,
        axesColor: Color? = nil,
        labelColor: Color? = nil,
        labelFont: Font? = nil
    ) {
        self.colors = colors
        self.lineWidth = lineWidth
        self.fillOpacity = fillOpacity
        self.curveType = curveType
        self.barCornerRadius = barCornerRadius
        self.barSpacing = barSpacing
        self.animationCurve = animationCurve
        self.gridColor = gridColor
        self.axesColor = axesColor
        self.labelColor = labelColor
        self.labelFont = labelFont
    }
    
    /// Returns the appropriate color for a series or data point at the given index
    /// - Parameters:
    ///   - index: The index of the series or data point
    ///   - theme: The current theme
    /// - Returns: The color for the given index
    public func nextColor(forIndex index: Int, theme: CTTheme) -> Color {
        if !colors.isEmpty && index < colors.count {
            return colors[index]
        }
        
        // If no custom colors are provided, use theme colors
        let themeColors: [Color] = [
            theme.primary,
            theme.secondary,
            theme.success,
            theme.warning,
            theme.info,
            theme.destructive
        ]
        
        // For indices beyond the basic theme colors, create new colors with different saturations
        return themeColors[index % themeColors.count]
    }
    
    /// The curve type for line and area charts
    public enum CurveType {
        /// Linear segments between points
        case linear
        /// Cardinal spline (smooth curve)
        case cardinal
        /// Step line (horizontal and vertical segments)
        case step
        /// Natural cubic spline
        case natural
        /// Monotone cubic spline (prevents overshooting)
        case monotone
    }
}

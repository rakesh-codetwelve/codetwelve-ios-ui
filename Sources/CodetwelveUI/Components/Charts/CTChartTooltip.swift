//
//  CTChartTooltip.swift
//  CodetwelveUI
//
//  Created on 29/03/25.
//

import SwiftUI

/// A tooltip component for charts.
///
/// `CTChartTooltip` displays data information when hovering over or tapping on chart elements.
/// It can be configured for different styles, positions, and content formats.
///
/// # Example
///
/// ```swift
/// CTChartTooltip(
///     content: "Sales: $1,234",
///     position: CGPoint(x: 100, y: 100),
///     isVisible: true
/// )
/// ```
public struct CTChartTooltip<Content: View>: View {
    // MARK: - Properties
    
    /// The content of the tooltip
    private let content: Content
    
    /// The position of the tooltip
    private let position: CGPoint
    
    /// Whether the tooltip is visible
    private let isVisible: Bool
    
    /// The configuration for the tooltip
    private let config: CTChartTooltipConfig
    
    /// Current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a chart tooltip with custom content
    /// - Parameters:
    ///   - content: The content builder for the tooltip
    ///   - position: The position of the tooltip
    ///   - isVisible: Whether the tooltip is visible
    ///   - config: The configuration for the tooltip
    public init(
        @ViewBuilder content: () -> Content,
        position: CGPoint,
        isVisible: Bool = true,
        config: CTChartTooltipConfig = .default
    ) {
        self.content = content()
        self.position = position
        self.isVisible = isVisible
        self.config = config
    }
    
    // MARK: - Body
    
    public var body: some View {
        if isVisible {
            tooltipContent
                .padding(config.contentPadding)
                .background(config.backgroundColor ?? theme.surface)
                .cornerRadius(config.cornerRadius)
                .shadow(
                    color: config.shadowColor ?? theme.shadowColor.opacity(theme.shadowOpacity),
                    radius: config.shadowRadius,
                    x: config.shadowOffset.width,
                    y: config.shadowOffset.height
                )
                .overlay(
                    RoundedRectangle(cornerRadius: config.cornerRadius)
                        .stroke(config.borderColor ?? theme.border, lineWidth: config.borderWidth)
                )
                .position(adjustedPosition)
                .transition(config.transition)
                .animation(config.animation, value: isVisible)
                .zIndex(100) // Ensure tooltip is above chart elements
                .ctAccessibilityElement(
                    label: "Tooltip",
                    hint: "Shows data details"
                )
        }
    }
    
    // MARK: - Private Properties and Methods
    
    /// The content of the tooltip
    private var tooltipContent: some View {
        content
            .frame(maxWidth: config.maxWidth)
    }
    
    /// Adjusted position to ensure the tooltip stays within the chart area
    private var adjustedPosition: CGPoint {
        // This is a simplified version. In a real implementation, you would need to
        // account for the actual size of the tooltip and adjust accordingly.
        return position
    }
}

/// Overload for string content
public extension CTChartTooltip where Content == AnyView {
    /// Initialize a chart tooltip with string content
    /// - Parameters:
    ///   - content: The string content for the tooltip
    ///   - position: The position of the tooltip
    ///   - isVisible: Whether the tooltip is visible
    ///   - config: The configuration for the tooltip
    init(
        content: String,
        position: CGPoint,
        isVisible: Bool = true,
        config: CTChartTooltipConfig = .default
    ) {
        self.init(
            content: {
                AnyView(
                    Text(content)
                        .font(config.font ?? CTTypography.captionSmall())
                        .foregroundColor(config.textColor ?? CTDefaultTheme().text)
                        .multilineTextAlignment(.center)
                )
            },
            position: position,
            isVisible: isVisible,
            config: config
        )
    }
    
    /// Initialize a chart tooltip with data point
    /// - Parameters:
    ///   - dataPoint: The data point for the tooltip
    ///   - position: The position of the tooltip
    ///   - isVisible: Whether the tooltip is visible
    ///   - config: The configuration for the tooltip
    ///   - formatter: Optional formatter for the data point values
    init(
        dataPoint: CTChartDataPoint,
        position: CGPoint,
        isVisible: Bool = true,
        config: CTChartTooltipConfig = .default,
        formatter: ((Double) -> String)? = nil
    ) {
        let formattedX = formatter?(dataPoint.x) ?? CTChartUtilities.formatNumber(dataPoint.x)
        let formattedY = formatter?(dataPoint.y) ?? CTChartUtilities.formatNumber(dataPoint.y)
        let label = dataPoint.label ?? "Point"
        
        self.init(
            content: {
                AnyView(
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        Text(label)
                            .font(config.titleFont ?? CTTypography.caption())
                            .foregroundColor(config.titleColor ?? CTDefaultTheme().text)
                        
                        HStack {
                            Text("X:")
                                .font(config.font ?? CTTypography.captionSmall())
                                .foregroundColor(config.labelColor ?? CTDefaultTheme().textSecondary)
                            Text(formattedX)
                                .font(config.font ?? CTTypography.captionSmall())
                                .foregroundColor(config.textColor ?? CTDefaultTheme().text)
                        }
                        
                        HStack {
                            Text("Y:")
                                .font(config.font ?? CTTypography.captionSmall())
                                .foregroundColor(config.labelColor ?? CTDefaultTheme().textSecondary)
                            Text(formattedY)
                                .font(config.font ?? CTTypography.captionSmall())
                                .foregroundColor(config.textColor ?? CTDefaultTheme().text)
                        }
                        
                        // Include any metadata if available
                        if let metadata = dataPoint.metadata, !metadata.isEmpty {
                            Divider()
                                .padding(.vertical, CTSpacing.xxs)
                            
                            ForEach(Array(metadata.keys).sorted(), id: \.self) { key in
                                if let value = metadata[key] {
                                    HStack {
                                        Text("\(key):")
                                            .font(config.font ?? CTTypography.captionSmall())
                                            .foregroundColor(config.labelColor ?? CTDefaultTheme().textSecondary)
                                        Text("\(String(describing: value))")
                                            .font(config.font ?? CTTypography.captionSmall())
                                            .foregroundColor(config.textColor ?? CTDefaultTheme().text)
                                    }
                                }
                            }
                        }
                    }
                )
            },
            position: position,
            isVisible: isVisible,
            config: config
        )
    }
    
    /// Initialize a chart tooltip with series data
    /// - Parameters:
    ///   - seriesData: Dictionary of series names and values
    ///   - title: Optional title for the tooltip
    ///   - position: The position of the tooltip
    ///   - isVisible: Whether the tooltip is visible
    ///   - config: The configuration for the tooltip
    ///   - formatter: Optional formatter for the data values
    init(
        seriesData: [String: Double],
        title: String? = nil,
        position: CGPoint,
        isVisible: Bool = true,
        config: CTChartTooltipConfig = .default,
        formatter: ((Double) -> String)? = nil
    ) {
        self.init(
            content: {
                AnyView(
                    VStack(alignment: .leading, spacing: CTSpacing.xs) {
                        if let title = title {
                            Text(title)
                                .font(config.titleFont ?? CTTypography.caption())
                                .foregroundColor(config.titleColor ?? CTDefaultTheme().text)
                                .padding(.bottom, CTSpacing.xxs)
                        }
                        
                        ForEach(Array(seriesData.keys).sorted(), id: \.self) { seriesName in
                            if let value = seriesData[seriesName] {
                                HStack {
                                    Text(seriesName)
                                        .font(config.font ?? CTTypography.captionSmall())
                                        .foregroundColor(config.labelColor ?? CTDefaultTheme().textSecondary)
                                    Spacer()
                                    Text(formatter?(value) ?? CTChartUtilities.formatNumber(value))
                                        .font(config.font ?? CTTypography.captionSmall())
                                        .foregroundColor(config.textColor ?? CTDefaultTheme().text)
                                }
                            }
                        }
                    }
                )
            },
            position: position,
            isVisible: isVisible,
            config: config
        )
    }
}

/// Configuration for chart tooltips
public struct CTChartTooltipConfig {
    /// The maximum width of the tooltip
    public var maxWidth: CGFloat
    
    /// The padding around the tooltip content
    public var contentPadding: EdgeInsets
    
    /// The corner radius of the tooltip
    public var cornerRadius: CGFloat
    
    /// The background color of the tooltip
    public var backgroundColor: Color?
    
    /// The text color for the tooltip content
    public var textColor: Color?
    
    /// The label color for tooltip labels
    public var labelColor: Color?
    
    /// The title color for tooltip titles
    public var titleColor: Color?
    
    /// The font for the tooltip content
    public var font: Font?
    
    /// The font for the tooltip title
    public var titleFont: Font?
    
    /// The border color of the tooltip
    public var borderColor: Color?
    
    /// The border width of the tooltip
    public var borderWidth: CGFloat
    
    /// The shadow color of the tooltip
    public var shadowColor: Color?
    
    /// The shadow radius of the tooltip
    public var shadowRadius: CGFloat
    
    /// The shadow offset of the tooltip
    public var shadowOffset: CGSize
    
    /// The transition for showing/hiding the tooltip
    public var transition: AnyTransition
    
    /// The animation for showing/hiding the tooltip
    public var animation: Animation?
    
    /// Default tooltip configuration
    public static var `default`: CTChartTooltipConfig {
        CTChartTooltipConfig(
            maxWidth: 200,
            contentPadding: EdgeInsets(top: CTSpacing.s, leading: CTSpacing.s, bottom: CTSpacing.s, trailing: CTSpacing.s),
            cornerRadius: 8,
            backgroundColor: nil,
            textColor: nil,
            labelColor: nil,
            titleColor: nil,
            font: nil,
            titleFont: nil,
            borderColor: nil,
            borderWidth: 0,
            shadowColor: nil,
            shadowRadius: 4,
            shadowOffset: CGSize(width: 0, height: 2),
            transition: .opacity.combined(with: .scale),
            animation: .easeInOut(duration: 0.2)
        )
    }
    
    /// Modern tooltip configuration with a border
    public static var modern: CTChartTooltipConfig {
        var config = CTChartTooltipConfig.default
        config.borderWidth = 1
        config.cornerRadius = 10
        config.shadowRadius = 8
        config.transition = .asymmetric(insertion: .scale, removal: .opacity.combined(with: .scale))
        return config
    }
    
    /// Minimal tooltip configuration with simpler styling
    public static var minimal: CTChartTooltipConfig {
        var config = CTChartTooltipConfig.default
        config.contentPadding = EdgeInsets(top: CTSpacing.xs, leading: CTSpacing.xs, bottom: CTSpacing.xs, trailing: CTSpacing.xs)
        config.shadowRadius = 2
        config.shadowOffset = CGSize(width: 0, height: 1)
        config.cornerRadius = 4
        config.transition = .opacity
        return config
    }
    
    /// Initialize tooltip configuration with custom parameters
    /// - Parameters:
    ///   - maxWidth: The maximum width of the tooltip
    ///   - contentPadding: The padding around the tooltip content
    ///   - cornerRadius: The corner radius of the tooltip
    ///   - backgroundColor: The background color of the tooltip
    ///   - textColor: The text color for the tooltip content
    ///   - labelColor: The label color for tooltip labels
    ///   - titleColor: The title color for tooltip titles
    ///   - font: The font for the tooltip content
    ///   - titleFont: The font for the tooltip title
    ///   - borderColor: The border color of the tooltip
    ///   - borderWidth: The border width of the tooltip
    ///   - shadowColor: The shadow color of the tooltip
    ///   - shadowRadius: The shadow radius of the tooltip
    ///   - shadowOffset: The shadow offset of the tooltip
    ///   - transition: The transition for showing/hiding the tooltip
    ///   - animation: The animation for showing/hiding the tooltip
    public init(
        maxWidth: CGFloat = 200,
        contentPadding: EdgeInsets = EdgeInsets(top: CTSpacing.s, leading: CTSpacing.s, bottom: CTSpacing.s, trailing: CTSpacing.s),
        cornerRadius: CGFloat = 8,
        backgroundColor: Color? = nil,
        textColor: Color? = nil,
        labelColor: Color? = nil,
        titleColor: Color? = nil,
        font: Font? = nil,
        titleFont: Font? = nil,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 0,
        shadowColor: Color? = nil,
        shadowRadius: CGFloat = 4,
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        transition: AnyTransition = .opacity.combined(with: .scale),
        animation: Animation? = .easeInOut(duration: 0.2)
    ) {
        self.maxWidth = maxWidth
        self.contentPadding = contentPadding
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.labelColor = labelColor
        self.titleColor = titleColor
        self.font = font
        self.titleFont = titleFont
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.transition = transition
        self.animation = animation
    }
}

/// A controller for managing tooltips in charts
public class CTChartTooltipController: ObservableObject {
    /// Whether the tooltip is visible
    @Published public var isTooltipVisible: Bool = false
    
    /// The position of the tooltip
    @Published public var tooltipPosition: CGPoint = .zero
    
    /// The currently active data point
    @Published public var activeDataPoint: CTChartDataPoint?
    
    /// The currently active series data
    @Published public var activeSeriesData: [String: Double]?
    
    /// The tooltip title
    @Published public var tooltipTitle: String?
    
    /// Show a tooltip for a data point
    /// - Parameters:
    ///   - dataPoint: The data point to show
    ///   - position: The position to show the tooltip
    public func showTooltip(for dataPoint: CTChartDataPoint, at position: CGPoint) {
        self.activeDataPoint = dataPoint
        self.activeSeriesData = nil
        self.tooltipTitle = dataPoint.label
        self.tooltipPosition = position
        self.isTooltipVisible = true
    }
    
    /// Show a tooltip for multiple series
    /// - Parameters:
    ///   - seriesData: Dictionary of series names and values
    ///   - title: Optional title for the tooltip
    ///   - position: The position to show the tooltip
    public func showTooltip(seriesData: [String: Double], title: String? = nil, at position: CGPoint) {
        self.activeDataPoint = nil
        self.activeSeriesData = seriesData
        self.tooltipTitle = title
        self.tooltipPosition = position
        self.isTooltipVisible = true
    }
    
    /// Show a tooltip with a custom title
    /// - Parameters:
    ///   - title: The title to show
    ///   - position: The position to show the tooltip
    public func showTooltip(title: String, at position: CGPoint) {
        self.activeDataPoint = nil
        self.activeSeriesData = nil
        self.tooltipTitle = title
        self.tooltipPosition = position
        self.isTooltipVisible = true
    }
    
    /// Hide the tooltip
    public func hideTooltip() {
        self.isTooltipVisible = false
    }
}

// MARK: - Preview

struct CTChartTooltip_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            // Simple text tooltip
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 300, height: 200)
                
                CTChartTooltip(
                    content: "Value: 42",
                    position: CGPoint(x: 150, y: 100)
                )
            }
            .previewDisplayName("Simple Tooltip")
            
            // Data point tooltip
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 300, height: 200)
                
                CTChartTooltip(
                    dataPoint: CTChartDataPoint(
                        x: 25,
                        y: 75,
                        label: "Q2 Sales",
                        metadata: ["Growth": "15%", "Category": "Electronics"]
                    ),
                    position: CGPoint(x: 150, y: 100)
                )
            }
            .previewDisplayName("Data Point Tooltip")
            
            // Series data tooltip
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 300, height: 200)
                
                CTChartTooltip(
                    seriesData: [
                        "Sales": 1250,
                        "Revenue": 2345,
                        "Profit": 890
                    ],
                    title: "Q2 2025",
                    position: CGPoint(x: 150, y: 100),
                    config: .modern
                )
            }
            .previewDisplayName("Series Data Tooltip")
        }
        .padding()
    }
}

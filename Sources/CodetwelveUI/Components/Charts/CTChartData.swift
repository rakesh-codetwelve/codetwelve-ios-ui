//
//  CTChartData.swift
//  CodetwelveUI
//
//  Created on 29/03/25.
//

import SwiftUI

/// Protocol for chart data that all chart types must implement
public protocol CTChartDataProtocol {
    /// The series of data in the chart
    var series: [CTChartSeries] { get }
    
    /// The x-axis domain (min and max values)
    var xDomain: ClosedRange<Double> { get }
    
    /// The y-axis domain (min and max values)
    var yDomain: ClosedRange<Double> { get }
    
    /// The x-axis tick values
    var xTicks: [Double] { get }
    
    /// The y-axis tick values
    var yTicks: [Double] { get }
    
    /// The x-axis tick labels
    var xTickLabels: [String] { get }
    
    /// The y-axis tick labels
    var yTickLabels: [String] { get }
    
    /// Accessibility description of the chart data
    var accessibilityDescription: String { get }
}

/// Extension with default implementations for chart data
public extension CTChartDataProtocol {
    /// Default x domain based on data points
    var xDomain: ClosedRange<Double> {
        if series.isEmpty || series.allSatisfy({ $0.dataPoints.isEmpty }) {
            return 0...1
        }
        
        let allXValues = series.flatMap { $0.dataPoints.map { $0.x } }
        let minX = allXValues.min() ?? 0
        let maxX = allXValues.max() ?? 1
        
        // If min equals max, create a range with some padding
        if minX == maxX {
            return (minX - 0.5)...(maxX + 0.5)
        }
        
        return minX...maxX
    }
    
    /// Default y domain based on data points
    var yDomain: ClosedRange<Double> {
        if series.isEmpty || series.allSatisfy({ $0.dataPoints.isEmpty }) {
            return 0...1
        }
        
        let allYValues = series.flatMap { $0.dataPoints.map { $0.y } }
        let minY = allYValues.min() ?? 0
        let maxY = allYValues.max() ?? 1
        
        // If min equals max, create a range with some padding
        if minY == maxY {
            return (minY - 0.5)...(minY + 0.5)
        }
        
        // For nice chart proportions, we may want to start at 0 if all values are positive
        let startAtZero = minY > 0 && minY < maxY * 0.2
        return (startAtZero ? 0 : minY)...maxY
    }
    
    /// Default x tick values (5 evenly spaced ticks)
    var xTicks: [Double] {
        return CTChartUtilities.generateTicks(domain: xDomain, count: 5)
    }
    
    /// Default y tick values (5 evenly spaced ticks)
    var yTicks: [Double] {
        return CTChartUtilities.generateTicks(domain: yDomain, count: 5)
    }
    
    /// Default x tick labels
    var xTickLabels: [String] {
        return xTicks.map { String(format: "%.0f", $0) }
    }
    
    /// Default y tick labels
    var yTickLabels: [String] {
        return yTicks.map { String(format: "%.0f", $0) }
    }
    
    /// Default accessibility description
    var accessibilityDescription: String {
        let seriesCount = series.count
        let pointCount = series.first?.dataPoints.count ?? 0
        
        if seriesCount == 1 {
            return "a single series with \(pointCount) data points"
        } else {
            return "\(seriesCount) series with approximately \(pointCount) data points each"
        }
    }
}

/// A series of data points in a chart
public struct CTChartSeries: Identifiable {
    /// Unique identifier for the series
    public let id = UUID()
    
    /// The name of the series
    public let name: String
    
    /// The data points in the series
    public let dataPoints: [CTChartDataPoint]
    
    /// The color of the series (optional, will use chart style if nil)
    public let color: Color?
    
    /// Whether the series is visible
    public var isVisible: Bool
    
    /// Initialize a chart series with data points
    /// - Parameters:
    ///   - name: The name of the series
    ///   - dataPoints: The data points in the series
    ///   - color: The color of the series (optional)
    ///   - isVisible: Whether the series is visible
    public init(name: String, dataPoints: [CTChartDataPoint], color: Color? = nil, isVisible: Bool = true) {
        self.name = name
        self.dataPoints = dataPoints
        self.color = color
        self.isVisible = isVisible
    }
}

/// A data point in a chart
public struct CTChartDataPoint: Identifiable {
    /// Unique identifier for the data point
    public let id = UUID()
    
    /// The x value of the data point
    public let x: Double
    
    /// The y value of the data point
    public let y: Double
    
    /// The optional label for the data point
    public let label: String?
    
    /// Additional metadata associated with this data point (can be used for custom tooltips)
    public let metadata: [String: Any]?
    
    /// Initialize a chart data point
    /// - Parameters:
    ///   - x: The x value
    ///   - y: The y value
    ///   - label: The label (optional)
    ///   - metadata: Additional metadata for the point (optional)
    public init(x: Double, y: Double, label: String? = nil, metadata: [String: Any]? = nil) {
        self.x = x
        self.y = y
        self.label = label
        self.metadata = metadata
    }
}

/// A simple implementation of CTChartDataProtocol for a single series
public struct CTSimpleChartData: CTChartDataProtocol {
    /// The series of data in the chart
    public let series: [CTChartSeries]
    
    /// Custom x-axis tick labels (optional)
    public let customXTickLabels: [String]?
    
    /// Custom y-axis tick labels (optional)
    public let customYTickLabels: [String]?
    
    /// Initialize with a series of data points
    /// - Parameters:
    ///   - dataPoints: The data points
    ///   - seriesName: The name of the series
    ///   - seriesColor: The color of the series (optional)
    ///   - xTickLabels: Custom x-axis tick labels (optional)
    ///   - yTickLabels: Custom y-axis tick labels (optional)
    public init(
        dataPoints: [CTChartDataPoint],
        seriesName: String = "Series",
        seriesColor: Color? = nil,
        xTickLabels: [String]? = nil,
        yTickLabels: [String]? = nil
    ) {
        self.series = [CTChartSeries(name: seriesName, dataPoints: dataPoints, color: seriesColor)]
        self.customXTickLabels = xTickLabels
        self.customYTickLabels = yTickLabels
    }
    
    /// Initialize with multiple series
    /// - Parameters:
    ///   - series: The series of data
    ///   - xTickLabels: Custom x-axis tick labels (optional)
    ///   - yTickLabels: Custom y-axis tick labels (optional)
    public init(
        series: [CTChartSeries],
        xTickLabels: [String]? = nil,
        yTickLabels: [String]? = nil
    ) {
        self.series = series
        self.customXTickLabels = xTickLabels
        self.customYTickLabels = yTickLabels
    }
    
    /// The x-axis tick labels
    public var xTickLabels: [String] {
        if let customLabels = customXTickLabels, !customLabels.isEmpty {
            return customLabels
        }
        return xTicks.map { String(format: "%.0f", $0) }
    }
    
    /// The y-axis tick labels
    public var yTickLabels: [String] {
        if let customLabels = customYTickLabels, !customLabels.isEmpty {
            return customLabels
        }
        return yTicks.map { String(format: "%.0f", $0) }
    }
}

/// A rich implementation of CTChartDataProtocol with additional features
public struct CTRichChartData: CTChartDataProtocol {
    /// The series of data in the chart
    public let series: [CTChartSeries]
    
    /// Custom x-axis domain (optional)
    public let customXDomain: ClosedRange<Double>?
    
    /// Custom y-axis domain (optional)
    public let customYDomain: ClosedRange<Double>?
    
    /// Custom x-axis ticks (optional)
    public let customXTicks: [Double]?
    
    /// Custom y-axis ticks (optional)
    public let customYTicks: [Double]?
    
    /// Custom x-axis tick labels (optional)
    public let customXTickLabels: [String]?
    
    /// Custom y-axis tick labels (optional)
    public let customYTickLabels: [String]?
    
    /// Custom x-axis title (optional)
    public let xAxisTitle: String?
    
    /// Custom y-axis title (optional)
    public let yAxisTitle: String?
    
    /// Custom accessibility description (optional)
    public let customAccessibilityDescription: String?
    
    /// Initialize with multiple series and customization options
    /// - Parameters:
    ///   - series: The series of data
    ///   - xDomain: Custom x-axis domain (optional)
    ///   - yDomain: Custom y-axis domain (optional)
    ///   - xTicks: Custom x-axis ticks (optional)
    ///   - yTicks: Custom y-axis ticks (optional)
    ///   - xTickLabels: Custom x-axis tick labels (optional)
    ///   - yTickLabels: Custom y-axis tick labels (optional)
    ///   - xAxisTitle: Custom x-axis title (optional)
    ///   - yAxisTitle: Custom y-axis title (optional)
    ///   - accessibilityDescription: Custom accessibility description (optional)
    public init(
        series: [CTChartSeries],
        xDomain: ClosedRange<Double>? = nil,
        yDomain: ClosedRange<Double>? = nil,
        xTicks: [Double]? = nil,
        yTicks: [Double]? = nil,
        xTickLabels: [String]? = nil,
        yTickLabels: [String]? = nil,
        xAxisTitle: String? = nil,
        yAxisTitle: String? = nil,
        accessibilityDescription: String? = nil
    ) {
        self.series = series
        self.customXDomain = xDomain
        self.customYDomain = yDomain
        self.customXTicks = xTicks
        self.customYTicks = yTicks
        self.customXTickLabels = xTickLabels
        self.customYTickLabels = yTickLabels
        self.xAxisTitle = xAxisTitle
        self.yAxisTitle = yAxisTitle
        self.customAccessibilityDescription = accessibilityDescription
    }
    
    /// The x-axis domain
    public var xDomain: ClosedRange<Double> {
        if let customDomain = customXDomain {
            return customDomain
        }
        if series.isEmpty || series.allSatisfy({ $0.dataPoints.isEmpty }) {
            return 0...1
        }
        
        let allXValues = series.flatMap { $0.dataPoints.map { $0.x } }
        let minX = allXValues.min() ?? 0
        let maxX = allXValues.max() ?? 1
        
        if minX == maxX {
            return (minX - 0.5)...(maxX + 0.5)
        }
        
        return minX...maxX
    }
    
    /// The y-axis domain
    public var yDomain: ClosedRange<Double> {
        if let customDomain = customYDomain {
            return customDomain
        }
        if series.isEmpty || series.allSatisfy({ $0.dataPoints.isEmpty }) {
            return 0...1
        }
        
        let allYValues = series.flatMap { $0.dataPoints.map { $0.y } }
        let minY = allYValues.min() ?? 0
        let maxY = allYValues.max() ?? 1
        
        if minY == maxY {
            return (minY - 0.5)...(minY + 0.5)
        }
        
        let startAtZero = minY > 0 && minY < maxY * 0.2
        return (startAtZero ? 0 : minY)...maxY
    }
    
    /// The x-axis tick values
    public var xTicks: [Double] {
        if let customTicks = customXTicks {
            return customTicks
        }
        return CTChartUtilities.generateTicks(domain: xDomain, count: 5)
    }
    
    /// The y-axis tick values
    public var yTicks: [Double] {
        if let customTicks = customYTicks {
            return customTicks
        }
        return CTChartUtilities.generateTicks(domain: yDomain, count: 5)
    }
    
    /// The x-axis tick labels
    public var xTickLabels: [String] {
        if let customLabels = customXTickLabels, !customLabels.isEmpty {
            return customLabels
        }
        return xTicks.map { String(format: "%.0f", $0) }
    }
    
    /// The y-axis tick labels
    public var yTickLabels: [String] {
        if let customLabels = customYTickLabels, !customLabels.isEmpty {
            return customLabels
        }
        return yTicks.map { String(format: "%.0f", $0) }
    }
    
    /// The accessibility description
    public var accessibilityDescription: String {
        if let customDescription = customAccessibilityDescription {
            return customDescription
        }
        let seriesCount = series.count
        let pointCount = series.first?.dataPoints.count ?? 0
        
        if seriesCount == 1 {
            return "a single series with \(pointCount) data points"
        } else {
            return "\(seriesCount) series with approximately \(pointCount) data points each"
        }
    }
}

/// Implementation for pie/donut chart data
public struct CTPieChartData: CTChartDataProtocol {
    /// The data for the pie chart, represented as a single series
    public let series: [CTChartSeries]
    
    /// Initialize with slice values
    /// - Parameters:
    ///   - values: The values for the pie slices
    ///   - labels: The labels for the pie slices
    ///   - colors: The colors for the pie slices (optional)
    public init(
        values: [Double],
        labels: [String],
        colors: [Color]? = nil
    ) {
        let dataPoints = zip(values, labels).enumerated().map { index, pair in
            let (value, label) = pair
            return CTChartDataPoint(x: Double(index), y: value, label: label)
        }
        
        let seriesColor = colors?.first
        self.series = [CTChartSeries(name: "Pie Data", dataPoints: dataPoints, color: seriesColor)]
    }
    
    /// Initialize with a dictionary of label-value pairs
    /// - Parameters:
    ///   - data: Dictionary with labels as keys and values as values
    ///   - colors: The colors for the pie slices (optional)
    public init(
        data: [String: Double],
        colors: [Color]? = nil
    ) {
        let sortedData = data.sorted { $0.value > $1.value }
        let dataPoints = sortedData.enumerated().map { index, pair in
            return CTChartDataPoint(x: Double(index), y: pair.value, label: pair.key)
        }
        
        let seriesColor = colors?.first
        self.series = [CTChartSeries(name: "Pie Data", dataPoints: dataPoints, color: seriesColor)]
    }
    
    /// Initialize with custom slices
    /// - Parameter slices: The pie slices
    public init(slices: [CTPieSlice]) {
        let dataPoints = slices.enumerated().map { index, slice in
            return CTChartDataPoint(
                x: Double(index),
                y: slice.value,
                label: slice.label,
                metadata: ["color": slice.color as Any]
            )
        }
        
        self.series = [CTChartSeries(name: "Pie Data", dataPoints: dataPoints)]
    }
}

/// A slice in a pie chart
public struct CTPieSlice: Identifiable {
    /// Unique identifier for the slice
    public let id = UUID()
    
    /// The value represented by this slice
    public let value: Double
    
    /// The label for this slice
    public let label: String
    
    /// The color of this slice
    public let color: Color?
    
    /// Whether this slice should be exploded from the pie
    public let isExploded: Bool
    
    /// Initialize a pie slice
    /// - Parameters:
    ///   - value: The value for the slice
    ///   - label: The label for the slice
    ///   - color: The color for the slice (optional)
    ///   - isExploded: Whether this slice should be exploded from the pie
    public init(value: Double, label: String, color: Color? = nil, isExploded: Bool = false) {
        self.value = value
        self.label = label
        self.color = color
        self.isExploded = isExploded
    }
}

/// Utilities for chart data processing and calculations
public enum CTChartUtilities {
    /// Generate evenly spaced tick values for an axis
    /// - Parameters:
    ///   - domain: The domain (min and max values)
    ///   - count: The number of ticks
    /// - Returns: An array of tick values
    public static func generateTicks(domain: ClosedRange<Double>, count: Int) -> [Double] {
        let range = domain.upperBound - domain.lowerBound
        let step = range / Double(count - 1)
        
        return (0..<count).map { domain.lowerBound + step * Double($0) }
    }
    
    /// Scale a value from a source range to a target range
    /// - Parameters:
    ///   - value: The value to scale
    ///   - sourceDomain: The source range
    ///   - targetRange: The target range
    /// - Returns: The scaled value
    public static func scale(
        value: Double,
        sourceDomain: ClosedRange<Double>,
        targetRange: ClosedRange<CGFloat>
    ) -> CGFloat {
        let sourceRange = sourceDomain.upperBound - sourceDomain.lowerBound
        let targetSpan = targetRange.upperBound - targetRange.lowerBound
        
        // Handle edge case to prevent division by zero
        if sourceRange == 0 {
            return targetRange.lowerBound
        }
        
        let scaledValue = ((value - sourceDomain.lowerBound) / sourceRange) * Double(targetSpan) + Double(targetRange.lowerBound)
        return CGFloat(scaledValue)
    }
    
    /// Format a number for display
    /// - Parameters:
    ///   - value: The value to format
    ///   - maximumFractionDigits: The maximum number of fraction digits
    ///   - minimumFractionDigits: The minimum number of fraction digits
    ///   - useGroupingSeparator: Whether to use a grouping separator (e.g., comma)
    /// - Returns: The formatted string
    public static func formatNumber(
        _ value: Double,
        maximumFractionDigits: Int = 1,
        minimumFractionDigits: Int = 0,
        useGroupingSeparator: Bool = true
    ) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.usesGroupingSeparator = useGroupingSeparator
        
        return formatter.string(from: NSNumber(value: value)) ?? String(value)
    }
    
    /// Format a percentage for display
    /// - Parameters:
    ///   - value: The value to format as a percentage (0.0 - 1.0)
    ///   - maximumFractionDigits: The maximum number of fraction digits
    /// - Returns: The formatted percentage string
    public static func formatPercentage(
        _ value: Double,
        maximumFractionDigits: Int = 1
    ) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = maximumFractionDigits
        
        return formatter.string(from: NSNumber(value: value)) ?? "\(Int(value * 100))%"
    }
    
    /// Calculate statistics for a series of data
    /// - Parameter dataPoints: The data points to analyze
    /// - Returns: A dictionary of statistics
    public static func calculateStatistics(for dataPoints: [CTChartDataPoint]) -> [String: Double] {
        let yValues = dataPoints.map { $0.y }
        
        guard !yValues.isEmpty else {
            return [:]
        }
        
        let sum = yValues.reduce(0, +)
        let count = Double(yValues.count)
        let mean = sum / count
        
        let sortedValues = yValues.sorted()
        let median: Double
        if yValues.count % 2 == 0 {
            median = (sortedValues[yValues.count / 2 - 1] + sortedValues[yValues.count / 2]) / 2
        } else {
            median = sortedValues[yValues.count / 2]
        }
        
        let min = yValues.min() ?? 0
        let max = yValues.max() ?? 0
        
        let variance = yValues.map { pow($0 - mean, 2) }.reduce(0, +) / count
        let standardDeviation = sqrt(variance)
        
        return [
            "count": count,
            "sum": sum,
            "mean": mean,
            "median": median,
            "min": min,
            "max": max,
            "variance": variance,
            "standardDeviation": standardDeviation
        ]
    }
}

/// Extension to add interpolation capabilities to data points
extension Array where Element == CTChartDataPoint {
    /// Interpolate between data points to generate smooth curves
    /// - Parameters:
    ///   - resolution: The number of points to generate between each pair of data points
    ///   - curveType: The type of curve to generate
    /// - Returns: An array of interpolated data points
    public func interpolated(resolution: Int = 10, curveType: CTChartStyle.CurveType = .monotone) -> [CTChartDataPoint] {
        guard self.count > 1 else { return self }
        
        // Sort by x value
        let sortedPoints = self.sorted { $0.x < $1.x }
        
        var result: [CTChartDataPoint] = []
        
        for i in 0..<(sortedPoints.count - 1) {
            let startPoint = sortedPoints[i]
            let endPoint = sortedPoints[i + 1]
            
            result.append(startPoint)
            
            for j in 1..<resolution {
                let t = Double(j) / Double(resolution)
                let interpolatedX: Double
                let interpolatedY: Double
                
                switch curveType {
                case .linear:
                    interpolatedX = startPoint.x + t * (endPoint.x - startPoint.x)
                    interpolatedY = startPoint.y + t * (endPoint.y - startPoint.y)
                    
                case .monotone, .cardinal, .natural:
                    // For simplicity, using a simple cubic interpolation for smooth curves
                    interpolatedX = startPoint.x + t * (endPoint.x - startPoint.x)
                    
                    // Cubic interpolation formula
                    let t2 = t * t
                    let t3 = t2 * t
                    let h00 = 2 * t3 - 3 * t2 + 1
                    let h10 = t3 - 2 * t2 + t
                    let h01 = -2 * t3 + 3 * t2
                    let h11 = t3 - t2
                    
                    // Tangent estimation (simplified)
                    let m0 = (i > 0) ? (endPoint.y - sortedPoints[i - 1].y) / 2 : (endPoint.y - startPoint.y)
                    let m1 = (i < sortedPoints.count - 2) ? (sortedPoints[i + 2].y - startPoint.y) / 2 : (endPoint.y - startPoint.y)
                    
                    interpolatedY = h00 * startPoint.y + h10 * m0 + h01 * endPoint.y + h11 * m1
                    
                case .step:
                    interpolatedX = startPoint.x + t * (endPoint.x - startPoint.x)
                    interpolatedY = startPoint.y
                }
                
                result.append(CTChartDataPoint(x: interpolatedX, y: interpolatedY))
            }
        }
        
        // Add the last point
        result.append(sortedPoints.last!)
        
        return result
    }
}

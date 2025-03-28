//
//  CTGrid.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A grid layout component with customization options.
///
/// `CTGrid` provides a flexible grid layout for arranging views in rows and columns.
/// It supports both fixed and adaptive grid layouts with customizable spacing and alignment.
///
/// # Example
///
/// ```swift
/// // Fixed grid with 2 columns
/// CTGrid(columns: 2, spacing: 10) {
///     ForEach(1...6, id: \.self) { index in
///         Text("Item \(index)")
///             .frame(height: 50)
///             .frame(maxWidth: .infinity)
///             .background(Color.blue.opacity(0.1))
///     }
/// }
///
/// // Adaptive grid with minimum item width
/// CTGrid(minItemWidth: 150, spacing: 10) {
///     ForEach(1...6, id: \.self) { index in
///         Text("Item \(index)")
///             .frame(height: 50)
///             .frame(maxWidth: .infinity)
///             .background(Color.blue.opacity(0.1))
///     }
/// }
/// ```
public struct CTGrid<Content: View>: View {
    // MARK: - Properties
    
    /// The content of the grid
    private let content: Content
    
    /// The number of columns (for fixed grid)
    private let columns: Int?
    
    /// The minimum width of each item (for adaptive grid)
    private let minItemWidth: CGFloat?
    
    /// The spacing between grid items
    private let spacing: CGFloat
    
    /// The horizontal alignment of grid items
    private let horizontalAlignment: HorizontalAlignment
    
    /// The vertical alignment of grid items
    private let verticalAlignment: VerticalAlignment
    
    /// The padding around the grid
    private let padding: EdgeInsets?
    
    // MARK: - Initializers
    
    /// Creates a fixed grid with a specified number of columns
    ///
    /// - Parameters:
    ///   - columns: The number of columns in the grid
    ///   - spacing: The spacing between grid items
    ///   - horizontalAlignment: The horizontal alignment of grid items
    ///   - verticalAlignment: The vertical alignment of grid items
    ///   - padding: Optional padding around the grid
    ///   - content: The grid content view builder
    public init(
        columns: Int,
        spacing: CGFloat = CTSpacing.m,
        horizontalAlignment: HorizontalAlignment = .center,
        verticalAlignment: VerticalAlignment = .center,
        padding: EdgeInsets? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.columns = columns
        self.minItemWidth = nil
        self.spacing = spacing
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.padding = padding
    }
    
    /// Creates an adaptive grid where the number of columns is determined by the available width
    ///
    /// - Parameters:
    ///   - minItemWidth: The minimum width for each grid item
    ///   - spacing: The spacing between grid items
    ///   - horizontalAlignment: The horizontal alignment of grid items
    ///   - verticalAlignment: The vertical alignment of grid items
    ///   - padding: Optional padding around the grid
    ///   - content: The grid content view builder
    public init(
        minItemWidth: CGFloat,
        spacing: CGFloat = CTSpacing.m,
        horizontalAlignment: HorizontalAlignment = .center,
        verticalAlignment: VerticalAlignment = .center,
        padding: EdgeInsets? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.columns = nil
        self.minItemWidth = minItemWidth
        self.spacing = spacing
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.padding = padding
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            let gridItems = calculateGridItems(availableWidth: geometry.size.width)
            
            LazyVGrid(
                columns: gridItems,
                alignment: horizontalAlignment,
                spacing: spacing,
                pinnedViews: []
            ) {
                content
            }
            .ctConditional(padding != nil) { view in
                view.padding(padding!)
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Calculates the grid items based on the configuration and available width
    ///
    /// - Parameter availableWidth: The available width for the grid
    /// - Returns: An array of grid items
    private func calculateGridItems(availableWidth: CGFloat) -> [GridItem] {
        if let columns = columns {
            // Fixed grid with specified number of columns
            return Array(repeating: GridItem(.flexible(), spacing: spacing, alignment: Alignment(horizontal: .center, vertical: verticalAlignment)), count: columns)
        } else if let minItemWidth = minItemWidth {
            // Adaptive grid with minimum item width
            let itemCount = max(1, Int(availableWidth / (minItemWidth + spacing)))
            return Array(repeating: GridItem(.adaptive(minimum: minItemWidth), spacing: spacing, alignment: Alignment(horizontal: .center, vertical: verticalAlignment)), count: 1)
        } else {
            // Default to a single column
            return [GridItem(.flexible(), alignment: Alignment(horizontal: .center, vertical: verticalAlignment))]
        }
    }
}

// MARK: - Extension for Item Sizing

public extension View {
    /// Sets the frame of the view to make it a square
    ///
    /// - Returns: A view with equal width and height
    func ctGridSquare() -> some View {
        GeometryReader { geometry in
            self
                .frame(width: geometry.size.width, height: geometry.size.width)
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    /// Sets the aspect ratio of the view
    ///
    /// - Parameter ratio: The width-to-height aspect ratio
    /// - Returns: A view with the specified aspect ratio
    func ctGridAspectRatio(_ ratio: CGFloat) -> some View {
        GeometryReader { geometry in
            self
                .frame(width: geometry.size.width, height: geometry.size.width / ratio)
        }
        .aspectRatio(ratio, contentMode: .fit)
    }
}

// MARK: - Previews

struct CTGrid_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 40) {
                // Fixed grid with 2 columns
                Text("Fixed Grid (2 columns)")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                CTGrid(columns: 2, spacing: 10) {
                    ForEach(1...6, id: \.self) { index in
                        Text("Item \(index)")
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                
                // Fixed grid with 3 columns
                Text("Fixed Grid (3 columns)")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                CTGrid(columns: 3, spacing: 10) {
                    ForEach(1...9, id: \.self) { index in
                        Text("Item \(index)")
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                
                // Adaptive grid
                Text("Adaptive Grid (min width: 120)")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                CTGrid(minItemWidth: 120, spacing: 10) {
                    ForEach(1...8, id: \.self) { index in
                        Text("Item \(index)")
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.purple.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                
                // Grid with square items
                Text("Grid with Square Items")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                CTGrid(columns: 3, spacing: 10) {
                    ForEach(1...6, id: \.self) { index in
                        Text("Item \(index)")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(8)
                            .ctGridSquare()
                    }
                }
                
                // Grid with aspect ratio items
                Text("Grid with Aspect Ratio Items (16:9)")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                CTGrid(columns: 2, spacing: 10) {
                    ForEach(1...4, id: \.self) { index in
                        Text("Item \(index)")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                            .ctGridAspectRatio(16/9)
                    }
                }
            }
            .padding()
        }
    }
}
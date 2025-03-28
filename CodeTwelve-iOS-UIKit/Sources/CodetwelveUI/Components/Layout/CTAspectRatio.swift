//
//  CTAspectRatio.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A component that maintains a specific aspect ratio for its content.
///
/// `CTAspectRatio` allows you to maintain a consistent width-to-height ratio
/// for a view regardless of the available space, which is useful for images,
/// videos, cards, and other content where proportions are important.
///
/// # Example
///
/// ```swift
/// // Create a view with 16:9 aspect ratio
/// CTAspectRatio(ratio: 16/9) {
///     Image("landscape")
///         .resizable()
///         .scaledToFill()
/// }
///
/// // Create a square view (1:1 aspect ratio)
/// CTAspectRatio(ratio: 1) {
///     Color.blue
/// }
///
/// // Create a view with 4:3 aspect ratio with .fit content mode
/// CTAspectRatio(ratio: 4/3, contentMode: .fit) {
///     Image("photo")
///         .resizable()
/// }
/// ```
public struct CTAspectRatio<Content: View>: View {
    // MARK: - Public Properties
    
    /// The content to display
    private let content: Content
    
    /// The aspect ratio to maintain (width / height)
    private let ratio: CGFloat
    
    /// The content mode to use
    private let contentMode: ContentMode
    
    /// The alignment of the content
    private let alignment: Alignment
    
    // MARK: - Initializers
    
    /// Initialize with a ratio and content
    /// - Parameters:
    ///   - ratio: The aspect ratio to maintain (width / height)
    ///   - contentMode: The content mode to use
    ///   - alignment: The alignment of the content
    ///   - content: The content to display
    public init(
        ratio: CGFloat,
        contentMode: ContentMode = .fill,
        alignment: Alignment = .center,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.ratio = ratio
        self.contentMode = contentMode
        self.alignment = alignment
    }
    
    /// Initialize with predefined ratio and content
    /// - Parameters:
    ///   - preset: A predefined aspect ratio
    ///   - contentMode: The content mode to use
    ///   - alignment: The alignment of the content
    ///   - content: The content to display
    public init(
        preset: AspectRatioPreset,
        contentMode: ContentMode = .fill,
        alignment: Alignment = .center,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.ratio = preset.ratio
        self.contentMode = contentMode
        self.alignment = alignment
    }
    
    // MARK: - Body
    
    public var body: some View {
        if contentMode == .fit {
            // For .fit mode, we constrain the content to the aspect ratio
            content
                .aspectRatio(ratio, contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
        } else {
            // For .fill mode, we create a view with the desired aspect ratio
            // and let the content fill it
            GeometryReader { geometry in
                content
                    .frame(width: geometry.size.width, height: geometry.size.width / ratio)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            }
            .aspectRatio(ratio, contentMode: .fill)
        }
    }
}

// MARK: - Supporting Types

/// Content modes for aspect ratio
public enum ContentMode {
    /// Fill the available space while maintaining aspect ratio
    case fill
    
    /// Fit within the available space while maintaining aspect ratio
    case fit
}

/// Predefined aspect ratios
public enum AspectRatioPreset {
    /// Square (1:1)
    case square
    
    /// 16:9 widescreen
    case widescreen
    
    /// 4:3 standard
    case standard
    
    /// 21:9 ultrawide
    case ultrawide
    
    /// 3:2 classic photo
    case photo
    
    /// 3:4 portrait
    case portrait
    
    /// 9:16 mobile portrait
    case mobilePortrait
    
    /// 2:1 panorama
    case panorama
    
    /// 1:2 tall portrait
    case tallPortrait
    
    /// Custom aspect ratio
    case custom(width: CGFloat, height: CGFloat)
    
    /// The calculated ratio (width / height)
    var ratio: CGFloat {
        switch self {
        case .square:
            return 1.0
        case .widescreen:
            return 16.0 / 9.0
        case .standard:
            return 4.0 / 3.0
        case .ultrawide:
            return 21.0 / 9.0
        case .photo:
            return 3.0 / 2.0
        case .portrait:
            return 3.0 / 4.0
        case .mobilePortrait:
            return 9.0 / 16.0
        case .panorama:
            return 2.0 / 1.0
        case .tallPortrait:
            return 1.0 / 2.0
        case .custom(let width, let height):
            return width / height
        }
    }
    
    /// The name of the aspect ratio
    var name: String {
        switch self {
        case .square:
            return "Square (1:1)"
        case .widescreen:
            return "Widescreen (16:9)"
        case .standard:
            return "Standard (4:3)"
        case .ultrawide:
            return "Ultrawide (21:9)"
        case .photo:
            return "Photo (3:2)"
        case .portrait:
            return "Portrait (3:4)"
        case .mobilePortrait:
            return "Mobile Portrait (9:16)"
        case .panorama:
            return "Panorama (2:1)"
        case .tallPortrait:
            return "Tall Portrait (1:2)"
        case .custom(let width, let height):
            return "Custom (\(Int(width)):\(Int(height)))"
        }
    }
}

// MARK: - View Extensions

public extension View {
    /// Apply a predefined aspect ratio to a view
    /// - Parameters:
    ///   - preset: A predefined aspect ratio
    ///   - contentMode: The content mode to use
    ///   - alignment: The alignment of the content
    /// - Returns: A view with the specified aspect ratio
    func ctAspectRatio(
        preset: AspectRatioPreset,
        contentMode: ContentMode = .fill,
        alignment: Alignment = .center
    ) -> some View {
        CTAspectRatio(preset: preset, contentMode: contentMode, alignment: alignment) {
            self
        }
    }
    
    /// Make the view square (1:1 aspect ratio)
    /// - Parameters:
    ///   - contentMode: The content mode to use
    ///   - alignment: The alignment of the content
    /// - Returns: A square view
    func ctSquare(
        contentMode: ContentMode = .fill,
        alignment: Alignment = .center
    ) -> some View {
        CTAspectRatio(preset: .square, contentMode: contentMode, alignment: alignment) {
            self
        }
    }
    
    /// Apply a 16:9 widescreen aspect ratio to a view
    /// - Parameters:
    ///   - contentMode: The content mode to use
    ///   - alignment: The alignment of the content
    /// - Returns: A view with 16:9 aspect ratio
    func ctWidescreen(
        contentMode: ContentMode = .fill,
        alignment: Alignment = .center
    ) -> some View {
        CTAspectRatio(preset: .widescreen, contentMode: contentMode, alignment: alignment) {
            self
        }
    }
}

// MARK: - Previews

struct CTAspectRatio_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: CTSpacing.m) {
                Group {
                    Text("Square (1:1)").font(.headline)
                    CTAspectRatio(preset: .square) {
                        Color.blue
                    }
                    .frame(width: 200)
                    .overlay(
                        Text("1:1")
                            .foregroundColor(.white)
                            .font(.title)
                    )
                }
                
                Group {
                    Text("Widescreen (16:9)").font(.headline)
                    CTAspectRatio(preset: .widescreen) {
                        Color.green
                    }
                    .frame(width: 200)
                    .overlay(
                        Text("16:9")
                            .foregroundColor(.white)
                            .font(.title)
                    )
                }
                
                Group {
                    Text("Standard (4:3)").font(.headline)
                    CTAspectRatio(preset: .standard) {
                        Color.red
                    }
                    .frame(width: 200)
                    .overlay(
                        Text("4:3")
                            .foregroundColor(.white)
                            .font(.title)
                    )
                }
                
                Group {
                    Text("Portrait (3:4)").font(.headline)
                    CTAspectRatio(preset: .portrait) {
                        Color.orange
                    }
                    .frame(width: 150)
                    .overlay(
                        Text("3:4")
                            .foregroundColor(.white)
                            .font(.title)
                    )
                }
                
                Group {
                    Text("Custom (2.5:1)").font(.headline)
                    CTAspectRatio(ratio: 2.5) {
                        Color.purple
                    }
                    .frame(width: 200)
                    .overlay(
                        Text("2.5:1")
                            .foregroundColor(.white)
                            .font(.title)
                    )
                }
                
                Group {
                    Text("Fit vs Fill Content Mode").font(.headline).padding(.top)
                    
                    HStack(spacing: CTSpacing.m) {
                        VStack {
                            Text("Fill").font(.subheadline)
                            CTAspectRatio(preset: .square, contentMode: .fill) {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color.blue)
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        VStack {
                            Text("Fit").font(.subheadline)
                            CTAspectRatio(preset: .square, contentMode: .fit) {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color.blue)
                            }
                            .frame(width: 100, height: 100)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                
                Group {
                    Text("View Extensions").font(.headline).padding(.top)
                    
                    Color.cyan
                        .ctSquare()
                        .frame(width: 100)
                        .overlay(Text("Square").foregroundColor(.white))
                    
                    Color.purple
                        .ctWidescreen()
                        .frame(width: 200)
                        .overlay(Text("Widescreen").foregroundColor(.white))
                    
                    Color.orange
                        .ctAspectRatio(preset: .panorama)
                        .frame(width: 200)
                        .overlay(Text("Panorama").foregroundColor(.white))
                }
            }
            .padding()
        }
    }
}

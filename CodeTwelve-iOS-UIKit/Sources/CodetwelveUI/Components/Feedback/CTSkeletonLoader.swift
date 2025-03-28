//
//  CTSkeletonLoader.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI

/// A customizable skeleton loading component for indicating content is loading.
///
/// `CTSkeletonLoader` provides consistent loading placeholders throughout your application
/// with support for different shapes, animations, and styles.
///
/// # Example
///
/// ```swift
/// // Basic skeleton loader
/// CTSkeletonLoader(shape: .rectangle)
///
/// // Circular skeleton with custom size
/// CTSkeletonLoader(shape: .circle, size: CGSize(width: 80, height: 80))
///
/// // Text skeleton with multiple lines
/// CTSkeletonLoader(shape: .text(lines: 3, lastLineWidth: 0.6))
///
/// // Custom skeleton with shimmer effect
/// CTSkeletonLoader(
///     shape: .rectangle,
///     animation: .shimmer,
///     cornerRadius: 8,
///     color: .ctPrimary.opacity(0.1)
/// )
/// ```
public struct CTSkeletonLoader: View {
    // MARK: - Private Properties
    
    /// The shape of the skeleton
    private let shape: CTSkeletonShape
    
    /// The animation style for the skeleton
    private let animation: CTSkeletonAnimation
    
    /// The size of the skeleton
    private let size: CGSize
    
    /// The corner radius of the skeleton
    private let cornerRadius: CGFloat
    
    /// The color of the skeleton
    private let color: Color?
    
    /// The shimmer color for shimmer animation
    private let shimmerColor: Color?
    
    /// Controls the animation state
    @State private var isAnimating = false
    
    /// The current theme from the environment
    @Environment(\.ctTheme) private var theme
    
    // MARK: - Initializers
    
    /// Initialize a new skeleton loader
    /// - Parameters:
    ///   - shape: The shape of the skeleton
    ///   - animation: The animation style for the skeleton
    ///   - size: The size of the skeleton (for rectangles, circles, and capsules)
    ///   - cornerRadius: The corner radius of the skeleton (for rectangle shape)
    ///   - color: The color of the skeleton
    ///   - shimmerColor: The shimmer color for shimmer animation
    public init(
        shape: CTSkeletonShape = .rectangle,
        animation: CTSkeletonAnimation = .pulse,
        size: CGSize? = nil,
        cornerRadius: CGFloat = 8,
        color: Color? = nil,
        shimmerColor: Color? = nil
    ) {
        self.shape = shape
        self.animation = animation
        self.cornerRadius = cornerRadius
        self.color = color
        self.shimmerColor = shimmerColor
        
        // Determine appropriate size based on shape
        switch shape {
        case .rectangle:
            self.size = size ?? CGSize(width: 200, height: 20)
        case .square:
            let dimension = size?.width ?? 80
            self.size = CGSize(width: dimension, height: dimension)
        case .circle:
            let dimension = size?.width ?? 80
            self.size = CGSize(width: dimension, height: dimension)
        case .capsule:
            self.size = size ?? CGSize(width: 120, height: 40)
        case .text(let lines, _):
            // For text, the height is determined by the number of lines
            let lineHeight: CGFloat = 16
            let lineSpacing: CGFloat = 8
            let calculatedHeight = CGFloat(lines) * lineHeight + CGFloat(max(0, lines - 1)) * lineSpacing
            self.size = size ?? CGSize(width: 200, height: calculatedHeight)
        }
    }
    
    // MARK: - Body
    
    public var body: some View {
        skeletonContent
            .frame(width: size.width, height: size.height)
            .onAppear {
                // Start animation when the view appears
                isAnimating = true
            }
            .accessibilityHidden(true) // Hide from accessibility since it's just a loading placeholder
    }
    
    // MARK: - Private Views
    
    private var skeletonContent: some View {
        Group {
            if case .rectangle = shape {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(effectiveColor)
                    .frame(width: size.width, height: size.height)
                    .applySkeletonAnimation(animation: animation, isAnimating: isAnimating, shimmerColor: effectiveShimmerColor)
            } else if case .square = shape {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(effectiveColor)
                    .frame(width: size.width, height: size.height)
                    .applySkeletonAnimation(animation: animation, isAnimating: isAnimating, shimmerColor: effectiveShimmerColor)
            } else if case .circle = shape {
                Circle()
                    .fill(effectiveColor)
                    .frame(width: size.width, height: size.height)
                    .applySkeletonAnimation(animation: animation, isAnimating: isAnimating, shimmerColor: effectiveShimmerColor)
            } else if case .capsule = shape {
                Capsule()
                    .fill(effectiveColor)
                    .frame(width: size.width, height: size.height)
                    .applySkeletonAnimation(animation: animation, isAnimating: isAnimating, shimmerColor: effectiveShimmerColor)
            } else if case .text(let lines, let lastLineWidth) = shape {
                textSkeleton(lines: lines, lastLineWidth: lastLineWidth)
            }
        }
    }
    
    /// Text skeleton with multiple lines
    private func textSkeleton(lines: Int, lastLineWidth: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            let lineViews = (0..<lines).map { index in
                let lineWidth: CGFloat
                if index == lines - 1 && lastLineWidth < 1.0 {
                    lineWidth = size.width * lastLineWidth
                } else {
                    lineWidth = size.width
                }
                
                return RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(effectiveColor)
                    .frame(width: lineWidth, height: 16)
                    .applySkeletonAnimation(animation: animation, isAnimating: isAnimating, shimmerColor: effectiveShimmerColor)
            }
            
            ForEach(lineViews.indices, id: \.self) { index in
                lineViews[index]
            }
        }
        .frame(width: size.width, alignment: .leading)
    }
    
    // MARK: - Private Properties
    
    /// The effective color of the skeleton
    private var effectiveColor: Color {
        color ?? theme.border.opacity(0.3)
    }
    
    /// The effective shimmer color for shimmer animation
    private var effectiveShimmerColor: Color {
        shimmerColor ?? theme.background
    }
}

// MARK: - Supporting Types

/// The shape of the skeleton
public enum CTSkeletonShape {
    /// Rectangle shape
    case rectangle
    
    /// Square shape
    case square
    
    /// Circle shape
    case circle
    
    /// Capsule shape
    case capsule
    
    /// Text shape with multiple lines
    case text(lines: Int, lastLineWidth: CGFloat)
}

/// The animation style for the skeleton
public enum CTSkeletonAnimation {
    /// Pulsing animation (fade in and out)
    case pulse
    
    /// Shimmer animation (left to right gradient)
    case shimmer
    
    /// No animation
    case none
}

// MARK: - Skeleton Animation View Modifier

/// View modifier for applying skeleton animations
struct SkeletonAnimationModifier: ViewModifier {
    let animation: CTSkeletonAnimation
    let isAnimating: Bool
    let shimmerColor: Color
    
    func body(content: Content) -> some View {
        switch animation {
        case .pulse:
            content
                .opacity(isAnimating ? 0.6 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 1.2)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
        case .shimmer:
            content
                .modifier(ShimmerEffect(isAnimating: isAnimating, shimmerColor: shimmerColor))
        case .none:
            content
        }
    }
}

/// Shimmer effect modifier
struct ShimmerEffect: ViewModifier {
    let isAnimating: Bool
    let shimmerColor: Color
    
    @State private var shimmerOffset: CGFloat = -0.75
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    shimmerColor
                        .opacity(0.7)
                        .mask(
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: .clear, location: 0.0),
                                            .init(color: .white, location: 0.4),
                                            .init(color: .white, location: 0.6),
                                            .init(color: .clear, location: 1.0)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .offset(x: isAnimating ? geometry.size.width : -geometry.size.width)
                        )
                        .animation(
                            Animation.linear(duration: 1.5)
                                .repeatForever(autoreverses: false)
                                .speed(0.7),
                            value: isAnimating
                        )
                        .blendMode(.screen)
                }
            )
    }
}

// MARK: - View Extension

extension View {
    /// Apply skeleton animation
    fileprivate func applySkeletonAnimation(
        animation: CTSkeletonAnimation,
        isAnimating: Bool,
        shimmerColor: Color
    ) -> some View {
        modifier(SkeletonAnimationModifier(
            animation: animation,
            isAnimating: isAnimating,
            shimmerColor: shimmerColor
        ))
    }
}

// MARK: - Previews

struct CTSkeletonLoader_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: CTSpacing.m) {
                Group {
                    Text("Skeleton Shapes").ctHeading2()
                    
                    CTSkeletonLoader(shape: .rectangle)
                        .previewDisplayName("Rectangle")
                    
                    CTSkeletonLoader(shape: .square)
                        .previewDisplayName("Square")
                    
                    CTSkeletonLoader(shape: .circle)
                        .previewDisplayName("Circle")
                    
                    CTSkeletonLoader(shape: .capsule)
                        .previewDisplayName("Capsule")
                }
                
                Group {
                    Text("Text Skeletons").ctHeading2()
                    
                    CTSkeletonLoader(shape: .text(lines: 1, lastLineWidth: 1.0))
                        .previewDisplayName("1 Line Text")
                    
                    CTSkeletonLoader(shape: .text(lines: 3, lastLineWidth: 0.7))
                        .previewDisplayName("3 Line Text")
                    
                    CTSkeletonLoader(shape: .text(lines: 5, lastLineWidth: 0.5))
                        .previewDisplayName("5 Line Text")
                }
                
                Group {
                    Text("Animation Styles").ctHeading2()
                    
                    CTSkeletonLoader(shape: .rectangle, animation: .pulse)
                        .previewDisplayName("Pulse Animation")
                    
                    CTSkeletonLoader(shape: .rectangle, animation: .shimmer)
                        .previewDisplayName("Shimmer Animation")
                    
                    CTSkeletonLoader(shape: .rectangle, animation: .none)
                        .previewDisplayName("No Animation")
                }
                
                Group {
                    Text("Custom Colors").ctHeading2()
                    
                    CTSkeletonLoader(shape: .rectangle, color: .ctPrimary.opacity(0.2))
                        .previewDisplayName("Custom Color")
                    
                    CTSkeletonLoader(
                        shape: .rectangle,
                        animation: .shimmer,
                        color: .ctPrimary.opacity(0.2),
                        shimmerColor: .ctPrimary.opacity(0.3)
                    )
                    .previewDisplayName("Custom Shimmer Color")
                }
                
                Group {
                    Text("Loading Card Example").ctHeading2()
                    
                    HStack(alignment: .top, spacing: 16) {
                        CTSkeletonLoader(shape: .circle, size: CGSize(width: 60, height: 60))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            CTSkeletonLoader(shape: .rectangle, size: CGSize(width: 200, height: 16))
                            CTSkeletonLoader(shape: .rectangle, size: CGSize(width: 120, height: 12))
                            CTSkeletonLoader(shape: .text(lines: 2, lastLineWidth: 0.8))
                        }
                    }
                    .padding()
                    .background(Color.ctSurface)
                    .cornerRadius(12)
                    .previewDisplayName("Loading Card")
                    
                    VStack(spacing: 16) {
                        ForEach(0..<3) { _ in
                            HStack {
                                CTSkeletonLoader(shape: .square, size: CGSize(width: 50, height: 50))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    CTSkeletonLoader(shape: .rectangle, size: CGSize(width: 150, height: 14))
                                    CTSkeletonLoader(shape: .rectangle, size: CGSize(width: 80, height: 10))
                                }
                                
                                Spacer()
                                
                                CTSkeletonLoader(shape: .capsule, size: CGSize(width: 60, height: 24))
                            }
                        }
                    }
                    .padding()
                    .background(Color.ctSurface)
                    .cornerRadius(12)
                    .previewDisplayName("Loading List")
                }
            }
            .padding()
        }
    }
}

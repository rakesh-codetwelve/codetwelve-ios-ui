//
//  CTDeviceUtilities.swift
//  CodetwelveUI
//
//  Created on 26/03/25.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// Utilities for determining device characteristics and environment
///
/// This class provides information about the current device and environment,
/// which can be useful for adapting the UI to different device sizes and contexts.
public enum CTDeviceUtilities {
    /// The current device type
    public static var deviceType: CTDeviceType {
        #if canImport(UIKit)
        let idiom = UIDevice.current.userInterfaceIdiom
        
        switch idiom {
        case .phone:
            return .phone
        case .pad:
            return .pad
        case .mac:
            return .mac
        default:
            return .unknown
        }
        #else
        return .unknown
        #endif
    }
    
    /// Whether the current device is an iPhone
    public static var isPhone: Bool {
        return deviceType == .phone
    }
    
    /// Whether the current device is an iPad
    public static var isPad: Bool {
        return deviceType == .pad
    }
    
    /// Whether the current device is a Mac
    public static var isMac: Bool {
        return deviceType == .mac
    }
    
    /// The current device size class
    public static var deviceSize: CTDeviceSize {
        #if canImport(UIKit)
        let screenWidth = UIScreen.main.bounds.width
        
        if screenWidth <= 375 {
            return .small
        } else if screenWidth <= 428 {
            return .medium
        } else if screenWidth <= 834 {
            return .large
        } else {
            return .extraLarge
        }
        #else
        return .medium
        #endif
    }
    
    /// Whether the current device is a small device (iPhone SE, iPhone 8 size)
    public static var isSmallDevice: Bool {
        return deviceSize == .small
    }
    
    /// Whether the current device supports Dynamic Island
    public static var hasDynamicIsland: Bool {
        #if canImport(UIKit)
        // Check for iPhone 14 Pro and newer models with Dynamic Island
        // This is an approximate check that might need adjustment for future devices
        if isPhone {
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            let maxDimension = max(screenWidth, screenHeight)
            
            // Dynamic Island devices have a screen height of 852 or 932
            return maxDimension >= 852
        }
        #endif
        return false
    }
    
    /// Whether the current device has a home button
    public static var hasHomeButton: Bool {
        #if canImport(UIKit)
        // Devices without a home button have a safe area inset at the bottom
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        
        guard let window = window else {
            return true // Default to true if we can't determine
        }
        
        return window.safeAreaInsets.bottom == 0
        #else
        return true
        #endif
    }
    
    /// The current orientation of the device
    #if canImport(UIKit)
    public static var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    #endif
    
    /// Whether the device is in landscape orientation
    public static var isLandscape: Bool {
        #if canImport(UIKit)
        return orientation.isLandscape
        #else
        return false
        #endif
    }
    
    /// Whether the device is in portrait orientation
    public static var isPortrait: Bool {
        #if canImport(UIKit)
        return orientation.isPortrait
        #else
        return true
        #endif
    }
    
    #if canImport(UIKit)
    /// The current horizontal size class
    public static var horizontalSizeClass: UIUserInterfaceSizeClass {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first else {
            return .unspecified
        }
        
        guard let window = windowScene.windows.first else {
            return .unspecified
        }
        
        return window.traitCollection.horizontalSizeClass
    }
    
    /// The current vertical size class
    public static var verticalSizeClass: UIUserInterfaceSizeClass {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first else {
            return .unspecified
        }
        
        guard let window = windowScene.windows.first else {
            return .unspecified
        }
        
        return window.traitCollection.verticalSizeClass
    }
    #endif
    
    /// Whether the app is running in a compact width environment
    public static var isCompactWidth: Bool {
        #if canImport(UIKit)
        return horizontalSizeClass == .compact
        #else
        return false
        #endif
    }
    
    /// Whether the app is running in a regular width environment
    public static var isRegularWidth: Bool {
        #if canImport(UIKit)
        return horizontalSizeClass == .regular
        #else
        return true
        #endif
    }
    
    /// Get the safe area insets of the current window
    public static var safeAreaInsets: EdgeInsets {
        #if canImport(UIKit)
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first else {
            return EdgeInsets()
        }
        
        guard let window = windowScene.windows.first else {
            return EdgeInsets()
        }
        
        let insets = window.safeAreaInsets
        return EdgeInsets(
            top: insets.top,
            leading: insets.left,
            bottom: insets.bottom,
            trailing: insets.right
        )
        #else
        return EdgeInsets()
        #endif
    }
}

/// The type of device the app is running on
public enum CTDeviceType {
    /// iPhone
    case phone
    
    /// iPad
    case pad
    
    /// Mac
    case mac
    
    /// Unknown device type
    case unknown
}

/// The size class of the current device
public enum CTDeviceSize {
    /// Small device (e.g., iPhone SE, iPhone 8)
    case small
    
    /// Medium device (e.g., iPhone X, iPhone 11, iPhone 12)
    case medium
    
    /// Large device (e.g., iPhone Plus, iPad mini)
    case large
    
    /// Extra large device (e.g., iPad Pro)
    case extraLarge
}
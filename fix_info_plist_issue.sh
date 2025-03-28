#!/bin/bash

echo "Cleaning DerivedData folder..."
rm -rf ~/Library/Developer/Xcode/DerivedData/CodeTwelve-iOS-UIKit-*

echo "Ensuring Info.plist file is removed from Examples directory..."
rm -f Examples/CodeTwelveExamples/Info.plist

echo "Cleaning project..."
xcodebuild clean -project CodeTwelve-iOS-UIKit.xcodeproj -scheme CodeTwelveExamples

echo "Done. Please try building the project in Xcode now." 
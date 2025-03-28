#!/bin/bash

# Clean up
echo "Cleaning DerivedData folder..."
rm -rf ~/Library/Developer/Xcode/DerivedData/CodeTwelve-iOS-UIKit-*
rm -rf ~/Library/Developer/Xcode/DerivedData/CodetwelveUI-*

echo "Removing any existing Info.plist file from Examples directory..."
rm -f Examples/CodeTwelveExamples/Info.plist

echo "Updating project.yml to exclude Info.plist from build..."
cat > project.yml << EOF
name: CodetwelveUI
options:
  bundleIdPrefix: com.codetwelve
  deploymentTarget:
    iOS: 16.0
  indentWidth: 2
  tabWidth: 2
packages: {}

targets:
  CodetwelveUI:
    type: framework
    platform: iOS
    deploymentTarget: "16.0"
    sources:
      - path: Sources/CodetwelveUI
        excludes:
          - "**/.gitkeep"
          - "**/.DS_Store"
    resources:
      - path: Sources/CodetwelveUI/Resources
        excludes:
          - "**/.gitkeep"
          - "**/.DS_Store"
    settings:
      base:
        PRODUCT_BUNDLE_IDENTIFIER: com.codetwelve.CodetwelveUI
        MARKETING_VERSION: 1.0.0
        CURRENT_PROJECT_VERSION: 1
        GENERATE_INFOPLIST_FILE: YES
        SWIFT_OPTIMIZATION_LEVEL: "-Onone"
        SWIFT_TREAT_WARNINGS_AS_ERRORS: NO
    postBuildScripts:
      - name: "Remove .gitkeep files"
        script: "find \"\${BUILT_PRODUCTS_DIR}/\${FRAMEWORKS_FOLDER_PATH}/CodetwelveUI.framework\" -name '.gitkeep' -delete || true"
        outputFiles:
          - "\$(DERIVED_FILE_DIR)/gitkeep_removed"
    scheme:
      testTargets:
        - CodetwelveUITests
      gatherCoverageData: true

  CodetwelveUITests:
    type: bundle.unit-test
    platform: iOS
    deploymentTarget: "16.0"
    sources:
      - path: Tests/CodetwelveUITests
    dependencies:
      - target: CodetwelveUI
    settings:
      base:
        PRODUCT_BUNDLE_IDENTIFIER: com.codetwelve.CodetwelveUITests
        GENERATE_INFOPLIST_FILE: YES
        SWIFT_TREAT_WARNINGS_AS_ERRORS: NO

  CodeTwelveExamples:
    type: application
    platform: iOS
    deploymentTarget: "16.0"
    sources:
      - path: Examples/CodeTwelveExamples
        excludes:
          - "**/Info.plist"
          - "**/.DS_Store"
    dependencies:
      - target: CodetwelveUI
    settings:
      base:
        PRODUCT_BUNDLE_IDENTIFIER: com.codetwelve.CodeTwelveExamples
        MARKETING_VERSION: 1.0.0
        CURRENT_PROJECT_VERSION: 1
        GENERATE_INFOPLIST_FILE: YES
        SWIFT_OPTIMIZATION_LEVEL: "-Onone"
        SWIFT_TREAT_WARNINGS_AS_ERRORS: NO
        INFOPLIST_KEY_UIApplicationSceneManifest_Generation: YES
        INFOPLIST_KEY_UILaunchScreen_Generation: YES
        INFOPLIST_FILE_OUTPUT_FORMAT: binary

schemes:
  CodetwelveUI:
    build:
      targets:
        CodetwelveUI: all
    test:
      targets:
        - CodetwelveUITests
      gatherCoverageData: true

  CodeTwelveExamples:
    build:
      targets:
        CodeTwelveExamples: all
    run:
      config: Debug
EOF

echo "Regenerating Xcode project..."
if command -v xcodegen &> /dev/null; then
    xcodegen
else
    echo "Warning: xcodegen not found. Please install it using 'brew install xcodegen' and run it manually."
fi

echo "Done. Please try building the project in Xcode now." 
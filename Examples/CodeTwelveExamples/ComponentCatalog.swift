//
//  ComponentCatalog.swift
//  CodeTwelveExamples
//
//  Created on 26/03/25.
//

import SwiftUI
import CodetwelveUI
import Foundation

// MARK: - Component Model

/// A model representing a navigation component with a name and destination
struct Component: Identifiable {
    var id = UUID()
    var name: String
    var destination: AnyView
    
    init(name: String, destination: some View) {
        self.name = name
        self.destination = AnyView(destination)
    }
}

// MARK: - ComponentCatalog View

/// A view that displays a categorized list of components
struct ComponentCatalog: View {
    // MARK: - Properties
    
    private let basicComponents = [
        Component(name: "Button", destination: ButtonExamples()),
        Component(name: "Text", destination: TextExamples()),
        Component(name: "Icon", destination: IconExamples()),
        Component(name: "Divider", destination: DividerExamples())
    ]
    
    // Use placeholders for components that are still being integrated
    private let layoutComponents = [
        Component(name: "Card", destination: CardExamples()),
        Component(name: "Container", destination: ContainerExamples()),
        Component(name: "Stack", destination: StackExamples()),
        Component(name: "Grid", destination: GridExamples()),
        Component(name: "Accordion", destination: AccordionExamples()),
        Component(name: "Aspect Ratio", destination: Text("Aspect Ratio Examples").padding()),
        Component(name: "Scroll Area", destination: Text("Scroll Area Examples").padding())
    ]
    
    private let formComponents = [
        Component(name: "Text Field", destination: TextFieldExamples()),
        Component(name: "Text Area", destination: Text("Text Area Examples").padding()),
        Component(name: "Checkbox", destination: CheckboxExamples()),
        Component(name: "Radio Group", destination: RadioGroupExamples()),
        Component(name: "Select", destination: SelectExamples()),
        Component(name: "Slider", destination: Text("Slider Examples").padding()),
        Component(name: "Switch", destination: ToggleExamples())
    ]
    
    // MARK: - Navigation Components
    private let navigationComponents = [
        Component(name: "Popover", destination: PopoverExamples()),
        Component(name: "Command Palette", destination: CommandPaletteExamples()),
        Component(name: "Pagination", destination: PaginationExamples()),
        Component(name: "Drawer", destination: DrawerExamples()),
        Component(name: "Navigation Menu", destination: NavigationMenuExamples()),
        Component(name: "Tab Bar", destination: TabBarExamples())
    ]
    
    // MARK: - Feedback Components
    var feedbackComponents: [Component] {
        [
            Component(name: "Toast", destination: ToastExamples()),
            Component(name: "Badge", destination: BadgeExamples()),
            Component(name: "Alert", destination: AlertExamples()),
            Component(name: "Progress", destination: ProgressExamples()),
            Component(name: "Skeleton", destination: SkeletonLoaderExamples()),
        ]
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            List {
                sectionView(title: "Basic Components", components: basicComponents)
                sectionView(title: "Layout Components", components: layoutComponents)
                sectionView(title: "Form Components", components: formComponents)
                sectionView(title: "Navigation Components", components: navigationComponents)
                sectionView(title: "Feedback Components", components: feedbackComponents)
                
                Section(header: Text("Theme")) {
                    NavigationLink("Theme Explorer", destination: ThemeExplorer())
                }
            }
            .navigationTitle("Codetwelve UI")
            .listStyle(InsetGroupedListStyle())
        }
    }
    
    // MARK: - Private Views
    
    /// Creates a section view with a title and list of components
    private func sectionView(title: String, components: [Component]) -> some View {
        Section(header: Text(title)) {
            ForEach(components) { component in
                NavigationLink(component.name, destination: component.destination)
            }
        }
    }
}

struct ComponentCatalog_Previews: PreviewProvider {
    static var previews: some View {
        ComponentCatalog()
    }
}
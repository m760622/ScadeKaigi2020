import ScadeKit

// MARK: - Extension

extension EObject {
    
    /* Description
     
     you can cast for target class
     
     */
    
    var asLabel: SCDWidgetsLabel? {
        return self as? SCDWidgetsLabel
    }
    
    var asImage: SCDWidgetsImage? {
        return self as? SCDWidgetsImage
    }
    
    var asButton: SCDWidgetsButton? {
        return self as? SCDWidgetsButton
    }
    
    var asList: SCDWidgetsList? {
        return self as? SCDWidgetsList
    }
    
    var asListView: SCDWidgetsListView? {
        return self as? SCDWidgetsListView
    }
    
    var asRow: SCDWidgetsRowView? {
        return self as? SCDWidgetsRowView
    }
    
    var asContainer: SCDWidgetsContainer? {
        return self as? SCDWidgetsContainer
    }
    
    var asGridData: SCDLayoutGridData? {
        return self as? SCDLayoutGridData
    }
    
    var asToolBarItem: SCDWidgetsToolBarItem? {
        return self as? SCDWidgetsToolBarItem
    }
    
    var asSideBar: SCDWidgetsSidebar? {
        return self as? SCDWidgetsSidebar
    }
    
    var asWebView: SCDWidgetsWebView? {
        return self as? SCDWidgetsWebView
    }
    
    var asClikable: SCDWidgetsClickable? {
        return self as? SCDWidgetsClickable
    }
    
    
    /* example
     
     let list: SCDWidgetsListView
     let row = list.children.first?.cast(for: SCDWidgetsRowView.self)
     
     */
    func cast<T: SCDWidgetsWidget>(for: T.Type) -> T? {
        return self as? T
    }
}

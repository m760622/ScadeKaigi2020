import ScadeKit

// MARK: - Delegate

protocol TimeTablePageDelegate: SCDLatticePageAdapter {
    func onSearchClicked()
    func onMenuClicked()
    func onMenuItemClicked(by type: Constants.PageType)
    func onTabClicked(by type: TimeTablePageType)
    func onItemSelected(with event: SCDWidgetsItemEvent?)
    func onTagSelected(with event: SCDWidgetsEvent?, at index: Int)
}

// MARK: - View

final class TimeTablePageView {
    
    // MARK: Properties
    
    var tabItems: [SCDWidgetsToolBarItem]
    var tabHandler: [SCDWidgetsEventHandler] = []
    weak var adapter: TimeTablePageAdapter?
    weak var timeTablePageDelegate: TimeTablePageDelegate?
    
    lazy var dataSource = from(timeTableList).dataSource.cast([Sessions].self)
    lazy var bindableItem = from(timeTableList).items
    lazy var row = from(timeTableList).rows.cast(TimeTablePageListElement.self)
    
    
    // MARK: Widgets
    
    private lazy var searchButton: SCDWidgetsButton! = {
        let btn = adapter?.page?.getWidgetByName("searchButton")?.asButton
        btn?.onClick.append(SCDWidgetsEventHandler { [weak self] event in
            self?.timeTablePageDelegate?.onSearchClicked()
        })
        return btn
    }()
    
    private lazy var menuButton: SCDWidgetsButton! = {
        let btn = adapter?.page?.getWidgetByName("menuButton")?.asButton
        btn?.onClick.append(SCDWidgetsEventHandler { [weak self] event in
            self?.timeTablePageDelegate?.onMenuClicked()
        })
        return btn
    }()
    
    private lazy var timeTableList: SCDWidgetsList! = {
        let list = adapter?.page?.getWidgetByName("timeTableList")?.asList
        list?.onItemSelected.append(SCDWidgetsItemSelectedEventHandler { [weak self] event in
            self?.timeTablePageDelegate?.onItemSelected(with: event)
        })
        return list
    }()
    
    private lazy var sidebar: SCDWidgetsSidebar! = {
        let bar = adapter?.page?.getWidgetByName("sidebar")?.asSideBar
        
        let homeMenu = bar?.panel?.getWidgetByName("homeMenuButton")?.asClikable
        homeMenu?.onClick.append(SCDWidgetsEventHandler{ [weak self] _ in 
            self?.timeTablePageDelegate?.onMenuItemClicked(by: .timeTable)
        })
        let aboutMenu = bar?.panel?.getWidgetByName("aboutMenuButton")?.asClikable
        aboutMenu?.onClick.append(SCDWidgetsEventHandler{ [weak self] _ in 
            self?.timeTablePageDelegate?.onMenuItemClicked(by: .about)
        })
        let infoMenu = bar?.panel?.getWidgetByName("infoMenuButton")?.asClikable
        infoMenu?.onClick.append(SCDWidgetsEventHandler{ [weak self] _ in 
            self?.timeTablePageDelegate?.onMenuItemClicked(by: .info)
        })
        let mapMenu = bar?.panel?.getWidgetByName("mapMenuButton")?.asClikable
        mapMenu?.onClick.append(SCDWidgetsEventHandler{ [weak self] _ in 
            self?.timeTablePageDelegate?.onMenuItemClicked(by: .map)
        })
        let sponsorMenu = bar?.panel?.getWidgetByName("sponsorMenuButton")?.asClikable
        sponsorMenu?.onClick.append(SCDWidgetsEventHandler{ [weak self] _ in 
            self?.timeTablePageDelegate?.onMenuItemClicked(by: .sponsor)
        })  
        let contributorsMenu = bar?.panel?.getWidgetByName("contributorsMenuButton")?.asClikable
        contributorsMenu?.onClick.append(SCDWidgetsEventHandler{ [weak self] _ in 
            self?.timeTablePageDelegate?.onMenuItemClicked(by: .contributors)
        })
        let settingsMenu = bar?.panel?.getWidgetByName("settingsMenuButton")?.asClikable
        settingsMenu?.onClick.append(SCDWidgetsEventHandler{ [weak self] _ in 
            self?.timeTablePageDelegate?.onMenuItemClicked(by: .setting)
        })
        let questionnaireMenu = bar?.panel?.getWidgetByName("questionnaireMenuButton")?.asClikable
        questionnaireMenu?.onClick.append(SCDWidgetsEventHandler{ [weak self] _ in 
            self?.timeTablePageDelegate?.onMenuItemClicked(by: .questionnaire)
        })
        return bar
    }()
    
    
    // MARK: Initializer
    
    init(adapter: TimeTablePageAdapter?) {
        self.adapter = adapter
        self.tabItems = TimeTablePageType.allCases.compactMap { 
            adapter?.page?.getWidgetByName($0.tabItem)?.asToolBarItem
        }
        self.tabHandler = TimeTablePageType.allCases.compactMap { type in
            SCDWidgetsEventHandler{ [weak self] _ in
                self?.timeTablePageDelegate?.onTabClicked(by: type)
            }
        }
        
        /// todo access widgets
        searchButton.isVisible = true
        menuButton.isVisible = true
        sidebar.isHidden = true
    }
    
    deinit {
        adapter = nil
        timeTablePageDelegate = nil
    }
}


// MARK: - Internal

extension TimeTablePageView {
    
    func appendOnTabClick() {
        DispatchQueue.global().async {
            self.tabItems.enumerated().forEach { index, item in
                item.onClick.append(self.tabHandler[index])
            }
        }
    }
    
    func removeOnTabClick() {
        DispatchQueue.global().async {
            self.tabItems.forEach { item in
                item.onClick.removeAll()
            }
        }
    }
    
    func appendOnTagClick() {
        DispatchQueue.global().async {
            self.timeTableList.elements.enumerated().forEach { i, wrapper in
                let image = wrapper.children.first?.asRow?.children[2].asImage
                image?.onClick.removeAll() // have to reset case of android keeping previous event
                image?.onClick.append(SCDWidgetsEventHandler { [weak self] e in
                    self?.timeTablePageDelegate?.onTagSelected(with: e, at: i)
                })
            }
        }
    }
    
    func setSidebar(isHidden: Bool? = nil) {   		
        if let isHidden = isHidden {
            sidebar.isHidden = isHidden
        } else {
            sidebar.isHidden.toggle()
        }
    }
}

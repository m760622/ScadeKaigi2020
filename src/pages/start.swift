import ScadeKit

// MARK: - Application

final class ScadeKaigi2020: SCDApplication {
	
		// MARK: Properties
    
    private let window = SCDLatticeWindow()
    
    private lazy var timeTableAdapter: TimeTablePageAdapter = {
        let service: TimetableService? = SCDRuntime.loadService("TimetableService.service")
        guard let result = service?.getTimetable() else { fatalError() } // todo
        
        let adapter = TimeTablePageAdapter(timetable: TimetableEntity(result),  pageType: .dayOne)
        return adapter
    }()
    
    private lazy var speakersListAdapter: SpeakersListPageAdapter = {
        let adapter = SpeakersListPageAdapter()
        return adapter
    }()
    
    private lazy var profileAdapter: ProfilePageAdapter = {
        let adapter = ProfilePageAdapter()
        return adapter
    }()
    
    
    // MARK: Overrides
    
    override func onFinishLaunching() {	
        debugPrint("---\(#function)---")
        
        timeTableAdapter.load(type: .timeTable)
        speakersListAdapter.load(type: .speckersList)
        profileAdapter.load(type: .profile)
        
        timeTableAdapter.show(window)
    }
}


// MARK: - iOS

#if os(iOS) 

import UIKit 

extension SCDApplication {
		static var rootViewController: UIViewController? {
				get {
						return UIApplication.shared.delegate?.window??.rootViewController
				}
		}
}
#endif
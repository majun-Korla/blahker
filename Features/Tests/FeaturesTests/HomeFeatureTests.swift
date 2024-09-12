import ComposableArchitecture
@testable import Features
import XCTest

@MainActor
final class HomeFeatureTests: XCTestCase {
    func testAppLaunch_userHaventEnableContentBlocker() async throws {
        let store = TestStore(initialState: HomeFeature.State(), reducer: { HomeFeature() })
        {
            $0.contentBlockerService.checkUserEnableContenBlocker = { _ in false }
        }
        
        await store.send(.scenePhaseBecomeActive)
        await store.receive(.userEnableContentBlocker(false))
        
    }
    
    func testAppLaunch_userAlreadyEnableContentBlocker() async throws {
        let store = TestStore(initialState: HomeFeature.State(), reducer: { HomeFeature() })
        {
            $0.contentBlockerService.checkUserEnableContenBlocker = { _ in true }

        }
        
        await store.send(.scenePhaseBecomeActive)
        await store.receive(.userEnableContentBlocker(true)) {
            $0.isEnabledContentBlocker = true
        }
        
    }
    
    func testAppLaunch_userHaventEnableContentBlocker_laterEnabled() async throws {
        let store = TestStore(initialState: HomeFeature.State(), reducer: { HomeFeature() })
        {
            $0.contentBlockerService.checkUserEnableContenBlocker = { _ in false }
        }
        
        await store.send(.scenePhaseBecomeActive)
        await store.receive(.userEnableContentBlocker(false))
        
        store.dependencies.contentBlockerService.checkUserEnableContenBlocker = { _ in true }
        await store.send(.scenePhaseBecomeActive)
        await store.receive(.userEnableContentBlocker(true)) {
            $0.isEnabledContentBlocker = true
        }
        
    }
    
    func testAlert_rate5Star_openAppstoreURL() async throws {
//        let store = TestStore(initialState: HomeFeature.State(), reducer: { HomeFeature() })
//        {
//            $0.openURL = .init(handler: { url in
//                XCTAssertEqual(url,
//                               URL(string: "https://apps.apple.com/cn/app/blahker-%E5%B7%B4%E6%8B%89%E5%89%8B/id1482371114?mt=12")!
//                )
//                
//                
//            })
//        }
//        await store.send(.tapDontTapMeButton)
//        
//        await store.send(.alert(.presented(.rateStar))) {
//            $0.alert = nil
        }
        
    }
    
}

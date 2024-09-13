import ComposableArchitecture
@testable import Features
import XCTest

@MainActor
final class HomeFeatureTests: XCTestCase {
   
     

 
    func testAppBecomeActivity_userHaventEnableContentBlocker() async throws {
        let store = TestStore(initialState: HomeFeature.State(), reducer: { HomeFeature() }) {
            $0.contentBlockerService.checkUserEnableContenBlocker = { _ in false }
        }
        
        await store.send(.scenePhaseBecomeActive)
        await store.receive(.userEnableContentBlocker(false)) {
            $0.alert = .pleaseEnableContentBlockerAlert
        }
    }
    
    func testAppBecomeActivity_userAlreadyEnableContentBlocker() async throws {
        let store = TestStore(initialState: HomeFeature.State(), reducer: { HomeFeature() }) {
            $0.contentBlockerService.checkUserEnableContenBlocker = { _ in true }
        }
        
        await store.send(.scenePhaseBecomeActive)
        await store.receive(.userEnableContentBlocker(true)) {
            $0.isEnabledContentBlocker = true
            $0.alert = .updateSuccessAlert

        }
    }
    
    func testAppBecomeActivity_userHaventEnableContentBlocker_laterEnabled() async throws {
        let store = TestStore(initialState: HomeFeature.State(), reducer: { HomeFeature() }) {
            $0.contentBlockerService.checkUserEnableContenBlocker = { _ in false }
        }
        
        await store.send(.scenePhaseBecomeActive)
        await store.receive(.userEnableContentBlocker(false)) {
            $0.alert = .pleaseEnableContentBlockerAlert
        }
        
        store.dependencies.contentBlockerService.checkUserEnableContenBlocker = { _ in true }
        await store.send(.scenePhaseBecomeActive)
        await store.receive(.userEnableContentBlocker(true)) {
            $0.isEnabledContentBlocker = true
            $0.alert = .updateSuccessAlert

        }
    }
    
    func testTapRefreshButton_userHaventEnableContentBlocker() async throws {
        let store = TestStore(initialState: HomeFeature.State(), reducer: { HomeFeature() }) {
            $0.contentBlockerService.checkUserEnableContenBlocker = { _ in false }
        }
        
        await store.send(.tapRefreshButton)
        await store.receive(.userEnableContentBlocker(false)) {
            $0.alert = .pleaseEnableContentBlockerAlert
        }
        await store.send(.alert(.presented(.okToReload))){
            $0.alert = nil

        }
        await store.receive(.userEnableContentBlocker(false)) {
            $0.alert = .pleaseEnableContentBlockerAlert
        }
        
        store.dependencies.contentBlockerService.checkUserEnableContenBlocker = { _ in true}
        
        await store.send(.alert(.presented(.okToReload))){
            $0.alert = nil

        }
        await store.receive(.userEnableContentBlocker(true)) {
            $0.isEnabledContentBlocker = true
            $0.alert = .updateSuccessAlert
        }

    }


    
    func testAlert_rate5Star_openAppstoreURL() async throws {
        let openURLExp = XCTestExpectation(description: "openURL")
        let store = TestStore(initialState: HomeFeature.State(), reducer: { HomeFeature() }) {
            $0.openURL = .init(handler: { url in
                XCTAssertEqual(url, URL(string: "https://apps.apple.com/cn/app/blahker-%E5%B7%B4%E6%8B%89%E5%89%8B/id1482371114?mt=12")!)
               
                openURLExp.fulfill()
                return true
                
            })
        }
        await store.send(.tapDontTapMeButton) {
            $0.alert = .donateAlert
        }
        
        await store.send(.alert(.presented(.rateStar))) {
            $0.alert = nil
        }
        
    }
}

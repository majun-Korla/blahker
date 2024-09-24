import ComposableArchitecture
@testable import Features
import XCTest

@MainActor
final class HomeFeatureTests: XCTestCase {
    func testAppBecomeActivity_userHaventEnableContentBlocker() async throws {
        let store = TestStore(initialState: HomeFeature.State(isAppLaunch: false), reducer: { HomeFeature() }) {
            $0.contentBlockerService.checkUserEnableContenBlocker = { _ in false }
            $0.contentBlockerService.reloadUserEnableContentBlocker = {
                _ in
                XCTFail("User havent enable blocker, should not run here.")
            }
        }
        
        await store.send(.scenePhaseBecomeActive) {
            $0.isCheckingBlockerlist = true
        }
        await store.receive(\.userEnableContentBlocker, false) {
            $0.isCheckingBlockerlist = false
            $0.alert = .pleaseEnableContentBlockerAlert
        }
    }
    
    func testAppLaunch_userAlreadyEnableContentBlocker() async throws {
//        let relaodContentBlockerExp = XCTestExpectation(description: "reloadContentBlocker")
        var reloadContentBlocker = false
        let store = TestStore(initialState: HomeFeature.State(isAppLaunch: true, isEnabledContentBlocker: false), reducer: { HomeFeature() }) {
            $0.contentBlockerService.checkUserEnableContenBlocker = {
                _ in
                do {
                    try await Task.sleep(for: .seconds(1))
                }
                catch {
                    print("try error->\(error)")
                }
                return true
            }
            $0.contentBlockerService.reloadUserEnableContentBlocker = {
                _ in
                reloadContentBlocker = true
//                relaodContentBlockerExp.fulfill()
            }
        }
        
        await store.send(.appDidFinishLaunching)
        {
            $0.isCheckingBlockerlist = true
        }
        await store.send(.scenePhaseBecomeActive)
        await store.receive(\.userEnableContentBlocker, true) {
            $0.isEnabledContentBlocker = true
            $0.isAppLaunch = false
            $0.isCheckingBlockerlist = false
        }
        XCTAssert(reloadContentBlocker)
//        await fulfillment(of: [relaodContentBlockerExp])
    }
     
    
    
    func testAppBecomeActivity_userAlreadyEnableContentBlocker() async throws {
        let store = TestStore(initialState: HomeFeature.State(isAppLaunch: false, isEnabledContentBlocker: true), reducer: { HomeFeature() }) {
            $0.contentBlockerService.checkUserEnableContenBlocker = { _ in true }
            $0.contentBlockerService.reloadUserEnableContentBlocker = { _ in }
        }
        
        await store.send(.scenePhaseBecomeActive)
        {
            $0.isCheckingBlockerlist = true
        }
        await store.receive(.userEnableContentBlocker(true)) {
            $0.isCheckingBlockerlist = false
        }
    }
    
    func testAppBecomeActivity_userHaventEnableContentBlocker_laterEnabled() async throws {
        let store = TestStore(initialState: HomeFeature.State(isAppLaunch: false), reducer: { HomeFeature() }) {
            $0.contentBlockerService.checkUserEnableContenBlocker = { _ in false }
            $0.contentBlockerService.reloadUserEnableContentBlocker = { _ in }
        }
        
        await store.send(.scenePhaseBecomeActive)
        {
            $0.isCheckingBlockerlist = true
        }
        await store.receive(\.userEnableContentBlocker, false) {
            $0.alert = .pleaseEnableContentBlockerAlert
            $0.isCheckingBlockerlist = false
        }
        
        store.dependencies.contentBlockerService.checkUserEnableContenBlocker = { _ in true }
        await store.send(.scenePhaseBecomeActive)
        {
            $0.isCheckingBlockerlist = true
        }
        await store.receive(.userEnableContentBlocker(true)) {
            $0.isEnabledContentBlocker = true
            $0.alert = .updateSuccessAlert
            $0.isCheckingBlockerlist = false

        }
    }
    
    func testTapRefreshButton_userHaventEnableContentBlocker_laterEnable() async throws {
        var isCheckingBlockerlist = 0
        let store = TestStore(initialState: HomeFeature.State(isAppLaunch: false), reducer: { HomeFeature() }) {
            $0.contentBlockerService.checkUserEnableContenBlocker = { _ in
                isCheckingBlockerlist += 1
                return false }
            $0.contentBlockerService.reloadUserEnableContentBlocker = { _ in }

        }
        
        await store.send(.tapRefreshButton)
        {
            $0.isCheckingBlockerlist = true
        }
        await store.receive(\.manullyUserEnableContentBlocker, false) {
            $0.alert = .pleaseEnableContentBlockerAlert
            $0.isCheckingBlockerlist = false

        }
        //later enable
        store.dependencies.contentBlockerService.checkUserEnableContenBlocker = { _ in
            isCheckingBlockerlist += 1
            return true }
        await store.send(.scenePhaseBecomeActive)
        {
            $0.isCheckingBlockerlist = true
        }
        await store.receive(.userEnableContentBlocker(true)) {
            $0.isEnabledContentBlocker = true
            $0.alert = .updateSuccessAlert
            $0.isCheckingBlockerlist = false
            
        }
        
        
//        await store.send(.alert(.presented(.okToReload))) {
        await store.send(\.alert.presented.okToReload) {

            $0.alert = nil
            $0.isCheckingBlockerlist = true

            
        }
        await store.receive(.manullyUserEnableContentBlocker(true)) {
            $0.alert = .updateSuccessAlert
            $0.isCheckingBlockerlist = false

        }
        XCTAssertEqual(isCheckingBlockerlist, 3)


    }

    func testTapRefreshButton_userAlreadyEnableContentBlocker() async throws {
        var initialState = HomeFeature.State(isAppLaunch: false)
        initialState.isEnabledContentBlocker = true
        
        let store = TestStore(initialState: initialState, reducer: { HomeFeature() }) {
            $0.contentBlockerService.checkUserEnableContenBlocker = { _ in true }
            $0.contentBlockerService.reloadUserEnableContentBlocker = { _ in }

        }
        
        await store.send(.tapRefreshButton)
        {
            $0.isCheckingBlockerlist = true
        }
        await store.receive(.manullyUserEnableContentBlocker(true)) {
            $0.alert = .updateSuccessAlert
            $0.isCheckingBlockerlist = false

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
        
        await store.send(\.alert.presented.rateStar) {
            $0.alert = nil
        }
    }
}

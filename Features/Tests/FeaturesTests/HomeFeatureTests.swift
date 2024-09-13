import ComposableArchitecture
@testable import Features
import XCTest

@MainActor
final class HomeFeatureTests: XCTestCase {
    static let pleaseEnableContentBlockerAlert = AlertState<HomeFeature.Action.Alert>(title: {
                                                                TextState("請開啟內容阻擋器")

                                                            },
                                                            actions: { ButtonState(role: .cancel) {
                                                                TextState("取消")
                                                            }
                                                            ButtonState(action: .okToReload) {
                                                                TextState("確定")
                                                            }
                                                            },
                                                            message: { TextState("請打開「設定」 > 「Safari」 > 「內容阻擋器」，並啟用 Blahker") })
     
//    AlertState {
//        TextState("請開啟內容阻擋器")
//    } actions: {
//        ButtonState(role: .cancel) {
//            TextState("取消")
//        }
//        ButtonState(action: .smallDonation) {
//            TextState("確定")
//        }
//
//    } message: {
//        TextState("請打開「設定」 > 「Safari」 > 「內容阻擋器」，並啟用 Blahker")
//    }
    
    func testAppBecomeActivity_userHaventEnableContentBlocker() async throws {
        let store = TestStore(initialState: HomeFeature.State(), reducer: { HomeFeature() }) {
            $0.contentBlockerService.checkUserEnableContenBlocker = { _ in false }
        }
        
        await store.send(.scenePhaseBecomeActive)
        await store.receive(.userEnableContentBlocker(false)) {
            $0.alert = Self.pleaseEnableContentBlockerAlert
        }
    }
    
    func testAppBecomeActivity_userAlreadyEnableContentBlocker() async throws {
        let store = TestStore(initialState: HomeFeature.State(), reducer: { HomeFeature() }) {
            $0.contentBlockerService.checkUserEnableContenBlocker = { _ in true }
        }
        
        await store.send(.scenePhaseBecomeActive)
        await store.receive(.userEnableContentBlocker(true)) {
            $0.isEnabledContentBlocker = true
        }
    }
    
    func testAppBecomeActivity_userHaventEnableContentBlocker_laterEnabled() async throws {
        let store = TestStore(initialState: HomeFeature.State(), reducer: { HomeFeature() }) {
            $0.contentBlockerService.checkUserEnableContenBlocker = { _ in false }
        }
        
        await store.send(.scenePhaseBecomeActive)
        await store.receive(.userEnableContentBlocker(false)) {
            $0.alert = Self.pleaseEnableContentBlockerAlert
        }
        
        store.dependencies.contentBlockerService.checkUserEnableContenBlocker = { _ in true }
        await store.send(.scenePhaseBecomeActive)
        await store.receive(.userEnableContentBlocker(true)) {
            $0.isEnabledContentBlocker = true
        }
    }
    
    func testTapRefreshButton_userHaventEnableContentBlocker() async throws {
        let store = TestStore(initialState: HomeFeature.State(), reducer: { HomeFeature() }) {
            $0.contentBlockerService.checkUserEnableContenBlocker = { _ in false }
        }
        
        await store.send(.tapRefreshButton)
        await store.receive(.userEnableContentBlocker(false)) {
            $0.alert = Self.pleaseEnableContentBlockerAlert
        }
        await store.send(.alert(.presented(.okToReload)))
    }

    func testTapRefreshButton_userAlreadyEnableContentBlocker() async throws {
        
        
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
            $0.alert = AlertState {
                TextState("支持開發者")
            } actions: {
                ButtonState(role: .cancel) {
                    TextState("取消")
                }
                ButtonState(action: .smallDonation) {
                    TextState("打賞小小費")
                }
                ButtonState(action: .mediumDonation) {
                    TextState("打賞小費")
                }
                ButtonState(action: .largeDonation) {
                    TextState("破費")
                }
                ButtonState(action: .rateStar) {
                    TextState("我不出錢，給個五星評分總行了吧")
                }
                
            } message: {
                TextState("Blahker 的維護包含不斷更新擋廣告清單。如果有你的支持一定會更好～")
            }
        }
        
        await store.send(.alert(.presented(.rateStar))) {
            $0.alert = nil
        }
    }
}

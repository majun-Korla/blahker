import ComposableArchitecture
@testable import Features
import XCTest

@MainActor
final class AppFeatureTests: XCTestCase {
    func testAppLaunch_userHaventEnableContentBlocker() async throws {
        let store = TestStore(initialState: AppFeature.State(), reducer: { AppFeature() })
        {
            $0.contentBlockerService.checkUserEnableContenBloacker = { _ in false }
        }
        
        await store.send(.scenePhaseBecomeActive)
        await store.receive(.checkUserEnableContentBlocker)
        await store.receive(.userEnableContentBlocker(false))
        
    }
    
    func testAppLaunch_userAlreadyEnableContentBlocker() async throws {
        let store = TestStore(initialState: AppFeature.State(), reducer: { AppFeature() })
        {
            $0.contentBlockerService.checkUserEnableContenBloacker = { _ in true }

        }
        
        await store.send(.scenePhaseBecomeActive)
        await store.receive(.checkUserEnableContentBlocker)
        await store.receive(.userEnableContentBlocker(true)) {
            $0.isEnabledContentBlocker = true
        }
        
    }
    
    func testAppLaunch_userHaventEnableContentBlocker_laterEnabled() async throws {
        let store = TestStore(initialState: AppFeature.State(), reducer: { AppFeature() })
        {
            $0.contentBlockerService.checkUserEnableContenBloacker = { _ in false }
        }
        
        await store.send(.scenePhaseBecomeActive)
        await store.receive(.checkUserEnableContentBlocker)
        await store.receive(.userEnableContentBlocker(false))
        
        store.dependencies.contentBlockerService.checkUserEnableContenBloacker = { _ in true }
        await store.send(.scenePhaseBecomeActive)
        await store.receive(.checkUserEnableContentBlocker)
        await store.receive(.userEnableContentBlocker(true)) {
            $0.isEnabledContentBlocker = true
        }
        
    }
    
}

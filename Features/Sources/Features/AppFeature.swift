import ComposableArchitecture
import SwiftUI

@main

struct BlahkuerApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(store: Store(initialState: AppFeature.State(), reducer: {
                AppFeature()
            }))
        }
    }
}

@Reducer
struct AppFeature {
    struct State: Equatable {}

    enum Action: Equatable {
        case scenePhaseBecomeActive
        case checkUserEnableContentBlocker
        case userEnableContentBlocker(Bool)
    }

    @Dependency(\.safariService) var safariService
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .scenePhaseBecomeActive:
            return .send(.checkUserEnableContentBlocker)
        
        case .checkUserEnableContentBlocker:
            return .run { send in
                let extensionID = "com.elaborapp.Blahker.ContentBlocker"

                let isEnabled = await safariService.checkUserEnableContenBloacker(extensionID)
                await send(.userEnableContentBlocker(isEnabled))
            }
        
        case .userEnableContentBlocker(let bool):
            return .none
        }
    }
}

struct AppView: View {
    let store: StoreOf<AppFeature>
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Text("App View")
            .onChange(of: scenePhase) { phase in
                switch phase {
                case .active:
                    store.send(.scenePhaseBecomeActive)

                case .background, .inactive:
                    break

                @unknown default:
                    break
                }
            }
    }
}

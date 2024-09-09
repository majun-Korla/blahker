import ComposableArchitecture
import ContentBlockerService
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
    struct State: Equatable {
        var isEnabledContentBlocker = false
    }

    enum Action: Equatable {
        case scenePhaseBecomeActive
        case checkUserEnableContentBlocker
        case userEnableContentBlocker(Bool)
    }

    @Dependency(\.contentBlockerService) var contentBlockerService

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .scenePhaseBecomeActive:
            return .send(.checkUserEnableContentBlocker)

        case .checkUserEnableContentBlocker:
            return .run { send in
                let extensionID = "com.elaborapp.Blahker.ContentBlocker"

                let isEnabled = await contentBlockerService.checkUserEnableContenBloacker(extensionID)
                await send(.userEnableContentBlocker(isEnabled))
            }

        case let .userEnableContentBlocker(isEnabled):
            state.isEnabledContentBlocker = isEnabled
            return .none
        }
    }
}

struct AppView: View {
    let store: StoreOf<AppFeature>
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        WithViewStore(store, observe: { $0.isEnabledContentBlocker }) {
            viewStore in
            let isEnable = viewStore.state

            Text("blocker is \(isEnable ? "Enable" : "Disable")")
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
}

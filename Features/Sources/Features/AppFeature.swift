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
        var home: HomeFeature.State = .init()
        
    }
    
    enum Action: Equatable {
        case home(HomeFeature.Action)
        
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        Reduce(core)
        
    }
    
    func core(into state: inout State, action: Action) -> Effect<Action> {
        switch  action {
        case let .home(.userEnableContentBlocker(isEnable)):
            return .none
        case .home:
            return .none
        
        }
        
    }
}



struct AppView: View {
    let store: StoreOf<AppFeature>
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        HomneView(store: store.scope(state: \.home, action: \.home))
    }
}


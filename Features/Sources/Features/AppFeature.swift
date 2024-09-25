import ComposableArchitecture
import ContentBlockerService
import SwiftUI

@main

struct BlahkuerApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: NewAppDelegate

    var body: some Scene {
        WindowGroup {
            AppView(store: appDelegate.store)
        }
    }
}

class NewAppDelegate: NSObject, UIApplicationDelegate {
    var store = Store(initialState: AppFeature.State(), reducer: {
        AppFeature()
    })

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        store.send(.home(.appDidFinishLaunching))

        return true
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
//            .ifLet(\.home, action: \.home)      //接待者模式?
    }

    func core(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
//        case let .home(.userEnableContentBlocker(isEnable)):
//            return .none
        case .home:
            return .none
        }
    }
}

struct AppView: View {
    let store: StoreOf<AppFeature>
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        WithPerceptionTracking {
            HomeView(store: store.scope(state: \.home, action: \.home))
        }
    }
}

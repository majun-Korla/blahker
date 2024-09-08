import SwiftUI
import ComposableArchitecture

@main

struct BlahkuerApp: App {
    var body: some Scene {
        WindowGroup {
            Text("TCA ")
        }
    }
}

@Reducer
struct AppFeature {
    struct State: Equatable {}
    
    enum Action: Equatable {}
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {}
}



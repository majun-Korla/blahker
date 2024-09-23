//
//  BlockerListFeature.swift
//
//
//  Created by Mason Ma on 2024/9/17.
//

import ComposableArchitecture
import Foundation

@Reducer
struct BlockerListFeature {
    @ObservableState
    struct State: Equatable {
        var ruleItems: [RuleItem] = []
        
    }

    enum Action: Equatable {
        //downloadlist , ruletItmes = rules.map()
        
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {}
}

struct RuleItem: Equatable, Identifiable {
    var title: String
    var description: String
    let id = UUID()
}

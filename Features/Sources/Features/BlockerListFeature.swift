//
//  BlockerListFeature.swift
//
//
//  Created by Mason Ma on 2024/9/17.
//

import ComposableArchitecture
import ContentBlockerService
import Foundation
import Models

@Reducer
struct BlockerListFeature {
    @ObservableState
    struct State: Equatable {
        var ruleItems: [RuleItem] = []
    }

    enum Action: Equatable {
        // downloadlist , ruletItmes = rules.map()
        case task
        case receiveRuleItems([RuleItem])
        case reload
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        let  fetchBlockerList: Effect<Action> =
            .run { send in
                @Dependency(\.contentBlockerService) var contentBlockerService
                let ruleItems = try await contentBlockerService.fetchBlockerList()
                 await send(.receiveRuleItems(ruleItems))
            }
            catch: { error, _ in
                print("--------")
                XCTFail(error.localizedDescription)
            }
        

        switch action {
        case .reload:
            return fetchBlockerList

        case .task:
            return fetchBlockerList

        case let .receiveRuleItems(ruleItems):
            state.ruleItems = ruleItems
            return .none
        }
    }
}

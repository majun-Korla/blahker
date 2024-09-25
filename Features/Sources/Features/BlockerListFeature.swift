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
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .task:

            return .run { send in

                @Dependency(\.contentBlockerService) var contentBlockerService
                let ruleItems = try await contentBlockerService.fetchBlockerList()
                await send(.receiveRuleItems(ruleItems))
            }
//            catch: { error, send in
//                XCTFail(error.localizedDescription)
//            }
        case let .receiveRuleItems(ruleItems):
            state.ruleItems = ruleItems
            return .none
        }
    }
}

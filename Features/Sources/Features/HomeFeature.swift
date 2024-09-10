//
//  File.swift
//  
//
//  Created by Mason Ma on 2024/9/10.
//

import ComposableArchitecture
import Foundation

@Reducer
struct HomeFeature {
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

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
        case userEnableContentBlocker(Bool)
        
        case tapRefreshButton
        case tapAboutButton
        case tapDontTapMeButton
    }

    @Dependency(\.contentBlockerService) var contentBlockerService

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        
        var ch: Effect<Action> {
            .run {
            send in
            let extensionID = "com.elaborapp.Blahker.ContentBlocker"
            
            let isEnabled = await contentBlockerService.checkUserEnableContenBloacker(extensionID)
            await send(.userEnableContentBlocker(isEnabled))
            }
        }
        
        switch action {
        case .scenePhaseBecomeActive:
            return ch

     

        case let .userEnableContentBlocker(isEnabled):
            state.isEnabledContentBlocker = isEnabled
            return .none
            
        case .tapRefreshButton:
            return ch
            
        case .tapAboutButton:
            return .none
            
        case .tapDontTapMeButton:
            return .none
            
        }
    }
        
}

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
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var isEnabledContentBlocker = false
    }

    enum Action: Equatable {
        case alert(PresentationAction<Alert>)
        
        case scenePhaseBecomeActive
        case userEnableContentBlocker(Bool)
        
        case tapRefreshButton
        case tapAboutButton
        case tapDontTapMeButton
        
        enum Alert {
            case smallDonation
            case mediumDonation
            case largeDonation
            case rateStar
            
            case okToReload
        }
    }

    @Dependency(\.contentBlockerService) var contentBlockerService
    @Dependency(\.openURL) var openURL

    var body: some ReducerOf<Self> {
        Reduce(core)
            .ifLet(\.$alert, action: \.alert)
    }
    
    func core(into state: inout State, action: Action) -> Effect<Action> {
        var ch: Effect<Action> {
            .run {
                send in
                let extensionID = "com.elaborapp.Blahker.ContentBlocker"
            
                let isEnabled = await contentBlockerService.checkUserEnableContenBlocker(extensionID)
                await send(.userEnableContentBlocker(isEnabled))
            }
        }
        
        switch action {
        case .scenePhaseBecomeActive:
            return ch

        case let .userEnableContentBlocker(isEnabled):
            state.isEnabledContentBlocker = isEnabled
            if isEnabled {
                state.alert = .updateSuccessAlert
            } else {
                state.alert = .pleaseEnableContentBlockerAlert
            }
            return .none
            
        case .tapRefreshButton:
            
            return ch
            
        case .tapAboutButton:
            
            return .none
            
        case .tapDontTapMeButton:
            state.alert = .donateAlert
            
            return .none
            
        case let .alert(.presented(action)):
            switch action {
            case .smallDonation:
                return .none
                
            case .mediumDonation:
                return .none
                
            case .largeDonation:
                return .none
                
            case .rateStar:
                return .run {
                    _ in
                    let url = URL(string: "https://apps.apple.com/cn/app/blahker-%E5%B7%B4%E6%8B%89%E5%89%8B/id1482371114?mt=12")!
                    await openURL(url)
                }
                
            case .okToReload:
                return ch
            }
            
        case .alert:
            return .none
        }
    }
}




//
//  File.swift
//
//
//  Created by Mason Ma on 2024/9/10.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct HomeFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action>?
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

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
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
            return .none
            
        case .tapRefreshButton:
            state.alert = AlertState {
                TextState("Alert!")
            } actions: {
                ButtonState(role: .cancel) {
                    TextState("Cancel")
                }
//                ButtonState(action: .okToReload) {
//                    TextState("Increment")
//                }
            } message: {
                TextState("This is an alert")
            }
            return .none
            
        case .tapAboutButton:
            state.alert = AlertState {
                TextState("支持開發者")
            } actions: {
                ButtonState(role: .cancel) {
                    TextState("Cancel")
                }
//                ButtonState(action: .smallDonation) {
//                    TextState("打賞小小費")
//                }
            } message: {
                TextState("Blahker 的維護包含不斷更新擋廣告清單。如果有你的支持一定會更好～")
            }
            return .none
            
        case .tapDontTapMeButton:
       
            
            
            
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
                return .none
                
            case .okToReload:
                return .none
            }
            
        case .alert:
            return .none
        }
    }
}

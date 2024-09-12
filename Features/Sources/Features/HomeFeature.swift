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
           
            return .none
            
        case .tapDontTapMeButton:
            state.alert = AlertState {
                TextState("支持開發者")
            } actions: {
                ButtonState(role: .cancel) {
                    TextState("取消")
                }
                ButtonState(action: .smallDonation) {
                    TextState("打賞小小費")
                }
                ButtonState(action: .mediumDonation) {
                    TextState("打賞小費")
                }
                ButtonState(action: .largeDonation) {
                    TextState("破費")
                }
                ButtonState(action: .rateStar) {
                    TextState("我不出錢，給個五星評分總行了吧")
                }
                
                
            } message: {
                TextState("Blahker 的維護包含不斷更新擋廣告清單。如果有你的支持一定會更好～")
            }
            
            
            
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
                    send in
                    let url = URL(string: "https://apps.apple.com/cn/app/blahker-%E5%B7%B4%E6%8B%89%E5%89%8B/id1482371114?mt=12")!
                    await openURL(url)

                }
                
            case .okToReload:
                return .none
            }
            
        case .alert:
            return .none
        }
    }
}

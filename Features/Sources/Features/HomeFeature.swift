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
        var isAppLaunch = true
        var isEnabledContentBlocker = false
        var isCheckingBlockerlist = false
        
        var path = StackState<Path.State>()
    }
    enum Action: Equatable {
        case path(StackActionOf<Path>)
        case alert(PresentationAction<Alert>)
        
        case appDidFinishLaunching
        case scenePhaseBecomeActive
        case userEnableContentBlocker(Bool)
        case manullyUserEnableContentBlocker(Bool)
        
        case tapRefreshButton
        case tapAboutButton
        case tapDontTapMeButton
        @CasePathable
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
            .forEach(\.path, action: \.path)
    }
    
    func core(into state: inout State, action: Action) -> Effect<Action> {
        func checkUserEnableContentBlockerAndReload(manully: Bool) -> Effect<Action> {
            state.isCheckingBlockerlist = true
            return .run {
                send in
                let bundleID = "com.elaborapp.Blahker.ContentBlocker"
            
                let isEnabled = await contentBlockerService.checkUserEnableContenBlocker(bundleID)
                if isEnabled {
                    try await contentBlockerService.reloadUserEnableContentBlocker(bundleID)
                }
              
                await send(manully ? .manullyUserEnableContentBlocker(isEnabled) : .userEnableContentBlocker(isEnabled))
            }
            .cancellable(id: CancleID.checkUserBlockerEnableCancleID, cancelInFlight: true)
        }
        
        enum CancleID: Hashable {
            case checkUserBlockerEnableCancleID
        }
        
        switch action {
        case .path(.element(id: _, action: .about(.tapBlockerListCell))):
            state.path.append(.blockerList(.init()))
            return .none
     
        case .appDidFinishLaunching:
            return checkUserEnableContentBlockerAndReload(manully: false)

        case .scenePhaseBecomeActive:
            return checkUserEnableContentBlockerAndReload(manully: false)

        case let .manullyUserEnableContentBlocker(isEnabled):
            if isEnabled {
                state.alert = .updateSuccessAlert
            } else {
                state.alert = .pleaseEnableContentBlockerAlert
            }
            state.isEnabledContentBlocker = isEnabled
            state.isCheckingBlockerlist = false

            return .none
            
        case let .userEnableContentBlocker(isEnabled):
            switch (isEnabled, state.isAppLaunch, state.isEnabledContentBlocker) {
            case (false, _, _):
                state.alert = .pleaseEnableContentBlockerAlert
 
            case (true, false, false):
                state.alert = .updateSuccessAlert

            case (true, _, _):
                break
            }
            state.isCheckingBlockerlist = false
            state.isEnabledContentBlocker = isEnabled
            state.isAppLaunch = false
            return .none
            
        case .tapRefreshButton:
            
            return checkUserEnableContentBlockerAndReload(manully: true)
            
        case .tapAboutButton:
            state.path.append(.about(.init()))
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
                   
                    await openURL(.appStore)
                }
                
            case .okToReload:
                return checkUserEnableContentBlockerAndReload(manully: true)
            }
            
        case .alert:
            return .none

        case .path:
            return .none
        }
    }
}

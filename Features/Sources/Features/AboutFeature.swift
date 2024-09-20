//
//  File.swift
//
//
//  Created by Mason Ma on 2024/9/17.
//

import ComposableArchitecture
import MessageUI

@Reducer
struct AboutFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
    }

    enum Action: Equatable {
        case alert(PresentationAction<Alert>)
        enum Alert {
            case sure
        }
        
        case tapBlockerListCell
        case tapReportCell
        case tapRateCell
        case tapAboutCell
        
        case presentPleaseMailOpenAlert
        
    }

    @Dependency(\.openURL) var openURL
    @Dependency(\.mailComposeClient) var mailComposeClient
    
    var body: some ReducerOf<Self> {
        Reduce(core)
            .ifLet(\.$alert, action: \.alert)
    }
    
    func core(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .tapBlockerListCell:
            return .none
        case .presentPleaseMailOpenAlert:
            state.alert = .pleaseMailOpen
            return .none
            
        case .tapReportCell:
            return .run {
                send in
                if mailComposeClient.canSendMail() {
                    
                }
                else {
                    await send(.presentPleaseMailOpenAlert)
                }
//                state.alert = .ttAlert
//                if await MFMailComposeViewController.canSendMail()  {
////                    await state.alert = .ttAlert
//                    await openURL(.appStore)
//
//                }
//                else {
//                    //                state.alert = .ttAlert
//                    await openURL(.github)
//                }
                /*
                 guard MFMailComposeViewController.canSendMail() else {
                     let alertController = UIAlertController(title: "請先啟用 iOS 郵件", message: "請先至 iOS 郵件 app 登入信箱，或寄信到 elaborapp+blahker@gmail.com", preferredStyle: .alert)
                     alertController.addAction(UIAlertAction(title: "確定", style: .cancel, handler: nil))
                     self.present(alertController, animated: true, completion: nil)
                     return
                 }
                 let vc = MFMailComposeViewController()
                 vc.setToRecipients(["elaborapp+blahker@gmail.com"])
                 vc.setSubject("[Blahker 使用者回報]我有問題")
                 vc.setMessageBody("Hello 開發者，\n\n建議加入擋蓋版廣告之網站：\n（請附上螢幕截圖，以利判斷，謝謝）\n\n", isHTML: false)
                 vc.mailComposeDelegate = self
                 self.present(vc, animated: true, completion: { })
                 */
            }
            
        case .tapRateCell:
            
            return .run {
                _ in
                await openURL(.appStore)
            }
            
        case .tapAboutCell:
            return .run {
                _ in
               
                await openURL(.github)
            }
        
        case let .alert(.presented(action)):
            switch action {
            case .sure:
                return .none
            }

        case .alert:
            return .none
        }
    }
}

//
//  File.swift
//  
//
//  Created by Mason Ma on 2024/9/13.
//

import ComposableArchitecture

extension AlertState<HomeFeature.Action.Alert> {
    static var pleaseEnableContentBlockerAlert = AlertState<HomeFeature.Action.Alert>(title: {
        TextState("請開啟內容阻擋器")

    },
    actions: { ButtonState(role: .cancel) {
        TextState("取消")
    }
    ButtonState(action: .okToReload) {
        TextState("確定")
    }
    },
    message: { TextState("請打開「設定」 > 「Safari」 > 「內容阻擋器」，並啟用 Blahker") })
    
    static var updateSuccessAlert = AlertState<HomeFeature.Action.Alert>(title: {
        TextState("更新成功")

    },
    actions: { ButtonState(role: .cancel) {
        TextState("確定")
    }
   
    },
    message: { TextState("已下載最新擋廣告網站清單") })
    
    static var donateAlert = AlertState {
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
}


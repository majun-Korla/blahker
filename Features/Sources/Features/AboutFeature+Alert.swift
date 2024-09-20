//
//  AboutFeature+Alert.swift
//  Features
//
//  Created by Mason Ma on 2024/9/19.
//
import ComposableArchitecture

extension AlertState<AboutFeature.Action.Alert> {
    static var pleaseMailOpen = AlertState<AboutFeature.Action.Alert>(title: {
        TextState("請先啟用 iOS 郵件")

    },
    actions: { ButtonState(role: .cancel) {
        TextState("取消")
    }
    ButtonState(action: .sure) {
        TextState("確定")
    }
    },
    message: { TextState("請先至 iOS 郵件 app 登入信箱，或寄信到 elaborapp+blahker@gmail.com") })
    
   
}


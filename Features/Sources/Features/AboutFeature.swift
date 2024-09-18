//
//  File.swift
//
//
//  Created by Mason Ma on 2024/9/17.
//

import ComposableArchitecture

@Reducer
struct AboutFeature: Equatable {
    struct State: Equatable {}

    enum Action: Equatable {}

    func reduce(into state: inout State, action: Action) -> Effect<Action> {}
}

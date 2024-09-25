//
//  HomeFeature+Path.swift
//
//
//  Created by Mason Ma on 2024/9/17.
//

import ComposableArchitecture
import Foundation

extension HomeFeature {
    @Reducer(state: .equatable, action: .equatable)
    enum Path {
        case about(AboutFeature)
        case blockerList(BlockerListFeature)
    }
}

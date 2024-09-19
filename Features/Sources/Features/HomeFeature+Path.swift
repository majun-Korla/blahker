//
//  HomeFeature+Path.swift
//
//
//  Created by Mason Ma on 2024/9/17.
//

import ComposableArchitecture
import Foundation

extension HomeFeature {
    @Reducer
    enum Path {
        case about(AboutFeature)
        case blockerList(BlockerListFeature)
    }
}

extension HomeFeature.Path.State: Equatable {}

extension HomeFeature.Path.Action: Equatable {}

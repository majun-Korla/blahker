//
//  BlockerListView.swift
//
//
//  Created by Mason Ma on 2024/9/17.
//
import ComposableArchitecture
import SwiftUI

struct BlockerListView: View {
    let store: StoreOf<BlockerListFeature>
    var body: some View {
        Text("BlockerListView")
    }
}

#Preview {
    BlockerListView(store: Store(initialState: BlockerListFeature.State(), reducer: {
        BlockerListFeature()
    }))
}

//
//  BlockerListView.swift
//
//
//  Created by Mason Ma on 2024/9/17.
//
import ComposableArchitecture
import Models
import SwiftUI

struct BlockerListView: View {
    let store: StoreOf<BlockerListFeature>
    var body: some View {
        WithPerceptionTracking {
            List {
                ForEach(store.ruleItems) { ruleItem in
                    VStack(alignment: .leading) {
                        Text(ruleItem.domain)
                            .font(.headline)
                            .lineLimit(1)
                        Text(ruleItem.selectors.joined(separator: ", "))
                            .font(.subheadline)
                            .lineLimit(3)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("blocker list ")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await store.send(.task).finish()
            }
        }
    }
}

#Preview {
    BlockerListView(
        store: .init(
            initialState: BlockerListFeature.State(
                ruleItems: [
                    .init(domain: "Ad.my", selectors: ["block my advertisement."]),
                    .init(
                        domain: "ad",
                        selectors: ["""
                        block my advertisement.
                        Ad.my0
                        Ad.my1
                        Ad.my2
                        """]
                    )
                ]
            ),
            reducer: { BlockerListFeature()
            }
        )
    )
    .preferredColorScheme(.dark)
}

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
        WithPerceptionTracking {
            List {
                ForEach(store.ruleItems) { ruleItem in
                    VStack(alignment: .leading) {
                        Text(ruleItem.title)
                            .font(.headline)
                            .lineLimit(1)
                        Text(ruleItem.description)
                            .font(.subheadline)
                            .lineLimit(3)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("blocker list ")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    BlockerListView(
        store: .init(
            initialState: BlockerListFeature.State(
                ruleItems: [
                    .init(title: "Ad.my", description: "block my advertisement."),
                    .init(title: "Ad.my", description: "block my advertisement."),

                    .init(
                        title: "Ad.my",
                        description: """
                        block my advertisement.
                        Ad.my0
                        Ad.my1
                        Ad.my2
                        """
                    )
                ]
            ),
            reducer: { BlockerListFeature()
            }
        )
    )
    .preferredColorScheme(.dark)
}

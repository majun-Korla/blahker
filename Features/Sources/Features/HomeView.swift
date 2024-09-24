//
//  SwiftUIView.swift
//
//
//  Created by Mason Ma on 2024/9/10.
//

import ComposableArchitecture
import SwiftUI

struct HomneView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Perception.Bindable var store: StoreOf<HomeFeature>

    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {

                VStack {
                    descriptionView
                    Spacer()
                    Text("Blahker is \(store.isEnabledContentBlocker ? "1Enabled" : "2Disable")")
                    dontTapMeButton
                }
                .navigationTitle("Blahker")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        refreshButton
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        aboutButton
                    }
                }
                .onChange(of: scenePhase) { phase in
                    switch phase {
                    case .active:
                        store.send(.scenePhaseBecomeActive)

                    case .background, .inactive:
                        break

                    @unknown default:
                        break
                    }
                }
            } destination: { store in
                switch store.case {
                case .about(let store):
                    AboutView(store: store)
                case .blockerList(let store):
                    BlockerListView(store: store)
                }
            }
            .preferredColorScheme(.dark)
            .tint(.mint)
            .alert($store.scope(state: \.alert, action: \.alert))
        }
    }

    @MainActor
    @ViewBuilder
    private var descriptionView: some View {
        Text("""
        Blahker 致力於消除網站中的蓋版廣告，支援 Safari 瀏覽器。

        App 將會自動取得最新擋廣告網站清單，你也可以透過左上角按鈕手動更新。

        欲回報廣告網站或者了解更多資訊，請參閱「關於」頁面。
        """)
        .padding()
    }

    @MainActor
    @ViewBuilder
    private var dontTapMeButton: some View {
        Button {
            store.send(.tapDontTapMeButton)
        } label: {
            Text("拜托别按我")
        }
        .font(.title)
    }

    @MainActor
    @ViewBuilder
    private var refreshButton: some View {
        WithPerceptionTracking {
            
            Button(action: {
                store.send(.tapRefreshButton)
            }, label: {
                Image(systemName: "arrow.clockwise")
            })
            .disabled(store.isCheckingBlockerlist)
        }
    }

    @MainActor
    @ViewBuilder
    private var aboutButton: some View {
        Button(action: {
            store.send(.tapAboutButton)

        }, label: {
            Text("关于")
        })
    }
}

#Preview {
    HomneView(store: Store(initialState: HomeFeature.State(), reducer: {
        HomeFeature()
    })
    )
}

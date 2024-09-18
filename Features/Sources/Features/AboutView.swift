//
//  AboutView.swift
//
//
//  Created by Mason Ma on 2024/9/17.
//
import ComposableArchitecture
import SwiftUI

struct AboutView: View {
    let store: StoreOf<AboutFeature>
    var body: some View {
        Text("AboutView")
    }
}

#Preview {
    AboutView(store: Store(initialState: AboutFeature.State(), reducer: {
        AboutFeature()
    }))
}

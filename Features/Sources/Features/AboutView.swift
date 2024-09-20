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
        List {
            Section {
                blockerListCell
                reportCell
            }
            Section {
                rateCell
                shareCell
                aboutCell
            }
        }
        .listStyle(.grouped)
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
        .alert(store: store.scope(state: \.$alert, action: \.alert))

    }
    @MainActor
    @ViewBuilder
    private var blockerListCell: some View {
        Button(action: {
            store.send(.tapBlockerListCell)

        }, label: {
            Text("blocker list")
        })
    }
    @MainActor
    @ViewBuilder
    private var reportCell: some View {
        Button(action: {
            store.send(.tapReportCell)

        }, label: {
            VStack(alignment: .leading) {
                Text("report issues")
                Text("attach screenshots").font(.footnote)

            }
        })
    }
    @MainActor
    @ViewBuilder
    private var rateCell: some View {
        Button(action: {
            store.send(.tapRateCell)
            
            
            
        }, label: {
            Text("rate")
        })
    }
    @MainActor
    @ViewBuilder
    private var shareCell: some View {
        ShareLink(item: .appStore) {
            Text("share")

        }
    }
    @MainActor
    @ViewBuilder
    private var aboutCell: some View {
        Button(action: {
            store.send(.tapAboutCell)
        }, label: {
            VStack(alignment: .leading) {
                
                Text("about & common")
                Text("v1.0.1(1121)")
                    .font(.footnote)
            }
        })
    }
    
}

#Preview {
    NavigationStack {
        AboutView(store: Store(initialState: AboutFeature.State(), reducer: {
            AboutFeature()
        }))
    }
    .preferredColorScheme(.dark)
}

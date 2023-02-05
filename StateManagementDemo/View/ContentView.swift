//
//  ContentView.swift
//  StateManagementDemo
//
//  Created by Sasikumar JP on 04/02/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var store: Store<AppState>
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Counter Demo") {
                    CounterView(store: store)
                }
                NavigationLink("Favorite Primes") {
                    FavoritePrimesView(store: store)
                }
                NavigationLink("Activity Feed") {
                    ActivityFeedView(store: store)
                }
            }
            .listStyle(.plain)
            .navigationTitle("State Management")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store<AppState>(initialValue: AppState()))
    }
}

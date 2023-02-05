//
//  ContentView.swift
//  StateManagementDemo
//
//  Created by Sasikumar JP on 04/02/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var state: AppState
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Counter Demo") {
                    CounterView(state: state)
                }
                NavigationLink("Favorite Primes") {
                    FavoritePrimesView(state: state)
                }
                NavigationLink("Activity Feed") {
                    ActivityFeedView(state: state)
                }
            }
            .listStyle(.plain)
            .navigationTitle("State Management")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(state: AppState())
    }
}

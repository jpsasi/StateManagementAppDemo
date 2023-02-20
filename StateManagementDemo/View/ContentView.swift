//
//  ContentView.swift
//  StateManagementDemo
//
//  Created by Sasikumar JP on 04/02/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var store: Store<AppState, AppAction>
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Counter Demo") {
                    CounterView(store: store.view(value: { $0.counterState
                    }, action: {
                        switch $0 {
                            case let .counter(counterAction):
                                return AppAction.counter(counterAction)
                            case let .primeModal(primeModalAction):
                                return AppAction.primeModal(primeModalAction)
                        }
                    }))
                }
                NavigationLink("Favorite Primes") {
                    FavoritePrimesView(store: store.view(value: { $0.favoritePrimesState
                    }, action: { AppAction.favoritePrimes($0)
                    }))
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
        ContentView(store: Store(initialValue: AppState(), reducer: appReducer))
    }
}

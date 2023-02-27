//
//  FavoritePrimesView.swift
//  StateManagementDemo
//
//  Created by Sasikumar JP on 05/02/23.
//

import SwiftUI

struct FavoritePrimesView: View {
    @ObservedObject var store: Store<FavoritePrimesState, FavoritePrimeAction>
    
    var body: some View {
        ZStack {
            if store.value.favoritePrimes.count > 0 {
                List {
                    ForEach(store.value.favoritePrimes, id:\.self) {
                        Text("\($0)")
                    }
                    .onDelete { indexSet in
                        store.send(.deleteFavoritePrimes(indexSet))
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Favorite Primes")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        addToolBarItems()
                    }
                }
            } else {
                Text("No Favoite Primes")
                    .navigationTitle("Favorite Primes")
                    .toolbar {
                        ToolbarItem {
                            addToolBarItems()
                        }
                    }
            }
        }
    }
    
    func addToolBarItems() -> some View {
        HStack {
            Button("Save") {
                store.send(.saveButtonTapped)
            }
            Button("Load") {
                store.send(.loadButtonTapped)
            }
        }
    }
}

struct FavoritePrimes_Previews: PreviewProvider {
    static var previews: some View {
        var appState = AppState()
        appState.favoritePrimes.append(contentsOf: [1,2,3,5,7,11])
        let store = Store(initialValue: AppState(), reducer: appReducer)
        return NavigationView {
            FavoritePrimesView(store: store.view(value: { $0.favoritePrimesState
            }, action: { AppAction.favoritePrimes($0)
            }))
        }
    }
}

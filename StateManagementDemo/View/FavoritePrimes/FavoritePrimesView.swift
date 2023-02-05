//
//  FavoritePrimesView.swift
//  StateManagementDemo
//
//  Created by Sasikumar JP on 05/02/23.
//

import SwiftUI

struct FavoritePrimesView: View {
    @ObservedObject var store: Store<AppState, AppAction>
    
    var body: some View {
        ZStack {
            if store.value.favoritePrimes.count > 0 {
                List {
                    ForEach(store.value.favoritePrimes, id:\.self) {
                        Text("\($0)")
                    }
                    .onDelete{ indexSet in
                        store.send(.favoritePrimes(.deleteFavoritePrimes(indexSet)))
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Favorite Primes")
            } else {
                Text("No Favoite Primes")
                .navigationTitle("Favorite Primes")
            }
        }
    }
}

struct FavoritePrimes_Previews: PreviewProvider {
    static var previews: some View {
        var appState = AppState()
        appState.favoritePrimes.append(contentsOf: [1,2,3,5,7,11])
        return FavoritePrimesView(store: Store(initialValue: AppState(), reducer: appReducer))
    }
}

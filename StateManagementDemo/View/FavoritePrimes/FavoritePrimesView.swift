//
//  FavoritePrimesView.swift
//  StateManagementDemo
//
//  Created by Sasikumar JP on 05/02/23.
//

import SwiftUI

struct FavoritePrimesView: View {
    @ObservedObject var store: Store<AppState>
    
    var body: some View {
        ZStack {
            if store.value.favoritePrimes.count > 0 {
                List {
                    ForEach(store.value.favoritePrimes, id:\.self) {
                        Text("\($0)")
                    }
                    .onDelete{ indexSet in
                        for index in indexSet {
                            let prime = store.value.favoritePrimes[index]
                            store.value.favoritePrimes.remove(at: index)
                            store.value.activityFeed.append(AppState.Activity.init(type: .removedFavoritePrime(prime)))
                        }
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
        return FavoritePrimesView(store: Store<AppState>(initialValue: AppState()))
    }
}

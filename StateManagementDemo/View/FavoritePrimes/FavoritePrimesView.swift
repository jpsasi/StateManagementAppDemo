//
//  FavoritePrimesView.swift
//  StateManagementDemo
//
//  Created by Sasikumar JP on 05/02/23.
//

import SwiftUI

struct FavoritePrimesView: View {
    @ObservedObject var state: AppState
    
    var body: some View {
        ZStack {
            if state.favoritePrimes.count > 0 {
                List {
                    ForEach(state.favoritePrimes, id:\.self) {
                        Text("\($0)")
                    }
                    .onDelete{ indexSet in
                        for index in indexSet {
                            let prime = state.favoritePrimes[index]
                            state.favoritePrimes.remove(at: index)
                            state.activityFeed.append(AppState.Activity.init(type: .removedFavoritePrime(prime)))
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
        let appState = AppState()
        appState.favoritePrimes.append(contentsOf: [1,2,3,5,7,11])
        return FavoritePrimesView(state: appState)
    }
}

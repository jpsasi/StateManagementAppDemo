//
//  PrimeModalView.swift
//  StateManagementDemo
//
//  Created by Sasikumar JP on 05/02/23.
//

import SwiftUI

struct PrimeModalView: View {
    @ObservedObject var store: Store<PrimeModalState, AppAction>
    
    var body: some View {
        if isPrime(store.value.count) {
            VStack {
                Text("\(store.value.count) is a prime 🤩")
                if (store.value.favoritePrimes.contains(store.value.count)) {
                    Button("Remove from Favorite Primes") {
                        store.send(.primeModal(.removeFavoritePrimeTapped))
                    }
                } else {
                    Button("Add to Favorite Primes") {
                        store.send(.primeModal(.saveFavoritePrimeTapped))
                    }
                }
            }
        } else {
            Text("\(store.value.count) is not a prime 😡")
        }
    }
    
    private func isPrime(_ n: Int) -> Bool {
        if n <= 1 { return false }
        if n <= 3 { return true }
        for i in 2..<Int(sqrtf(Float(n))) {
            if n % i == 0 {
                return false
            }
        }
        return true
    }
}

struct PrimeModalView_Previews: PreviewProvider {
    static var previews: some View {
        PrimeModalView(store: Store(initialValue: AppState(), reducer: appReducer).view({ $0.primeModalState
        }))
    }
}

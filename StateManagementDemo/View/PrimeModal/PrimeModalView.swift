//
//  PrimeModalView.swift
//  StateManagementDemo
//
//  Created by Sasikumar JP on 05/02/23.
//

import SwiftUI

struct PrimeModalView: View {
    @ObservedObject var appState: AppState
    
    var body: some View {
        if isPrime(appState.count) {
            VStack {
                Text("\(appState.count) is a prime 🤩")
                if (appState.favoritePrimes.contains(appState.count)) {
                    Button("Remove from Favorite Primes") {
                        appState.favoritePrimes.removeAll(where: {appState.count == $0})
                        appState.activityFeed.append(AppState.Activity(type: .removedFavoritePrime(appState.count)))
                    }
                } else {
                    Button("Add to Favorite Primes") {
                        appState.favoritePrimes.append(appState.count)
                        appState.activityFeed.append(AppState.Activity.init(type: .addedFavoritePrime(appState.count)))
                    }
                }
            }
        } else {
            Text("\(appState.count) is not a prime 😡")
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
        PrimeModalView(appState: AppState())
    }
}

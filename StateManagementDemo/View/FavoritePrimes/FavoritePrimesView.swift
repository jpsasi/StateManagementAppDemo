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
        List {
            ForEach(state.favoritePrimes, id:\.self) {
                Text("\($0)")
            }
            .onDelete{ indexSet in
                state.favoritePrimes.remove(atOffsets: indexSet)
            }
        }
        .listStyle(.plain)
    }
}

struct FavoritePrimes_Previews: PreviewProvider {
    static var previews: some View {
        let appState = AppState()
        appState.favoritePrimes.append(contentsOf: [1,2,3,5,7,11])
        return FavoritePrimesView(state: appState)
    }
}

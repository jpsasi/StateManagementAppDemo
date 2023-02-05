//
//  AppState.swift
//  StateManagementDemo
//
//  Created by Sasikumar JP on 04/02/23.
//

import Foundation

class AppState: ObservableObject {
    @Published var count = 0
    @Published var favoritePrimes:[Int] = []
    @Published var loggedInUser: User? = nil
    @Published var activityFeed: [Activity] = []
    
    struct Activity {
        let timeStamp: Date
        
        enum ActivityType {
            case addedFavoritePrime(Int)
            case removeFavoritePrime(Int)
        }
    }
    
    struct User {
        let id: Int
        let name: String
        let bio: String
    }
}

struct PrimeAlert: Identifiable {
    let prime: Int
    var id: Int { self.prime }
}

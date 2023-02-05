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
    
    struct Activity: Hashable, Equatable {
        let timeStamp: Date
        let type: ActivityType
        
        enum ActivityType: Equatable {
            case addedFavoritePrime(Int)
            case removedFavoritePrime(Int)
        }
        
        init(timeStamp: Date = Date(), type: ActivityType) {
            self.timeStamp = timeStamp
            self.type = type
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.timeStamp.timeIntervalSince1970)
        }
        
        static func == (lhs: AppState.Activity, rhs: AppState.Activity) -> Bool {
            return lhs.timeStamp == rhs.timeStamp && lhs.type == rhs.type
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

//
//  AppState.swift
//  StateManagementDemo
//
//  Created by Sasikumar JP on 04/02/23.
//

import Foundation

struct AppState  {
    var count = 0
    var favoritePrimes:[Int] = []
    var loggedInUser: User? = nil
    var activityFeed: [Activity] = []
    
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

enum CounterAction {
    case incrTapped
    case decrTapped
}

let counterReducer: (AppState, CounterAction) -> AppState = { (state, action) in
    var copy = state
    switch action {
        case .incrTapped:
            copy.count += 1
        case .decrTapped:
            copy.count -= 1
    }
    return copy
}

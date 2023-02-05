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

enum AppAction {
    case counter(CounterAction)
    case primeModal(PrimeModalAction)
    case favoritePrimes(FavoritePrimeAction)
}

enum CounterAction {
    case incrTapped
    case decrTapped
}

enum PrimeModalAction {
    case saveFavoritePrimeTapped
    case removeFavoritePrimeTapped
}

enum FavoritePrimeAction {
    case deleteFavoritePrimes(IndexSet)
}

let appReducer: (inout AppState, AppAction) -> Void = { (state, action) in
    switch action {
        case let .counter(counterAction):
            switch counterAction {
                case .incrTapped:
                    state.count += 1
                case .decrTapped:
                    state.count -= 1
            }
        case let .primeModal(primeModalAction):
            switch primeModalAction {
                case .saveFavoritePrimeTapped:
                    state.favoritePrimes.append(state.count)
                    state.activityFeed.append(AppState.Activity.init(type: .addedFavoritePrime(state.count)))
                case .removeFavoritePrimeTapped:
                    state.favoritePrimes.removeAll(where: {state.count == $0})
                    state.activityFeed.append(AppState.Activity(type: .removedFavoritePrime(state.count)))
            }
        case let .favoritePrimes(favoritePrimesAction):
            switch favoritePrimesAction {
                case let .deleteFavoritePrimes(indexSet):
                    for index in indexSet {
                        let prime = state.favoritePrimes[index]
                        state.favoritePrimes.remove(at: index)
                        state.activityFeed.append(AppState.Activity.init(type: .removedFavoritePrime(prime)))
                    }
            }
    }
}

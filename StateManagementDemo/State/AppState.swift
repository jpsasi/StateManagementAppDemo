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
    
    var favoritePrimesState: FavoritePrimesState {
        get {
            return FavoritePrimesState(favoritePrimes: favoritePrimes,
                                       activityFeed: activityFeed)
        }
        set {
            favoritePrimes = newValue.favoritePrimes
            activityFeed = newValue.activityFeed
        }
    }
    
    var primeModalState: PrimeModalState {
        get {
            return PrimeModalState(count: count,
                                   favoritePrimes: favoritePrimes,
                                   activityFeed: activityFeed)
        }
        set {
            count = newValue.count
            favoritePrimes = newValue.favoritePrimes
            activityFeed = newValue.activityFeed
        }
    }
    
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

struct PrimeModalState {
    let count: Int
    var favoritePrimes: [Int]
    var activityFeed: [AppState.Activity]
}

struct FavoritePrimesState {
    var favoritePrimes: [Int]
    var activityFeed:[AppState.Activity]
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

let countReducer: (inout Int, AppAction) -> Void = { (state, action) in
    switch action {
        case .counter(.incrTapped):
            state += 1
        case .counter(.decrTapped):
            state -= 1
        default:
            break
    }
}

let primeModalReducer: (inout PrimeModalState, AppAction) -> Void = { (state, action) in
    switch action {
        case .primeModal(.saveFavoritePrimeTapped):
            state.favoritePrimes.append(state.count)
            state.activityFeed.append(AppState.Activity.init(type: .addedFavoritePrime(state.count)))
        case .primeModal(.removeFavoritePrimeTapped):
            state.favoritePrimes.removeAll(where: {state.count == $0})
            state.activityFeed.append(AppState.Activity(type: .removedFavoritePrime(state.count)))
        default:
            break
    }
}

let favoritePrimesReducer: (inout FavoritePrimesState, AppAction) -> Void = { (state, action) in
    switch action {
        case let .favoritePrimes(.deleteFavoritePrimes(indexSet)):
            for index in indexSet {
                let prime = state.favoritePrimes[index]
                state.favoritePrimes.remove(at: index)
                state.activityFeed.append(AppState.Activity.init(type: .removedFavoritePrime(prime)))
            }
        default:
            break
    }
}

func combine<Value, Action>(_ first: @escaping (inout Value, Action) -> Void,
                            _ second: @escaping (inout Value, Action) -> Void) -> (inout Value, Action) -> Void {
    return { value,action in
        first(&value, action)
        second(&value, action)
    }
}

func combine<Value, Action>(_ reducers: (inout Value, Action) -> Void...) -> (inout Value, Action) -> Void {
    return { value, action in
        for reducer in reducers {
            reducer(&value, action)
        }
    }
}

func pullback<LocalValue, GlobalValue, Action>(
    _ reducer: @escaping (inout LocalValue, Action) -> Void,
    _ f: @escaping (GlobalValue) -> LocalValue
) -> (inout GlobalValue, Action) -> Void {
    return { globalValue, action in
        var localValue = f(globalValue)
        reducer(&localValue, action)
    }
}

func pullback<LocalValue, GlobalValue, Action>(
    _ reducer: @escaping (inout LocalValue, Action) -> Void,
    _ value: WritableKeyPath<GlobalValue, LocalValue>
) -> (inout GlobalValue, Action) -> Void {
    return { globalValue, action in
       reducer(&globalValue[keyPath: value], action)
    }
}
//let appReducer: (inout AppState, AppAction) -> Void = combine(countReducer, combine(primeModalReducer, favoritePrimesReducer))
let appReducer: (inout AppState, AppAction) -> Void = combine(
    pullback(countReducer, \.count),
    pullback(primeModalReducer, \.primeModalState),
    pullback(favoritePrimesReducer, \.favoritePrimesState))


//
//  AppState.swift
//  StateManagementDemo
//
//  Created by Sasikumar JP on 04/02/23.
//

import Foundation

struct AppState: Codable  {
    var count = 0
    var favoritePrimes:[Int] = []
    var loggedInUser: User? = nil
    var activityFeed: [Activity] = []
    
    var counterState: CounterState {
        get {
            return CounterState(count: count,
                                favoritePrimes: favoritePrimes,
                                activityFeed: activityFeed)
        }
        set {
            count = newValue.count
            favoritePrimes = newValue.favoritePrimes
            activityFeed = newValue.activityFeed
        }
    }
    
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
    
    struct Activity: Hashable, Equatable, Codable {
        let timeStamp: Date
        let type: ActivityType
        
        enum ActivityType: Equatable, Codable {
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
    
    struct User: Codable {
        let id: Int
        let name: String
        let bio: String
    }
}
typealias CounterState = (count: Int, favoritePrimes: [Int], activityFeed: [AppState.Activity])
typealias PrimeModalState = (count: Int, favoritePrimes: [Int], activityFeed: [AppState.Activity])

struct FavoritePrimesState: Codable {
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
    
    var counter: CounterAction? {
        get {
            guard case let .counter(counterAction) = self else {
                return nil
            }
            return counterAction
        }
        set {
            guard case.counter = self, let newValue = newValue else {
                return
            }
            self = .counter(newValue)
        }
    }
    var primeModal: PrimeModalAction? {
        get {
            guard case let .primeModal(primeModalAction) = self else {
                return nil
            }
            return primeModalAction
        }
        set {
            guard case .primeModal = self, let newValue = newValue else {
                return
            }
            self = .primeModal(newValue)
        }
    }
    
    var favoritePrimes: FavoritePrimeAction? {
        get {
            guard case let .favoritePrimes(favoritePrimeAction) = self else {
                return nil
            }
            return favoritePrimeAction

        }
        set {
            guard case .favoritePrimes = self, let newValue = newValue else {
                return
            }
            self = .favoritePrimes(newValue)
        }
    }
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
    case loadedFavoritePrimes([Int])
    case loadButtonTapped
    case saveButtonTapped
}

let countReducer: Reducer<Int, CounterAction> = { (state, action) in
    switch action {
        case .incrTapped:
            state += 1
            return []
        case .decrTapped:
            state -= 1
            return []
    }
}

let primeModalReducer: Reducer<PrimeModalState, PrimeModalAction> = { (state, action) in
    switch action {
        case .saveFavoritePrimeTapped:
            state.favoritePrimes.append(state.count)
            state.activityFeed.append(AppState.Activity.init(type: .addedFavoritePrime(state.count)))
            return []
        case .removeFavoritePrimeTapped:
            state.favoritePrimes.removeAll(where: {state.count == $0})
            state.activityFeed.append(AppState.Activity(type: .removedFavoritePrime(state.count)))
            return []
    }
}

let favoritePrimesReducer: Reducer<FavoritePrimesState, FavoritePrimeAction>  = { (state, action) in
    switch action {
        case let .deleteFavoritePrimes(indexSet):
            for index in indexSet {
                let prime = state.favoritePrimes[index]
                state.favoritePrimes.remove(at: index)
                state.activityFeed.append(AppState.Activity.init(type: .removedFavoritePrime(prime)))
            }
            return []
        case let .loadedFavoritePrimes(favoritePrimes):
            state.favoritePrimes = favoritePrimes
            return []
        case .loadButtonTapped:
            return [ loadFavoritePrimeEffect()]
        case .saveButtonTapped:
            return [saveFavoritePrimeEffect(favoritePrimes: state.favoritePrimes)]
    }
}

private func saveFavoritePrimeEffect(favoritePrimes: [Int]) -> Effect<FavoritePrimeAction> {
    return {
        let data = try! JSONEncoder().encode(favoritePrimes)
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsUrl = URL(fileURLWithPath: documentsPath)
        let url = documentsUrl.appending(path: "favorite-primes.json")
        try! data.write(to: url)
        return nil
    }
}

private func loadFavoritePrimeEffect() -> Effect<FavoritePrimeAction> {
    return { () -> FavoritePrimeAction? in
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsUrl = URL(fileURLWithPath: documentsPath)
        let url = documentsUrl.appending(path: "favorite-primes.json")
        guard let data = try? Data(contentsOf: url),
              let favoritesPrimes = try? JSONDecoder().decode([Int].self, from: data) else { return nil }
        return .loadedFavoritePrimes(favoritesPrimes)
    }
}

//let appReducer: (inout AppState, AppAction) -> Void = combine(countReducer, combine(primeModalReducer, favoritePrimesReducer))
let appReducer: Reducer<AppState, AppAction> = combine(
    pullback(countReducer, \.count, \.counter),
    pullback(primeModalReducer, \.primeModalState, \.primeModal),
    pullback(favoritePrimesReducer, \.favoritePrimesState, \.favoritePrimes))


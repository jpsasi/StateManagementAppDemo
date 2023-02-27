//
//  Store.swift
//  StateManagementDemo
//
//  Created by Sasikumar JP on 05/02/23.
//

import Foundation
import Combine

typealias Effect<Action> = () -> Action?
typealias Reducer<Value, Action> = (inout Value, Action) -> [Effect<Action>]

class Store<Value, Action>: ObservableObject {
    let reducer: Reducer<Value, Action>
    @Published var value: Value
    var cancellable: Cancellable?
    
    init(initialValue: Value, reducer: @escaping Reducer<Value, Action>) {
        self.value = initialValue
        self.reducer = reducer
    }
    
    func send(_ action: Action) {
        let effects = reducer(&value, action)
        effects.forEach { effect in
            if let action = effect() {
                send(action)
            }
        }
    }
    
    func view<LocalValue>(
        _ f: @escaping (Value) -> LocalValue
    ) -> Store<LocalValue, Action> {
        let localStore = Store<LocalValue, Action>(
            initialValue: f(self.value),
            reducer: { localValue, action in
                self.send(action)
                localValue = f(self.value)
                return []
            })
        localStore.cancellable = self.$value.sink { [weak localStore] value in
            localStore?.value = f(value)
        }
        return localStore
    }
    
    func view<LocalValue, LocalAction>(
        value toLocalValue: @escaping (Value) -> LocalValue,
        action toGlobalAction: @escaping (LocalAction) -> Action
    ) -> Store<LocalValue, LocalAction> {
        let localStore = Store<LocalValue, LocalAction>(
            initialValue: toLocalValue(self.value),
            reducer: { localValue, localAction in
                self.send(toGlobalAction(localAction))
                localValue = toLocalValue(self.value)
                return []
            })
        localStore.cancellable = self.$value.sink { [weak localStore] value in
            localStore?.value = toLocalValue(value)
        }
        return localStore
    }
}

func combine<Value, Action>(
    _ first: @escaping Reducer<Value, Action>,
    _ second: @escaping Reducer<Value, Action>
) -> Reducer<Value, Action> {
    return { value,action in
        var effects:[Effect<Action>] = []
        effects.append(contentsOf:first(&value, action))
        effects.append(contentsOf:second(&value, action))
        return effects
    }
}

func combine<Value, Action>(
    _ reducers: Reducer<Value, Action>...
) -> Reducer<Value, Action> {
    return { value, action in
        let effects = reducers.flatMap { $0(&value, action) }
        return effects
    }
}

//Initial State Pullback with Function
func pullback<LocalValue, GlobalValue, Action>(
    _ reducer: @escaping Reducer<LocalValue, Action>,
    _ f: @escaping (GlobalValue) -> LocalValue
) -> Reducer<GlobalValue, Action> {
    return { globalValue, action in
        var localValue = f(globalValue)
        let effects = reducer(&localValue, action)
        return effects
    }
}

//State Pullback with WritableKeyPath
func pullback<LocalValue, GlobalValue, Action>(
    _ reducer: @escaping Reducer<LocalValue, Action>,
    _ value: WritableKeyPath<GlobalValue, LocalValue>
) -> Reducer<GlobalValue, Action> {
    return { globalValue, action in
        let effects = reducer(&globalValue[keyPath: value], action)
        return effects
    }
}

// Action Pullback with WritableKeyPath
func pullback<Value, LocalAction, GlobalAction>(
    _ reducer: @escaping Reducer<Value, LocalAction>,
    _ action: WritableKeyPath<GlobalAction, LocalAction>
) -> Reducer<Value, GlobalAction> {
    return { value, globalAction in
        let localAction = globalAction[keyPath: action]
        let localEffects = reducer(&value, localAction)
        return localEffects.map { localEffect in
            { () -> GlobalAction? in
                guard let localAction = localEffect() else { return nil }
                var globalAction = globalAction
                globalAction[keyPath: action] = localAction
                return globalAction
            }
        }
    }
}

// State & Action combined Pullback
func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ reducer: @escaping Reducer<LocalValue, LocalAction>,
    _ value: WritableKeyPath<GlobalValue, LocalValue>,
    _ action: WritableKeyPath<GlobalAction, LocalAction?>
) -> Reducer<GlobalValue, GlobalAction> {
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else { return [] }
        let localEffects = reducer(&globalValue[keyPath: value], localAction)
        return localEffects.map { localEffect in
            { () -> GlobalAction? in
                guard let localAction = localEffect() else { return nil }
                var globalAction = globalAction
                globalAction[keyPath: action] = localAction
                return globalAction
            }
        }
    }
}

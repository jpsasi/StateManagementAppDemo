//
//  Store.swift
//  StateManagementDemo
//
//  Created by Sasikumar JP on 05/02/23.
//

import Foundation
import Combine

class Store<Value, Action>: ObservableObject {
    let reducer: (inout Value, Action) -> Void
    @Published var value: Value
    var cancellable: Cancellable?
    
    init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
        self.value = initialValue
        self.reducer = reducer
    }
    
    func send(_ action: Action) {
        reducer(&value, action)
    }
    
    func view<LocalValue>(
        _ f: @escaping (Value) -> LocalValue
    ) -> Store<LocalValue, Action> {
        let localStore = Store<LocalValue, Action>(initialValue: f(self.value), reducer: { localValue, action in
            self.send(action)
            localValue = f(self.value)
        })
        localStore.cancellable = self.$value.sink { [weak localStore] value in
            localStore?.value = f(value)
        }
        return localStore
    }
}

func combine<Value, Action>(
    _ first: @escaping (inout Value, Action) -> Void,
    _ second: @escaping (inout Value, Action) -> Void
) -> (inout Value, Action) -> Void {
    return { value,action in
        first(&value, action)
        second(&value, action)
    }
}

func combine<Value, Action>(
    _ reducers: (inout Value, Action) -> Void...
) -> (inout Value, Action) -> Void {
    return { value, action in
        for reducer in reducers {
            reducer(&value, action)
        }
    }
}

//Initial State Pullback with Function
func pullback<LocalValue, GlobalValue, Action>(
    _ reducer: @escaping (inout LocalValue, Action) -> Void,
    _ f: @escaping (GlobalValue) -> LocalValue
) -> (inout GlobalValue, Action) -> Void {
    return { globalValue, action in
        var localValue = f(globalValue)
        reducer(&localValue, action)
    }
}

//State Pullback with WritableKeyPath
func pullback<LocalValue, GlobalValue, Action>(
    _ reducer: @escaping (inout LocalValue, Action) -> Void,
    _ value: WritableKeyPath<GlobalValue, LocalValue>
) -> (inout GlobalValue, Action) -> Void {
    return { globalValue, action in
        reducer(&globalValue[keyPath: value], action)
    }
}

// Action Pullback with WritableKeyPath
func pullback<Value, LocalAction, GlobalAction>(
    _ reducer: @escaping (inout Value, LocalAction) -> Void,
    _ action: WritableKeyPath<GlobalAction, LocalAction>
) -> (inout Value, GlobalAction) -> Void {
    return { value, globalAction in
        let localAction = globalAction[keyPath: action]
        reducer(&value, localAction)
    }
}

// State & Action combined Pullback
func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ reducer: @escaping (inout LocalValue, LocalAction) -> Void,
    _ value: WritableKeyPath<GlobalValue, LocalValue>,
    _ action: WritableKeyPath<GlobalAction, LocalAction?>
) -> (inout GlobalValue, GlobalAction) -> Void {
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else { return }
        reducer(&globalValue[keyPath: value], localAction)
    }
}

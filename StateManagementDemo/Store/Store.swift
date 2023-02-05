//
//  Store.swift
//  StateManagementDemo
//
//  Created by Sasikumar JP on 05/02/23.
//

import Foundation

class Store<Value, Action>: ObservableObject {
    let reducer: (Value, Action) -> Value
    @Published var value: Value
    
    init(initialValue: Value, reducer: @escaping (Value, Action) -> Value) {
        self.value = initialValue
        self.reducer = reducer
    }
    
    func send(_ action: Action) {
        self.value = reducer(value, action)
    }
}

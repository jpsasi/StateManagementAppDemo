//
//  Store.swift
//  StateManagementDemo
//
//  Created by Sasikumar JP on 05/02/23.
//

import Foundation

class Store<Value>: ObservableObject {
    @Published var value: Value
    
    init(initialValue: Value) {
        self.value = initialValue
    }
}

//
//  StateManagementDemoApp.swift
//  StateManagementDemo
//
//  Created by Sasikumar JP on 04/02/23.
//

import SwiftUI

@main
struct StateManagementDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialValue: AppState(), reducer: appReducer))
        }
    }
}
